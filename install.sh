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
sudo pamac upgrade -a
sudo pamac install --no-confirm $(<pkglist.txt)

./dotnet/dotnet-install.sh

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting up zsh..."
    wget -q git.io/antigen -O antigen.zsh
    chsh -s $(which zsh)
fi

# Install dotfiles
# make symlinks from the home directory to files in ~/dotfiles
echo "Setting up dotfiles..."
CONFIG_DIR="$HOME/.config"
VSCODE_DIR="$CONFIG_DIR/Code - OSS/User"
BACKUP_DIR="./backup"
mkdir -p "$BACKUP_DIR"
I3_DIR="$HOME/.i3"
I3_BACKUP="$BACKUP_DIR/i3_backup_config"
I3_CONFIG="$I3_DIR/config"

echo stow vscode
mkdir -p "$VSCODE_DIR"
stow vscode -t "$VSCODE_DIR"

echo stow zshrc
stow zsh -t "$HOME"

echo stow git
stow git -t "$HOME"

echo stow i3
if [ -f "$I3_CONFIG" ] && [ ! -L "$I3_CONFIG" ]; then
    mv "$I3_CONFIG" "$I3_BACKUP"
fi
stow i3 -t "$I3_DIR"

echo stow redshift
stow redshfit -t "$CONFIG_DIR"

echo stow profile
if ! grep -q '.profile.customize' ~/.profile; then
   echo "# Customize profile" >> ~/.profile
   echo ". ~/.profile.customize" >> ~/.profile
fi
stow profile -t "$HOME"

# Do a check for all broken symlinks in home directory and print to stdout
echo "Listing all broken symlinks"
echo $(find $HOME -path ~/go -prune -o -xtype l)

echo "All clear...good to go"

# Disable caps lock and bind hjkl to arrow keys
echo stow keyboard layout
sudo mv -vn /usr/share/X11/xkb/symbols/us "$BACKUP_DIR/us_backup"
sudo mv -vn /usr/share/X11/xkb/symbols/is "$BACKUP_DIR/is_backup"
sudo stow keyboard -t /usr/share/X11/xkb/symbols

# Install vs code extensions
echo "Installing vs code extensions"
readarray -t extensions < ./vscode-extensions.txt

for i in "${extensions[@]}"
do
    echo "$i"
    echo "yes" | code --install-extension "$i" || true
done
