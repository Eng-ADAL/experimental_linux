# experimental_linux

Under contruction!

New repo structure:

```
experimental_linux/
│
├── bootstrap.sh
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
│   └── debian-base.txt
│
├── modules/
│   ├── base/
│   │   └── install.sh
│   │
│   ├── dotfiles/
│   │   └── install.sh
│   │
│   ├── empty-trash/
│   │   ├── empty-trash
│   │   ├── install.sh
│   │   └── README.md
│   │
│   ├── ios-mount/
│   │   ├── build_ios_auto.sh
│   │   └── install.sh
│   │
│   └── i3/
│       └── install.sh
│
└── scripts/
    ├── install_packages.sh
    └── link_config.sh
```
