use super::base::{LaunchbarItemState, LaunchbarState, WmInterface, WorkspaceItemState};
use crate::frb_generated::StreamSink;
use anyhow::Error;
use niri_ipc::{socket::Socket, Event};

pub struct Niri {}

impl Niri {
    fn get_socket() -> Result<Socket, Error> {
        let socket = Socket::connect();
        match socket {
            Ok(val) => Ok(val),
            Err(_) => todo!(),
        }
    }
}

impl WmInterface for Niri {
    async fn watch_launchbar_events(sink: StreamSink<LaunchbarState>) -> Result<(), Error> {
        let socket = Niri::get_socket()?;
        let mut next = socket.read_events();
        let mut state = LaunchbarState {
            launchbar: vec![],
            workspaces: vec![],
        };

        loop {
            // Update state
            match next() {
                Ok(Event::WorkspacesChanged { workspaces }) => {
                    let mut workspaces_new: Vec<WorkspaceItemState> = Vec::new();
                    workspaces.iter().map(|e| {
                        workspaces_new.push(WorkspaceItemState {
                            id: e.id,
                            name: e.name.clone(),
                            is_focused: e.is_focused,
                        });
                    });
                    state.workspaces = workspaces_new;
                }
                Ok(Event::WindowsChanged { windows }) => {
                    let mut windows_new: Vec<LaunchbarItemState> = Vec::new();
                    windows.iter().map(|e| {
                        windows_new.push(LaunchbarItemState {
                            window_id: e.id,
                            app_id: e.app_id.clone(),
                            window_title: e.title.clone(),
                            workspace_id: e.workspace_id,
                            process_id: e.pid,
                            is_focused: e.is_focused,
                        });
                    });
                    state.launchbar = windows_new;
                }
                Ok(_) => (),
                Err(_) => todo!(),
            };

            // Send new state to flutter
            sink.add(state.clone());
        }
    }

    fn focus_window(window_id: String) -> Result<(), Error> {
        todo!()
    }

    fn close_window(window_id: String) -> Result<(), Error> {
        todo!()
    }

    fn switch_workspace(workspace_id: String) -> Result<(), Error> {
        todo!()
    }
}
