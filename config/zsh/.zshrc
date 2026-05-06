export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
  z
)

source $ZSH/oh-my-zsh.sh

alias ls="eza --icons"
alias cat="bat"