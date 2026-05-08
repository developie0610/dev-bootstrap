#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== Cursor =="

if is_macos; then
  run "brew install --cask cursor || true"

elif is_linux_or_wsl; then
  echo "💡 Cursor installation on Linux:"
  echo "   1. Download from: https://cursor.sh"
  echo "   2. Or use AppImage: https://github.com/getcursor/cursor"
  echo ""
  echo "   For WSL: Install Cursor on Windows side for best integration"

  # Try to install via snap if available
  if command -v snap >/dev/null 2>&1; then
    run "sudo snap install cursor || true" 2>/dev/null || echo "   Snap install not available, manual download required"
  fi
fi