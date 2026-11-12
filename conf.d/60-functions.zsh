# Small, self-contained helpers. No external dependencies beyond the tools
# already installed by this setup.

mkcd() {
  [[ -n $1 ]] || { print -u2 'usage: mkcd <dir>'; return 1 }
  mkdir -p -- "$1" && cd -- "$1"
}

take() { mkcd "$@" }

extract() {
  [[ -f $1 ]] || { print -u2 "extract: no such file: $1"; return 1 }
  case $1 in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar.zst)        tar --zstd -xf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.zip)            unzip "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.xz)             unxz "$1" ;;
    *.zst)            unzstd "$1" ;;
    *.7z)             7z x "$1" ;;
    *) print -u2 "extract: unknown archive: $1"; return 1 ;;
  esac
}

fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git --exclude node_modules |
        fzf --preview 'eza --tree --level=1 --color=always --icons=auto {}') || return
  cd -- "$dir"
}

fkill() {
  local pid
  pid=$(ps -eo pid=,comm=,args= --sort=-%cpu |
        fzf --header='kill process' --preview 'ps -p {1} -o pid,comm,args') || return
  pid=${pid%% *}
  [[ -n $pid ]] && kill -TERM "$pid" && print "killed $pid"
}

# Average interactive startup, in milliseconds.
zstartup() {
  local n=${1:-20} i t0 t1 total=0
  for (( i = 1; i <= n; i++ )); do
    t0=${EPOCHREALTIME%.*}${${EPOCHREALTIME#*.}[1,6]}
    zsh -i -c exit
    t1=${EPOCHREALTIME%.*}${${EPOCHREALTIME#*.}[1,6]}
    total=$(( total + t1 - t0 ))
  done
  local avg=$(( total / n ))
  printf 'avg startup: %d.%03d ms over %d runs\n' \
    $(( avg / 1000 )) $(( avg % 1000 )) "$n"
}

# Recompile every plugin and cached init script. Run after updating plugins.
zcompile-all() {
  local f
  for f in "$ZDOTDIR"/plugins/*/**/*.zsh(N) "$ZDOTDIR"/cache/*-init.zsh(N); do
    [[ -f $f ]] || continue
    rm -f -- "$f.zwc"
    zcompile -R -- "$f" 2>/dev/null
  done
}

# Pull vendored plugins, recompile, and rebuild the completion dump.
zsh-update() {
  local d
  for d in "$ZDOTDIR"/plugins/*(N/); do
    [[ -d $d/.git ]] || continue
    print -P "%F{cyan}==> ${d:t}%f"
    git -C "$d" pull --ff-only --quiet || print -u2 "update failed: ${d:t}"
  done
  zcompile-all
  zcompinit
  print -P "%F{green}plugins updated%f"
}
