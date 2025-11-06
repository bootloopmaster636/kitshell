use std::collections::HashMap;

use anyhow::{bail, Error};
use flutter_rust_bridge::frb;
use rusty_network_manager::{AccessPointProxy, NetworkManagerProxy, WirelessProxy};
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

    #[frb(ignore)]
    dbus_connection: Option<Connection>,

    #[frb(ignore)]
    device_path: Option<OwnedObjectPath>,
}

#[derive(Clone)]
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

#[derive(Clone, Copy)]
pub enum WifiFreq {
    Freq2_4ghz,
    Freq5ghz,
    Freq6ghz,
    FreqUnknown,
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
        let access_points = Vec::new();
        let wireless_proxy = match self.get_wireless_proxy().await {
            Ok(val) => val,
            Err(_) => {
                bail!("API | Network | Wireless: Could not get wireless proxy");
            }
        };

        let ap_path_list = match wireless_proxy.get_access_points().await {
            Ok(val) => val,
            Err(_) => bail!("API | Network | Wireless: Failed to get AP list"),
        };
        for ap_path in ap_path_list {
            let ap_proxy = match AccessPointProxy::new_from_path(
                ap_path,
                self.dbus_connection.as_ref().unwrap(),
            )
            .await
            {
                Ok(val) => val,
                Err(_) => bail!("API | Network | Wireless: Cannot get AP proxy"),
            };

            let ssid = match ap_proxy.ssid().await {
                Ok(val) => String::from_utf8(val).unwrap(),
                Err(_) => bail!("API | Network | Wireless: Cannot get AP SSID"),
            };

            // access_points.push(AccessPoint {
            //     ssid: ssid,
            //     strength: (),
            //     frequency: (),
            //     is_active: (),
            // });
        }

        Ok(access_points)
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
}

/// Create new [WlanDevice] instance from specified interface name
pub fn create_wlan_device(from_iface: String) -> WlanDevice {
    WlanDevice {
        interface: from_iface,
        dbus_connection: None,
        device_path: None,
    }
}
