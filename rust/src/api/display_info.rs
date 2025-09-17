use display_info::DisplayInfo;

pub struct DispInfo {
    pub name: String,
    pub idx: u32,
    pub width_px: u32,
    pub height_px: u32,
    pub scale: f32,
}

pub fn get_display_info() -> Vec<DispInfo> {
    let mut displays = Vec::new();
    let display_info = DisplayInfo::all().unwrap();

    display_info.iter().enumerate().for_each(|disp| {
        println!("API | DisplayInfo: Found display {:?}", disp.1);
        displays.push(DispInfo {
            name: String::from(&disp.1.friendly_name),
            idx: disp.0 as u32,
            width_px: disp.1.width,
            height_px: disp.1.height,
            scale: disp.1.scale_factor,
        });
    });

    displays
}
