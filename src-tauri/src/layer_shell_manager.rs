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
