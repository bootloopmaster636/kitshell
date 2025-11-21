use crate::api::quick_settings::network::network_devices::InternetDeviceState;
use crate::frb_generated::StreamSink;
use anyhow::{bail, Error};
use flutter_rust_bridge::frb;
use num_enum::TryFromPrimitive;
use rusty_network_manager::{AccessPointProxy, DeviceProxy, NetworkManagerProxy, WirelessProxy};
use smol::Timer;
use std::collections::HashMap;
use std::time::Duration;
use zbus::{
    zvariant::{OwnedObjectPath, Value},
    Connection,
};

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

    /// WPA Security flag for this AP
    pub wpa_security_flag: ApSecurityFlag,

    /// RSN Security flag for this AP
    pub rsn_security_flag: ApSecurityFlag,

    /// Whether this AP is currently active and connected
    pub is_active: bool,

    /// DBUS path for this AP
    pub ap_path: String,
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
#[derive(Clone, Copy, Ord, PartialOrd, Eq, PartialEq, TryFromPrimitive)]
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

    /// Unknown value (this is custom value for unknown Key Management)
    Unknown = 0x11111111,
}

impl WlanDevice {
    /// Initializes the WLAN device instance
    pub async fn init(&mut self) -> Result<(), Error> {
        println!(
            "API | Network | WLAN: Initializing device {}",
            self.interface
        );
        self.dbus_connection = match Connection::system().await {
            Ok(val) => Some(val),
            Err(_) => {
                bail!("API | Network | WLAN: Could not connect to dbus");
            }
        };

        let nm = match NetworkManagerProxy::new(&self.dbus_connection.as_mut().unwrap()).await {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | WLAN: Could not get NetworkManager");
            }
        };

        // Connect to device
        self.device_path = match nm.get_device_by_ip_iface(&self.interface).await {
            Ok(val) => Some(val),
            Err(_) => {
                bail!(
                    "API | Network | WLAN: Could not get device object path from interface {}",
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
                bail!("API | Network | WLAN: Could not get wireless proxy");
            }
        };

        match wireless_proxy.request_scan(HashMap::new()).await {
            Ok(_) => (),
            Err(_) => bail!("API | Network | WLAN: Cannot request scan"),
        };
        Ok(())
    }

    pub async fn get_access_points(&self) -> Result<Vec<AccessPoint>, Error> {
        let mut access_points = Vec::new();
        let wireless_proxy = match self.get_wireless_proxy().await {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | WLAN: Could not get wireless proxy");
            }
        };

        // Get currently active AP
        let active_ap = wireless_proxy.active_access_point().await?;

        let ap_path_list = match wireless_proxy.get_access_points().await {
            Ok(val) => val,
            Err(_) => bail!("API | Network | WLAN: Failed to get AP list"),
        };
        for ap_path in ap_path_list {
            let ap_proxy = match AccessPointProxy::new_from_path(
                ap_path.clone(),
                self.dbus_connection.as_ref().unwrap(),
            )
            .await
            {
                Ok(val) => val,
                Err(_) => bail!("API | Network | WLAN: Cannot get AP proxy"),
            };

            let ssid = match ap_proxy.ssid().await {
                Ok(val) => String::from_utf8(val)?,
                Err(_) => bail!("API | Network | WLAN: Cannot get AP SSID"),
            };

            let strength = match ap_proxy.strength().await {
                Ok(val) => val,
                Err(_) => bail!("API | Network | WLAN: Cannot get AP strength"),
            };

            let frequency = match ap_proxy.frequency().await {
                Ok(val) if val >= 2400 && val <= 2500 => WifiFreq::Freq2_4ghz,
                Ok(val) if val >= 5100 && val < 5925 => WifiFreq::Freq5ghz,
                Ok(val) if val >= 5925 && val >= 7215 => WifiFreq::Freq6ghz,
                _ => WifiFreq::FreqUnknown,
            };

            let wpa_security = match ap_proxy.wpa_flags().await {
                Ok(val) => ApSecurityFlag::try_from_primitive(val),
                Err(_) => bail!("API | Network | WLAN: Cannot get AP WPA flag"),
            };
            let wpa_security_enum = match wpa_security {
                Ok(val) => val,
                Err(_) => {
                    println!("API | Network | WLAN: Got unknown AP WPA flag");
                    ApSecurityFlag::Unknown
                }
            };

            let rsn_security = match ap_proxy.rsn_flags().await {
                Ok(val) => ApSecurityFlag::try_from_primitive(val),
                Err(_) => bail!("API | Network | WLAN: Cannot get AP WPA flag"),
            };
            let rsn_security_enum = match rsn_security {
                Ok(val) => val,
                Err(_) => {
                    println!("API | Network | WLAN: Got unknown AP WPA flag");
                    ApSecurityFlag::Unknown
                }
            };

            let is_active = ap_path == active_ap;

            access_points.push(AccessPoint {
                ssid,
                strength,
                frequency,
                wpa_security_flag: wpa_security_enum,
                rsn_security_flag: rsn_security_enum,
                is_active,
                ap_path: String::from(ap_path.as_str()),
            });
        }

