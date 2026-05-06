#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== Terminal Setup =="

run "brew install iterm2 ghostty zsh fzf eza bat ripgrep fd"

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  run 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Fonts
run "brew tap homebrew/cask-fonts || true"
run "brew install font-meslo-lg-nerd-font || true"

# Configs
run "cp ./config/zsh/.zshrc ~/.zshrc"
run "mkdir -p ~/.config/ghostty"
run "cp ./config/ghostty/config ~/.config/ghostty/config"

echo "⚠️ Open iTerm2 once to finalize settings"