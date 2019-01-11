#!/bin/bash

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

if [[ $EUID = 0 ]]; then
    echo "This script must be run as normal user"
    exit 1
fi

usage () {
	echo "Usage: --help, --default, --update, --aur, --pacman, --zsh, --dotfiles, --code, --dir, --flutter, --microk8s, --skip-aur, --keyboard"
    exit 1
}

TEMP=`getopt -o '' --long help,default,update,aur,pacman,zsh,dotfiles,code,dir,flutter,microk8s,skip-aur -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

TOOLS_DIR="$HOME/tools"
CODE_DIR="$HOME/code"
AUR_TMP_DIR="$HOME/.aur_tmp_dir"

initdefault() {
    RUNPACMAN=$1
    RUNZSH=$1
    RUNDOTFILES=$1
    RUNCODE=$1
    RUNDIR=$1
}

initupdate() {
    RUNPACMAN=$1
    RUNDOTFILES=$1
}

HELP=false
RUNAUR=false
RUNMICROK8S=false
RUNFLUTTER=false
RUNKEYBOARD=false

initdefault false

while true; do
    case "$1" in
        --help) usage; shift ;;
        --default) initdefault true; shift ;;
        --update) initupdate true; shift ;;
        --aur) RUNAUR=true; shift ;;
        --pacman) RUNPACMAN=true; shift ;;
        --zsh) RUNZSH=true; shift ;;
        --dotfiles) RUNDOTFILES=true; shift ;;
        --code) RUNCODE=true; shift ;;
        --dir) RUNDIR=true; shift ;;
        --flutter) RUNFLUTTER=true; shift ;;
        --keyboard) RUNKEYBOARD=true; shift ;;
        --microk8s) RUNMICROK8S=true; shift ;;
        --) shift ; break ;;
        *) usage ;;
    esac
done

# Directory setup
if [ "$RUNDIR" = true ]; then
    echo "Setting up directories..."
    rm -d ~/Pictures || true
    rm -d ~/Templates || true
    rm -d ~/Videos || true
    rm -d ~/Music || true
    rm -d ~/Public || true
    rm -d ~/Documents || true
    mkdir -p $CODE_DIR/tmp
    mkdir -p $TOOLS_DIR
fi

# Install packages
if [ "$RUNPACMAN" = true ]; then
    echo "Installing pacman packages..."
    sudo pacman -Syyu --noconfirm
    sudo pacman -S --needed --noconfirm - < ./pkglist.txt
fi

# Setup zsh shell
if [ "$RUNZSH" = true ] && [ $SHELL != "$(which zsh)" ]; then
    echo "Setting up zsh..."
    chsh -s $(which zsh)
fi

# Install from aur
if [ "$RUNAUR" = true ]; then
    echo "Installing aur packages..."
    mkdir -p "$AUR_TMP_DIR"
    trizen -S --needed --clone-dir="$AUR_TMP_DIR" --noedit - < ./aurpkglist.txt
fi

# Install dotfiles
# make symlinks from the home directory to files in ~/dotfiles
if [ "$RUNDOTFILES" = true ]; then
    echo "Setting up dotfiles..."
    CONFIG_DIR="$HOME/.config"
    VSCODE_DIR="$CONFIG_DIR/Code - OSS/User"
    I3_DIR="$HOME/.i3"
    I3_BACKUP="./backup/i3_backup_config"
    I3_CONFIG="$I3_DIR/config"
    PROFILE_CONFIG="$HOME/.profile"
    PROFILE_BACKUP="./backup/profile_backup"
    
    echo stow vscode
    mkdir -p "$VSCODE_DIR"
    stow vscode -t "$VSCODE_DIR"
    
    echo stow vim
    stow vim -t "$HOME"

    echo stow zshrc
    if [ ! -f ~/.zshrc ]; then
        touch ~/.zshrc
    fi
    if ! grep -q 'zshrc-custom.zshrc' ~/.zshrc; then
        echo "# Customize zshrc" >> ~/.zshrc
        echo ". ~/.zshrc-custom.zshrc" >> ~/.zshrc
    fi
    stow zsh -t "$HOME"

    echo "################### zsh config diff #######################"
    diff ~/.zshrc /etc/skel/.zshrc --color=always || true
    echo "##########################################################"

    echo stow git
    stow git -t "$HOME"
    
    echo stow redshift
    stow redshift -t "$CONFIG_DIR"
    
    if [ -f "$PROFILE_CONFIG" ] && [ ! -L "$PROFILE_CONFIG" ]; then
        mv "$PROFILE_CONFIG" "$PROFILE_BACKUP"
    fi
    
    echo stow profile
    if ! grep -q '.profile.customize' ~/.profile; then
        echo "# Customize profile" >> ~/.profile
        echo ". ~/.profile.customize" >> ~/.profile
    fi
    stow profile -t "$HOME"
    
    echo "################### Profile config diff #######################"
    diff "$PROFILE_BACKUP" "$PROFILE_CONFIG" --color=always || true
    echo "##########################################################"
    
    echo stow i3
    
    if [ -f "$I3_CONFIG" ] && [ ! -L "$I3_CONFIG" ]; then
        mv "$I3_CONFIG" "$I3_BACKUP"
    fi
    
    stow i3 -t "$I3_DIR"
    
    echo "################### i3 config diff #######################"
    diff "$I3_BACKUP" "$I3_CONFIG" --color=always || true
    echo "##########################################################"
    
    
    # Do a check for all broken symlinks in home directory and print to stdout
    echo "Listing all broken symlinks"
    echo $(find $HOME -path ~/go -prune -o -xtype l)
    
    echo "All clear...good to go"
fi


# Disable caps lock and bind hjkl to arrow keys
if [ "$RUNKEYBOARD" = true ]; then
    echo stow keyboard layout
    sudo mv -vn /usr/share/X11/xkb/symbols/us ./backup/us_backup
    sudo mv -vn /usr/share/X11/xkb/symbols/is ./backup/is_backup
    sudo stow keyboard -t /usr/share/X11/xkb/symbols
fi
    

# Install vs code extensions
if [ "$RUNCODE" = true ]; then
    echo "Installing vs code extensions"
    declare -a extensions=("vscodevim.vim"
    "ms-python.python"
    "ms-vscode.csharp"
    "ms-vscode.Go"
    "eamodio.gitlens"
    "eg2.tslint"
    "PeterJausovec.vscode-docker"
    "esbenp.prettier-vscode"
    "redhat.vscode-yaml"
    "Dart-Code.dart-code"
    "Dart-Code.flutter"
    "joaompinto.asciidoctor-vscode"
    "zxh404.vscode-proto3"
    "pflannery.vscode-versionlens"
    "christian-kohler.path-intellisense"
    "hbenl.vscode-firefox-debug"
    )

    for i in "${extensions[@]}"
    do
        echo "$i"
        echo "yes" | code --install-extension "$i" || true
    done
fi

# Install flutter
if [ "$RUNFLUTTER" = true ]; then
    echo "Installing android studio..."
    trizen -S --needed --clone-dir="$AUR_TMP_DIR" --noedit android-studio
    echo "Installing flutter..."
    flutter_executable=$(which flutter || true)
    if [ -x "$flutter_executable" ]; then
        echo "Flutter is already installed at: $flutter_executable"
    else
        mkdir -p $TOOLS_DIR
        FLUTTER_PATH="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz"
        curl -L -o $TOOLS_DIR/flutter.tar.xz $FLUTTER_PATH 
        tar -xvf $TOOLS_DIR/flutter.tar.xz -C $TOOLS_DIR
        export PATH=$TOOLS_DIR/flutter/bin:$PATH
        flutter upgrade
        flutter doctor
    fi
fi

# MicroK8s
if [ "$RUNMICROK8S" = true ]; then
    echo "Installing snapd..."
    sudo pacman -S --needed --noconfirm snapd
    echo "Enabling snapd..."
    sudo systemctl enable --now apparmor.service
    sudo systemctl enable --now snapd.apparmor.service
    sudo systemctl enable --now snapd.socket
    echo "Enabling snapd classic support..."
    sudo ln -s /var/lib/snapd/snap /snap
    sudo snap install microk8s --classic --edge
fi
