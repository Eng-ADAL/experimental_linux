![GitHub release](https://img.shields.io/github/v/release/Eng-ADAL/experimental_linux?label=release)
![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/github/license/Eng-ADAL/experimental_linux)

# experimental_linux

A modular Debian workstation bootstrap for reproducible, explicit, and maintainable Linux setup.

The project is designed to take a fresh Debian system and turn it into a usable workstation with:

- base CLI tools
- dotfiles
- optional desktop environments
- custom utilities
- a later welcome and onboarding flow

The layout is intentionally modular. Each component lives in its own module and is installed in a fixed order.

---

## Current status

The project is actively evolving.

### Stable modules

- `base`
- `dotfiles`

### Available desktop modules

- `i3`
- `sway`

### Existing but still being refined

- `empty-trash`
- `ios-mount`

---

## Installation flow

There are two entry points.

### 1. Fresh Debian bootstrap

This is the machine-first entry point.

It is intended to be run from a clean Debian install, usually from a root shell.

Example:

```bash
su -
wget -qO- https://adal.page/dev/run.sh | bash
````

This script is responsible only for preparing the system and handing off to the repository bootstrap.

### 2. Repository bootstrap

After the repo is cloned, the main bootstrap can be run directly.

Example:

```bash
git clone https://github.com/Eng-ADAL/experimental_linux.git
cd experimental_linux
bash bootstrap.sh --desktop sway
```

Or:

```bash
bash bootstrap.sh --desktop i3
```

---

## Scripts

### `bootstrap.sh`

Automated installer for the repository.

It installs:

* `base`
* `dotfiles`
* either `sway` or `i3`
* the next-step handoff script

This is the non-interactive path.

### `install.sh`

Interactive menu-based installer.

This is for manual selection of modules during development or testing.

---

## Repository layout

```text
experimental_linux/
├── bootstrap.sh
├── install.sh
├── LICENSE
├── README.md
│
├── configs/
│   ├── git/gitconfig
│   ├── tmux/tmux.conf
│   ├── tmux/tmux.cheatsheet.txt
│   ├── vim/vimrc
│   └── zsh/zshrc
│
├── manifests
│   ├── apt-base.txt
│   └── flatpak.txt
│
├── modules/
│   ├── base/
│   │   ├── apt.txt
│   │   └── install.sh
│   ├── dotfiles/
│   │   └── install.sh
│   ├── i3/
│   │   ├── apt.txt
│   │   └── install.sh
│   ├── sway/
│   │   ├── apt.txt
│   │   └── install.sh
│   ├── empty-trash/
│   ├── ios-mount/
│   └── modules.list
│
<<<<<<< HEAD
├── scripts/
│   ├── create_continue_setup.sh
│   ├── detect_user.sh
│   ├── install_flatpak.sh
│   ├── install_packages.sh
│   └── link_config.sh
│
└── welcome/
=======
├── scripts
│   ├── create_continue_setup.sh
│   ├── detect_environment.sh
│   ├── detect_user.sh
│   ├── install_flatpak.sh
│   ├── install_packages.sh
│   └── link_config.sh
│
└── welcome
>>>>>>> 6614eb8 (Improve dotfiles automation and add optional Oh My Zsh module)
    └── welcome.py
```

---

## Modules

### base

Core command line tooling and utilities.

Installs packages such as:

* git
* vim
* tmux
* zsh
* ripgrep
* fd-find
* bat
* tree
* htop
* curl
* wget
* direnv
* fzf

### dotfiles

Links user configuration for:

* Git
* tmux
* Vim
* Zsh

Also installs TPM for tmux and prepares the tmux plugin environment.

### i3

Installs an i3 desktop stack for lightweight systems.

This is intended for older or lower-spec machines where simplicity matters.

### sway

Installs a Sway Wayland stack for newer systems and better modern input support.

### empty-trash

A helper utility for managing the Linux trash folder safely.

### ios-mount

A helper for iPhone or iPad mounting workflows on Linux.

---

## Design principles

* Modular
  Every feature lives in a separate module.

* Explicit
  Installation order is deliberate, not auto-discovered.

* Reproducible
  Package lists live in manifests.

* Recoverable
  Existing dotfiles are backed up before replacement where appropriate.

* Practical
  The project is built for real Debian machines, not theory.

---

## Requirements

Tested on Debian 13.

Required for the fresh bootstrap path:

* root access or `sudo`
* internet access
* `wget`

Useful on the workstation itself:

* `git`
* `sudo`
* `curl`

---

## Current limitations

* No uninstall flow yet
* No dependency graph between modules yet
* Welcome app is still a placeholder
* Some optional modules are still being refined
* Flatpak support exists, but is not yet the main path
<<<<<<< HEAD
=======

## Open issues
* WSL clipboard integration
* Installation profiles (minimal/developer/full)
* coc.nvim + Node.js separation
* Uninstall support
* Environment-aware modules
>>>>>>> 6614eb8 (Improve dotfiles automation and add optional Oh My Zsh module)

---

## Roadmap

Planned work includes:

* welcome app onboarding
* first-login setup flow
* more polished desktop selection
* module dependency handling
* better desktop-specific shared config
* packaging towards a Debian package later on

---

## Goal

The long-term goal is simple:

```bash
sudo apt install eng-workstation
```

This repository is the path towards that outcome.

---

## License

MIT

