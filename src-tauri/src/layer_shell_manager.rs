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

use std::sync::Mutex;

use display_info::DisplayInfo;
use gtk::{
    traits::{ContainerExt, GtkWindowExt, WidgetExt},
    ApplicationWindow,
};
use gtk_layer_shell::{Edge, LayerShell};
use tauri::{App, Manager, State, WebviewWindow};

pub struct LayerShellData {
    pub main_window: Option<WebviewWindow>,
    pub shell_window: Option<ApplicationWindow>,
}

unsafe impl Send for LayerShellData {}
unsafe impl Sync for LayerShellData {}

impl LayerShellData {
    pub fn init(&mut self, app: &mut App, label: &str) {
        // Get main window from Tauri
        self.main_window = Some(
            app.get_webview_window(label)
                .expect("Webview window is not provided!"),
        );
        self.main_window.as_mut().unwrap().hide().unwrap();

        // Add new GTK window to be a layer shell
        self.shell_window = Some(gtk::ApplicationWindow::new(
            &self
                .main_window
                .as_mut()
                .unwrap()
                .gtk_window()
                .unwrap()
                .application()
                .unwrap(),
        ));
        // Set the newly created GTK window to paintable, to prevent black screen
        self.shell_window.as_mut().unwrap().set_app_paintable(true);

        // Move Tauri's content to newly created GTK window(?)
        let vbox = self.main_window.as_mut().unwrap().default_vbox().unwrap();
        self.main_window
            .as_mut()
            .unwrap()
            .gtk_window()
            .unwrap()
            .remove(&vbox);
        self.shell_window.as_mut().unwrap().add(&vbox);

        // Init layer shell
        self.shell_window.as_mut().unwrap().init_layer_shell();

        // Set layer shell size
        let display_info = DisplayInfo::all().unwrap();
        let first_monitor = display_info.first();
        self.shell_window
            .as_mut()
            .unwrap()
            .set_width_request(first_monitor.unwrap().width as i32);
        self.shell_window.as_mut().unwrap().set_height_request(48);

        // Set layer shell positions
        self.shell_window
            .as_mut()
            .unwrap()
            .set_anchor(Edge::Bottom, true);
        self.shell_window
            .as_mut()
            .unwrap()
            .auto_exclusive_zone_enable();

        // Show layer shell
        self.shell_window.as_mut().unwrap().show_all();
    }

    pub fn change_margin(&mut self, horizontal_padding: i32, bottom_padding: i32) {
        self.shell_window
            .as_mut()
            .unwrap()
            .set_layer_shell_margin(Edge::Left, horizontal_padding);
        self.shell_window
            .as_mut()
            .unwrap()
            .set_layer_shell_margin(Edge::Right, horizontal_padding);
        self.shell_window
            .as_mut()
            .unwrap()
            .set_layer_shell_margin(Edge::Bottom, bottom_padding);
    }
}

#[tauri::command]
pub fn change_shell_margin(
    layer_shell_state: State<Mutex<LayerShellData>>,
    h_padding: i32,
    bottom_padding: i32,
) {
    layer_shell_state
        .lock()
        .unwrap()
        .change_margin(h_padding, bottom_padding);
}
