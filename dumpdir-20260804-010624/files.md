# File dump

===== dumpdir-20260804-010624/tree.txt =====
[mime: text/plain, size: 1732 bytes, lines: 69]
# dumpdir snapshot

- root: /home/eng-adal/PROJECTS_WSL/experimental_linux
- output: /home/eng-adal/PROJECTS_WSL/experimental_linux/dumpdir-20260804-010624
- created: 2026-08-04 00:06:24Z
- host: WIN-HOST

## Git

- branch: refactor/installer
- commit: a573f46
- status:
 M bootstrap.sh
?? dumpdir-20260804-010624/

## Tree

/home/eng-adal/PROJECTS_WSL/experimental_linux
├── .gitignore
├── LICENSE
├── README.md
├── VERSION
├── bootstrap.sh
├── configs
│   ├── tmux
│   │   ├── tmux.cheatsheet.txt
│   │   └── tmux.conf
│   ├── vim
│   │   └── vimrc
│   └── zsh
│       └── zshrc
├── dumpdir-20260804-010624
│   └── tree.txt
├── experimental_linux.png
├── install.sh
├── manifests
│   ├── apt-base.txt
│   └── flatpak.txt
├── modules
│   ├── base
│   │   ├── apt.txt
│   │   └── install.sh
│   ├── dotfiles
│   │   └── install.sh
│   ├── i3
│   │   ├── apt.txt
│   │   └── install.sh
│   ├── modules.list
│   ├── oh-my-zsh
│   │   └── install.sh
│   └── sway
│       ├── apt.txt
│       └── install.sh
├── scripts
│   ├── add_sudoer.sh
│   ├── create_continue_setup.sh
│   ├── detect_environment.sh
│   ├── detect_user.sh
│   ├── diagnostics.sh
│   ├── install_flatpak.sh
│   ├── install_packages.sh
│   └── link_config.sh
└── welcome
    └── welcome.py

15 directories, 32 files

## Files


===== .gitignore =====
[mime: text/plain, size: 22 bytes, lines: 3]
*.swp
*.swo
.DS_Store

===== LICENSE =====
[mime: text/plain, size: 1061 bytes, lines: 21]
MIT License

Copyright (c) 2025 ADAL

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

===== README.md =====
[mime: text/plain, size: 5156 bytes, lines: 289]
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

![experimental_linux](experimental_linux.png)

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
├── scripts
│   ├── create_continue_setup.sh
│   ├── detect_environment.sh
│   ├── detect_user.sh
│   ├── install_flatpak.sh
│   ├── install_packages.sh
│   └── link_config.sh
│
└── welcome
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

## Open issues
* WSL clipboard integration
* Installation profiles (minimal/developer/full)
* coc.nvim + Node.js separation
* Uninstall support
* Environment-aware modules

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


===== VERSION =====
[mime: text/plain, size: 6 bytes, lines: 1]
0.4.1

===== bootstrap.sh =====
[mime: text/x-shellscript, size: 3070 bytes, lines: 147]
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$ROOT_DIR/VERSION")"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[bootstrap] could not detect target user" >&2
  exit 1
fi

MODULE_DIR="$ROOT_DIR/modules"

PROFILE=""
AUTO_YES=false

usage() {
cat <<EOF

experimental_linux bootstrap $VERSION

Usage:

  ./bootstrap.sh --profile sway
  ./bootstrap.sh --profile i3
  ./bootstrap.sh --profile auto      (default if nothing is given)

  --desktop sway / --desktop i3 are accepted as legacy aliases for
  --profile sway / --profile i3.

Options:

  --profile <sway|i3|auto>   Choose what gets installed (default: auto)
  --desktop <sway|i3>        Legacy alias for --profile
  -y, --yes          Non-interactive mode
  -h, --help         Show help

EOF
}

install_module() {
    local module="$1"

    if [[ ! -f "$MODULE_DIR/$module/install.sh" ]]; then
        echo "[bootstrap] module not found: $module"
        exit 1
    fi

    echo
    echo "=================================================="
    echo "Installing module: $module"
    echo "=================================================="
    echo

    bash "$MODULE_DIR/$module/install.sh"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -- profile)
           PROFILE="${2:1}"
           shift 2
           ;;
        --desktop)
            PROFILE="${2:-}"
            shift 2
            ;;
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "[bootstrap] unknown argument: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$PROFILE" ]]; then
    PROFILE="auto"
fi

export AUTO_YES

echo
echo "experimental_linux bootstrap"
echo "desktop: $PROFILE"
echo

#
# Core workstation
#

install_module base
install_module dotfiles
install_module oh-my-zsh

#
# Desktop
#

# Profile resolution. Real platform/capability-based auto-detection is
# not implemented yet, that's a later slice. Until then, auto
# deliberately installs no desktop, rather than guessing one.
case "PROFILE" in
    sway)
        install_module sway
        ;;
    i3)
        install_module i3
        ;;
    auto)
    echo "[bootstrap] profile=auto: automatic desktop selection isn't implemented yet."
    echo "[bootstrap] installing base tools only, no desktop."
    echo "[bootstrap] use --profile sway or --profile i3 to choose one explicitly."
    ;;
    *)
        echo "[bootstrap] unsupported desktop: $PROFILE"
        exit 1
        ;;
esac

#
# Welcome experience
#

if [[ -f "$ROOT_DIR/scripts/create_continue_setup.sh" ]]; then
    bash "$ROOT_DIR/scripts/create_continue_setup.sh"
fi

# for phase 2 commented out need maintenance with create_continue_setup.sh 
# install -o "$TARGET_USER" -g "$TARGET_USER" -m 0644 /dev/null \
#  "$TARGET_HOME/.eng-workstation-installed"

echo
echo "Bootstrap complete."
echo
echo "Reboot recommended."
echo

===== configs/tmux/tmux.cheatsheet.txt =====
[mime: text/plain, size: 1607 bytes, lines: 62]
TMUX CHEATSHEET
===============

Quick controls
--------------
Prefix key: Ctrl + b    (can be change at ~/.tmux.conf)

Prefix + r   Reload tmux config
Prefix + R   Refresh client display
Prefix + h   Open this cheatsheet popup
Prefix + ?   Open tmux original cheatsheet

