
alias fatdirs="ls -A1d .*/ */ | parallel du -sh {.} | sort -h"
alias aptup='sudo apt update'
alias aptug='sudo apt full-upgrade'
alias myip="curl ifconfig.co"
if command -v nvim > /dev/null; then
    alias vim=nvim
    export NVIM_LISTEN_ADDRESS=/var/tmp/nvim.$USER.sock
    function nvr_xdo() {
        nvr $*
        if [ `pgrep neovide` ]; then
            xdotool search neovide windowactivate
        fi
    }
    alias xnvr=nvr_xdo
fi
