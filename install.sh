#!/usr/bin/env bash
# Adds the graphify skill to the current project folder.
# Run from inside the project you want to add it to:
#   curl -fsSL https://raw.githubusercontent.com/sergiogoqui-cpu/graphify-template/main/install.sh | bash

set -euo pipefail

repo="https://github.com/sergiogoqui-cpu/graphify-template.git"
tmp="$(mktemp -d)"

echo "Fetching graphify skill files..."
git clone --depth 1 -q "$repo" "$tmp"

mkdir -p ./.claude/skills
cp -R "$tmp/.claude/skills/graphify" ./.claude/skills/

if [ ! -f ./CLAUDE.md ]; then
    cp "$tmp/CLAUDE.md" ./CLAUDE.md
elif ! grep -q graphify ./CLAUDE.md; then
    printf '\n%s\n' "$(cat "$tmp/CLAUDE.md")" >> ./CLAUDE.md
fi

rm -rf "$tmp"

if ! command -v graphify >/dev/null 2>&1; then
    echo "Installing graphify CLI (uv tool install graphifyy)..."
    if command -v uv >/dev/null 2>&1; then
        uv tool install graphifyy
    else
        pip install graphifyy
    fi
fi

echo ""
echo "Done. graphify is ready in this project - open Claude Code here and type: /graphify ."