Pane navigation      |    Arrow keys also work:
---------------           ---------------------
Alt + h   Move left         ←
Alt + j   Move down         ↓
Alt + k   Move up           ↑
Alt + l   Move right        →

Pane resizing
-------------
Prefix + H   Resize pane left by 5
Prefix + J   Resize pane down by 5
Prefix + K   Resize pane up by 5
Prefix + L   Resize pane right by 5

Window navigation
-----------------
Alt + 1   Go to window 1
Alt + 2   Go to window 2
Alt + 3   Go to window 3
Alt + 4   Go to window 4
Alt + 5   Go to window 5
Alt + 6   Go to window 6
Alt + 7   Go to window 7
Alt + 8   Go to window 8
Alt + 9   Go to window 9
Alt + 0   Go to window 0

Ctrl + Alt + h   Previous window
Ctrl + Alt + l   Next window

Copy mode
---------
tmux uses vi-style copy mode.

Inside copy mode:
v    Start selection
y    Copy selection and exit
Enter Copy selection and exit

ctrl + c and ctrl + v also works globally

Splits and windows                      Defaults are also available
------------------                      ---------------------------
Prefix + |   Split pane horizontally                %
Prefix + -   Split pane vertically                  "
Prefix + !   Break pane to a new window
Prefix + c   Create new window in current path
Prefix + x   Kill the active pane
Prefix + &   Kill current window


===== configs/tmux/tmux.conf =====
[mime: text/plain, size: 6995 bytes, lines: 238]
# =====================================================================
#
#                                  github
#                                 @Eng-ADAL
#                                ¯\\_(ツ)_/¯
#
#               ┌─────────────────────────────────────────┐
#               │ Requirements                            │
#               │ tmux >= 3.2                             │
#               │ tmux plugin manager (TPM)               │
#               │ optional: batcat for cheatsheet popup   │
#               └─────────────────────────────────────────┘
#
# =====================================================================
#                Enterprise Grade Tmux Config (~/.tmux.conf)
# =====================================================================


# ----------------------
# Quick controls
# ----------------------

# Prefix = Ctrl + b
# Prefix + r  reload config
# Prefix + R  refresh client
# Prefix + h  cheatsheet popup

# ----------------------
# Terminal behaviour
# ----------------------

set -g mouse on

set -g default-terminal "tmux-256color"
set -as terminal-features ",xterm-256color:RGB"
set -g focus-events on
set -g allow-rename off
setw -g automatic-rename off

# ----------------------
# Change Prefix (optional) Ctrl+b to Ctrl+a
# ----------------------

# set -g prefix C-a
# unbind C-b
# bind C-a send-prefix

# ----------------------
# Reload config + tmux
# ----------------------

# Reload config with Prefix + r
bind r source-file ~/.tmux.conf \; display-message "tmux config reloaded"

# Refresh the client display with Prefix + R
bind-key R refresh-client

# ----------------------
# Pane Navigation
# ----------------------

bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R

# Resize panes faster
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5


# ----------------------
# Window Navigation
# ----------------------

bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5
bind -n M-6 select-window -t 6
bind -n M-7 select-window -t 7
bind -n M-8 select-window -t 8
bind -n M-9 select-window -t 9
bind -n M-0 select-window -t 0

bind -n C-M-h previous-window
bind -n C-M-l next-window

bind -n C-M-Left previous-window
bind -n C-M-Right next-window

# ----------------------
# Copy Mode
# ----------------------

set -g mode-keys vi
set -g set-clipboard on

# Global clip copy
# set -g set-clipboard external
set -g assume-paste-time 1

bind-key -T copy-mode-vi v send -X begin-selection
bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
bind-key -T copy-mode-vi Enter send -X copy-selection-and-cancel

# Faster command repeat
set -s repeat-time 200


# ----------------------
# Pane / Window Creation
# ----------------------

bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"

# Traditional tmux pane splits
# bind % split-window -h -c "#{pane_current_path}"
# bind '"' split-window -v -c "#{pane_current_path}"

# Scroll history limit
set -g history-limit 50000

# Windows number starts from 1
set -g base-index 1
setw -g pane-base-index 1

# Deleted windows renumber automatically
set -g renumber-windows on

# Prevents tmux from kicking you out when a session/window dies
set -g detach-on-destroy off

# ----------------------
# Plugins
# ----------------------

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

set -g @resurrect-dir ~/.tmux/resurrect
set -g @resurrect-capture-pane-contents on

set -g @continuum-restore on
set -g @continuum-boot off
set -g @continuum-save-interval 10

# ----------------------
# Cheat Sheet Popup
# ----------------------

# Cheatsheet popup, uses batcat if available
bind-key h display-popup -E -w 73 -h 90% "bash -c 'clear; command -v batcat >/dev/null 2>&1 && batcat --paging=always ~/.tmux.cheatsheet.txt || less ~/.tmux.cheatsheet.txt'"

#bind-key h display-popup -E -w 73 -h 90% "bash -c 'clear; less ~/.tmux.cheatsheet.txt'"


# ------------------ #
#     Status Bar
# ------------------ #

# Status bar settings - use glyphs if you have a patched font; if not, visual will still work
set -g status on
set -g status-interval 5
set -g status-justify centre
set -g status-left-length 50
set -g status-right-length 150

# Colours (using terminal colour names)
set -g @color_bg_dark colour232
set -g @color_bg_dark_g colour239
set -g @color_fg_light colour231
set -g @color_user colour254
set -g @color_host colour252
set -g @color_date colour245
set -g @color_time colour252
set -g @color_accent0 colour233
set -g @color_accent1 colour208
set -g @color_accent2 colour39
set -g @color_accent3 colour5
set -g @color_accent4 colour234
set -g @color_doodle_bg colour2
set -g @color_doodle_fg colour255

set -g status-style "bg=#{@color_bg_dark},fg=#{@color_fg_light}"

