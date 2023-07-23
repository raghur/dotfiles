#! /bin/sh

if [ -r /dev/clipboard ]; then
    cat > /dev/clipboard
elif [ -x /usr/bin/xclip ]; then
    xclip -selection c > /dev/null
fi
tmux display-message "Copied"

