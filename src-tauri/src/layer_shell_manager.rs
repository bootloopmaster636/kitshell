/*
Copyright (c) 2025 Christopher Hartono

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
*/

use gtk::{
    traits::{ContainerExt, GtkWindowExt, WidgetExt},
    ApplicationWindow,
};
use gtk_layer_shell::{Edge, KeyboardMode, LayerShell};
use serde::{Deserialize, Serialize};
use tauri::{App, Manager, State, Url, Webview, WebviewWindow};

use crate::AppState;

pub struct LayerShellData {
    pub webview: Option<Webview>,
    pub main_window: Option<WebviewWindow>,
    pub shell_window: Option<ApplicationWindow>,
}

#[derive(Serialize, Deserialize, Clone, Copy)]
#[serde(rename_all = "camelCase")]
pub enum PopupPosition {
    Left,
    Center,
    Right,
}

unsafe impl Send for LayerShellData {}
unsafe impl Sync for LayerShellData {}

impl LayerShellData {
    pub fn init(
        &mut self,
        app: &mut App,
        label: &str,
        width: i32,
        height: i32,
        anchor_side: Edge,
        anchor_to_edge: bool,
        enable_auto_exclusive_zone: bool,
    ) {
        // Get webview
        self.webview = Some(app.get_webview(label).unwrap());

        // Get main window from Tauri
        self.main_window = Some(
            app.get_webview_window(label)
                .expect("Webview window is not provided/not found!"),
        );
        let main_window = self.main_window.as_mut().unwrap();
        main_window.hide().unwrap();

        // Add new GTK window to be a layer shell
        self.shell_window = Some(gtk::ApplicationWindow::new(
            &main_window.gtk_window().unwrap().application().unwrap(),
        ));
        let shell_window = self.shell_window.as_mut().unwrap();
        // Set the newly created GTK window to paintable, to prevent black screen
        // and to make app transparent
        shell_window.set_app_paintable(true);

        // Move Tauri's content to newly created GTK window(?)
        let vbox = main_window.default_vbox().unwrap();
        main_window.gtk_window().unwrap().remove(&vbox);
        shell_window.add(&vbox);

        // Init layer shell
        shell_window.init_layer_shell();

        // Set layer shell size
        shell_window.set_width_request(width);
        shell_window.set_height_request(height);

        // Set layer shell positions
        shell_window.set_anchor(anchor_side, anchor_to_edge);
        shell_window.set_keyboard_mode(KeyboardMode::OnDemand);

        if enable_auto_exclusive_zone {
            shell_window.auto_exclusive_zone_enable();
        }

        // Show layer shell
        shell_window.show_all();
    }

    pub fn change_margin(&mut self, horizontal_padding: i32, bottom_padding: i32) {
        let shell_window = self.shell_window.as_mut().unwrap();
        shell_window.set_layer_shell_margin(Edge::Left, horizontal_padding);
        shell_window.set_layer_shell_margin(Edge::Right, horizontal_padding);
        shell_window.set_layer_shell_margin(Edge::Bottom, bottom_padding);
    }

    pub fn hide_shell(&mut self) {
        self.shell_window.as_mut().unwrap().hide();
    }

    pub fn show_shell(&mut self) {
        self.shell_window.as_mut().unwrap().show();
    }

    pub fn set_shell_size(&mut self, width: i32, height: i32) {
        let shell_window = self.shell_window.as_mut().unwrap();
        shell_window.set_size_request(width, height);
        shell_window.resize(1, 1);
    }

    pub fn set_shell_anchor(&mut self, anchor_side: Edge, anchor_to_edge: bool) {
        self.shell_window
            .as_mut()
            .unwrap()
            .set_anchor(anchor_side, anchor_to_edge);
    }

    pub fn change_url(&mut self, path: &str) {
        let current_url = self.webview.as_mut().unwrap().url().unwrap();
        let domain = current_url.host_str().unwrap();
        let port = current_url.port().unwrap();
        let result = format!("http://{}:{}/{}", domain, port, path);

        let _ = self
            .webview
            .as_mut()
            .unwrap()
            .navigate(Url::parse(result.as_str()).unwrap());
    }
}

#[tauri::command]
pub fn change_shell_margin(app_state: State<AppState>, h_padding: i32, bottom_padding: i32) {
    app_state
        .main_panel_state
        .lock()
        .unwrap()
        .change_margin(h_padding, bottom_padding);
}

#[tauri::command]
pub fn show_popup(
    app_state: State<AppState>,
    path: &str,
    popup_width: i32,
    popup_height: i32,
    popup_position: PopupPosition,
) {
    let mut popup_window = app_state.popup_panel_state.lock().unwrap();
    popup_window.hide_shell();

    // Set shell size
    popup_window.set_shell_size(popup_width, popup_height);

    // Set shell position
    let anchor_side = match popup_position {
        PopupPosition::Left => Some(Edge::Left),
        PopupPosition::Center => None,
        PopupPosition::Right => Some(Edge::Right),
    };

    if !anchor_side.is_none() {
        popup_window.set_shell_anchor(anchor_side.unwrap(), true);
    }
    popup_window.set_shell_anchor(Edge::Bottom, true);

    // Set margin
    popup_window.change_margin(8, 8);

    // Set url
    popup_window.change_url(path);

    // Show shell
    popup_window.show_shell();
}

#[tauri::command]
pub fn hide_popup(app_state: State<AppState>) {
    app_state.popup_panel_state.lock().unwrap().hide_shell();
}
