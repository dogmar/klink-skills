#!/usr/bin/env bash
# Add a vendored skill to skills/ as a relative symlink, then reinstall.
# Usage: ./link-skill.sh vendor/mattpocock/skills/engineering/tdd [...more]
# Remove one: rm skills/<name> && ./install.sh
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo"
for src in "$@"; do
  src="${src%/}"
  [ -f "$src/SKILL.md" ] || { echo "no SKILL.md in $src" >&2; exit 1; }
  name="$(basename "$src")"
  if [ -e "skills/$name" ] || [ -L "skills/$name" ]; then
    echo "skip  $name (skills/$name already exists)" >&2; continue
  fi
  ln -s "../$src" "skills/$name" && echo "add   $name -> $src"
done
./install.sh
