#!/usr/bin/env bash

if [[ -n "$TMUX" ]]; then
    current_dir=$(tmux display-message -p -F "#{pane_current_path}")
    cd "$current_dir" || exit 1
fi

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd --type f --exclude .git --follow \
        | sk --margin 10% --color="bw")
fi

[[ ! $selected ]] && exit 0


file_uri="file://$current_dir/$selected"
if command -v xdg-open &> /dev/null; then
    nohup xdg-open "$file_uri" >/dev/null 2>&1 & disown
elif command -v open &> /dev/null; then
    open "$selected"
else
    echo "Error: neither xdg-open nor open commands found."
    exit 1
fi
