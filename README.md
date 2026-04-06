# experimental_linux

A small Debian workstation setup for i3, tmux, Vim, Zsh, and a few custom tools.

This repo is meant to make a fresh Debian install usable quickly without turning it into a mess.

## What it installs

- base CLI tools
- dotfiles
- i3 desktop packages
- `empty-trash`
- iOS mount helpers

## How to use it

### Fast install

```bash
curl -fsSL https://raw.githubusercontent.com/Eng-ADAL/experimental_linux/main/install.sh | bash
````

### Manual install

```bash
git clone https://github.com/Eng-ADAL/experimental_linux.git
cd experimental_linux
bash install.sh
```

### Interactive bootstrap

If you want to pick modules one by one:

```bash
bash bootstrap.sh
```

Note: This repo still **under construction**

## Repository layout

```text
experimental_linux/
├── bootstrap.sh
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
│   │   ├── apt.txt
│   │   ├── empty-trash
│   │   └── install.sh
│   ├── ios-mount/
│   │   ├── apt.txt
│   │   └── build_ios_auto.sh
│   └── i3/
│       ├── apt.txt
│       └── install.sh
│
└── scripts/
    ├── install_packages.sh
    ├── install_flatpak.sh
    └── link_config.sh
```

## Modules

### base

Core CLI packages and general workstation tools.

### dotfiles

Links config files into place for:

* Git
* tmux
* Vim
* Zsh

### empty-trash

A small utility for checking and emptying the user trash folder.

Usage:

```bash
empty-trash
empty-trash --list
empty-trash --clean
empty-trash --version
```

### ios-mount

Helper scripts for mounting an iPhone or iPad from Linux.

### i3

Packages and setup for the i3 window manager environment.

## Config files

The main config files live under `configs/`:

* `configs/git/gitconfig`
* `configs/tmux/tmux.conf`
* `configs/vim/vimrc`
* `configs/zsh/zshrc`

These are linked into the home directory by the dotfiles module.

## Requirements

Tested on Debian 13.

You will need:

* `sudo`
* `curl`
* `git`

## Notes

* `bootstrap.sh` is for module-by-module installation.
* `install.sh` is the quick setup path.
* `modules/*.txt` files list package dependencies for each module.

## Roadmap

Planned work:

* module dependency handling
* non-interactive install mode
* better uninstall support

## License

MIT