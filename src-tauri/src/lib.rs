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
