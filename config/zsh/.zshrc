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

# ============================================
# Git Aliases (complementing Oh My Zsh git plugin)
# ============================================

# Basic git shortcuts
alias g='git'
alias gs='git status'
alias gst='git status -sb'
alias gss='git status -s'

# Add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'

# Commit
alias gc='git commit'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gc!='git commit --amend'
alias gcn!='git commit --amend --no-edit'

# Branch & Checkout
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'

# Diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# Log
alias gl='git log --oneline --decorate --graph -20'
alias glo='git log --oneline --decorate'
alias glg='git log --oneline --decorate --graph --all'
alias gls='git log --stat'
alias glc='git log --oneline --decorate --graph -10 --all --simplify-by-decoration'

# Pull/Push/Fetch
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gpr='git pull --rebase'
alias gf='git fetch'
alias gfa='git fetch --all --prune'

# Stash
alias gsta='git stash'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstsh='git stash show -p'

# Rebase & Reset
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grh='git reset'
alias grhh='git reset --hard'
alias grhs='git reset --soft'

# Cherry-pick & Revert
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias grv='git revert'

# Merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'

# Remote
alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'
alias grd='git remote remove'
alias gru='git remote update'

# Worktree
alias gwt='git worktree'
alias gwtl='git worktree list'
alias gwtadd='git worktree add'
alias gwtrm='git worktree remove'

# Utility
alias gsh='git show'
alias gbl='git blame -b -w'
alias gclean='git clean -fd'
alias gign='git update-index --assume-unchanged'
alias gunign='git update-index --no-assume-unchanged'
alias grm='git rm'
alias gmv='git mv'

# Quick branch switch (fzf required)
alias gbr='git branch --sort=-committerdate | fzf --header="Checkout branch" | xargs git checkout'

# ============================================
# forgit - Interactive Git with fzf
# https://github.com/wfxr/forgit
# ============================================

# macOS (Homebrew)
if [ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ]; then
  source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh
# Linux/WSL (manual install or package manager)
elif [ -f /usr/local/share/forgit/forgit.plugin.zsh ]; then
  source /usr/local/share/forgit/forgit.plugin.zsh
elif [ -f /usr/share/forgit/forgit.plugin.zsh ]; then
  source /usr/share/forgit/forgit.plugin.zsh
# Check in user's home for manual installation
elif [ -f $HOME/.local/share/forgit/forgit.plugin.zsh ]; then
  source $HOME/.local/share/forgit/forgit.plugin.zsh
fi

# forgit provides these interactive commands:
#   ga   - git add (interactive file selector)
#   gd   - git diff (interactive file selector)
#   glo  - git log (interactive viewer with preview)
#   gco  - git checkout (interactive branch/commit selector)
#   gsw  - git switch (interactive branch selector)
#   gcb  - git checkout -b (create and switch branch)
#   gbd  - git branch -D (delete branch interactively)
#   gss  - git stash show (interactive stash viewer)
#   gsp  - git stash push (interactive stash creator)
#   gcp  - git cherry-pick (interactive commit selector)
#   grb  - git rebase -i (interactive rebase)
#   gfu  - git commit --fixup (interactive fixup)
#   gbl  - git blame (interactive blame)
#   gi   - git ignore (interactive .gitignore generator)
#   gclean - git clean (interactive cleaner)

# ============================================
# Other Useful Aliases
# ============================================
alias cl='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'