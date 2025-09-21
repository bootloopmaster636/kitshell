# Kitshell [ALPHA]

### *A modern looking, Material-ish panel/bar built with ease of use in mind.*

## 👋 Introduction

**What is a panel/bar?**  
A panel/bar is a generic term for program that is used to provide information and status (such as
battery, time, sound volume, running apps, notification, etc.) in a desktop.

Linux ecosystem's modular nature means that we have the ability to customize our own system to
suit our unique needs. Example of that would be running
a [window manager (WM)](https://wiki.archlinux.org/title/Window_manager) instead of
traditional [desktop environment (DE)](https://wiki.archlinux.org/title/Desktop_environment) for
simplicity and speed (and also cool points ofc 😄).

Customizing window manager will often need you to compose parts from other programs (such as bar,
app runner, notification daemon) to make window managers usable, because oftentimes window manager
come bare-bone, no other function other than managing your app window and starting a few program at
start/on key press.

One part of a WM setup is a panel/bar to make seeing information easier... A lot of bar programs
were made to be customizable, to the point of making your own components, and... that's not so
familiar with some people. So...

**Another bar program? Well..... yes... But this one is a bit different.**  
Kitshell aims to be beginner-friendly by making user interfaces that is familiar to common people,
so you don't need to make parts yourself. This program contains most of the functionality you need
to make WM setup ready for daily use, like

- A time and date display
- A notification system (with do not disturb)
- An app menu and running task display
- Quick settings button to change brightness, volume, Wifi, Bluetooth
- WM integration (currently only supports [Niri](https://github.com/YaLTeR/niri))
- And more soon...

**So, all of these benefits, but what does it cost?**  
To be easier to use, means that this program does not have many customizations. Customization is
done through panel UI, *not* through configuration text/dotfiles. You can't also make components
yourself (not at this moment). So this program is not for you who want to fully customize the
content of the bar.

## ⬇️ Installing

This program is currently in heavy development, things might not be stable, so I don't think it is
ready to be installed on your system yet...

Those who may have experience can run this program (on its alpha state) with instruction available
below:

## 🏗️ Building and development

This panel is built using [Flutter](https://flutter.dev/) (for UI/common business logic)
and [Rust](https://www.rust-lang.org/) (for interfacing with the system). Development is done
using [RustRover](https://www.jetbrains.com/rust/), use of other IDE is allowed.

### Prerequisites

Install these tool first

- Flutter SDK 3.35.0 and up,
  use [FVM (recommended)](https://fvm.app/documentation/getting-started/installation) or use
  instruction from [Flutter's website](https://docs.flutter.dev/get-started/install/linux/desktop)
- Rust toolchain 1.90.0 and up, use [Rustup](https://rustup.rs/)
- [Taskfile](https://taskfile.dev/docs/installation), to run code generators easily (recommended)

and then

1. Clone this repository to your device `git clone https://github.com/bootloopmaster636/kitshell`
   and change current directory to newly downloaded repo `cd ./kitshell`.
2. Install dependencies with `flutter pub get`.
3. Run code generation with `task codegen` (or `go-task codegen` if you run Arch Linux). This
   will generate required Flutter <=> Rust binding, localizations, and other required code.
4. Run Kitshell with `flutter run --verbose`. Verbose option here is to make Rust compilation
   message appear, so it is easier to debug.

## 👥 Community

We have a [Discord server you can join here](https://discord.gg/j7bYE27quA). Please be civil and
follow Discord rules.

## ⏩️ Roadmap to stable

- [ ] Workspace indicator and launchbar improvement
- [ ] More settings in quick settings
- [ ] Media player and visualization
- [ ] Settings for personalization and theming
- [ ] Polishing bugs
- [ ] Code documentation and testing
- [ ] Multi monitor support (when Flutter multi window officially released I suppose)

## ❤️ Acknowledgements

Thanks to the people(s) behind these project/contribution that helps us in building Kitshell:

- Libraries that made this program possible
- [flutter_layer_shell](https://github.com/Mr-1311/wayland_layer_shell) for making Flutter
  plugin to create Wayland layer shell apps.
- [niri-taskbar](https://github.com/LawnGnome/niri-taskbar) for how to do Niri IPC
- And you
