use crate::api::quick_settings::network::network_devices::InternetDeviceState;
use crate::frb_generated::StreamSink;
use anyhow::{bail, Error};
use flutter_rust_bridge::frb;
use num_enum::TryFromPrimitive;
use rusty_network_manager::{AccessPointProxy, DeviceProxy, NetworkManagerProxy, WirelessProxy};
use smol::Timer;
use std::collections::HashMap;
use std::time::Duration;
use zbus::{zvariant::OwnedObjectPath, Connection};

/// Enum containing connectivity state
///
/// Copied from [NetworkManager docs](https://people.freedesktop.org/~lkundrak/nm-docs/nm-dbus-types.html#NMConnectivityState)
#[derive(Clone, Copy)]
pub enum ConnectivityState {
    /// Network connectivity is unknown.
    Unknown = 1,

    /// The host is not connected to any network.
    None = 2,

    /// The host is behind a captive portal and cannot reach the full Internet.
    Portal = 3,

    /// The host is connected to a network, but does not appear to be able to reach the full Internet.
    Limited = 4,

    /// The host is connected to a network, and appears to be able to reach the full Internet.
    Full = 5,
}

/// Wlan device info that can be used to do network operation
/// and list access points.
#[derive(Clone)]
#[frb(opaque)]
pub struct WlanDevice {
    /// Wireless LAN device interface name
    pub interface: String,

    /// Current device state
    pub device_state: InternetDeviceState,

    #[frb(ignore)]
    dbus_connection: Option<Connection>,

    #[frb(ignore)]
    device_path: Option<OwnedObjectPath>,
}

#[derive(Clone, Eq, Ord, PartialOrd, PartialEq)]
#[frb(non_opaque)]
pub struct AccessPoint {
    /// This access point name/SSID
    pub ssid: String,

    /// This access point signal strength in percent
    pub strength: u8,

    /// This access point radio frequency
    pub frequency: WifiFreq,

    /// Whether this AP is currently active and connected
    pub is_active: bool,
}

#[derive(Clone, Copy, Ord, Eq, PartialOrd, PartialEq)]
pub enum WifiFreq {
    Freq2_4ghz,
    Freq5ghz,
    Freq6ghz,
    FreqUnknown,
}

/// Enum containing AP security flags
///
/// Copied from
/// [NetworkManager docs](https://people.freedesktop.org/~lkundrak/nm-docs/nm-dbus-types.html#NM80211ApSecurityFlags)
#[derive(Eq, PartialEq, TryFromPrimitive)]
#[repr(u32)]
pub enum ApSecurityFlag {
    /// the access point has no special security requirements
    None = 0x00000000,

    /// 40/64-bit WEP is supported for pairwise/unicast encryption
    PairWep40 = 0x00000001,

    /// 104/128-bit WEP is supported for pairwise/unicast encryption
    PairWep104 = 0x00000002,

    /// TKIP is supported for pairwise/unicast encryption
    PairTkip = 0x00000004,

    /// AES/CCMP is supported for pairwise/unicast encryption
    PairCcmp = 0x00000008,

    /// 40/64-bit WEP is supported for group/broadcast encryption
    GroupWep40 = 0x00000010,

    /// 104/128-bit WEP is supported for group/broadcast encryption
    GroupWep104 = 0x00000020,

    /// TKIP is supported for group/broadcast encryption
    GroupTkip = 0x00000040,

    /// AES/CCMP is supported for group/broadcast encryption
    GroupCcmp = 0x00000080,

    /// WPA/RSN Pre-Shared Key encryption is supported
    KeyMgmtPsk = 0x00000100,

    /// 802.1x authentication and key management is supported
    KeyMgmt802_1x = 0x00000200,
}

impl WlanDevice {
    /// Initializes the WLAN device instance
    pub async fn init(&mut self) -> Result<(), Error> {
        println!(
            "API | Network | Wireless: Initializing device {}",
            self.interface
        );
        self.dbus_connection = match Connection::system().await {
            Ok(val) => Some(val),
            Err(_) => {
                bail!("API | Network | Wireless: Could not connect to dbus");
            }
        };

        let nm = match NetworkManagerProxy::new(&self.dbus_connection.as_mut().unwrap()).await {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | Wireless: Could not get NetworkManager");
            }
        };

        // Connect to device
        self.device_path = match nm.get_device_by_ip_iface(&self.interface).await {
            Ok(val) => Some(val),
            Err(_) => {
                bail!(
                    "API | Network | Wireless: Could not get device object path from interface {}",
                    &self.interface
                );
            }
        };

