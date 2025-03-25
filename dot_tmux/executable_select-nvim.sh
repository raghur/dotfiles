#!/bin/sh

tmux list-panes -a -F '#{window_index}.#{pane_index}:#{pane_current_command}' | \
    grep "nvim"| awk -F"[.:]" '{print "select-window -t" $1 "\; select-pane -t" $2}' | \
    xargs tmux

