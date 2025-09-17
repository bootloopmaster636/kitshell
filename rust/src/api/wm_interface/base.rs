use std::env::{self};

use anyhow::Error;

use crate::frb_generated::StreamSink;

pub enum WindowManager {
    Niri,
    // Hyprland,
    Unsupported,
}

#[derive(Clone)]
pub struct LaunchbarItemState {
    pub window_id: u64,
    pub window_title: Option<String>,
    pub app_id: Option<String>,
    pub workspace_id: Option<u64>,
    pub process_id: Option<i32>,
    pub is_focused: bool,
}

#[derive(Clone)]
pub struct WorkspaceItemState {
    pub id: u64,
    pub name: Option<String>,
    pub is_focused: bool,
}

#[derive(Clone)]
pub struct WmState {
    pub launchbar: Vec<LaunchbarItemState>,
    pub workspaces: Vec<WorkspaceItemState>,
}

pub trait WmInterface {
    async fn watch_launchbar_events(sink: StreamSink<WmState>) -> Result<(), Error>;

    fn focus_window(window_id: u64) -> Result<(), Error>;

    fn close_window(window_id: u64) -> Result<(), Error>;

    fn switch_workspace(workspace_id: u64) -> Result<(), Error>;
}

/// Get current WM used
pub fn detect_current_wm() -> Result<WindowManager, Error> {
    let key = "XDG_CURRENT_DESKTOP";
    let result = match env::var(key) {
        Ok(val) => match val.as_str() {
            "niri" => WindowManager::Niri,
            // "hyprland" => WindowManager::Hyprland,
            _ => WindowManager::Unsupported,
        },
        _ => WindowManager::Unsupported,
    };

    Ok(result)
}