        // Set device status
        let device_proxy = self.get_device_proxy().await?;
        self.device_state = InternetDeviceState::try_from_primitive(device_proxy.state().await?)?;

        Ok(())
    }

    pub async fn request_scan(&self) -> Result<(), Error> {
        let wireless_proxy = match self.get_wireless_proxy().await {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | Wireless: Could not get wireless proxy");
            }
        };

        match wireless_proxy.request_scan(HashMap::new()).await {
            Ok(_) => (),
            Err(_) => bail!("API | Network | Wireless: Cannot request scan"),
        };
        Ok(())
    }

    pub async fn get_access_points(&self) -> Result<Vec<AccessPoint>, Error> {
        let mut access_points = Vec::new();
        let wireless_proxy = match self.get_wireless_proxy().await {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | Wireless: Could not get wireless proxy");
            }
        };

        // Get currently active AP
        let active_ap = wireless_proxy.active_access_point().await?;

        let ap_path_list = match wireless_proxy.get_access_points().await {
            Ok(val) => val,
            Err(_) => bail!("API | Network | Wireless: Failed to get AP list"),
        };
        for ap_path in ap_path_list {
            let ap_proxy = match AccessPointProxy::new_from_path(
                ap_path.clone(),
                self.dbus_connection.as_ref().unwrap(),
            )
            .await
            {
                Ok(val) => val,
                Err(_) => bail!("API | Network | Wireless: Cannot get AP proxy"),
            };

            let ssid = match ap_proxy.ssid().await {
                Ok(val) => String::from_utf8(val)?,
                Err(_) => bail!("API | Network | Wireless: Cannot get AP SSID"),
            };

            let strength = match ap_proxy.strength().await {
                Ok(val) => val,
                Err(_) => bail!("API | Network | Wireless: Cannot get AP strength"),
            };

            let frequency = match ap_proxy.frequency().await {
                Ok(val) if val >= 2400 && val <= 2500 => WifiFreq::Freq2_4ghz,
                Ok(val) if val >= 5100 && val < 5925 => WifiFreq::Freq5ghz,
                Ok(val) if val >= 5925 && val >= 7215 => WifiFreq::Freq6ghz,
                _ => WifiFreq::FreqUnknown,
            };

            let is_active = ap_path == active_ap;

            access_points.push(AccessPoint {
                ssid,
                strength,
                frequency,
                is_active,
            });
        }

        // Sort by strength
        access_points.sort_by_key(|e| e.strength);
        access_points.reverse();

        Ok(access_points)
    }

    pub async fn connect_to_ap(&self, ssid: String, password: Option<String>) -> Result<(), Error> {
        Ok(())
    }

    pub async fn monitor_device_state(
        &self,
        sink: StreamSink<InternetDeviceState>,
    ) -> Result<(), Error> {
        let device_proxy = self.get_device_proxy().await?;

        loop {
            let state = device_proxy.state().await?;
            let _ = sink.add(InternetDeviceState::try_from_primitive(state)?);
            Timer::after(Duration::from_millis(100)).await;
        }
    }

    /// Get a wireless proxy for this device
    async fn get_wireless_proxy(&self) -> Result<WirelessProxy<'_>, Error> {
        if let (Some(device_path), Some(connection)) = (&self.device_path, &self.dbus_connection) {
            match WirelessProxy::new_from_path(device_path.clone(), connection).await {
                Ok(proxy) => Ok(proxy),
                Err(e) => bail!("Failed to create wireless proxy: {}", e),
            }
        } else {
            bail!("Device not initialized. Call init() first.")
        }
    }

    /// Get a device proxy for this
    async fn get_device_proxy(&self) -> Result<DeviceProxy<'_>, Error> {
        if let (Some(device_path), Some(connection)) = (&self.device_path, &self.dbus_connection) {
            match DeviceProxy::new_from_path(device_path.clone(), connection).await {
                Ok(proxy) => Ok(proxy),
                Err(e) => bail!("Failed to create wireless proxy: {}", e),
            }
        } else {
            bail!("Device not initialized. Call init() first.")
        }
    }
}

/// Create new [WlanDevice] instance from specified interface name
pub fn create_wlan_device(from_iface: String) -> WlanDevice {
    WlanDevice {
        interface: from_iface,
        dbus_connection: None,
        device_path: None,
        device_state: InternetDeviceState::Unknown,
    }
}
