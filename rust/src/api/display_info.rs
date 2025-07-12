use display_info::DisplayInfo;

pub struct DispInfo {
    pub width_px: u32,
    pub height_px: u32,
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn get_primary_display_size() -> DispInfo {
    let display_info = DisplayInfo::all().unwrap();
    let primary_display = display_info
        .clone()
        .into_iter()
        .find(|display| display.is_primary == true);

    match primary_display {
        Some(display) => DispInfo {
            width_px: display.width,
            height_px: display.height,
        },
        None => DispInfo {
            width_px: display_info.clone()[0].width,
            height_px: display_info.clone()[0].height,
        },
    }
}
