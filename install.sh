#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/tdd"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"

echo "Installed TDD skill to $SKILL_DIR/SKILL.md"
