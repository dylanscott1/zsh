# Plugins, loaded in dependency order. Init scripts for external binaries are
# cached under cache/ and only regenerated when the binary changes.

# A `git clone` without install.sh leaves no plugins; say so once and keep the
# rest of the shell usable instead of erroring line by line.
if [[ ! -d $ZDOTDIR/plugins/zsh-syntax-highlighting ]]; then
  print -u2 -- "zsh: plugins missing, run $ZDOTDIR/install.sh"
  return 0
fi

# --- fzf (Ctrl-R history, Ctrl-T files, Alt-C cd) ----------------------------
if (( $+commands[fzf] )); then
  _fzf_init="$ZDOTDIR/cache/fzf-init.zsh"
  if [[ ! -s $_fzf_init || $commands[fzf] -nt $_fzf_init ]]; then
    fzf --zsh >| "$_fzf_init"
  fi
  source "$_fzf_init"
  unset _fzf_init
fi

# --- zoxide (z / zi) ---------------------------------------------------------
if (( $+commands[zoxide] )); then
  _zoxide_init="$ZDOTDIR/cache/zoxide-init.zsh"
  if [[ ! -s $_zoxide_init || $commands[zoxide] -nt $_zoxide_init ]]; then
    zoxide init zsh >| "$_zoxide_init"
  fi
  source "$_zoxide_init"
  unset _zoxide_init

  # `cd` gains zoxide's frecency for bare names, but keeps real cd semantics for
  # paths, `-`, flags and no arguments. `z` and `zi` remain available as before.
  cd() {
    if [[ $# -eq 1 && $1 != - && ! -e $1 ]]; then
      z "$1" 2>/dev/null || builtin cd "$1"
    else
      builtin cd "$@"
    fi
  }
fi

# --- defer (loads fzf-tab after the first prompt) ----------------------------
source "$ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh"

# --- autosuggestions ---------------------------------------------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# --- history substring search (Up/Down after typing a prefix) ----------------
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=black,bg=cyan'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=white,bg=red'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

# --- fzf-tab: fuzzy completion menu -----------------------------------------
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath'
zstyle ':fzf-tab:*' fzf-flags --height=60% --border=rounded --info=inline-right
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group ',' '.'
zsh-defer source "$ZDOTDIR/plugins/fzf-tab/fzf-tab.zsh"

# --- syntax highlighting (must be sourced last) ------------------------------
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=512
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
