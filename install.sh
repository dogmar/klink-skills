#!/usr/bin/env bash
# Sync SKILLS.md ticks into skills/, then symlink every skill in ./skills into a
# skills directory (default: ~/.claude/skills).
# Usage: ./install.sh [target-dir]     e.g. ./install.sh ~/.codex/skills
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${1:-$HOME/.claude/skills}"

python3 -I "$repo/scripts/skills.py" sync
python3 -I "$repo/scripts/skills.py" apply
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
  fi
  echo "link  $name -> $link"
done

# Remove dangling symlinks that point back into this repo (deleted/renamed skills).
for link in "$target"/*; do
  if [ -L "$link" ] && [ ! -e "$link" ] && [[ "$(readlink "$link")" == "$repo"/* ]]; then
    rm "$link" && echo "prune $(basename "$link")"
  fi
done