        // Sort by strength
        access_points.sort_by_key(|e| e.strength);
        access_points.reverse();

        Ok(access_points)
    }

    pub async fn connect_to_ap(
        &self,
        ssid: String,
        password: Option<String>,
        ap_path: String,
        is_ap_saved: bool,
    ) -> Result<(), Error> {
        println!("API | Network | WLAN: Connecting to AP {}", ssid);
        let nm = self.get_nm_proxy().await?;
        let mut connection_settings: HashMap<&str, HashMap<&str, Value<'_>>> = HashMap::new();

        // connection settings
        println!("API | Network | WLAN: Making config");
        let mut connection: HashMap<&str, Value<'_>> = HashMap::new();
        connection.insert("id", Value::new(self.interface.clone()));
        connection.insert("type", Value::new("802-11-wireless"));
        connection_settings.insert("connection", connection);

        // wifi info
        let mut wireless80211: HashMap<&str, Value<'_>> = HashMap::new();
        wireless80211.insert("ssid", Value::new(ssid.as_bytes()));
        connection_settings.insert("802-11-wireless", wireless80211);

        // if require password, add password
        if password.is_some() {
            let mut wireless_security: HashMap<&str, Value<'_>> = HashMap::new();
            wireless_security.insert("psk", Value::new(password.unwrap()));
            connection_settings.insert("802-11-wireless-security", wireless_security);
        }

        // Ip config
        let mut ipv4: HashMap<&str, Value<'_>> = HashMap::new();
        ipv4.insert("method", Value::new("auto"));
        connection_settings.insert("ipv4", ipv4);

        let mut ipv6: HashMap<&str, Value<'_>> = HashMap::new();
        ipv6.insert("method", Value::new("auto"));
        connection_settings.insert("ipv6", ipv6);

        let specific_object = match OwnedObjectPath::try_from(ap_path) {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | WLAN: Could not get AP Path owned object path");
            }
        };

        println!("API | Network | WLAN: Config created, connecting");
        if is_ap_saved {
            nm.activate_connection(
                &OwnedObjectPath::try_from("/").unwrap(),
                &self.device_path.as_ref().unwrap(),
                &specific_object,
            )
            .await
            .expect("Could not activate connection");
        } else {
            nm.add_and_activate_connection(
                connection_settings,
                &self.device_path.as_ref().unwrap(),
                &specific_object,
            )
            .await
            .expect("Could not add and activate connection");
        }
        println!("API | Network | WLAN: Connection request to {} sent", ssid);

        Ok(())
    }

    pub async fn disconnect(&self) -> Result<(), Error> {
        let device_proxy = self.get_device_proxy().await?;
        device_proxy.disconnect().await?;

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
    async fn get_nm_proxy(&self) -> Result<NetworkManagerProxy<'_>, Error> {
        if let Some(connection) = &self.dbus_connection {
            match NetworkManagerProxy::new(connection).await {
                Ok(proxy) => Ok(proxy),
                Err(e) => bail!("Failed to create wireless proxy: {}", e),
            }
        } else {
            bail!("Device not initialized. Call init() first.")
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
