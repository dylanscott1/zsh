#!/usr/bin/env zsh
#
# Bootstrap this zsh setup on a new machine:
#
#   git clone <repo-url> ~/.zsh
#   ~/.zsh/install.sh
#
# Re-running is safe: existing plugins, symlinks and caches are kept.

emulate -L zsh
setopt pipe_fail

repo=${0:A:h}
target=$HOME/.zsh

die()  { print -u2 -- "error: $*"; exit 1 }
warn() { print -u2 -- "warning: $*" }
ok()   { print -- "  ok   $*" }

[[ $repo == $target ]] ||
  die "expected the repo at $target (found $repo); clone it there and re-run"

# --- bootstrap symlink -------------------------------------------------------
# zsh reads $HOME/.zshenv before it knows about ZDOTDIR, so this one symlink is
# what makes the rest of the setup reachable. Never delete an existing file.
if [[ -L $HOME/.zshenv && $HOME/.zshenv -ef $repo/.zshenv ]]; then
  ok "~/.zshenv -> $repo/.zshenv"
else
  if [[ -e $HOME/.zshenv || -L $HOME/.zshenv ]]; then
    backup=$HOME/.zshenv.bak.$(date +%Y%m%d-%H%M%S)
    mv -- $HOME/.zshenv $backup
    print -- "  moved existing ~/.zshenv to ${backup:t}"
  fi
  ln -s -- $repo/.zshenv $HOME/.zshenv || die "could not link ~/.zshenv"
  ok "~/.zshenv -> $repo/.zshenv"
fi

# --- dependencies ------------------------------------------------------------
# Only git is required; the rest degrade gracefully (plain prompt, no aliases).
(( $+commands[git] )) || die "git is required"
missing=()
for c in fzf zoxide starship eza bat fd; do
  (( $+commands[$c] )) || missing+=($c)
done
(( $#missing )) && warn "not on PATH: ${(j:, :)missing}"

# --- plugins -----------------------------------------------------------------
# Pinned in plugins.tsv. Cloned on branch `master` (not detached) so
# `zsh-update`'s `git pull --ff-only` keeps working.
while IFS=$'\t' read -r name url ref; do
  [[ -z $name || $name == '#'* ]] && continue
  dir=$repo/plugins/$name
  if [[ -d $dir/.git ]]; then
    ok "plugins/$name"
    continue
  fi
  print -- "  get  plugins/$name @ ${ref[1,7]}"
  mkdir -p -- $repo/plugins
  git clone --quiet -- $url $dir || die "clone failed: $url"
  git -C $dir checkout --quiet -B master $ref || warn "could not pin $name to $ref"
done < $repo/plugins.tsv

# --- smoke test --------------------------------------------------------------
# Builds cache/{fzf,zoxide,starship}-init.zsh and the completion dump.
tmp=$(mktemp) || die "mktemp failed"
zsh -i -c true 2> $tmp
rc=$?
# Without a tty there is no ZLE, so fzf's generated init complains twice.
grep -vF "can't change option: zle" $tmp >&2
rm -f -- $tmp
if (( rc == 0 )); then
  ok "interactive shell starts"
else
  warn "interactive shell exited $rc"
fi

print -- ""
print -- "done. open a new shell, or run: exec zsh -l"