# Left: session and user; fall back to ASCII doodle if glyphs missing
set -g status-left "\
#[bg=#{@color_accent1},fg=#{@color_accent0},bold]#S\
#[fg=#{@color_accent1},bg=#{@color_bg_dark}]\
#[fg=#{@color_bg_dark},bg=#{@color_bg_dark}]\
#[fg=#{@color_bg_dark},bg=#{@color_bg_dark_g}]\
#[fg=#{@color_user},bg=#{@color_bg_dark_g},bold] #(whoami) \
#[fg=#{@color_bg_dark},bg=#{@color_bg_dark_g}]\
#[fg=#{@color_doodle_bg},bg=#{@color_bg_dark}]\
#[fg=#{@color_doodle_fg},bg=#{@color_doodle_bg}]¯\\_(ツ)_/¯\
#[fg=#{@color_doodle_bg},bg=#{@color_bg_dark}]"

# Highlight current window
setw -g window-status-current-format "\
#[fg=#{@color_accent2},bg=#{@color_bg_dark}]\
#[fg=#{@color_bg_dark},bg=#{@color_accent2},bold]#I:#W\
#[fg=#{@color_accent2},bg=#{@color_bg_dark}]"

setw -g window-status-format "\
#[fg=#{@color_bg_dark},bg=#{@color_bg_dark_g}]\
#[bg=#{@color_bg_dark_g},fg=#{@color_fg_light}]#I:#W#[default]\
#[fg=#{@color_bg_dark_g},bg=#{@color_bg_dark}]"

# Right: host + date + time
set -g status-right "\
#[fg=#{@color_bg_dark},bg=#{@color_bg_dark_g}]\
#[fg=#{@color_host},bg=#{@color_bg_dark_g}]@#h\
#[fg=#{@color_bg_dark},bg=#{@color_bg_dark_g}]\
#[fg=#{@color_accent3},bg=#{@color_bg_dark}]\
#[fg=#{@color_date},bg=#{@color_accent3},bold]%y-%m-%d \
#[fg=#{@color_accent4},bg=#{@color_accent3}]λ\
#[fg=#{@color_time},bg=#{@color_accent3},bold] %H:%M #[default]\
#[fg=#{@color_bg_dark},bg=#{@color_accent3}]"

# Initialize TPM (Tmux Plugin Manager) if present

if-shell 'test -x ~/.tmux/plugins/tpm/tpm' \
  'run-shell ~/.tmux/plugins/tpm/tpm'

set -g escape-time 10


===== configs/vim/vimrc =====
[mime: text/plain, size: 15027 bytes, lines: 344]
" =====================================================================
"
"                                  github
"                                 @Eng-ADAL
"                                ¯\\_(ツ)_/¯
"
" =====================================================================
"                          Senior Grad Vim (.vimrc)
" =====================================================================
" 
" After set ~/.vimrc
" Install pluggins
" :PlugInstall
"
" install Node.js®
" sudo apt install nodejs npm | for debian/ubuntu apt
"
" After plugin installation
" :CocInstall coc-pyright coc-json coc-tsserver coc-sh coc-yaml coc-clangd


set nocompatible
" keep filetype off until plugin init
filetype off

" -------------------------
" Plugins (lightweight & essential)
" -------------------------
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }   " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Fuzzy finder native installer
Plug 'junegunn/fzf.vim'                                 " FZF integration
Plug 'tpope/vim-obsession'                              " Session manager
Plug 'preservim/vim-indent-guides'                      " Visual indent lines
Plug 'benmills/vimux'                                   " Run shell commands via tmux
Plug 'christoomey/vim-tmux-navigator'                   " Navigate between vim and tmux panes easily
Plug 'morhetz/gruvbox'

" --- Upgrades ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}         " VSCodium-style intelligence
Plug 'jiangmiao/auto-pairs'                             " auto-pairs	automatic bracket/quote completion
Plug 'tpope/vim-commentary'                             " vim-commentary	fast commenting
Plug 'airblade/vim-gitgutter'                           " gitgutter	git diff signs in gutter
Plug 'airblade/vim-rooter'                              " auto-detects project root via: .git | package.json | pyproject.toml | etc

call plug#end()

" =====================================================================
" Ensure required directories (undo/backup/swap) exist
" =====================================================================
silent! call mkdir(expand('~/.vim/undo'), 'p')
silent! call mkdir(expand('~/.vim/backup'), 'p')
silent! call mkdir(expand('~/.vim/swap'), 'p')


" =====================================================================
" Vim persistent undo and sensible backups
" =====================================================================
set undofile
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//


" =====================================================================
" Mouse behaviour and Copy Paste
" =====================================================================
" Enable mouse in Vim
set mouse=a

" High confidence copy workflow
vnoremap <C-c> "+y
nnoremap <C-c> "+yy


" =====================================================================
" Basic UI
" =====================================================================
syntax on
set number
set relativenumber
set signcolumn=yes
set hlsearch
set ignorecase
set smartcase

" =====================================================================
" True colour if supported
" =====================================================================
if (has("termguicolors"))
  set termguicolors
endif

" =====================================================================
" Editor preferences
" =====================================================================
set hidden
set updatetime=300
set completeopt=menuone,noinsert,noselect
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8
filetype plugin indent on


" =====================================================================
" Reduce viminfo pressure for huge tmux restores
" =====================================================================
set viminfo='50,<100,s10,h


" =====================================================================
" Visual indentation with safe fallbacks
" =====================================================================
set list
" Unicode glyphs may not render on all terminals, so provide safe ASCII fallback
if &term =~# '256color'
  set listchars=tab:┊\ ,trail:·,extends:>,precedes:<
else
  set listchars=tab:>-,trail:-,extends:>,precedes:<
endif

" =====================================================================
" Colours - try gruvbox, else fall back to desert
" =====================================================================
set background=dark
try
  colorscheme gruvbox
catch
  colorscheme desert
endtry

" =====================================================================
" Leader key
" =====================================================================
let mapleader = " "

" =====================================================================
" Plugin Settings and Mappings
" =====================================================================

" --- NERDTree ---
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" --- FZF ---
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

" =====================================================================
" --- Vimux (run commands in tmux split) ---
" =====================================================================

" Use shellescape to safely handle filenames with spaces (update and run)
nnoremap <silent> <leader>r :update<CR>:call VimuxRunCommand('python3 ' . shellescape(expand("%"), 1))<CR>

" Run command in vim
nnoremap <silent> <leader>t :VimuxPromptCommand<CR>

