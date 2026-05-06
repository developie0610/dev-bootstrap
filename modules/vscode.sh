#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== VS Code =="

run "brew install --cask visual-studio-code || true"

if command -v code >/dev/null 2>&1; then
  run "code --install-extension esbenp.prettier-vscode || true"
  run "code --install-extension dbaeumer.vscode-eslint || true"
else
  echo "⚠️ Visual Studio Code CLI not found. Open VS Code and use 'Shell Command: Install 'code' command in PATH'."
fi