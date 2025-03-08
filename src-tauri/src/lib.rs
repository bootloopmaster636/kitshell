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

use layer_shell_manager::{change_shell_margin, LayerShellData};
use tauri::{generate_handler, Manager};

mod layer_shell_manager;

pub unsafe fn run() {
    let mut layer_shell_state = LayerShellData {
        main_window: None,
        shell_window: None,
    };

    tauri::Builder::default()
        .setup(move |app| {
            layer_shell_state.init(app, "main");

            app.manage(Mutex::new(layer_shell_state));
            Ok(())
        })
        .invoke_handler(generate_handler![change_shell_margin])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