" Create / reuse a tmux pane for running code with venv (direnv)
nnoremap <leader>rp :VimuxOpenRunner<CR>:call VimuxRunCommand('direnv exec . "$SHELL"')<CR>

" Run last command again
nnoremap <leader>rr :VimuxRunLastCommand<CR>

" Kill runner pane if needed
nnoremap <leader>rk :VimuxCloseRunner<CR>

" Clean/Reset runner terminal
nnoremap <silent> <leader>rc :call VimuxRunCommand("reset")<CR>

" Launch tiny pane for running code (if not exist)
let g:VimuxHeight = "40"
let g:VimuxOrientation = "h"

" --- Obsession ---
nnoremap <silent> <leader>s :Obsession<CR>


" --- Obsession Save Rule ---
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winpos,winsize

" --- [ESC] Remove Search Highlights ---
nnoremap <Esc> :nohlsearch<CR><Esc>


" --- Split Vim Panes ---
" Move between Vim splits with Ctrl-h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Create splits quickly
nnoremap <leader>- :split<CR>
nnoremap <leader>\| :vsplit<CR>


" --- Coc mappings ---
" Go to definition
nmap gd <Plug>(coc-definition)

" Go to references
nmap gr <Plug>(coc-references)

" Rename symbol
nmap rn <Plug>(coc-rename)

" Hover documentation
nnoremap K :call CocActionAsync('doHover')<CR>

" Trigger completion manually
inoremap <silent><expr> <C-Space> coc#refresh()

" TAB completion like VSCode
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

" Shift-TAB navigate backwards
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" --- vim-indent-guides ---
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
augroup IndentGuidesColors
  autocmd!
  autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=236
  autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=238
augroup END


" Show diagnostic under cursor
nnoremap <silent> <leader>d :call CocActionAsync('diagnosticInfo')<CR>

