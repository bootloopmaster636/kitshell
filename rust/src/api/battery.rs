use battery::units;
use battery::units::ratio::percent;
use std::process::Command;

pub enum BatteryState {
    Charging,
    Discharging,
    Full,
    Empty,
    Unknown,
}

pub enum PowerProfiles {
    Powersave,
    Balanced,
    Performance,
}

pub struct BatteryData {
    pub capacity_percent: Vec<u8>,
    pub drain_rate_watt: Vec<f32>,
    pub status: Vec<BatteryState>,
}

pub async fn get_battery_data() -> BatteryData {
    let manager = battery::Manager::new().unwrap();

    let mut capacity_percent_list: Vec<u8> = Vec::new();
    let mut drain_rate_watt_list: Vec<f32> = Vec::new();
    let mut status_list: Vec<BatteryState> = Vec::new();

    for (_idx, maybe_battery) in manager.batteries().unwrap().enumerate() {
        let battery = maybe_battery.unwrap();

        capacity_percent_list.push(battery.state_of_charge().get::<percent>().round() as u8);
        drain_rate_watt_list.push(f32::from(battery.energy_rate().get::<units::power::watt>()));

        match battery.state() {
            battery::State::Charging => status_list.push(BatteryState::Charging),
            battery::State::Discharging => status_list.push(BatteryState::Discharging),
            battery::State::Full => status_list.push(BatteryState::Full),
            battery::State::Empty => status_list.push(BatteryState::Empty),
            _ => status_list.push(BatteryState::Unknown),
        }
    }

    BatteryData {
        capacity_percent: capacity_percent_list,
        drain_rate_watt: drain_rate_watt_list,
        status: status_list,
    }
}

pub async fn get_power_profile() -> PowerProfiles {
    let output = Command::new("powerprofilesctl")
        .args(["get"])
        .output()
        .expect("failed to execute process");

    let output_string = String::from_utf8_lossy(&output.stdout);

    match output_string.trim() {
        "power-saver" => PowerProfiles::Powersave,
        "balanced" => PowerProfiles::Balanced,
        "performance" => PowerProfiles::Performance,
        _ => panic!("Unknown power profile"),
    }
}

pub async fn set_power_profile(profile: PowerProfiles) {
    let profile_string = match profile {
        PowerProfiles::Powersave => "power-saver",
        PowerProfiles::Balanced => "balanced",
        PowerProfiles::Performance => "performance",
    };

    Command::new("powerprofilesctl")
        .args(["set", profile_string])
        .output()
        .expect("failed to execute process");
}