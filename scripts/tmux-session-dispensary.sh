#!/usr/bin/env bash

DIRS=(
    "$HOME/documents/work"
    "$HOME/documents/projects"
    "$HOME/documents"
    "$HOME/documents/notes"
    "$HOME"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path --base-directory $HOME \
        | sed "s|^$HOME/||" \
        | sk --margin 10% --color="bw")

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if [[ -z $TMUX ]]; then
    echo "This script must be run inside a Tmux session."
    exit 1
fi

if ! tmux select-window -t "$selected_name" 2> /dev/null; then
    tmux new-window -c "$selected" -n "$selected_name"
fi