" Next diagnostic
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Previous diagnostic
nmap <silent> [d <Plug>(coc-diagnostic-prev)




" =====================================================================
" Cheatsheet (press <Space> ?)
" =====================================================================
function! ShowCheatsheetFull() abort
  silent! tabnew __VIM_CHEATSHEET__
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nowrap
  setlocal nonumber norelativenumber
  setlocal modifiable

  call setline(1, [
        \ '  ┌─────────────────────────────────────────────────────────────────────┐',
        \ '  │ Vim Cheatsheet v3                                   (q or <Space>)  │',
        \ '  ├─────────────────────────────────────────────────────────────────────┤',
        \ '  │ Search | Replace                                                    │',
        \ '  │   /pattern  -> search forward    n / N -> next / previous match     │',
        \ '  │   :noh      -> clear search highlight or [ESC]                      │',
        \ '  │   :%s/old/new/gc -> Replace | "c" for confromation %" for al lines  │',
        \ '  │                                                                     │',
        \ '  │ Splits / Windows                                                    │',
        \ '  │   <leader>-   -> horizontal split                                   │',
        \ '  │   <leader>|   -> vertical split                                     │',
        \ '  │   <C-h/j/k/l> -> move between Vim splits                            │',
        \ '  │   <C-w>w      -> next split                                         │',
        \ '  │   :only       -> close other splits                                 │',
        \ '  │   :q          -> close current split                                │',
        \ '  │                                                                     │',
        \ '  │ Buffers                                                             │',
        \ '  │   :ls        -> list buffers                                        │',
        \ '  │   :bn / :bp  -> next / previous buffer                              │',
        \ '  │   :bd        -> delete buffer                                       │',
        \ '  │                                                                     │',
        \ '  │ Files / Search                                                      │',
        \ '  │   <Space>f   -> FZF file search                                     │',
        \ '  │   <Space>b   -> FZF buffer list                                     │',
        \ '  │   <Space>n   -> NERDTree toggle                                     │',
        \ '  │                                                                     │',
        \ '  │ Coc / Intelligence                                                  │',
        \ '  │   gd         -> go to definition                                    │',
        \ '  │   gr         -> references                                          │',
        \ '  │   rn         -> rename symbol                                       │',
        \ '  │   K          -> hover documentation                                 │',
        \ '  │   ]d / [d    -> next / previous diagnostic                          │',
        \ '  │   <Space>d   -> diagnostic info under cursor                        │',
        \ '  │   <Tab>      -> select / trigger completion                         │',
        \ '  │                                                                     │',
[truncated: first 300 lines only]

===== configs/zsh/zshrc =====
[mime: text/plain, size: 4311 bytes, lines: 200]
# ~/.zshrc
# =====================================================================
#
#                                  github
#                                 @Eng-ADAL
#                                ¯\\_(ツ)_/¯
#
# =====================================================================
#                          Enterprise Grad ZSH (.zshrc)
# =====================================================================


# ----------------------
# PATH early and clean
# ----------------------
typeset -U path
path=(
  $HOME/.local/bin
  $HOME/bin
  $path
)
export PATH

# ----------------------
# Oh My Zsh
# ----------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

# Optional plugins if installed
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  plugins+=(zsh-autosuggestions)
fi
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  plugins+=(zsh-syntax-highlighting)
fi

if [ -s "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ----------------------
# Preferred editor
# ----------------------
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
elif command -v vim >/dev/null 2>&1; then
  export EDITOR='vim'
else
  export EDITOR='nano'
fi

# ----------------------
# Command Shortener
# ----------------------
# BatCat cool cat
#alias bat=batcat
# fdfind finder
#command -v fdfind >/dev/null && alias fd=fdfind

alias fd='fdfind'
alias bat='batcat'

# ----------------------
# tmux helpers
# ----------------------
alias ta='tmux attach'
alias tat='tmux attach -t'
alias tn='tmux new -s'
alias tls='tmux ls'
alias tk='tmux kill-session -t'

# ----------------------
# Iphone moun/unmount/directory 
# ----------------------
# Mount and enter iPhone folder
alias imount='mkdir -p ~/iPhone && (mount | grep -q ~/iPhone && echo "Already mounted" || ifuse ~/iPhone) && cd ~/iPhone'
# Unmount cleanly
alias iumount='fusermount3 -u ~/iPhone 2>/dev/null || fusermount -u ~/iPhone 2>/dev/null || sudo umount -l ~/iPhone'
# Quick cd into iPhone folder
alias cdiph='cd ~/iPhone'


# ----------------------
# File tools
# ----------------------
alias tree="tree -I '*venv*|*__pycache__*'"
alias trea="tree -a -I '*venv*|*__pycache__*|*.git*|*direnv*'"

# Make directory and change directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ----------------------
# Safer file operations
#----------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ----------------------
# Git shortcuts
# ----------------------
alias gs='git status'
alias gsv='git status -vv'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# ----------------------
# Clipboard sanity (tmux + Linux)
# ----------------------

# GPG key
export GPG_TTY=$(tty)

# Use correct TERM outside tmux
if [ -z "$TMUX" ]; then
  export TERM=xterm-256color
fi

# Fix bracketed paste inside tmux
if [[ -n $TMUX ]]; then
  autoload -Uz bracketed-paste-magic
  zle -N bracketed-paste bracketed-paste-magic
fi

# WSL copy.exe copyclip encoding issue fix | comment or delete on Real or VM Linux environment
copyclip() {
  iconv -f utf-8 -t utf-16le | clip.exe
}


# ----------------------
# Personal aliases and functions
# ----------------------

# Run joplin from terminal
alias joplin='flatpak run net.cozic.joplin_desktop'

# start X session manually
alias s='startx'



# dump directory and files
dumpdir() {
  local IGNORE_DIRS='.git|node_modules|__pycache__|venv'

  tree -a -I "$IGNORE_DIRS"
  echo

  rg --files \
    -g '!.git/*' \
    -g '!node_modules/*' \
    -g '!__pycache__/*' \
    -g '!venv/*' \
    -g '!env/*' \
    -g '!.env*' \
    -g '!*.key' \
    -g '!*.pem' \
    -g '!*.crt' \
    -g '!*.p12' \
    -g '!*.pfx' \
    -g '!id_rsa*' \
    -g '!id_ed25519*' \
    -g '!*.sqlite' \
    -g '!*.db' \
    -g '*.sh' \
    -g '*.py' \
    -g '*.md' \
    -g '*.txt' \
    -g '*.json' \
    -g '*.yaml' \
    -g '*.yml' \
    -g '*.toml' \
    -g '*.conf' \
    -g '*.cfg' |
  while read -r file; do

    # skip large files
    if [ "$(stat -c%s "$file")" -gt 200000 ]; then
      continue
    fi

    # only dump text
    if file "$file" | grep -q text; then
      echo "===== $file ====="
      cat "$file"
      echo
    fi

  done
}

eval "$(direnv hook zsh)"


===== install.sh =====
[mime: text/x-shellscript, size: 4472 bytes, lines: 181]
#!/usr/bin/env bash
set -euo pipefail

# Error Handling
trap 'echo; echo "Interrupted."; exit 1' INT

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$ROOT_DIR/VERSION")"

MODULE_DIR="$ROOT_DIR/modules"
SCRIPT_DIR="$ROOT_DIR/scripts"
APT_MANIFEST="$ROOT_DIR/modules/base/apt.txt"

DRY_RUN=false
AUTO_YES=false
INSTALL_ALL=false

print_menu() {
echo
echo "      ╔══════════════════════════════════╗"
echo "      ║   experimental_linux bootstrap   ║"
echo "      ╚══════════════════════════════════╝"
echo
echo "       Repo root: $ROOT_DIR"
echo
echo "     1) Base CLI tools"
echo "     2) Dotfiles"
echo "     3) oh-my-zsh"
echo "     4) empty-trash utility        (coming soon)"
echo "     5) iOS mount tools            (coming soon)"
echo "     6) sway desktop environment   (use bootstrap.sh)"
echo "     7) i3   desktop environment   (use bootstrap.sh)"
echo
echo "     a) All (1-2-3)"
echo "     h) Help"
echo "     q) Quit"
echo
}

help_bootstrap() {
echo
echo "             experimental_linux installation $VERSION "
echo "          ───────────────────────────────────────────── "
echo "Usage:"
echo "  ./install.sh           interactive mode"
echo "  ./install.sh --all     Installing: CLI tools - Dotfiles - Oh My Zsh"
echo "  ./install.sh --all -y  install everyting (non-interactive)"
echo "  ./install.sh --version show version"
echo "  ./install.sh --help    show this help"
echo
echo " Base CLI tools:"
echo "[base] packages to install:"
grep -vE '^\s*#|^\s*$' "$APT_MANIFEST" | sed 's/^/  - /'
echo
echo " Dotfiles:               Vim - TMUX - ZSH"
echo " Desktop environments:"
echo "   Use bootstrap.sh --desktop sway"
echo "   Use bootstrap.sh --desktop i3"
echo " empty-trash utility:    Install trash bin app for smart deletion and recovery"
echo " iOS mount tools:        Install iOS (iPhone/iPad) mount tools"
echo "          ───────────────────────────────────────────── "
echo
}

prepare_environment() {
    echo "Preparing environment..."
    [[ -d "$MODULE_DIR" ]] || { echo "Modules directory missing"; exit 1; }
    [[ -d "$SCRIPT_DIR" ]] || { echo "Scripts directory missing"; exit 1; }

    chmod +x "$ROOT_DIR/install.sh"
    # make all helper scripts executable
    find "$SCRIPT_DIR" -type f -name "*.sh" -exec chmod +x {} \;
    # make all module installers executable
    find "$MODULE_DIR" -type f -name "install.sh" -exec chmod +x {} \;
}

install_module() {
    local module=$1
    if [[ -f "$MODULE_DIR/$module/install.sh" ]]; then
        echo
        echo "==> Installing $module"
        echo
        bash "$MODULE_DIR/$module/install.sh"
    else
        echo "Module $module not found."
    fi
}

# CI/CD args
for arg in "$@"; do
  case $arg in
    -y|--yes)
      AUTO_YES=true
      echo "[bootstrap] AUTO_YES=$AUTO_YES"
      ;;
    --all)
      INSTALL_ALL=true
      ;;
    --version)
      echo "experimental_linux version $VERSION"
      exit 0
      ;;
    --help)
      help_bootstrap
      exit 0
      ;;
  esac
done

export AUTO_YES


prepare_environment

