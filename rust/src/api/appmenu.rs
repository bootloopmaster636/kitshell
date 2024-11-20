use freedesktop_desktop_entry::{
    default_paths, get_languages_from_env, DesktopEntry, Iter,
};
use nix::sys::wait::waitpid;
use nix::unistd::{fork, ForkResult};
use std::fs;
use std::os::unix::process::CommandExt;
use std::process::Command;
use xdgkit::icon_finder;

pub struct AppData {
    pub name: String,
    pub description: String,
    pub exec: Vec<String>,
    pub icon: String,
    pub use_terminal: bool,
}

pub async fn get_all_apps() -> Vec<AppData> {
    let locales = get_languages_from_env();
    let mut apps = Vec::new();

    for path in Iter::new(default_paths()) {
        if let Ok(bytes) = fs::read_to_string(&path) {
            if let Ok(entry) = DesktopEntry::from_str(&path, &bytes, Some(&locales)) {
                // get app name, exec and icon
                let name = entry.name(&[locales.first().unwrap()]);
                let description = entry.comment(&[locales.first().unwrap()]);
                let terminal = entry.terminal();
                let exec = entry.parse_exec().unwrap_or(vec!["".to_string()]);
                let icon = entry.icon().unwrap_or("");

                apps.push(AppData {
                    name: name.unwrap().to_string(),
                    description: description.unwrap_or_default().to_string(),
                    exec,
                    icon: String::from(icon),
                    use_terminal: terminal,
                });
            }
        }
    }

    apps
}

pub fn find_icon_path_from_icon_name(icon_name: String) -> String {
    let path = icon_finder::find_icon(icon_name, 48, 1).unwrap_or_default();
    String::from(path.to_str().unwrap())
}

pub async fn launch_app(exec: Vec<String>, use_terminal: bool) {
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
                        Command::new(app).args(args).exec();
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
