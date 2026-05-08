#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

OS=$(get_os)

echo "== Terminal Setup =="
echo "🖥️  OS: $OS"

# Oh My Zsh (cross-platform)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  run 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Oh My Zsh plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Platform-specific setup
if is_macos; then
  # macOS: Install terminal emulators via Homebrew
  echo "Installing macOS terminal emulators..."
  run "brew install --cask iterm2 ghostty || true"

  # Fonts via Homebrew
  run "brew tap homebrew/cask-fonts || true"
  run "brew install font-meslo-lg-nerd-font || true"

  # CLI tools (in case core.sh missed them)
  run "brew install fzf eza bat ripgrep fd forgit || true"

  echo "⚠️  macOS: Open iTerm2 once to finalize settings"

elif is_linux_or_wsl; then
  echo "Setting up Linux/WSL terminal environment..."

  # On WSL, install Windows Terminal font if available
  if is_wsl; then
    echo "💡 WSL detected: Install Windows Terminal from Microsoft Store for best experience"
    echo "💡 Install MesloLGS NF font on Windows: https://github.com/romkatv/powerlevel10k#fonts"
  fi

  # Check if terminal tools are available (installed by core.sh)
  for tool in fzf bat eza ripgrep fd; do
    if ! command -v $tool >/dev/null 2>&1; then
      echo "⚠️  Tool '$tool' not found. It may need manual installation."
    fi
  done

  # Install Ghostty on Linux (manual since it's not in most repos yet)
  if ! command -v ghostty >/dev/null 2>&1; then
    echo "💡 Ghostty not available via package manager. Install manually if needed:"
    echo "   https://ghostty.org/docs/install/binary"
  fi

  echo "✅ Linux terminal setup complete"
  echo "💡 Recommended: Install a Nerd Font for Powerlevel10k icons:"
  echo "   https://github.com/romkatv/powerlevel10k#fonts"
fi

# Configs - using smart file handling (cross-platform)
# Zsh config - merge at end with clear marker
install_file "./config/zsh/.zshrc" "$HOME/.zshrc" "# ============================================
# DEV-BOOTSTRAP CONFIGURATION - APPENDED BELOW
# ============================================" "end"

# Ghostty config (only if Ghostty is installed)
if command -v ghostty >/dev/null 2>&1 || is_macos; then
  run "mkdir -p ~/.config/ghostty"
  install_file "./config/ghostty/config" "$HOME/.config/ghostty/config" "# Added by dev-bootstrap" "end"
fi

# Change default shell to zsh if not already
if [ "$SHELL" != "$(which zsh)" ] && [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
  if command -v zsh >/dev/null 2>&1; then
    echo "Changing default shell to zsh..."
    if is_linux_or_wsl; then
      run "sudo chsh -s $(which zsh) $USER"
    else
      run "chsh -s $(which zsh)"
    fi
    echo "⚠️  Shell change will take effect after logging out and back in"
  fi
fi