use freedesktop_desktop_entry::{default_paths, desktop_entries, Iter};
use freedesktop_icons::lookup;
use nix::sys::wait::waitpid;
use nix::unistd::{fork, ForkResult};
use sha2::{Digest, Sha256};
use std::os::unix::process::CommandExt;
use std::process::Command;

pub struct AppEntry {
    pub id: String,
    pub app_id: String,
    pub name: String,
    pub desc: String,
    pub exec: Vec<String>,
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
        let exec = entry.parse_exec().unwrap_or(vec!["".to_string()]);
        let exec_joined = exec.join(" ");

        // Calculate hash
        let id_unhashed = format!("{}{}", name, exec_joined);
        let hashed = Sha256::digest(&id_unhashed);
        let id = base16ct::lower::encode_string(&hashed);

        entries.push(AppEntry {
            id,
            app_id: entry.appid.clone(),
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

pub async fn launch_app(exec: Vec<String>, use_terminal: bool) {
    // TODO: refactor some function
    let mut command = exec.iter().map(|s| s.as_str()).collect::<Vec<&str>>();

    if use_terminal {
        command.insert(0, "xterm");
        command.insert(1, "-e");
    }

    let app = command.remove(0);
    let args = command;

    unsafe {
        match fork() {
            Ok(ForkResult::Parent { child, .. }) => {
                waitpid(child, None).unwrap();
            }
            Ok(ForkResult::Child) => {
                match fork() {
                    Ok(ForkResult::Parent { child, .. }) => {
                        println!("PID {} successfully detached from Kitshell", child);
                    }
                    Ok(ForkResult::Child) => {
                        let _ = Command::new(app).args(args).exec();
                        libc::_exit(0);
                    }
                    Err(_) => println!("Second fork failed"),
                }
                libc::_exit(0);
            }
            Err(_) => println!("First fork failed"),
        }
    }
}
