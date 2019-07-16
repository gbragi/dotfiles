#!/bin/sh

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

if [[ $EUID = 0 ]]; then
    echo "This script must be run as normal user"
    exit 1
fi

usage () {
	echo "Usage: --help, --default, --dotfiles, --code, --dir"
    exit 1
}

TEMP=`getopt -o '' --long help,default,dotfiles,code,dir -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

TOOLS_DIR="$HOME/tools"
CODE_DIR="$HOME/code"

initdefault() {
    RUNDOTFILES=$1
    RUNCODE=$1
    RUNDIR=$1
}

HELP=false

initdefault false

while true; do
    case "$1" in
        --help) usage; shift ;;
        --default) initdefault true; shift ;;
        --dotfiles) RUNDOTFILES=true; shift ;;
        --code) RUNCODE=true; shift ;;
        --dir) RUNDIR=true; shift ;;
        --) shift ; break ;;
        *) usage ;;
    esac
done

# Directory setup
if [ "$RUNDIR" = true ]; then
    echo "Setting up directories..."
    mkdir -p $CODE_DIR/tmp
    mkdir -p $TOOLS_DIR
fi

# Install dotfiles
# make symlinks from the home directory to files in ~/dotfiles
if [ "$RUNDOTFILES" = true ]; then
    echo "Setting up dotfiles..."
    CONFIG_DIR="$HOME/.config"
    SSH_CONFIG_DIR="$HOME/.ssh"
    mkdir -p "$SSH_CONFIG_DIR"
    VSCODE_DIR="$CONFIG_DIR/Code/User"
    BACKUP_DIR="./backup"
    I3_DIR="$CONFIG_DIR/i3"
    I3_BACKUP="$BACKUP_DIR/i3_backup_config"
    I3_CONFIG="$I3_DIR/config"
    PROFILE_CONFIG="$HOME/.profile"
    PROFILE_BACKUP="$BACKUP_DIR/profile_backup"
    TERMITE_DIR="$CONFIG_DIR/termite"
    mkdir -p "$TERMITE_DIR"
    mkdir -p "$BACKUP_DIR"
    
    echo stow vscode
    mkdir -p "$VSCODE_DIR"
    stow vscode -t "$VSCODE_DIR"
    
    echo stow vim
    stow vim -t "$HOME"

    echo stow git
    stow git -t "$HOME"
    
    echo stow redshift
    stow redshift -t "$CONFIG_DIR"

    echo stow termite
    stow termite -t "$TERMITE_DIR"
    
    if [ -f "$PROFILE_CONFIG" ] && [ ! -L "$PROFILE_CONFIG" ]; then
        cp "$PROFILE_CONFIG" "$PROFILE_BACKUP"
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

    echo stow ssh config
    stow ssh -t "$SSH_CONFIG_DIR"
    
    # Do a check for all broken symlinks in home directory and print to stdout
    echo "Listing all broken symlinks"
    echo $(find $HOME -path ~/go -prune -o -xtype l)
    
    echo "All clear...good to go"
fi


# Install vs code extensions
if [ "$RUNCODE" = true ]; then
    echo "Installing vs code extensions"
    readarray -t extensions < ./vscode-extensions.txt

    for i in "${extensions[@]}"
    do
        echo "$i"
        echo "yes" | code --install-extension "$i" || true
    done
fi
