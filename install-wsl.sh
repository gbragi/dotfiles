#!/bin/bash

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

if [[ $EUID = 0 ]]; then
    echo "This script must be run as normal user"
    exit 1
fi

TOOLS_DIR="$HOME/tools"
CODE_DIR="$HOME/code"

# Directory setup
echo "Setting up directories..."
rm -d ~/Pictures || true
rm -d ~/Templates || true
rm -d ~/Videos || true
rm -d ~/Music || true
rm -d ~/Public || true
rm -d ~/Documents || true
mkdir -p $CODE_DIR/tmp
mkdir -p $TOOLS_DIR

# Install packages
echo "Installing packages..."
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt install $(cat pkglist.txt)

#curl -sfL https://get.k3s.io | sh - --write-kubeconfig-mode 644
curl -fsSL https://get.pulumi.com | sh

echo "Install NeoVim"
curl -Lo "$TOOLS_DIR/nvim" https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x "$TOOLS_DIR/nvim"
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.local/bin
ln -sfn $(which fdfind) ~/.local/bin/fd

if ! [ "$SHELL" = "$(which zsh)" ]; then
    echo "Setting up zsh..."
    chsh -s $(which zsh)
fi

if command -v kubectl &> /dev/null; then
    echo "Setting up zsh kubectl completions..."
    mkdir -p ~/.zsh/completions
    kubectl completion zsh >| ~/.zsh/completions/_kubectx
fi

# Install dotfiles
# make symlinks from the home directory to files in ~/dotfiles
echo "Setting up dotfiles..."
CONFIG_DIR="$HOME/.config"
VSCODE_DIR="$CONFIG_DIR/Code/User"
BACKUP_DIR="./backup"
mkdir -p "$BACKUP_DIR"

echo stow vim
NVIM_DIR="$CONFIG_DIR/nvim"
mkdir -p "$NVIM_DIR"
stow neovim -t "$NVIM_DIR"

echo stow zshrc
P10K_DIR="$HOME/.zsh/powerlevel10k"
mkdir -p "$P10K_DIR"
stow powerlevel10k -t "$P10K_DIR"
stow zsh-wsl -t "$HOME"

echo stow git
stow git -t "$HOME"

echo stow profile
if ! grep -q '.profile.customize' ~/.profile; then
   echo "# Customize profile" >> ~/.profile
   echo ". ~/.profile.customize" >> ~/.profile
fi
stow profile -t "$HOME"