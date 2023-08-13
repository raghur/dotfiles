export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
# Setup fzf
# ---------
if [[ ! "$PATH" == */home/raghu/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/raghu/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/raghu/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------

if [ -e "~/.fzf/shell/key-bindings.zsh" ]; then
    source "~/.fzf/shell/key-bindings.zsh"
fi
