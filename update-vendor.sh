#!/usr/bin/env bash
# Pull upstream changes into every vendored skill set (git subtree), then refresh
# SKILLS.md (new upstream skills appear unticked) and reinstall.
# Commit or stash local work first.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
pull() { git subtree pull --prefix="vendor/$1" "$2" main --squash -m "Update vendor/$1 from upstream"; }
pull mattpocock https://github.com/mattpocock/skills.git
pull t3dotgg    https://github.com/t3dotgg/tstack.git
./install.sh
