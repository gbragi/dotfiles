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
sudo pamac update
sudo pamac upgrade -a
sudo pamac install --no-confirm $(<pkgs/manjaro.txt)
#pamac build $(<pkgs/manjaro-aur.txt)

curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install dotfiles
# make symlinks from the home directory to files in ~/dotfiles
echo "Setting up dotfiles..."
CONFIG_DIR="$HOME/.config"
VSCODE_DIR="$CONFIG_DIR/Code/User"
BACKUP_DIR="./backup"
mkdir -p "$BACKUP_DIR"

echo stow profile
if ! grep -q '.profile.customize' ~/.profile; then
   echo "# Customize profile" >> ~/.profile
   echo ". ~/.profile.customize" >> ~/.profile
fi
stow profile -t "$HOME"

echo setup zsh
if ! grep -q '.zshrc.customize' ~/.zshrc; then
    echo "# Customize ZSH" >> ~/.zshrc
    echo ". ~/.zshrc.customize" >> ~/.zshrc
fi
stow zsh-manjaro -t "$HOME"

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting up zsh..."
    chsh -s $(which zsh)
fi

echo stow vscode
mkdir -p "$VSCODE_DIR"
stow vscode -t "$VSCODE_DIR"

echo stow vim
NVIM_DIR="$CONFIG_DIR/nvim"
mkdir -p "$NVIM_DIR"
stow neovim -t "$NVIM_DIR"

echo stow git
stow git -t "$HOME"

#echo stow i3
#stow i3 -t "$HOME/.i3"

#echo stow redshift
#stow redshift -t "$CONFIG_DIR"

# Disable caps lock and bind hjkl to arrow keys
echo stow keyboard layout
sudo mv /usr/share/X11/xkb/symbols/is "$BACKUP_DIR"
sudo mv /usr/share/X11/xkb/symbols/us "$BACKUP_DIR"
sudo stow keyboard -t /usr/share/X11/xkb/symbols

# Install vs code extensions
#echo "Installing vs code extensions"
#readarray -t extensions < ./vscode-extensions.txt
#
#for i in "${extensions[@]}"
#do
#    echo "$i"
#    echo "yes" | code --install-extension "$i" || true
#done
