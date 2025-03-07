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
use gtk_layer_shell::LayerShell;
use tauri::{App, Manager, WebviewWindow};

pub struct LayerShellData {
    pub main_window: Option<WebviewWindow>,
    pub shell_window: Option<ApplicationWindow>,
}

unsafe impl Send for LayerShellData {}

impl LayerShellData {
    pub fn init(&mut self, app: &mut App, label: &str) {
        self.main_window = Some(
            app.get_webview_window(label)
                .expect("Webview window is not provided!"),
        );
        self.main_window.as_mut().unwrap().hide().unwrap();

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
        self.shell_window.as_mut().unwrap().set_app_paintable(true);

        let vbox = self.main_window.as_mut().unwrap().default_vbox().unwrap();
        self.main_window
            .as_mut()
            .unwrap()
            .gtk_window()
            .unwrap()
            .remove(&vbox);
        self.shell_window.as_mut().unwrap().add(&vbox);

        self.shell_window.as_mut().unwrap().init_layer_shell();

        self.shell_window.as_mut().unwrap().set_width_request(1366);
        self.shell_window.as_mut().unwrap().set_height_request(48);

        self.shell_window.as_mut().unwrap().show_all();
    }
}
