use std::env::{self, VarError};

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
pub struct LaunchbarState {
    pub launchbar: Vec<LaunchbarItemState>,
    pub workspaces: Vec<WorkspaceItemState>,
}

pub trait WmInterface {
    async fn watch_launchbar_events(sink: StreamSink<LaunchbarState>) -> Result<(), Error>;

    fn focus_window(window_id: String) -> Result<(), Error>;

    fn close_window(window_id: String) -> Result<(), Error>;

    fn switch_workspace(workspace_id: String) -> Result<(), Error>;
}

pub fn detect_current_wm() -> Result<WindowManager, VarError> {
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
