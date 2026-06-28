

function reset-prompt-and-accept-line() {
    # load autoloaded func-scripts from ~/.zsh.d
    # files that do not start with _
    for f in ~/.zsh.d/[^_]*.zsh(D:t); do
        $f
        [ $PROFILE -ge 2 ] && echo $f
    done
    # remove older compiled files
    for f in ~/.zsh.d/library*.zwc(om[2,100]); do 
        rm -f $f
    done
    zle reset-prompt
    zle accept-line

    # redefine this function so it's a one time thing
    function reset-prompt-and-accept-line() {
        zle reset-prompt
        zle accept-line
    }
}

(alias | grep -q 'gco=')  &&  unalias gco
(alias | grep -q 'gsta=') &&  unalias gsta
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

function nvr() {
    local runtime_dir="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
    local server=$(find "$runtime_dir" -maxdepth 5 -type s -name "nvim.*.0" -print -quit 2>/dev/null)
    # Create a local Zsh array to hold the absolute paths
    local absolute_paths=()
    local file
    
    # Loop through each argument passed to the function ($@)
    for file in "$@"; do
        # (:A) is Zsh's built-in, lightning-fast modifier for absolute realpath
        absolute_paths+=("${file:A}") 
    done
    nvim --server "$server" --remote "${absolute_paths[@]}"
}
