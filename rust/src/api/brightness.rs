use crate::frb_generated::StreamSink;
use brightness::Brightness;
use flutter_rust_bridge::frb;
use futures::TryStreamExt;

#[frb(opaque)]
pub struct BrightnessData {
    pub device: Vec<str>,
    pub brightness: Vec<u32>,
}

impl BrightnessData {
    fn new(&mut self, device: Box<str>, brightness: u32) {
        self.device.push(*device);
        self.brightness.push(brightness);
    }

    pub async fn get_brightness_stream(sink: StreamSink<&BrightnessData>) {
        let mut brightness_data = BrightnessData {
            device: Vec::new(),
            brightness: Vec::new(),
        };

        loop {
            brightness_data.get_brightness().await;
            sink.add(&brightness_data).expect("Failed to send brightness");
        }
    }

    async fn get_brightness(&mut self) {
        let mut device_name: Vec<str> = Vec::new();
        let mut device_brightness: Vec<u32> = Vec::new();

        brightness::brightness_devices().try_for_each(|dev| async move {
            device_name.push(dev.device_name());
            device_brightness.push(dev.get().unwrap());

            &self.device = device_name;
            &self.brightness = device_brightness;
            Ok(())
        }).expect("Failed to get brightness");
    }

    pub async fn set_brightness_all(&mut self, brightness: u32) {
        brightness::brightness_devices().try_for_each(|mut dev| async move {
            dev.set(brightness).unwrap();
            Ok(())
        }).expect("Failed to set brightness");
    }
}
