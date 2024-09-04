use hyprland::data::{Client, Workspace, Workspaces};
use hyprland::dispatch::DispatchType::*;
use hyprland::dispatch::{Dispatch, WorkspaceIdentifierWithSpecial};
use hyprland::shared::{HyprData, HyprDataActive, HyprDataActiveOptional};

pub struct WorkspaceData {
    pub id: u8,
    pub name: String,
}

pub struct HyprlandData {
    pub active_window_title: String,
    pub active_workspace: WorkspaceData,
}

pub async fn get_hyprland_data() -> HyprlandData {
    let active_window_title = get_active_window_title();
    let active_workspace = get_active_workspace_number();
    HyprlandData {
        active_window_title,
        active_workspace,
    }
}

pub fn dispatch_switch_workspace_next() {
    Dispatch::call(Workspace(WorkspaceIdentifierWithSpecial::Relative(1))).expect("Failed to switch to next workspace");
}

pub fn dispatch_switch_workspace_previous() {
    Dispatch::call(Workspace(WorkspaceIdentifierWithSpecial::Relative(-1))).expect("Failed to switch to previous workspace");
}

pub fn dispatch_kill_active() {
    Dispatch::call(KillActiveWindow).unwrap();
}

pub fn get_active_window_title() -> String {
    let data = Client::get_active().unwrap().expect("Failed to get active window");
    data.title
}

pub fn get_active_workspace_number() -> WorkspaceData {
    let data = Workspace::get_active().unwrap();
    WorkspaceData {
        id: data.id as u8,
        name: data.name,
    }
}

pub async fn get_workspaces() -> Workspaces {
    Workspaces::get_async().await.unwrap()
}