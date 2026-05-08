#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== Claude CLI =="

# Ensure node/npm is available
if ! command -v node >/dev/null 2>&1; then
  if is_macos; then
    run "brew install node || true"
  elif is_linux_or_wsl; then
    # Try to install node via apt
    run "sudo apt install -y nodejs npm || true"
    # If that fails, try nodesource
    if ! command -v node >/dev/null 2>&1; then
      echo "Installing Node.js via NodeSource..."
      run "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || true"
      run "sudo apt install -y nodejs || true"
    fi
  fi
fi

# Install Claude CLI
if command -v npm >/dev/null 2>&1; then
  run "npm install -g @anthropic-ai/claude-cli || true"
else
  echo "⚠️  npm not found. Claude CLI installation failed."
  echo "   Install Node.js manually: https://nodejs.org"
fi

echo ""
echo "👉 Set your API key: export ANTHROPIC_API_KEY=your_key"
echo "👉 Or add to ~/.zshrc: export ANTHROPIC_API_KEY=your_key"