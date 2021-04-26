# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v


# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/bragi/.zshrc'

# autoload -Uz compinit
# compinit
# End of lines added by compinstall
#

# Custom aliases
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

alias vim='nvim'
alias v='nvim'

# tools dir
export PATH=$PATH:~/tools

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export KUBECONFIG=/mnt/c/Users/bragi/.kube/config

complete -F __start_kubectl k

fpath=(~/.zsh/completions $fpath)
