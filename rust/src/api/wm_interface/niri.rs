use super::base::{LaunchbarItemState, WmInterface, WmState, WorkspaceItemState, WorkspaceState};
use crate::frb_generated::StreamSink;
use anyhow::Error;
use niri_ipc::{socket::Socket, Action, Event, Request, Window, Workspace, WorkspaceReferenceArg};

pub struct Niri {}

impl Niri {
    fn get_socket() -> Result<Socket, Error> {
        let socket = Socket::connect();
        match socket {
            Ok(val) => Ok(val),
            Err(_) => Err(anyhow::anyhow!("Could not connect to NIRI")),
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
                    on_workspaces_changed(&mut state, workspaces)
                }

                Ok(Event::WindowsChanged { windows }) => on_windows_changed(&mut state, windows),

                Ok(Event::WindowOpenedOrChanged { window }) => {
                    on_window_opened_or_changed(&mut state, window)
                }

                Ok(Event::WindowFocusChanged { id }) => on_windows_focus_changed(&mut state, id),

                Ok(Event::WorkspaceActiveWindowChanged {
                    workspace_id: _,
                    active_window_id,
                }) => on_workspace_active_window_changed(&mut state, active_window_id),

                Ok(Event::WindowClosed { id }) => on_window_closed(&mut state, id),

                Ok(Event::WorkspaceActivated { id, focused }) => {
                    on_workspace_activated(&mut state, id, focused)
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

        fn on_workspaces_changed(state: &mut WmState, workspaces: Vec<Workspace>) {
            let mut workspaces_result: Vec<WorkspaceState> = Vec::new();

            workspaces.iter().for_each(|workspace_data| {
                let workspace_idx = workspaces_result
                    .iter()
                    .position(|e| e.output == workspace_data.output);

                match workspace_idx {
                    // Found, push new data to this WorkspaceState
                    Some(idx) => workspaces_result[idx].items.push(WorkspaceItemState {
                        id: workspace_data.id,
                        idx: workspace_data.idx,
                        name: workspace_data.name.clone(),
                        is_focused: workspace_data.is_focused,
                        is_active: workspace_data.is_active,
                    }),
                    // Not found, add new WorkspaceState with this output/monitor
                    None => workspaces_result.push(WorkspaceState {
                        items: vec![WorkspaceItemState {
                            id: workspace_data.id,
                            idx: workspace_data.idx,
                            name: workspace_data.name.clone(),
                            is_focused: workspace_data.is_focused,
                            is_active: workspace_data.is_active,
                        }],
                        output: workspace_data.output.clone(),
                    }),
                }
            });

            state.workspaces = workspaces_result;
        }

        fn on_windows_changed(state: &mut WmState, windows: Vec<Window>) {
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

        fn on_window_opened_or_changed(state: &mut WmState, window: Window) {
            let mut launchbar_items = state.launchbar.clone();
            let window_exists = launchbar_items.iter().any(|e| e.window_id == window.id);
            let result: Vec<LaunchbarItemState>;

            if window_exists {
                result = launchbar_items
                    .iter()
                    .map(|e| -> LaunchbarItemState {
                        return if e.window_id == window.id {
                            LaunchbarItemState {
                                window_id: window.id,
                                window_title: window.title.clone(),
                                app_id: window.app_id.clone(),
                                workspace_id: window.workspace_id,
                                process_id: window.pid,
                                is_focused: window.is_focused,
                            }
                        } else {
                            e.to_owned()
                        };
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

        fn on_windows_focus_changed(state: &mut WmState, id: Option<u64>) {
            match id {
                Some(val) => {
                    let launchbar_items = state.launchbar.clone();
                    let new_list: Vec<LaunchbarItemState> = launchbar_items
                        .iter()
                        .map(|e| -> LaunchbarItemState {
                            return if e.window_id == val {
                                let mut item = e.clone();
                                item.is_focused = true;
                                item
                            } else {
                                let mut item = e.clone();
                                item.is_focused = false;
                                item
                            };
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
            }
        }

        fn on_workspace_active_window_changed(state: &mut WmState, active_window_id: Option<u64>) {
            match active_window_id {
                Some(val) => {
                    let launchbar_items = state.launchbar.clone();
                    let new_list: Vec<LaunchbarItemState> = launchbar_items
                        .iter()
                        .map(|e| -> LaunchbarItemState {
                            return if e.window_id == val {
                                let mut item = e.clone();
                                item.is_focused = true;
                                item
                            } else {
                                let mut item = e.clone();
                                item.is_focused = false;
                                item
                            };
                        })
                        .collect();
                    state.launchbar = new_list;
                }
                None => {}
            }
        }

        fn on_window_closed(state: &mut WmState, id: u64) {
            let mut result = state.launchbar.clone();

            let index = result.iter().position(|item| item.window_id == id);
            if let Some(index) = index {
                result.remove(index);
            }

            state.launchbar = result;
        }

        fn on_workspace_activated(state: &mut WmState, id: u64, focused: bool) {
            // Copied from https://yalter.github.io/niri/niri_ipc/enum.Event.html#variant.WorkspaceActivated
            // ------------------
            // A workspace was activated on an output.
            //
            // This doesn’t always mean the workspace became focused, just that it’s now
            // the active workspace on its output.
            // All other workspaces on the same output become inactive.
            // ------------------
            //
            // This means that each output can only have one active

            let mut workspaces = state.workspaces.clone();
            let result: Vec<WorkspaceState>;

            // We iterate through all workspaces in all outputs
            for output_idx in 0..workspaces.len() {
                // below is used to make other workspace in this output inactive
                let output_does_contain_id =
                    workspaces[output_idx].items.iter().any(|e| e.id == id);

                for workspace_idx in 0..workspaces[output_idx].items.len() {
                    let mut item = workspaces[output_idx].items[workspace_idx].clone();

                    if output_does_contain_id {
                        item.is_active = item.id == id;
                    }
                    item.is_focused = item.id == id && focused;

                    workspaces[output_idx].items[workspace_idx] = item;
                }
            }

            state.workspaces = result;
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
