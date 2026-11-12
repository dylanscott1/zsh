# Emacs-style line editing with sane terminal bindings.

bindkey -e
KEYTIMEOUT=1

# Home / End / Delete / Backspace, via terminfo when available.
[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]}  ]] && bindkey "${terminfo[kend]}"  end-of-line
[[ -n ${terminfo[kdch1]} ]] && bindkey "${terminfo[kdch1]}" delete-char
[[ -n ${terminfo[kbs]}   ]] && bindkey "${terminfo[kbs]}"   backward-delete-char
# Fallbacks for terminals that lie about terminfo.
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# Word-wise movement and deletion.
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^H'      backward-kill-word
bindkey '^[[3;5~' kill-word

# Completion menu navigation.
bindkey '^[[Z' reverse-menu-complete

# History substring search (widgets provided by zsh-history-substring-search).
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P'   history-substring-search-up
bindkey '^N'   history-substring-search-down

# Edit the current command line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
