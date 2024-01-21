export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
# Setup fzf
# ---------
if [[ ! "$PATH" == *~/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}~/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source ~/.fzf/shell/completion.zsh 2> /dev/null

# Key bindings
# ------------

if test -e ~/.fzf/shell/key-bindings.zsh; then
    source ~/.fzf/shell/key-bindings.zsh
fi
