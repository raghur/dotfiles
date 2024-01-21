
reset-prompt-and-accept-line() {
    zle reset-prompt
    zle accept-line
}

(alias | grep -q gco)  &&  unalias gco
(alias | grep -q gsta) &&  unalias gsta
function start_tmux() {
    if type tmux &> /dev/null && test -z "$TMUX"; then
        if tmux run 2>/dev/null; then
            # echo "Tmux running"
            if $(tmux list-sessions | grep -qv attached); then
                # echo tmux not attached
                tmux -2u attach -dt default || tmux -2u new-session -s default
            fi
        else
            # echo "Tmux not running"
            tmux -2u attach -dt default || tmux -2u new-session -s default
        fi
    fi
}
function gco() {
  local selected=$(_fzf_git_each_ref --no-multi)
  selected=${selected/origin\//}
  [ -n "$selected" ] && git checkout "$selected"
}
function gsta() {
  local selected=$(_fzf_git_stashes --no-multi)
  [ -n "$selected" ] && git stash show "$selected"
}
function showdirs() {
    # if $1 starts with - then only args to append
    if [[ $1 =~ '-.*' ]]; then
        find -maxdepth 1 ! -path . -type d "$@"
    else # use $1 as folder to look into
        find $1 -maxdepth 1 ! -path . -type d "${@:2}"
    fi
}

