# experimental_linux

Under construction!



New repo structure:


```
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
    └── link_config.sh```
