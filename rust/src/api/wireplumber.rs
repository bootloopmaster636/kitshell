use std::process::Command;

pub struct WireplumberData {
    pub volume: f32,
}

// tries to run wpctl get-volume @DEFAULT_AUDIO_SINK@ and return the volume
pub async fn get_volume() -> WireplumberData {
    let output = Command::new("wpctl")
        .args(["get-volume", "@DEFAULT_AUDIO_SINK@"])
        .output()
        .expect("failed to execute process");

    let output_string = String::from_utf8_lossy(&output.stdout);
    let volume_string = output_string.trim().strip_prefix("Volume: ").unwrap();
    let volume = volume_string.parse::<f32>().unwrap();

    WireplumberData {
        volume,
    }
}

// tries to run wpctl set-volume @DEFAULT_AUDIO_SINK@ <volume> and return the volume
// volume range is 0.0 to 1.0
pub async fn set_volume(volume: f32) {
    Command::new("wpctl")
        .args(["set-volume", "@DEFAULT_AUDIO_SINK@", &volume.to_string()])
        .output()
        .expect("failed to execute process");
}