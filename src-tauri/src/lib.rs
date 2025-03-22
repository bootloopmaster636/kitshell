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
use gtk_layer_shell::Edge;
use layer_shell_manager::{change_shell_margin, hide_popup, show_popup, LayerShellData};
use tauri::{generate_handler, Manager};

mod layer_shell_manager;
pub mod widgets;

struct AppState {
    main_panel_state: Mutex<LayerShellData>,
    popup_panel_state: Mutex<LayerShellData>,
}

pub unsafe fn run() {
    let main_panel_state = LayerShellData {
        webview: None,
        main_window: None,
        shell_window: None,
    };
    let popup_panel_state = LayerShellData {
        webview: None,
        main_window: None,
        shell_window: None,
    };

    let app_state = AppState {
        main_panel_state: Mutex::new(main_panel_state),
        popup_panel_state: Mutex::new(popup_panel_state),
    };

    tauri::Builder::default()
        .setup(move |app| {
            // Build window
            let shell_url = tauri::WebviewUrl::App("/".into());
            let popup_url = tauri::WebviewUrl::App("/popup".into());
            tauri::WebviewWindowBuilder::new(app, "shell", shell_url)
                .transparent(true)
                .build()?;
            tauri::WebviewWindowBuilder::new(app, "popup", popup_url)
                .transparent(true)
                .visible(false)
                .build()?;

            let display_info = DisplayInfo::all().unwrap();
            let first_monitor = display_info.first();

            app_state.main_panel_state.lock().unwrap().init(
                app,
                "shell",
                first_monitor.unwrap().width as i32,
                48,
                Edge::Bottom,
                true,
                true,
            );

            app_state.popup_panel_state.lock().unwrap().init(
                app,
                "popup",
                200,
                60,
                Edge::Bottom,
                true,
                false,
            );

            widgets::init::init_widgets_data();
            app.manage(app_state);
            Ok(())
        })
        .invoke_handler(generate_handler![
            change_shell_margin,
            show_popup,
            hide_popup
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
