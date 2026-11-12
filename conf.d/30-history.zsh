# Shared, deduplicated, timestamped history in XDG state.

HISTFILE="${XDG_STATE_HOME}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p -- "${HISTFILE:h}"

HISTSIZE=200000
SAVEHIST=200000

setopt EXTENDED_HISTORY       # timestamps
setopt SHARE_HISTORY          # live sync across terminals
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_FCNTL_LOCK
