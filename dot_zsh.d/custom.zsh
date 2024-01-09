#!/bin/zsh
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/b4b4r07/zplug ~/.zplug
fi
eval "$(direnv hook zsh)"

source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "MichaelAquilina/zsh-you-should-use"
zplug "zsh-users/zsh-completions"
# zplug "marlonrichert/zsh-autocomplete"
if [[ "$(uname)" =~ 'Darwin' ]]; then
    zplug 'agkozak/agkozak-zsh-prompt'
elif command -v starship > /dev/null ; then
    eval "$(starship init zsh)"
else
    zplug 'agkozak/agkozak-zsh-prompt'
fi
zplug "agkozak/zsh-z"
zplug "andrewferrier/fzf-z"
zplug "raghur/zsh-arduino"
zplug "~/code/zsh-xclip", from:local
zplug "srsudar/fzf-complete-flags"
# zplug "zsh-users/zsh-syntax-highlighting"
zplug "jonmosco/kube-ps1", use:"*.sh"
zplug "brookhong/zsh-autosuggestions"
zplug "zsh-users/zaw", use:"*.plugin.zsh"
if command -v atuin > /dev/null ; then
	zplug "ellie/atuin", at:'main', use:"*.plugin.zsh"
fi
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

# -X - do not clear screen
export LESS="--tabs 4 -R -X"
alias proot='pushd $(git rev-parse --show-toplevel)'
setopt correct
unsetopt correctall
# alias gcb="git branch -av |fzf --preview 'echo {}|awk \"{print \\\$1}\"|xargs git lg --color=always' | awk '{print \$1}' | xargs git checkout"
(alias | grep -q gco)  &&  unalias gco
function gco() {
  local selected=$(_fzf_git_each_ref --no-multi)
  selected=${selected/origin\//}
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

bindkey '^ ' autosuggest-accept
zstyle ':completion:*' menu select

