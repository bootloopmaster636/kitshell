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
    /// WIndow ID provided by compositor
    pub window_id: u64,

    /// Optional window title
    pub window_title: Option<String>,

    /// App ID (taken from dekstop entry name without ".desktop")
    pub app_id: Option<String>,

    /// Workspace ID this window belongs to
    pub workspace_id: Option<u64>,

    /// Process ID (PID)
    pub process_id: Option<i32>,

    /// Whether this window is currently focused
    pub is_focused: bool,
}

#[derive(Clone)]
pub struct WorkspaceItemState {
    /// ID of the workspace, should be stable when moving between outputs
    pub id: u64,

    /// Index of the workspace inside this output
    pub idx: u8,

    /// Optional name of workspace
    pub name: Option<String>,

    /// Whether this workspace is currently focused
    pub is_focused: bool,

    /// Whether this workspace is active/showing on the output
    pub is_active: bool,
}

#[derive(Clone)]
pub struct WorkspaceState {
    /// Workspaces in this output
    pub items: Vec<WorkspaceItemState>,

    /// Output (monitor name)
    pub output: Option<String>,

    /// Whether this output have workspace focused
    pub has_workspace_focused: bool,
}

#[derive(Clone)]
pub struct WmState {
    /// Launchbar items containing running apps
    pub launchbar: Vec<LaunchbarItemState>,

    /// Workspaces data
    pub workspaces: Vec<WorkspaceState>,
}

pub trait WmInterface {
    fn watch_launchbar_events(sink: StreamSink<WmState>) -> Result<(), Error>;

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
