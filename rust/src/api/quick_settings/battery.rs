use crate::frb_generated::StreamSink;
use anyhow::Error;
use battery::{
    units::{ratio::percent, time::second},
    State,
};
use notify::{Config, PollWatcher, RecursiveMode, Watcher};
use std::{fs::read_dir, path::Path, time::Duration as StdDuration};

pub struct BatteryInfo {
    pub name: String,
    pub capacity: f32,
    pub batt_state: BatteryState,
    pub time_to_full_secs: Option<f32>,
    pub time_to_empty_secs: Option<f32>,
}

pub enum BatteryState {
    Unknown = 0,
    Charging = 1,
    Discharging = 2,
    Empty = 3,
    Full = 4,
}

pub fn watch_battery_event(sink: StreamSink<Vec<BatteryInfo>>) -> notify::Result<()> {
    // Config watcher
    let (tx, rx) = std::sync::mpsc::channel();
    let mut watcher = PollWatcher::new(
        tx,
        Config::default()
            .with_poll_interval(StdDuration::from_millis(50))
            .with_follow_symlinks(true)
            .with_compare_contents(true),
    )?;

    // Get backlight directories
    let mut power_supply_paths: Vec<String> = Vec::new();
    let power_supply_dir = read_dir("/sys/class/power_supply").unwrap();
    for entry in power_supply_dir {
        // Skip power supply not in "Battery" category
        let file_name = entry.as_ref().unwrap().file_name().into_string().unwrap();
        if !file_name.contains("BAT") {
            continue;
        };

        if entry.as_ref().unwrap().file_type().unwrap().is_symlink() {
            power_supply_paths.push(entry.unwrap().path().display().to_string());
        }
    }

    // Send first time data to stream
    let _ = sink.add(get_battery_info().unwrap());

    // Run FS watcher
    power_supply_paths.iter().for_each(|file| {
        let capacity_file = Path::new(file).join("capacity");
        let status_file = Path::new(file).join("status");

        let _ = watcher.watch(&capacity_file, RecursiveMode::NonRecursive);
        let _ = watcher.watch(&status_file, RecursiveMode::NonRecursive);
    });

    for res in rx {
        let _ = match res {
            Ok(_) => {
                // Read the content of brightness files in available directory
                let _ = sink.add(get_battery_info().unwrap());
            }
            Err(_) => panic!("display_brightness: Failed to watch file"),
        };
    }

    Ok(())
}

fn get_battery_info() -> Result<Vec<BatteryInfo>, Error> {
    let manager = battery::Manager::new()?;

    let mut batteries = Vec::new();
    for (_, maybe_bat) in manager.batteries()?.enumerate() {
        let bat = maybe_bat?;
        batteries.push(BatteryInfo {
            name: bat.model().unwrap_or("").to_string(),
            capacity: bat.state_of_charge().get::<percent>(),
            batt_state: match bat.state() {
                State::Unknown => BatteryState::Unknown,
                State::Charging => BatteryState::Charging,
                State::Discharging => BatteryState::Discharging,
                State::Empty => BatteryState::Empty,
                State::Full => BatteryState::Full,
                _ => BatteryState::Unknown,
            },
            time_to_full_secs: match bat.time_to_full() {
                Some(time) => Some(time.get::<second>()),
                None => None,
            },
            time_to_empty_secs: match bat.time_to_empty() {
                Some(time) => Some(time.get::<second>()),
                None => None,
            },
        });
    }

    Ok(batteries)
}
