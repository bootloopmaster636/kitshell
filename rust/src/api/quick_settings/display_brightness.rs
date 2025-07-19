use brightness::blocking::Brightness;
use notify::{Config, PollWatcher, RecursiveMode, Watcher};
use std::{
    fs::{read_dir, read_to_string},
    io::Error,
    path::Path,
    time::Duration,
};

use crate::frb_generated::StreamSink;

pub struct BacklightInfo {
    pub name: String,
    pub brightness: u16,
    pub max_brightness: u16,
}

pub fn watch_backlight_event(sink: StreamSink<Vec<BacklightInfo>>) -> notify::Result<()> {
    // Config watcher
    let (tx, rx) = std::sync::mpsc::channel();
    let mut watcher = PollWatcher::new(
        tx,
        Config::default()
            .with_poll_interval(Duration::from_millis(50))
            .with_follow_symlinks(true)
            .with_compare_contents(true),
    )?;

    // Get backlight directories
    let mut backlight_display_paths: Vec<String> = Vec::new();
    let backlight_dir = read_dir("/sys/class/backlight").unwrap();
    for entry in backlight_dir {
        let entry = entry.unwrap();
        if entry.file_type().unwrap().is_symlink() {
            backlight_display_paths.push(entry.path().display().to_string());
        }
    }

    // Send first time data to stream
    let _ = sink.add(get_brightness_from_path(&backlight_display_paths).unwrap());

    // Run FS watcher
    backlight_display_paths.iter().for_each(|file| {
        let actual_brightness_file = Path::new(file).join("actual_brightness");
        let _ = watcher.watch(&actual_brightness_file, RecursiveMode::NonRecursive);
    });

    for res in rx {
        let _ = match res {
            Ok(_) => {
                // Read the content of brightness files in available directory
                let _ = sink.add(get_brightness_from_path(&backlight_display_paths).unwrap());
            }
            Err(_) => panic!("display_brightness: Failed to watch file"),
        };
    }

    Ok(())
}

fn get_brightness_from_path(backlight_paths: &Vec<String>) -> Result<Vec<BacklightInfo>, Error> {
    let mut backlight_infos = Vec::new();

    backlight_paths.iter().for_each(|file| {
        // Make file path
        let brightness_file = Path::new(file).join("brightness");
        let max_brightness_file = Path::new(file).join("max_brightness");

        let brightness;
        let max_brightness;

        // Read files
        match read_to_string(&brightness_file) {
            Ok(file_content) => {
                brightness = file_content.trim().parse::<u16>().unwrap();
            }
            Err(_) => {
                panic!("display_brightness: Could not get brightness info")
            }
        }
        match read_to_string(&max_brightness_file) {
            Ok(file_content) => {
                max_brightness = file_content.trim().parse::<u16>().unwrap();
            }
            Err(_) => {
                panic!("display_brightness: Could not get max brightness info")
            }
        }

        backlight_infos.push(BacklightInfo {
            name: file
                .clone()
                .split('/')
                .collect::<Vec<_>>()
                .last()
                .unwrap()
                .to_string(),
            brightness,
            max_brightness,
        });
    });

    Ok(backlight_infos)
}

pub async fn change_brightness(name: String, value: u16) {
    brightness::blocking::brightness_devices()
        .try_for_each(|dev| -> Result<(), ()> {
            // Search display by name
            let dev = dev.as_ref().unwrap();
            if dev.device_name().unwrap() != name {
                return Ok(());
            }

            // Set backlight value
            let _ = dev.set(value.into());
            Ok(())
        })
        .unwrap()
}
