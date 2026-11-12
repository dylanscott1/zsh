# Starship prompt. Init output is cached so each shell does not spawn starship
# just to build the prompt functions.

_zstarship_init="$ZDOTDIR/cache/starship-init.zsh"
if (( $+commands[starship] )); then
  if [[ ! -s $_zstarship_init || $commands[starship] -nt $_zstarship_init ]]; then
    # `starship init` ends with a `PROMPT2=$(starship prompt --continuation)` call,
    # i.e. a subprocess on every shell start. The continuation prompt is static,
    # so strip that line and set it ourselves.
    {
      starship init zsh | grep -v '^PROMPT2='
      print -r -- "PROMPT2='%F{8}∙%f '"
    } >| "$_zstarship_init"
    rm -f -- "$_zstarship_init.zwc"
    zcompile -R -- "$_zstarship_init" 2>/dev/null
  fi
  source "$_zstarship_init"
fi
unset _zstarship_init

# Clock on the right, rendered by zsh itself: zero extra processes per prompt.
# Set both names: zsh-defer probes RPS1 and clears it if unset.
RPROMPT='%F{8}%D{%H:%M}%f'
RPS1=$RPROMPT
ZLE_RPROMPT_INDENT=0
