#!/bin/zsh
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/b4b4r07/zplug ~/.zplug
fi
eval "$(direnv hook zsh)"
KUBE_PS1_NS_ENABLE=false
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_CTX_COLOR='red'
function get_cluster_short() {
    case $1 in
        *"sandbox"*)
            KUBE_PS1_CTX_COLOR='blue'
            echo Sandbox
            ;;
        *"dev"*)
            echo Nonprod
            ;;
        *"prod"*)
            echo Production
            ;;
        *) 
            echo $1
            ;;
    esac
}
KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short

source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "MichaelAquilina/zsh-you-should-use"
zplug "zsh-users/zsh-completions"
# zplug "marlonrichert/zsh-autocomplete"
if command -v starship > /dev/null ; then
    eval "$(starship init zsh)"
else 
    zplug 'agkozak/agkozak-zsh-prompt'
fi
zplug "agkozak/zsh-z"
zplug "andrewferrier/fzf-z"
zplug "raghur/zsh-arduino"
zplug "~/code/zsh-xclip", from:local
zplug "srsudar/fzf-complete-flags"
zplug "jonmosco/kube-ps1", use:"*.sh"
# zplug "zsh-users/zsh-syntax-highlighting"
zplug "brookhong/zsh-autosuggestions"
zplug "zsh-users/zaw", use:"*.plugin.zsh"
zplug "ellie/atuin", at:'main', use:"*.plugin.zsh"
zplug 'junegunn/fzf-git.sh', use:"*.sh"
if ! zplug check; then
    zplug install
fi

ZSHZ_CASE=smart
AGKOZAK_LEFT_PROMPT_ONLY=1
zplug load

function showdirs() {
    # if $1 starts with - then only args to append
    if [[ $1 =~ '-.*' ]]; then
        find -maxdepth 1 ! -path . -type d "$@"
    else # use $1 as folder to look into
        find $1 -maxdepth 1 ! -path . -type d "${@:2}"
    fi
}

function nvr_xdo() {
    nvr $*
    if [ `pgrep neovide` ]; then
        xdotool search neovide windowactivate
    fi
}
alias fatdirs="ls -A1d .*/ */ | parallel du -sh {.} | sort -h"
# -X - do not clear screen
export LESS="--tabs 4 -R -X"
alias aptup='sudo apt update'
alias aptug='sudo apt full-upgrade'
alias myip="curl ifconfig.co"
alias vim=nvim
export NVIM_LISTEN_ADDRESS="$XDG_RUNTIME_DIR/nvim.sock"
alias xnvr=nvr_xdo
alias proot='pushd $(git rev-parse --show-toplevel)'
setopt correct
unsetopt correctall
# alias gcb="git branch -av |fzf --preview 'echo {}|awk \"{print \\\$1}\"|xargs git lg --color=always' | awk '{print \$1}' | xargs git checkout"
(alias | grep -q gco)  &&  unalias gco
function gco() {
  local selected=$(_fzf_git_each_ref --no-multi)
  [ -n "$selected" ] && git checkout "$selected"
}
(alias | grep -q gsta) &&  unalias gsta
function gsta() {
  local selected=$(_fzf_git_stashes --no-multi)
  [ -n "$selected" ] && git stash show "$selected"
}
# alias gcb="git branch -av |fzf --preview 'source ~/.zshrc; showbranch({})' | awk '{print \$1}' | xargs git checkout"
# alias gsta="git stash list | fzf --preview-window down,70%,border-horizontal --preview 'echo {}| awk -F: \"{print \\\$1}\" | xargs git diff --color=always' | awk -F: '{print \$1}' | xargs git stash apply" 
# export FZF_CTRL_R_OPTS=
bindkey "^[[A" history-beginning-search-backward # after the atuin init
atuin-setup() {
        if ! which atuin &> /dev/null; then return 1; fi
        bindkey '^E' _atuin_search_widget

        export ATUIN_NOBIND="true"
        eval "$(atuin init "zsh")"
        fzf-atuin-history-widget() {
            local selected num
            setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

            # local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
            local atuin_opts="--cmd-only"
            local fzf_opts=(
                --height=${FZF_TMUX_HEIGHT:-80%}
                --tac
                "-n2..,.."
                --tiebreak=index
                "--query=${LBUFFER}"
                "+m"
                "--bind=ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
                "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
            )

            selected=$(
                eval "atuin search ${atuin_opts}" |
                    fzf "${fzf_opts[@]}"
            )
            local ret=$?
            if [ -n "$selected" ]; then
                # the += lets it insert at current pos instead of replacing
                LBUFFER+="${selected}"
            fi
            zle reset-prompt
            return $ret
        }
        zle -N fzf-atuin-history-widget
        bindkey '^R' fzf-atuin-history-widget
    }
atuin-setup
bindkey '^ ' autosuggest-accept
_zsh_autosuggest_strategy_atuin_top() {
    suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix $1)
}
ZSH_AUTOSUGGEST_STRATEGY=atuin_top
zstyle ':completion:*' menu select

function startwinvm() {
    domain=${1:-win10}
    if virsh list --name |grep -qv $domain; then
        virsh start $domain
    fi
    virt-viewer $domain &
}
function stopwinvm() {
    domain=${1:-win10}
    if virsh list --name |grep -q $domain; then
        virsh shutdown --mode agent $domain
    fi
}

