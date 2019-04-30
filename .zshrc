# [[ $TERM != "screen" ]] && exec tmux -2 new-session -A -s main
# ^^ blows up inside nvim term

ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

ZSH_THEME="int-index"

bgnotify_threshold=4

plugins=(git stack cabal jump bgnotify)

source $ZSH/oh-my-zsh.sh

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

alias edit="nvim-qt"
