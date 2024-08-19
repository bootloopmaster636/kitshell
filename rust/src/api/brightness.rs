use crate::frb_generated::StreamSink;
use async_std::task;
use brightness::Brightness;
use flutter_rust_bridge::frb;
use futures::{StreamExt, TryStreamExt};
use std::time::Duration;

#[frb(opaque)]
pub struct BrightnessData {
    pub device_name: Vec<String>,
    pub brightness: Vec<u32>,
}

pub async fn get_brightness_stream(sink: StreamSink<BrightnessData>) {
    let one_sec = Duration::from_millis(1000);

    loop {
        let brightness_data = get_brightness().await;
        sink.add(brightness_data).expect("Failed to add brightness data");
        task::sleep(one_sec).await;
    }
}

async fn get_brightness() -> BrightnessData {
    let mut device_list: Vec<String> = Vec::new();
    let mut brightness_list: Vec<u32> = Vec::new();

    let mut stream = brightness::brightness_devices();

    while let Some(data) = stream.next().await {
        let data_unwrapped = data.unwrap();

        let device = data_unwrapped.device_name().await.expect("failed to get display name");
        let brightness = data_unwrapped.get().await.expect("failed to get brightness val");

        device_list.push(device);
        brightness_list.push(brightness);
    }

    BrightnessData {
        device_name: device_list,
        brightness: brightness_list,
    }
}

pub async fn set_brightness_all(brightness: u32) {
    brightness::brightness_devices().try_for_each(|mut dev| async move {
        dev.set(brightness).await.expect("Failed to set brightness");
        Ok(())
    }).await.expect("Failed to set brightness");
}
