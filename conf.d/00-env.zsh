# Environment for interactive shells.

zmodload zsh/datetime 2>/dev/null   # $EPOCHREALTIME, used by zstartup
zmodload zsh/parameter 2>/dev/null  # $commands

# --- fzf ---------------------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS='--height=60% --layout=reverse --border=rounded --info=inline-right
  --color=fg:-1,bg:-1,hl:cyan,fg+:bright-white,bg+:-1,hl+:bright-cyan
  --color=info:yellow,prompt:cyan,pointer:magenta,marker:green,spinner:yellow,header:blue,border:bright-black'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}' --preview-window=right:60%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=auto {}' --preview-window=right:50%"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"

# --- prompt ------------------------------------------------------------------
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
eval "$(/home/dylan/.local/bin/mise activate zsh)"
