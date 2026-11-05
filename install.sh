#!/usr/bin/env bash
# Sync SKILLS.md ticks into skills/, then symlink every skill in ./skills into each
# agent's user-level skills directory.
#
# Default targets:
#   ~/.claude/skills   Claude Code
#   ~/.agents/skills   Codex and Gemini CLI (shared cross-agent location; Claude Code ignores it)
#
# Usage: ./install.sh [target-dir ...]   e.g. ./install.sh ~/some/other/skills
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$#" -gt 0 ]; then
  targets=("$@")
else
  targets=("$HOME/.claude/skills" "$HOME/.agents/skills")
fi

python3 -I "$repo/scripts/skills.py" sync
python3 -I "$repo/scripts/skills.py" apply

install_into() {
  local target="$1" dir name link count=0
  mkdir -p "$target"
  for dir in "$repo"/skills/*/; do
    name="$(basename "$dir")"
    link="$target/$name"
    if [ -L "$link" ]; then
      ln -sfn "${dir%/}" "$link"
    elif [ -e "$link" ]; then
      echo "skip  $name (a non-symlink already exists at $link)" >&2
      continue
    else
      ln -s "${dir%/}" "$link"
      echo "link  $name -> $link"
    fi
    count=$((count + 1))
  done
  # Remove dangling symlinks that point back into this repo (deleted/renamed skills).
  for link in "$target"/*; do
    if [ -L "$link" ] && [ ! -e "$link" ] && [[ "$(readlink "$link")" == "$repo"/* ]]; then
      rm "$link" && echo "prune $(basename "$link") from $target"
    fi
  done
  echo "$count skills installed in $target"
}

for target in "${targets[@]}"; do
  install_into "$target"
done
