# experimental_linux

A reproducible Linux environment built like a product, not a pet.  
One repo. One script. Zero nonsense.

This project turns a fresh Linux install into a fully-loaded developer workstation using automation, configuration as code, and sharp defaults.

---

## What this does

This is not “dotfiles”.
This is infrastructure for a human.

The repo bootstraps:

- Zsh with sensible aliases and tooling
- Vim with plugin management and productivity defaults
- tmux with session persistence and workflow automation
- Git with signing support
- SSH ready for GitHub
- Core CLI tools wired for speed
- Package dependencies installed automatically

The goal is simple:  
**Rebuild any Linux machine in minutes, not days.**

---

## Quick start (new machine)

On a clean Linux system:

```bash
git clone git@github.com:eng-adal/experimental_linux.git
cd experimental_linux
./install.sh
exec zsh
````

Open Vim and install plugins:

```bash
vim
:PlugInstall
```

Done. Machine is live.

---

## Project structure

```
experimental_linux/
├── config/
│   ├── vimrc
│   ├── tmux.conf
│   ├── zshrc
│   └── gitconfig (optional)
├── install.sh
└── README.md
```

All configuration lives in version control.
All machines sync to this source of truth.

---

## Tooling included

This environment ships with:

* tmux for session control
* Vim with plugin system
* ripgrep (rg) for fast searching
* bat as pager replacement
* fd for file discovery
* Git with optional signing
* Zsh via Oh My Zsh
* tree, htop, curl, wget
* GPG tooling

## Command Aliases

This setup standardises modern CLI tools with short, familiar names.
The goal is muscle-memory compatibility with better tooling.

Add the following to your `~/.zshrc` or `~/.bashrc`:

```bash
# Modern replacements
alias bat='batcat'     # Better cat
alias fd='fdfind'      # Better find
alias rg='rg'          # ripgrep (already sane)

# Safer defaults
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias gsv='git status --short --branch'

# Quality of life
alias ll='ls -lah'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'


---

## Philosophy

This project exists because reinstalling a machine by hand is amateur hour.

The modern workstation is not setup.
It is deployed.

This repo treats developer environment as:

* versioned
* portable
* rebuildable
* owned

No screenshots.
No guesswork.
No drift.

---

## Contribution

This is a personal operating system with opinions.

Fork it.
Break it.
Improve it.
Steal ideas.
Build something better.

---

## Roadmap

Planned upgrades:

* OS detection in installer
* per-machine override profile
* secrets encryption
* signed tag releases
* remote bootstrap
* CI for environment validation

---

## Status

This repo is alive.
It evolves weekly.
It replaces documentation with automation.

If this machine dies tomorrow, this repo resurrects it.

---

## Licence

Use it.
Modify it.
Own it.

This is infrastructure, not art.

---


