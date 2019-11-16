# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bragi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#

source ~/dotfiles/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme robbyrussell

antigen apply

# Custom aliases
if [ -x "$(command -v hub)" ]; then eval "$(hub alias -s)"; fi
alias g=git
alias gu='git add . && git commit && git push'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'

alias k='kubectl'
alias kwp='watch kubectl get pods'
alias kwpa='kwp --all-namespaces'
alias kws='watch kubectl get services'
alias kwsa='watch kubectl get services --all-namespaces'