# Dry run (need maintenance)
#if [[ "${DRY_RUN:-false}" == "true" ]]; then
#  echo "[DRY-RUN] apt install ${packages[*]}"
#  exit 0
#fi

# Install All interactive
if [[ "$INSTALL_ALL" == "true" ]]; then
  while read -r module; do
    install_module "$module"
  done < "$MODULE_DIR/modules.list"
  exit 0
fi

print_menu
read -rp "     Select option: " choice

case $choice in
1)
install_module base
;;
2)
install_module dotfiles
;;
3)
install_module oh-my-zsh
;;
4)
echo "Module temporarily unavailable"
#install_module empty-trash
;;
5)
echo "Module temporarily unavailable"
#install_module ios-mount
;;
6)
echo "Module temporarily unavailable"
#install_module sway
;;
7)
echo "Module temporarily unavailable"
#install_module i3
;;
a)
echo "Installing all modules"
echo " - Installing base"
install_module base
echo " - Installing dotfiles"
install_module dotfiles
echo " - Installing oh-my-zsh"
install_module oh-my-zsh
#install_module empty-trash
#install_module ios-mount
;;
h)
help_bootstrap
read -rp "Press any key to continue menu"
printf '\n%.0s' {1..50}
./install.sh
;;
q)
exit 0
;;
*)
echo "Invalid option"
;;
esac

===== manifests/apt-base.txt =====
[mime: text/plain, size: 82 bytes, lines: 14]
# core cli tools
git
vim
tmux
zsh

# utilities
7z
ripgrep
bat
curl
wget
tree
htop

===== manifests/flatpak.txt =====
[mime: text/plain, size: 48 bytes, lines: 2]
org.mozilla.firefox
org.libreoffice.LibreOffice

===== modules/base/apt.txt =====
[mime: text/plain, size: 107 bytes, lines: 18]
# core CLI
git
vim
tmux
zsh

# utilities
ripgrep
fd-find
bat
tree
htop
curl
wget
gpg
p7zip-full
direnv
fzf

===== modules/base/install.sh =====
[mime: text/x-shellscript, size: 703 bytes, lines: 21]
#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo
echo "      Update and [base] installing packages"
echo "  ───────────────────────────────────────────── "
echo
grep -vE '^\s*#|^\s*$' "$APT_MANIFEST" | sed 's/^/  - /'
echo
echo "  ───────────────────────────────────────────── "
echo

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

echo "[base] done"

===== modules/dotfiles/install.sh =====
[mime: text/x-shellscript, size: 2842 bytes, lines: 106]
#!/usr/bin/env bash
set -euo pipefail

# Error handling
trap 'echo; echo "Interrupted."; exit 1' INT

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[dotfiles] could not detect target user" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
TPM_DIR="$TARGET_HOME/.tmux/plugins/tpm"
DATETIME="$(date +"%Y%m%d_%H%M%S")"
AUTO_YES="${AUTO_YES:-false}"

echo "[dotfiles] linking configs"

link_config() {
  local src="$1"
  local dest="$2"
  local confirm="n"

  if [[ ! -e "$dest" ]]; then
    ln -sf "$src" "$dest"
    echo "[dotfiles] linked $dest"
    return
  fi

  if [[ "$AUTO_YES" == "true" ]]; then
    confirm="y"
  else
    read -rp "[dotfiles] overwrite $dest? (y/N): " confirm
  fi

  if [[ "$confirm" == "y" ]]; then
    cp -L "$dest" "$dest.old.$DATETIME" 2>/dev/null || true
    echo "[dotfiles] backup: $dest.old.$DATETIME"
    ln -sf "$src" "$dest"
    echo "[dotfiles] updated $dest"
  else
    echo "[dotfiles] skipped $dest"
  fi
}

install_vim_plug() {
  local target_user="$1"
  local target_home="$2"

  sudo -u "$target_user" -H mkdir -p "$target_home/.vim/autoload"

  if [[ ! -f "$target_home/.vim/autoload/plug.vim" ]]; then
    sudo -u "$target_user" -H curl -fLo "$target_home/.vim/autoload/plug.vim" \
      --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

for cmd in git curl vim; do
    command -v "$cmd" >/dev/null || {
        echo "[dotfiles] missing dependency: $cmd"
        exit 1
    }
done

link_config "$ROOT_DIR/configs/tmux/tmux.conf" "$TARGET_HOME/.tmux.conf"
link_config "$ROOT_DIR/configs/tmux/tmux.cheatsheet.txt" "$TARGET_HOME/.tmux.cheatsheet.txt"
link_config "$ROOT_DIR/configs/vim/vimrc" "$TARGET_HOME/.vimrc"
link_config "$ROOT_DIR/configs/zsh/zshrc" "$TARGET_HOME/.zshrc"

install_vim_plug "$TARGET_USER" "$TARGET_HOME"

echo "[dotfiles] installing vim plugins"
sudo -u "$TARGET_USER" -H env HOME="$TARGET_HOME" \
    vim +'PlugInstall --sync' +'qa'

echo "[dotfiles] setting up tmux plugins (TPM)"
if command -v git >/dev/null; then
  if [[ ! -d "$TPM_DIR" ]]; then
    sudo -u "$TARGET_USER" -H git clone \
      https://github.com/tmux-plugins/tpm \
      "$TPM_DIR"
    echo "[dotfiles] TPM installed"
  else
    echo "[dotfiles] TPM already installed"
  fi
else
  echo "[dotfiles] warning: git not installed, skipping TPM"
fi

if command -v tmux >/dev/null && [[ -x "$TPM_DIR/bin/install_plugins" ]] && [[ -f "$TARGET_HOME/.tmux.conf" ]]; then
  sudo -u "$TARGET_USER" -H env HOME="$TARGET_HOME" \
    "$TPM_DIR/bin/install_plugins"
  echo "[dotfiles] tmux plugins installed"
else
  echo "[dotfiles] tmux plugins skipped"
fi

echo "[dotfiles] done"


===== modules/i3/apt.txt =====
[mime: text/plain, size: 208 bytes, lines: 21]
# i3 desktop
i3
i3status
i3lock
dmenu
xorg
xinit

# desktop utilities
feh
lxappearance
rofi
picom
alacritty

# network and media
network-manager
network-manager-gnome
pulseaudio-utils
brightnessctl
playerctl

===== modules/i3/install.sh =====
[mime: text/x-shellscript, size: 501 bytes, lines: 24]
#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo
echo "[i3] installing packages"
echo

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

if [[ $EUID -eq 0 ]]; then
  systemctl enable NetworkManager
  systemctl enable fstrim.timer
else
  sudo systemctl enable NetworkManager
  sudo systemctl enable fstrim.timer
fi

echo "[i3] done"

===== modules/modules.list =====
[mime: text/plain, size: 39 bytes, lines: 5]
base
dotfiles
i3
empty-trash
ios-mount

===== modules/oh-my-zsh/install.sh =====
[mime: text/x-shellscript, size: 782 bytes, lines: 32]
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"
if [[ -z "$TARGET_USER" ]]; then
  echo "[oh-my-zsh] could not detect target user" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -d "$TARGET_HOME/.oh-my-zsh" ]]; then
  echo "[oh-my-zsh] already installed"
  exit 0
