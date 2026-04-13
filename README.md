# experimental_linux

A modular Debian workstation bootstrap designed for reproducibility, clarity, and control.

This project provisions a clean Linux environment with a focus on simplicity, transparency, and maintainability.

---

## What it installs

* Base CLI tools
* Dotfiles (Git, tmux, Vim, Zsh)
* Optional modules (currently gated):

  * i3 desktop environment
  * empty-trash utility
  * iOS mount helpers

---

## Project Status

This project is actively evolving.

### Stable modules

* base
* dotfiles

### Temporarily disabled modules

These exist in the repository but are not enabled in the installer until fully validated:

* i3
* empty-trash
* ios-mount

---

## How to use it

### Quick install (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/Eng-ADAL/experimental_linux/main/install.sh | bash
```

---

### Manual install

```bash
git clone https://github.com/Eng-ADAL/experimental_linux.git
cd experimental_linux
bash install.sh
```

---

### Interactive install

```bash
bash install.sh
```

Select modules from the menu.

Note: some modules are temporarily disabled until validation is complete.

---

### Non-interactive install (automation / CI)

```bash
bash install.sh --all -y
```

Environment flags:

* `AUTO_YES=true` → skip confirmations

---

## Repository layout

```text
experimental_linux/
├── install.sh
├── README.md
├── LICENSE
│
├── configs/
│   ├── git/gitconfig
│   ├── tmux/tmux.conf
│   ├── vim/vimrc
│   └── zsh/zshrc
│
├── manifests/
│   ├── apt-base.txt
│   └── flatpak.txt
│
├── modules/
│   ├── modules.list
│   ├── base/
│   │   ├── apt.txt
│   │   └── install.sh
│   ├── dotfiles/
│   │   └── install.sh
│   ├── empty-trash/
│   ├── ios-mount/
│   └── i3/
│
└── scripts/
    ├── install_packages.sh
    ├── install_flatpak.sh
    └── link_config.sh
```

---

## Modules

### base

Core CLI tooling and utilities.

Installed via manifest:

* git, vim, tmux, zsh
* ripgrep, fd, bat, curl, wget
* tree, htop, direnv, fzf, etc.

---

### dotfiles

Manages configuration for:

* Git (via include.path, non-destructive)
* tmux (with TPM automation)
* Vim
* Zsh

Features:

* Idempotent symlink creation
* Backup of existing configs
* Optional non-interactive overwrite mode

---

### empty-trash (disabled)

Utility for safe inspection and cleanup of the Linux trash directory.

---

### ios-mount (disabled)

Automates:

* iPhone pairing
* ifuse build and install
* Mount workflow + shell aliases

---

### i3 (disabled)

Installs i3 window manager and related desktop tooling.

---

## Design Principles

* Idempotent
  Safe to run multiple times without breaking the system

* Modular
  Each module installs independently

* Transparent
  All packages defined in manifests

* Minimal
  No hidden side effects

* Recoverable
  Existing configs are backed up automatically

---

## Key Features

* Manifest-driven package installation (APT + Flatpak)
* Modular bootstrap architecture
* TPM (tmux plugin manager) auto-install and plugin bootstrap
* Interactive and non-interactive modes
* Environment-aware execution (AUTO_YES support)
* Clean logging and error handling

---

## Requirements

Tested on Debian 13.

Required:

* sudo
* curl
* git

---

## Known Limitations

* No dependency resolution between modules yet
* No uninstall mechanism
* Some modules not validated across multiple environments
* Dry-run mode not fully implemented

---

## Roadmap

Planned improvements:

* Module dependency graph
* `--module <name>` CLI flag
* Proper dry-run mode
* Uninstall support
* Cross-distro compatibility
* CI pipeline for validation

---

## Why this project exists

Most Linux setup scripts degrade into fragile.

This project treats system setup like software engineering:

* versioned
* modular
* testable
* reproducible

The goal is a reliable, repeatable workstation bootstrap that scales beyond a single machine.

---

## License

MIT

