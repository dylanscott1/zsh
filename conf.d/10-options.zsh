# Shell behaviour. Every option here earns its place; nothing speculative.

setopt AUTO_CD              # `foo/` enters the directory
setopt AUTO_PUSHD           # cd pushes, `cd -` style navigation
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB        # ^, #, ~ qualifiers
setopt NUMERIC_GLOB_SORT
setopt INTERACTIVE_COMMENTS # `# ...` in the line editor
setopt COMPLETE_IN_WORD     # complete in the middle of a word
setopt ALWAYS_TO_END        # cursor to end of completed word
setopt AUTO_MENU            # second Tab opens the menu
setopt AUTO_LIST
setopt LIST_PACKED
setopt NO_BEEP
setopt NO_FLOW_CONTROL      # free Ctrl-S / Ctrl-Q
setopt LONG_LIST_JOBS
setopt HASH_CMDS
setopt HASH_DIRS
setopt PROMPT_SUBST

unsetopt BEEP

# Keep PROMPT_SP's line clearing, drop the visible '%' marker.
PROMPT_EOL_MARK=''
