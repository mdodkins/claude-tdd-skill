#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LINK_PATH="$SKILLS_DIR/tdd"

mkdir -p "$SKILLS_DIR"

if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
    echo "Removing existing $LINK_PATH"
    rm -rf "$LINK_PATH"
fi

ln -s "$SCRIPT_DIR" "$LINK_PATH"

echo "Symlinked $LINK_PATH -> $SCRIPT_DIR"
