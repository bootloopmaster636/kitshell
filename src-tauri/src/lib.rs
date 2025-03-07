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

use layer_shell_manager::LayerShellData;

mod layer_shell_manager;

pub unsafe fn run() {
    let mut layer_shell = LayerShellData {
        main_window: None,
        shell_window: None,
    };

    tauri::Builder::default()
        .setup(move |app| {
            layer_shell.init(app, "main");

            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
