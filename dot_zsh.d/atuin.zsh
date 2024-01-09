
if ! command -v atuin > /dev/null ; then
    return 
fi
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
                # "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
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
_zsh_autosuggest_strategy_atuin_top() {
    suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix $1)
}
ZSH_AUTOSUGGEST_STRATEGY=atuin_top
bindkey "^[[A" history-beginning-search-backward # after the atuin init
