use battery::units;
use battery::units::ratio::percent;

pub enum BatteryState {
    Charging,
    Discharging,
    Full,
    Empty,
    Unknown,
}

pub struct BatteryData {
    pub capacity_percent: Vec<f32>,
    pub drain_rate_watt: Vec<f32>,
    pub status: Vec<BatteryState>,
}

pub async fn get_battery_data() -> BatteryData {
    let manager = battery::Manager::new().unwrap();

    let mut capacity_percent_list: Vec<f32> = Vec::new();
    let mut drain_rate_watt_list: Vec<f32> = Vec::new();
    let mut status_list: Vec<BatteryState> = Vec::new();

    for (idx, maybe_battery) in manager.batteries().unwrap().enumerate() {
        let battery = maybe_battery.unwrap();

        capacity_percent_list.push(f32::from(battery.state_of_charge().get::<percent>()));
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