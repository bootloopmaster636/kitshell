use freedesktop_desktop_entry::{default_paths, Iter};
use freedesktop_icons::lookup;
use sha2::{Digest, Sha256};

pub struct AppEntry {
    pub id: String,
    pub name: String,
    pub desc: String,
    pub exec: String,
    pub working_dir: String,
    pub run_in_terminal: bool,
    pub icon: String,
}

pub async fn get_appmenu_items(locale: &str) -> Vec<AppEntry> {
    let mut entries = Vec::new();
    let raw_entries = Iter::new(default_paths())
        .entries(Some(&[locale][..]))
        .collect::<Vec<_>>();

    for entry in raw_entries {
        // Skip if entry is hidden
        if entry.hidden() {
            continue;
        };

        // Get name and exec (for id)
        let name = entry.name(&[locale][..]).unwrap_or_default().to_string();
        let exec = String::from(entry.exec().unwrap_or_default());

        // Calculate hash
        let id_unhashed = format!("{}{}", name, exec);
        let hashed = Sha256::digest(id_unhashed);

        entries.push(AppEntry {
            id: base16ct::lower::encode_string(&hashed),
            name,
            desc: String::from(entry.comment(&[locale][..]).unwrap_or_default()),
            exec,
            working_dir: String::from(entry.path().unwrap_or_default()),
            run_in_terminal: entry.terminal(),
            icon: String::from(entry.icon().unwrap_or_default()),
        });
    }

    entries
}

pub async fn get_icon_path(icon: &str) -> String {
    let icon_path = lookup(icon)
        .with_theme("Adwaita")
        .with_theme("breeze")
        .with_theme("hicolor")
        .with_size(48)
        .find();
    String::from(icon_path.unwrap_or_default().to_str().unwrap_or_default())
}
