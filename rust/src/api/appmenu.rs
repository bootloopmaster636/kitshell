use freedesktop_desktop_entry::{
    default_paths, get_languages_from_env, DesktopEntry, Iter,
};
use std::fs;
use xdgkit::icon_finder;

pub struct AppData {
    pub name: String,
    pub exec: String,
    pub icon: String,
}

pub async fn get_all_apps() -> Vec<AppData> {
    let locales = get_languages_from_env();
    let mut apps = Vec::new();

    for path in Iter::new(default_paths()) {
        if let Ok(bytes) = fs::read_to_string(&path) {
            if let Ok(entry) = DesktopEntry::from_str(&path, &bytes, Some(&locales)) {
                // get app name, exec and icon
                let name = entry.name(&[locales.first().unwrap()]);
                let exec = entry.exec().unwrap_or("");
                let icon = entry.icon().unwrap_or("");

                // resolve icon absolute path
                let icon_path = icon_finder::find_icon(icon.to_string(), 48, 1).unwrap_or_default();

                apps.push(AppData {
                    name: name.unwrap().to_string(),
                    exec: String::from(exec),
                    icon: String::from(icon_path.to_str().unwrap()),
                });
            }
        }
    }

    apps
}