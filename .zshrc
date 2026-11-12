# ~/.zsh/.zshrc (ZDOTDIR is set in ~/.zshenv)
# Entry point: source numbered fragments in order. No framework, no plugin manager.

[[ -o interactive ]] || return 0

for _zsh_conf in "$ZDOTDIR"/conf.d/*.zsh(N); do
  source "$_zsh_conf"
done
unset _zsh_conf
