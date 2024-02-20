#!/usr/bin/env bash

# This script is used to create a new tmux session based on the repo directory
# borrowed from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

if [[ $# -eq 1 ]]; then
    selected=$1
else
	# shellcheck disable=SC2012
	selected=$(ls ~/repo | fzf --bind "ctrl-j:accept")
fi

if [[ -z $selected ]]; then
    exit 0
fi

#trim everything but directory name
selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
