# Completion: zsh's own compsys, cached dump, no framework.

fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)

autoload -Uz compinit
zmodload zsh/stat 2>/dev/null
typeset -g _zcompdump="$ZDOTDIR/cache/zcompdump-$ZSH_VERSION"
typeset -ga _zcomp_mtime
zstat -A _zcomp_mtime +mtime -- "$_zcompdump" 2>/dev/null

# Rebuild at most once a day (or when the dump is missing). `-C` skips all
# security/newness checks on the fast path; `-u` skips the audit on rebuild.
if [[ ! -f $_zcompdump ]] || (( EPOCHSECONDS - ${_zcomp_mtime[1]:-0} > 86400 )); then
  compinit -u -d "$_zcompdump"
  rm -f -- "$_zcompdump.zwc"
  zcompile -UR -- "$_zcompdump" 2>/dev/null
else
  compinit -C -d "$_zcompdump"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*:messages'     format '%F{magenta}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches for: %d%f'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' ignore-parent-dirs yes
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/cache/zcompcache"
zstyle ':completion:*' completer _expand _complete _ignored _match _approximate
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' verbose yes
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# Rebuild the dump on demand: `zcompinit`.
zcompinit() {
  compinit -u -d "$_zcompdump"
  rm -f -- "$_zcompdump.zwc"
  zcompile -UR -- "$_zcompdump" 2>/dev/null
}
