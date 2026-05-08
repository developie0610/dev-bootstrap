#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

OS=$(get_os)
PKG_MANAGER=$(get_pkg_manager)

echo "== Core Setup =="
echo "🖥️  OS detected: $OS"
echo "📦 Package manager: $PKG_MANAGER"

# macOS-specific: Xcode CLI tools
if is_macos; then
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    run "xcode-select --install"
  fi
fi

# Package manager setup
if is_macos; then
  # macOS: Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    # Add to PATH for this session if newly installed
    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  run "brew update"
  run "brew bundle --file=./Brewfile || true"

elif is_linux_or_wsl; then
  # Linux/WSL: apt (Ubuntu/Debian)
  if [ "$PKG_MANAGER" = "apt" ]; then
    echo "Updating package lists..."
    run "sudo apt update"

    echo "Installing core packages..."
    run "sudo apt install -y git curl wget zsh fzf bat exa ripgrep fd-find \
      build-essential pkg-config"

    # Create symlinks for tools with different names on Linux
    if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
      run "sudo ln -sf $(which fdfind) /usr/local/bin/fd"
    fi

    if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
      run "sudo ln -sf $(which batcat) /usr/local/bin/bat"
    fi

    # Install forgit manually on Linux (not in apt)
    if ! command -v git-forgit >/dev/null 2>&1; then
      echo "Installing forgit..."
      run "sudo curl -fsSL https://raw.githubusercontent.com/wfxr/forgit/main/bin/git-forgit -o /usr/local/bin/git-forgit"
      run "sudo chmod +x /usr/local/bin/git-forgit"
      # Also get the plugin script
      run "sudo curl -fsSL https://raw.githubusercontent.com/wfxr/forgit/main/forgit.plugin.zsh -o /usr/local/share/forgit/forgit.plugin.zsh"
    fi

  elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo "Installing packages with dnf..."
    run "sudo dnf install -y git curl wget zsh fzf bat eza ripgrep fd-find"

  elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo "Installing packages with pacman..."
    run "sudo pacman -S --needed git curl wget zsh fzf bat eza ripgrep fd forgit"

  else
    echo "⚠️  Unsupported package manager. Please install manually:"
    echo "   git, zsh, fzf, bat, eza/exa, ripgrep, fd, forgit"
  fi
fi