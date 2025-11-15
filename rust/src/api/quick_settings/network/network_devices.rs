use anyhow::Error;
use flutter_rust_bridge::frb;
use num_enum::TryFromPrimitive;
use rusty_network_manager::{DeviceProxy, NetworkManagerProxy};
use zbus::Connection;

#[frb(opaque)]
pub struct NetworkDevice {
    /// Interface name of the device (e.g. wlan0, eth0)
    pub iface: String,

    /// Device path
    pub device_path: String,

    /// This device's device type
    pub dev_type: DeviceType,

    /// This device state
    pub dev_state: InternetDeviceState,
}

/// Enum containing Network's device state, can be used to display
/// connecting status when connecting to Wi-Fi
///
/// Description is copied from
/// [NetworkManager docs](https://people.freedesktop.org/~lkundrak/nm-docs/nm-dbus-types.html#NMDeviceState)
#[derive(Clone, Copy, Eq, PartialEq, TryFromPrimitive)]
#[repr(u32)]
pub enum InternetDeviceState {
    /// the device's state is unknown
    Unknown = 0,

    /// the device is recognized, but not managed by NetworkManager
    Unmanaged = 10,

    /// the device is managed by NetworkManager, but is not available for use.
    /// Reasons may include the wireless switched off, missing firmware,
    /// no ethernet carrier, missing supplicant or modem manager, etc.
    Unavailable = 20,

    /// the device can be activated, but is currently idle
    /// and not connected to a network.
    Disconnected = 30,

    /// the device is preparing the connection to the network. This
    /// may include operations like changing the MAC address, setting
    /// physical link properties, and anything else required to connect
    /// to the requested network.
    Prepare = 40,

    /// the device is connecting to the requested network. This may include
    /// operations like associating with the Wi-Fi AP, dialing the modem, connecting
    /// to the remote Bluetooth device, etc.
    Config = 50,

    /// the device requires more information to continue connecting to the requested
    /// network. This includes secrets like Wi-Fi passphrases, login passwords, PIN
    /// codes, etc.
    NeedAuth = 60,

    /// the device is requesting IPv4 and/or IPv6 addresses and routing information from the network.
    IpConfig = 70,

    /// the device is checking whether further action is required for the requested network connection.
    /// This may include checking whether only local network access is available, whether a captive portal
    /// is blocking access to the Internet, etc.
    IpCheck = 80,

    /// the device is waiting for a secondary connection (like a VPN) which must activated
    /// before the device can be activated
    Secondaries = 90,

    /// the device has a network connection, either local or global.
    Activated = 100,

    /// a disconnection from the current network connection was requested, and the device is cleaning up
    /// resources used for that connection. The network connection may still be valid.
    Deactivating = 110,

    /// the device failed to connect to the requested network and is cleaning up the connection request
    Failed = 120,
}

/// Enum containing part of device type
///
/// Copied from [NetworkManager docs](https://people.freedesktop.org/~lkundrak/nm-docs/nm-dbus-types.html#NMDeviceType)
#[derive(Clone, Eq, PartialEq, TryFromPrimitive)]
#[repr(u32)]
pub enum DeviceType {
    /// Network using Ethernet cable
    Eth = 1,

    /// Network using Wireless LAN/Wi-Fi
    Wifi = 2,

    /// Network using modem (e.g. LTE)
    Modem = 8,

    /// Unknown network type
    Unknown = 0,
}

pub async fn get_network_devices() -> Result<Vec<NetworkDevice>, Error> {
    let mut found_devices: Vec<NetworkDevice> = Vec::new();

    let connection = Connection::system()
        .await
        .expect("API | Network: Could not get a connection.");

    let nm = NetworkManagerProxy::new(&connection)
        .await
        .expect("API | Network: Could not get NetworkManager");

    for device in nm.get_all_devices().await.expect("Could not find devices") {
        let device_proxy = DeviceProxy::new_from_path(device.clone(), &connection)
            .await
            .expect("API | Network: Could not retrieve Device Proxy");

        let iface = device_proxy.interface().await?;
        let dev_type = device_proxy.device_type().await?;
        let dev_state = device_proxy.state().await?;

        let dev_type_enum = match DeviceType::try_from_primitive(dev_type) {
            Ok(val) => val,
            Err(err) => {
                println!(
                    "API | Network: Found unknown/incompatible device type: {}",
                    err.number
                );
                DeviceType::Unknown
            }
        };

        found_devices.push(NetworkDevice {
            iface,
            device_path: device.to_string(),
            dev_type: dev_type_enum,
            dev_state: InternetDeviceState::try_from_primitive(dev_state)?,
        });
    }

    Ok(found_devices)
}
