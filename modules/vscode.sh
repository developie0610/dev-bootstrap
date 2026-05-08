#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== VS Code =="

# Platform-specific installation
if is_macos; then
  run "brew install --cask visual-studio-code || true"

elif is_linux_or_wsl; then
  # Try multiple methods for Linux
  if ! command -v code >/dev/null 2>&1; then
    echo "Installing VS Code on Linux..."

    # Method 1: snap (Ubuntu/Debian)
    if command -v snap >/dev/null 2>&1; then
      run "sudo snap install code --classic || true"
    fi

    # Method 2: Download and install .deb
    if ! command -v code >/dev/null 2>&1 && [ -f /etc/debian_version ]; then
      echo "Downloading VS Code .deb package..."
      run "curl -L -o /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'"
      run "sudo apt install -y /tmp/vscode.deb || true"
      rm -f /tmp/vscode.deb
    fi

    # Method 3: WSL - use Windows VS Code (already installed on Windows side)
    if is_wsl && ! command -v code >/dev/null 2>&1; then
      echo "💡 WSL detected: VS Code should be installed on Windows side."
      echo "   Download from: https://code.visualstudio.com"
      echo "   WSL extension will be installed automatically when opening WSL folder."
    fi
  fi

  if ! command -v code >/dev/null 2>&1; then
    echo "⚠️  VS Code installation failed or skipped."
    echo "   Manual install options:"
    echo "   - snap: sudo snap install code --classic"
    echo "   - Download: https://code.visualstudio.com"
  fi
fi

# Install extensions (works on all platforms if code CLI is available)
if command -v code >/dev/null 2>&1; then
  echo "Installing VS Code extensions..."
  run "code --install-extension esbenp.prettier-vscode || true"
  run "code --install-extension dbaeumer.vscode-eslint || true"
else
  echo "⚠️  VS Code CLI not found. Skipping extensions."
  if is_macos; then
    echo "   Open VS Code and use 'Shell Command: Install 'code' command in PATH'"
  fi
fi