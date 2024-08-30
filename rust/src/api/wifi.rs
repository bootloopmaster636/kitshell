use waifai::{Client, WiFi};

pub struct WifiData {
    pub is_connected: bool,
    pub ssid: String,
    pub signal_strength: u32,
}

pub async fn get_wifi_list(rescan: bool) -> Vec<WifiData> {
    let mut wifi_list: Vec<WifiData> = Vec::new();

    let wifi = WiFi::new("wlan0".to_string());
    let scan_result = wifi.scan(rescan).expect("Failed to scan wifi");

    for network in scan_result {
        let wifi_data = WifiData {
            is_connected: network.connected,
            ssid: network.ssid,
            signal_strength: network.signal,
        };
        wifi_list.push(wifi_data);
    }
    wifi_list
}

pub async fn connect_to_wifi(ssid: &str, password: &str) -> anyhow::Result<bool> {
    let wifi = WiFi::new("wlan0".to_string());
    Ok(wifi.connect(ssid, Option::from(password)).expect("Failed to connect to wifi"))
}