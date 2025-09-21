use super::base::{LaunchbarItemState, WmInterface, WmState, WorkspaceItemState};
use crate::frb_generated::StreamSink;
use anyhow::Error;
use niri_ipc::{socket::Socket, Action, Event, Request, WorkspaceReferenceArg};

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
    fn watch_launchbar_events(sink: StreamSink<WmState>) -> Result<(), Error> {
        let mut socket = Niri::get_socket()?;
        let _ = socket.send(Request::EventStream)?;

        let mut next = socket.read_events();
        let mut state = WmState {
            launchbar: vec![],
            workspaces: vec![],
        };

        loop {
            // Update state
            match next() {
                Ok(Event::WorkspacesChanged { workspaces }) => {
                    let mut workspaces_new: Vec<WorkspaceItemState> = Vec::new();
                    workspaces.iter().for_each(|e| {
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
                    windows.iter().for_each(|e| {
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
                Ok(Event::WindowOpenedOrChanged { window }) => {
                    let mut launchbar_items = state.launchbar.clone();
                    let window_exists = launchbar_items.iter().any(|e| e.window_id == window.id);
                    let result: Vec<LaunchbarItemState>;

                    if window_exists {
                        result = launchbar_items
                            .iter()
                            .map(|e| -> LaunchbarItemState {
                                if e.window_id == window.id {
                                    return LaunchbarItemState {
                                        window_id: window.id,
                                        window_title: window.title.clone(),
                                        app_id: window.app_id.clone(),
                                        workspace_id: window.workspace_id,
                                        process_id: window.pid,
                                        is_focused: window.is_focused,
                                    };
                                } else {
                                    return e.to_owned();
                                }
                            })
                            .collect();
                    } else {
                        launchbar_items.push(LaunchbarItemState {
                            window_id: window.id,
                            window_title: window.title.clone(),
                            app_id: window.app_id.clone(),
                            workspace_id: window.workspace_id,
                            process_id: window.pid,
                            is_focused: window.is_focused,
                        });
                        result = launchbar_items;
                    }

                    state.launchbar = result;
                }
                Ok(Event::WindowFocusChanged { id }) => match id {
                    Some(val) => {
                        let launchbar_items = state.launchbar.clone();
                        let new_list: Vec<LaunchbarItemState> = launchbar_items
                            .iter()
                            .map(|e| -> LaunchbarItemState {
                                if e.window_id == val {
                                    let mut item = e.clone();
                                    item.is_focused = true;
                                    return item;
                                } else {
                                    let mut item = e.clone();
                                    item.is_focused = false;
                                    return item;
                                }
                            })
                            .collect();
                        state.launchbar = new_list;
                    }
                    None => {
                        let launchbar_items = state.launchbar.clone();
                        let new_list: Vec<LaunchbarItemState> = launchbar_items
                            .iter()
                            .map(|e| -> LaunchbarItemState {
                                let mut item = e.clone();
                                item.is_focused = false;
                                return item;
                            })
                            .collect();
                        state.launchbar = new_list;
                    }
                },
                Ok(Event::WorkspaceActiveWindowChanged {
                    workspace_id: _,
                    active_window_id,
                }) => match active_window_id {
                    Some(val) => {
                        let launchbar_items = state.launchbar.clone();
                        let new_list: Vec<LaunchbarItemState> = launchbar_items
                            .iter()
                            .map(|e| -> LaunchbarItemState {
                                if e.window_id == val {
                                    let mut item = e.clone();
                                    item.is_focused = true;
                                    return item;
                                } else {
                                    let mut item = e.clone();
                                    item.is_focused = false;
                                    return item;
                                }
                            })
                            .collect();
                        state.launchbar = new_list;
                    }
                    None => {}
                },
                Ok(Event::WindowClosed { id }) => {
                    let mut result = state.launchbar.clone();

                    let index = result.iter().position(|item| item.window_id == id);
                    if let Some(index) = index {
                        result.remove(index);
                    }

                    state.launchbar = result;
                }
                Ok(Event::WorkspaceActivated { id, focused }) => {
                    let workspaces = state.workspaces.clone();
                    let result: Vec<WorkspaceItemState>;

                    result = workspaces
                        .iter()
                        .map(|e| {
                            if e.id == id {
                                let mut item = e.clone();
                                item.is_focused = focused;
                                return item;
                            } else {
                                return e.to_owned();
                            }
                        })
                        .collect();

                    state.workspaces = result;
                }
                Ok(other_event) => {
                    println!("API | Niri: got unmapped event {:?}", other_event);
                }
                Err(e) => {
                    println!("API | Niri: got error {}", e.to_string());
                }
            };

            // Send new state to flutter
            let _ = sink.add(state.clone());
        }
    }

    fn focus_window(window_id: u64) -> Result<(), Error> {
        let mut socket = Niri::get_socket()?;
        let _ = socket.send(Request::Action(Action::FocusWindow { id: window_id }));

        Ok(())
    }

    fn close_window(window_id: u64) -> Result<(), Error> {
        let mut socket = Niri::get_socket()?;
        let _ = socket.send(Request::Action(Action::CloseWindow {
            id: Some(window_id),
        }));

        Ok(())
    }

    fn switch_workspace(workspace_id: u64) -> Result<(), Error> {
        let mut socket = Niri::get_socket()?;
        let _ = socket.send(Request::Action(Action::FocusWorkspace {
            reference: WorkspaceReferenceArg::Id(workspace_id),
        }));

        Ok(())
    }
}
