# ~/.zshenv -> ~/zsh/zshenv
# Runs for every zsh (interactive, login, scripts). Keep it tiny and side-effect free.

export ZDOTDIR=${ZDOTDIR:-$HOME/.zsh}

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# User-local binaries (fzf, zoxide, starship, eza, bat live here).
path=("$HOME/.local/bin" $path)
typeset -U path
export PATH

# Some environments ship EDITOR/VISUAL=true; never let that win.
if [[ -z $EDITOR || $EDITOR == true ]]; then
  export EDITOR=vim
fi
if [[ -z $VISUAL || $VISUAL == true ]]; then
  export VISUAL=$EDITOR
fi
if [[ -z $PAGER || $PAGER == cat ]]; then
  export PAGER=less
fi
export LESS=${LESS:--R}
export LESSHISTFILE=-
