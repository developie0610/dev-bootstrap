#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== Core Setup =="

if ! xcode-select -p >/dev/null 2>&1; then
  run "xcode-select --install"
fi

if ! command -v brew >/dev/null 2>&1; then
  run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

run "brew update"
run "brew bundle --file=./Brewfile || true"