fi

tmpfile="$(mktemp)"
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$tmpfile"

sudo -u "$TARGET_USER" -H env RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh "$tmpfile" --unattended

rm -f "$tmpfile"

echo
echo "[oh-my-zsh] installed"
echo "[oh-my-zsh] restart your shell to activate"

===== modules/sway/apt.txt =====
[mime: text/plain, size: 374 bytes, lines: 38]
# sway
sway
swaybg
swayidle
swaylock
waybar
wofi
foot
mako-notifier

# networking
network-manager
network-manager-gnome

# audio
pipewire
wireplumber
pipewire-pulse
pavucontrol

# utilities
brightnessctl
playerctl
wl-clipboard
grim
slurp

# portal
xdg-desktop-portal-wlr

# fonts
fonts-noto
fonts-font-awesome

# firmware
firmware-linux
firmware-iwlwifi
firmware-sof-signed

===== modules/sway/install.sh =====
[mime: text/x-shellscript, size: 553 bytes, lines: 29]
#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$MODULE_DIR/../.." && pwd)"

APT_MANIFEST="$MODULE_DIR/apt.txt"
INSTALL_PACKAGES="$ROOT_DIR/scripts/install_packages.sh"

echo
echo "[sway] installing packages"
echo

bash "$INSTALL_PACKAGES" "$APT_MANIFEST"

echo
echo "[sway] enabling services"
echo

if [[ $EUID -eq 0 ]]; then
  systemctl enable NetworkManager
  systemctl enable fstrim.timer
else
  sudo systemctl enable NetworkManager
  sudo systemctl enable fstrim.timer
fi

echo
echo "[sway] done"

===== scripts/add_sudoer.sh =====
[mime: text/x-shellscript, size: 967 bytes, lines: 44]
#!/usr/bin/env bash
set -euo pipefail

detect_candidate_users() {
  getent passwd | awk -F: '
    $3 >= 1000 && $1 != "nobody" && $1 != "systemd-network" && $1 != "systemd-timesync" {
      print $1
    }'
}

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "[sudoer] run as root" >&2
  exit 1
fi

if [[ -n "${SUDO_USER:-}" && "${SUDO_USER:-root}" != "root" ]]; then
  TARGET_USER="$SUDO_USER"
else
  mapfile -t USERS < <(detect_candidate_users)

  case "${#USERS[@]}" in
    0)
      echo "[sudoer] no normal users found" >&2
      exit 1
      ;;
    1)
      TARGET_USER="${USERS[0]}"
      ;;
    *)
      echo "[sudoer] multiple users found:"
      select TARGET_USER in "${USERS[@]}"; do
        [[ -n "${TARGET_USER:-}" ]] && break
      done
      ;;
  esac
fi


if id -nG "$TARGET_USER" | grep -qw sudo; then
    echo "[sudoer] $TARGET_USER is already a sudoer."
else
    usermod -aG sudo "$TARGET_USER"
    echo "[sudoer] Added $TARGET_USER to sudo group."
fi

===== scripts/create_continue_setup.sh =====
[mime: text/x-shellscript, size: 735 bytes, lines: 37]
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$ROOT_DIR/scripts/detect_user.sh"

TARGET_USER="$(detect_primary_user)"

if [[ -z "$TARGET_USER" ]]; then
    exit 0
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

cat > "$TARGET_HOME/Continue_Setup.sh" <<'EOF'
#!/usr/bin/env bash

MARKER="$HOME/.adal-workstation-installed"

if [[ -f "$MARKER" ]]; then
    echo
    echo "Workstation already configured."
    exit 0
fi

echo
echo "Welcome to eng-workstation."
echo
echo "Documentation:"
echo "https://example.com"
echo
EOF

chmod +x "$TARGET_HOME/Continue_Setup.sh"
chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/Continue_Setup.sh"

===== scripts/detect_environment.sh =====
[mime: text/plain, size: 52 bytes, lines: 1]
# Place holder for environment and distro detection

===== scripts/detect_user.sh =====
[mime: text/x-shellscript, size: 268 bytes, lines: 12]
#!/usr/bin/env bash
set -euo pipefail

detect_primary_user() {
  if [[ -n "${SUDO_USER:-}" && "${SUDO_USER:-root}" != "root" ]]; then
    printf '%s\n' "$SUDO_USER"
    return 0
  fi

  getent passwd \
    | awk -F: '$3 >= 1000 && $1 != "nobody" { print $1; exit }'
}

===== scripts/diagnostics.sh =====
[mime: text/x-shellscript, size: 4006 bytes, lines: 177]
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
DEFAULT_OUTPUT="/tmp/dev-workstation-diagnostics-${TIMESTAMP}.txt"
OUTPUT="${1:-$DEFAULT_OUTPUT}"

mkdir -p "$(dirname "$OUTPUT")"

# Write to both terminal and file
exec > >(tee -a "$OUTPUT") 2>&1

section() {
  echo
  echo "=================================================="
  echo "$1"
  echo "=================================================="
}

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd -> $(command -v "$cmd")"
  else
    echo "[MISSING] $cmd"
  fi
}

check_file() {
  local path="$1"
  if [[ -e "$path" ]]; then
    echo "[OK] $path"
    ls -ld "$path" 2>/dev/null || true
  else
    echo "[MISSING] $path"
  fi
}

