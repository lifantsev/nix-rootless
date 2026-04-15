init_completions() {
    autoload -U compinit && compinit

    unfunction init_completions
    bindkey ^I expand-or-complete

    zle expand-or-complete
}
zle -N init_completions
bindkey ^I init_completions
