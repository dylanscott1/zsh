# Aliases: modern replacements where they are drop-in, nothing that changes
# POSIX semantics of grep/find.

if (( $+commands[eza] )); then
  alias ls='eza --icons=auto --group-directories-first'
  alias l='eza -l --icons=auto --group-directories-first'
  alias ll='eza -l --icons=auto --group-directories-first --git --time-style=relative'
  alias la='eza -la --icons=auto --group-directories-first --git --time-style=relative'
  alias lt='eza --tree --level=2 --icons=auto'
  alias lta='eza --tree --level=2 --icons=auto --all'
else
  alias ll='ls -l'
  alias la='ls -la'
fi

(( $+commands[bat] )) && alias cat='bat --style=plain --paging=never'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias reload='exec zsh -l'
alias zshconfig='cd "$ZDOTDIR" && ${EDITOR:-vim} .'

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
