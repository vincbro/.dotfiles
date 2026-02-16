#!/usr/bin/env bash

FILENAME="$1"
FROM_LINE="$2"
TO_LINE="$3"
echo $FILENAME $FROM_LINE $TO_LINE
PROMPT=$(gum write --placeholder "Enter prompt for $FILENAME $FROM_LINE:$TO_LINE")

JSON=$(jq -n \
  --arg file "$FILENAME" \
  --arg from_line "$FROM_LINE" \
  --arg to_line "$TO_LINE" \
  --arg prompt "$PROMPT" \
  '{file: $file, from_line: $from_line, to_line: $to_line, prompt: $prompt}')

opencode --prompt "$JSON"