echo "[diagnostics] output: $OUTPUT"
echo "[diagnostics] repo: $ROOT_DIR"

section "System"
if command -v hostnamectl >/dev/null 2>&1; then
  hostnamectl || true
else
  uname -a
fi

echo
echo "OS release:"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
else
  echo "No /etc/os-release found"
fi

echo
echo "Kernel:"
uname -r

echo
echo "Virtualisation:"
if command -v systemd-detect-virt >/dev/null 2>&1; then
  if systemd-detect-virt --quiet; then
    systemd-detect-virt
  else
    echo "none"
  fi
else
  echo "systemd-detect-virt not available"
fi

section "User and shell"
echo "User: $(id -un)"
echo "UID: $(id -u)"
echo "GID: $(id -g)"
echo "Groups: $(id -nG)"
echo "Shell: ${SHELL:-unknown}"
echo "HOME: ${HOME:-unknown}"
echo "SUDO_USER: ${SUDO_USER:-none}"
echo "SUDO_UID: ${SUDO_UID:-none}"

echo
echo "Current login shell from /etc/passwd:"
getent passwd "$(id -un)" | awk -F: '{print $7}' || true

section "Session"
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unset}"
echo "DISPLAY=${DISPLAY:-unset}"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-unset}"
echo "SWAYSOCK=${SWAYSOCK:-unset}"
echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unset}"

section "Graphics"
echo "DRM devices:"
if [[ -d /dev/dri ]]; then
  ls -l /dev/dri || true
else
  echo "No /dev/dri directory"
fi

echo
echo "GPU-related kernel modules:"
lsmod | grep -E 'i915|amdgpu|nouveau|vmwgfx|virtio_gpu|drm' || true

section "Commands"
check_cmd git
check_cmd curl
check_cmd wget
check_cmd sudo
check_cmd tmux
check_cmd vim
check_cmd zsh
check_cmd sway
check_cmd i3
check_cmd foot
check_cmd alacritty
check_cmd waybar
check_cmd wofi
check_cmd flatpak

section "Packages"
if command -v dpkg >/dev/null 2>&1; then
  for pkg in git tmux vim zsh sway i3 foot alacritty waybar wofi network-manager; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "[OK] package installed: $pkg"
    else
      echo "[MISS] package not installed: $pkg"
    fi
  done
else
  echo "dpkg not available"
fi

section "Dotfiles"
check_file "$HOME/.tmux.conf"
check_file "$HOME/.tmux.cheatsheet.txt"
check_file "$HOME/.vimrc"
check_file "$HOME/.zshrc"
check_file "$HOME/.vim/autoload/plug.vim"
check_file "$HOME/.tmux/plugins/tpm"
check_file "$HOME/.oh-my-zsh"

section "Git"
if command -v git >/dev/null 2>&1; then
  echo "git version: $(git --version)"
  echo
  echo "Global include.path:"
  git config --global --get-all include.path || echo "none"
fi

section "Services"
if command -v systemctl >/dev/null 2>&1; then
  for svc in NetworkManager fstrim.timer; do
    echo "--- $svc ---"
    systemctl is-enabled "$svc" 2>/dev/null || true
    systemctl is-active "$svc" 2>/dev/null || true
  done
else
  echo "systemctl not available"
fi

section "VM-specific hints"
if command -v systemd-detect-virt >/dev/null 2>&1 && systemd-detect-virt --quiet; then
  VIRT_TYPE="$(systemd-detect-virt)"
  echo "Detected VM: $VIRT_TYPE"
  if [[ "$VIRT_TYPE" == "vmware" ]]; then
    echo "Hint: Sway may need WLR_RENDERER=pixman on VMware."
  fi
fi

section "Useful environment"
env | grep -E '^(PATH|TERM|SHELL|HOME|USER|LOGNAME|XDG_|WAYLAND_DISPLAY|DISPLAY|SWAYSOCK|WLR_)=' | sort || true

section "Summary"
echo "Diagnostics written to: $OUTPUT"

===== scripts/install_flatpak.sh =====
[mime: text/x-shellscript, size: 795 bytes, lines: 44]
#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-}"

APT_CMD="apt-get"

if [[ $EUID -ne 0 ]]; then
    APT_CMD="sudo apt-get"
fi

if [[ -z "$MANIFEST" || ! -f "$MANIFEST" ]]; then
    echo "[flatpak] manifest not found: $MANIFEST"
    exit 1
fi

mapfile -t apps < <(
    grep -vE '^\s*#|^\s*$' "$MANIFEST"
)

if [[ ${#apps[@]} -eq 0 ]]; then
    echo "[flatpak] no applications found"
    exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
    echo "[flatpak] installing flatpak"

    $APT_CMD update
    $APT_CMD install -y flatpak
fi

echo "[flatpak] ensuring flathub"

flatpak remote-add \
    --if-not-exists \
    flathub \
    https://flathub.org/repo/flathub.flatpakrepo

echo "[flatpak] installing applications"

flatpak install -y flathub "${apps[@]}"

echo "[flatpak] done"

===== scripts/install_packages.sh =====
[mime: text/x-shellscript, size: 730 bytes, lines: 39]
#!/usr/bin/env bash
set -euo pipefail

MANIFEST="${1:-}"

APT_CMD="apt-get"

if [[ $EUID -ne 0 ]]; then
    APT_CMD="sudo apt-get"
fi


if [[ -z "$MANIFEST" || ! -f "$MANIFEST" ]]; then
  echo "[packages] ERROR: manifest not found: $MANIFEST"
  exit 1
fi

mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$MANIFEST")

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "[packages] WARNING: no packages in $MANIFEST"
  exit 0
fi

echo
echo "[packages] installing from: $MANIFEST"
printf "  - %s\n" "${packages[@]}"
echo

# Optional optimisation hook
if [[ "${APT_UPDATED:-false}" != "true" ]]; then
  echo "[packages] apt update"
  $APT_CMD update
  export APT_UPDATED=true
fi

$APT_CMD install -y "${packages[@]}"

echo "[packages] done"

===== welcome/welcome.py =====
[mime: text/plain, size: 30 bytes, lines: 1]
# Place holder for welcome.py

