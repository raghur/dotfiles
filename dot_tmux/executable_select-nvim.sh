#!/bin/sh

nvim=$(tmux list-panes -a -F '#{window_index}.#{pane_index}:#{pane_current_command}' | \
    grep "nvim")
if [ "$nvim" != "" ] ; then
    echo "$nvim" | awk -F"[.:]" '{print "select-window -t" $1 "\\; select-pane -t" $2}' | \
    xargs tmux
else
    tmux display "Nvim pane not found"
fi

