#!/usr/bin/env bash

set -e

PROMPT_SCRIPT_PATH="$HOME/.bash/bashrc.sh"
BASHRC_PATH="$HOME/.bashrc"

# The exact string we want to look for and add
SOURCE_COMMAND="source \"$PROMPT_SCRIPT_PATH\""

# 1. Check if the line already exists in .bashrc
# -F treats the string as fixed text (not a regex)
# -x ensures it matches the whole line
# -q makes it quiet (no output to terminal)
if grep -Fxq "$SOURCE_COMMAND" "$BASHRC_PATH" 2>/dev/null; then
    echo "✔ Custom prompt is already sourced in .bashrc."
else
    # 2. If not found, append it safely
    echo "Appending custom prompt to .bashrc..."
    
    # Add a blank line first just in case .bashrc doesn't end with a newline
    echo "" >> "$BASHRC_PATH"
    echo "# Load custom bash prompt" >> "$BASHRC_PATH"
    echo "$SOURCE_COMMAND" >> "$BASHRC_PATH"
    
    echo "✔ Done! Run 'source ~/.bashrc' or restart your terminal to apply."
fi
