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
sudo add-apt-repository -y ppa:kgilmer/regolith-stable
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt install $(cat pkglist.txt)

sudo snap install --classic code || true
curl -sfL https://get.k3s.io | sh - --write-kubeconfig-mode 644

if ! [ -x "$(command -v git)" ]; then
    echo "setting up rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if [ "$SHELL" = "$(which zsh)" ]; then
    echo "Setting up zsh..."
    wget -q git.io/antigen -O antigen.zsh
    chsh -s $(which zsh)
fi

# Install dotfiles
# make symlinks from the home directory to files in ~/dotfiles
echo "Setting up dotfiles..."
CONFIG_DIR="$HOME/.config"
VSCODE_DIR="$CONFIG_DIR/Code/User"
BACKUP_DIR="./backup"
mkdir -p "$BACKUP_DIR"

echo stow vscode
mkdir -p "$VSCODE_DIR"
stow vscode -t "$VSCODE_DIR"

#echo stow vim
#stow vim -t "$HOME"

echo stow zshrc
stow zsh -t "$HOME"

echo stow git
stow git -t "$HOME"

LIBSECRET_DIR="/usr/share/doc/git/contrib/credential/libsecret"

if [ ! -f "$LIBSECRET_DIR/git-credential-libsecret.o" ]; then
    pushd "$LIBSECRET_DIR"
    sudo make
    popd
fi

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
