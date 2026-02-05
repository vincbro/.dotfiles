#!/usr/bin/env bash

path=$(tmux display-message -p -F "#{pane_current_path}")

cd "$path" || exit 1

# 2. Get the remote URL safely
if ! url=$(git remote get-url origin 2>/dev/null); then
    echo "Not a git repository"
    exit 0
fi

if [[ $url == git@* ]]; then
    url="${url#git@}" 
    url="${url/:/\/}"
    url="https://$url"
fi

url="${url%.git}"

if [[ $url == *github.com* ]]; then
    if command -v xdg-open &> /dev/null; then
        nohup xdg-open "$url" >/dev/null 2>&1 & disown
    elif command -v open &> /dev/null; then
        open "$url"      # macOS
    fi
else
    echo "This repository is not hosted on GitHub"
fi
