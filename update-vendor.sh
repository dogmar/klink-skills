#!/usr/bin/env bash
# Pull upstream changes into vendored skill sets (git subtree). Commit or stash local work first.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
git subtree pull --prefix=vendor/mattpocock https://github.com/mattpocock/skills.git main --squash -m "Update vendor/mattpocock from upstream"
./install.sh
