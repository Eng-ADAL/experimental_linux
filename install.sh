#!/usr/bin/env bash
set -e

echo "BOOTSTRAP: experimental_linux starting"

PACKAGES=(
  git vim tmux zsh
  ripgrep bat fd-find
  curl wget gpg tree htop
)

echo "Installing base packages"
sudo apt update
sudo apt install -y "${PACKAGES[@]}"

echo "Linking dotfiles"
ln -sf "$PWD/config/vimrc" ~/.vimrc
ln -sf "$PWD/config/tmux.conf" ~/.tmux.conf
ln -sf "$PWD/config/zshrc" ~/.zshrc

if [ -f "$PWD/config/gitconfig" ]; then
  ln -sf "$PWD/config/gitconfig" ~/.gitconfig
fi

echo "Installing TPM (tmux plugin manager)"
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Installing Vim plug"
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "Applying Debian fixes"
if ! grep -q "alias bat=" ~/.zshrc; then
  echo "alias bat=batcat" >> ~/.zshrc
  echo "alias fd=fdfind" >> ~/.zshrc
  echo "alias ripgrep=rg" >> ~/.zshrc
fi

echo "DONE. Restart terminal. Then run :PlugInstall in Vim."

