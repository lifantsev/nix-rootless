bindkey '^H' fzf-history-widget

function copy_buffer() { wl-copy -n <<< "$BUFFER"; }
zle -N copy_buffer
bindkey "^Y" copy_buffer # ctrl Y

bindkey "^[[1;2D" beginning-of-line # shift left
bindkey "^[[1;2C" end-of-line # shift right

bindkey "^[[3~" delete-char # delete key

bindkey '^[[Z' autosuggest-accept # shift tab
bindkey '^I' expand-or-complete # tab
