# Git Toolchain & Aliases

This document describes the git tools, aliases, and interactive utilities configured in this bootstrap.

## Table of Contents

1. [Core Tools](#core-tools)
2. [Git Aliases](#git-aliases)
3. [forgit - Interactive Git TUI](#forgit---interactive-git-tui)
4. [Oh My Zsh Git Plugin](#oh-my-zsh-git-plugin)
5. [Quick Reference](#quick-reference)

---

## Core Tools

| Tool | Purpose | Install (macOS) | Install (Linux/WSL) |
|------|---------|-----------------|---------------------|
| `git` | Version control | `brew install git` | `sudo apt install git` |
| `fzf` | Fuzzy finder | `brew install fzf` | `sudo apt install fzf` |
| `forgit` | Interactive git TUI | `brew install forgit` | Manual: [install guide](../linux-setup.md#forgit-not-loading) |
| `delta` | Syntax-highlighting pager | `brew install git-delta` | Download from GitHub releases |
| `lazygit` | Terminal UI for git | `brew install lazygit` | `sudo apt install lazygit` |

**Note:** On Linux/WSL, forgit is downloaded to `/usr/local/share/forgit/` during bootstrap. The `.zshrc` checks multiple paths for the forgit plugin.

---

## Git Aliases

All aliases are defined in `config/zsh/.zshrc`. They complement the Oh My Zsh git plugin.

### Status & Basic
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Shorthand for git |
| `gs` | `git status` | Full status |
| `gst` | `git status -sb` | Short branch status |
| `gss` | `git status -s` | Short status |

### Add
| Alias | Command | Description |
|-------|---------|-------------|
| `ga` | `git add` | Add files |
| `gaa` | `git add --all` | Add all changes |
| `gap` | `git add --patch` | Interactive patch add |

### Commit
| Alias | Command | Description |
|-------|---------|-------------|
| `gc` | `git commit` | Commit |
| `gcm` | `git commit -m` | Commit with message |
| `gcam` | `git commit -am` | Add and commit |
| `gc!` | `git commit --amend` | Amend last commit |
| `gcn!` | `git commit --amend --no-edit` | Amend without editing message |

### Branch & Checkout
| Alias | Command | Description |
|-------|---------|-------------|
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | List all branches |
| `gbd` | `git branch -d` | Delete branch |
| `gbD` | `git branch -D` | Force delete branch |
| `gco` | `git checkout` | Checkout branch/file |
| `gcb` | `git checkout -b` | Create and checkout branch |
| `gsw` | `git switch` | Switch branch |
| `gswc` | `git switch -c` | Create and switch branch |
| `gbr` | (fzf) | Interactive branch checkout |

### Diff
| Alias | Command | Description |
|-------|---------|-------------|
| `gd` | `git diff` | Show unstaged changes |
| `gds` | `git diff --staged` | Show staged changes |
| `gdw` | `git diff --word-diff` | Word-level diff |

### Log (Graphical)
| Alias | Command | Description |
|-------|---------|-------------|
| `gl` | `git log --oneline --decorate --graph -20` | Pretty log (last 20) |
| `glo` | `git log --oneline --decorate` | One-line log |
| `glg` | `git log --oneline --decorate --graph --all` | Graph all branches |
| `gls` | `git log --stat` | Log with stats |
| `glc` | `git log ... --simplify-by-decoration` | Show branch points only |

### Push/Pull/Fetch
| Alias | Command | Description |
|-------|---------|-------------|
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Safe force push |
| `gpl` | `git pull` | Pull |
| `gpr` | `git pull --rebase` | Pull with rebase |
| `gf` | `git fetch` | Fetch |
| `gfa` | `git fetch --all --prune` | Fetch all, prune deleted |

### Stash
| Alias | Command | Description |
|-------|---------|-------------|
| `gsta` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |
| `gstd` | `git stash drop` | Drop stash |
| `gstl` | `git stash list` | List stashes |
| `gstsh` | `git stash show -p` | Show stash contents |

### Rebase & Reset
| Alias | Command | Description |
|-------|---------|-------------|
| `grb` | `git rebase` | Rebase |
| `grbi` | `git rebase -i` | Interactive rebase |
| `grba` | `git rebase --abort` | Abort rebase |
| `grbc` | `git rebase --continue` | Continue rebase |
| `grh` | `git reset` | Reset |
| `grhh` | `git reset --hard` | Hard reset |
| `grhs` | `git reset --soft` | Soft reset |

### Cherry-pick & Revert
| Alias | Command | Description |
|-------|---------|-------------|
| `gcp` | `git cherry-pick` | Cherry-pick commit |
| `gcpa` | `git cherry-pick --abort` | Abort cherry-pick |
| `gcpc` | `git cherry-pick --continue` | Continue cherry-pick |
| `grv` | `git revert` | Revert commit |

### Merge
| Alias | Command | Description |
|-------|---------|-------------|
| `gm` | `git merge` | Merge |
| `gma` | `git merge --abort` | Abort merge |
| `gmc` | `git merge --continue` | Continue merge |

### Remote
| Alias | Command | Description |
|-------|---------|-------------|
| `gr` | `git remote` | List remotes |
| `grv` | `git remote -v` | Verbose remote list |
| `gra` | `git remote add` | Add remote |
| `grd` | `git remote remove` | Remove remote |
| `gru` | `git remote update` | Update remote |

### Worktree
| Alias | Command | Description |
|-------|---------|-------------|
| `gwt` | `git worktree` | Worktree commands |
| `gwtl` | `git worktree list` | List worktrees |
| `gwtadd` | `git worktree add` | Add worktree |
| `gwtrm` | `git worktree remove` | Remove worktree |

### Utility
| Alias | Command | Description |
|-------|---------|-------------|
| `gsh` | `git show` | Show commit |
| `gbl` | `git blame -b -w` | Blame (ignore whitespace) |
| `gclean` | `git clean -fd` | Remove untracked files |
| `gign` | `git update-index --assume-unchanged` | Ignore file changes |
| `gunign` | `git update-index --no-assume-unchanged` | Stop ignoring file |

---

## forgit - Interactive Git TUI

**forgit** provides interactive git commands powered by `fzf`. It shows previews, allows fuzzy searching, and makes git operations visual.

### Installation
```bash
brew install forgit
```

The bootstrap already sources forgit in `.zshrc`:
```zsh
if [ -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh ]; then
  source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh
fi
```

### Commands

| Command | Description | Interactive Feature |
|---------|-------------|-------------------|
| `ga` | git add | Fuzzy file selector with diff preview |
| `gd` | git diff | Interactive diff viewer |
| `glo` | git log | Browse commits with full preview |
| `gco` | git checkout | Fuzzy branch/commit selector |
| `gsw` | git switch | Interactive branch switcher |
| `gcb` | git checkout -b | Create branch with name input |
| `gbd` | git branch -D | Delete branches interactively |
| `gss` | git stash show | Browse stashes with preview |
| `gsp` | git stash push | Create stash with message |
| `gcp` | git cherry-pick | Interactive commit picker |
| `grb` | git rebase -i | Interactive rebase |
| `gfu` | git commit --fixup | Interactive fixup commit |
| `gsq` | git commit --squash | Interactive squash commit |
| `grw` | git commit --reword | Interactive reword commit |
| `gbl` | git blame | Interactive blame viewer |
| `gi` | .gitignore generator | Search and add gitignore templates |
| `gat` | .gitattributes | Search and add gitattributes |
| `gclean` | git clean | Interactive untracked file cleaner |
| `grh` | git reset HEAD | Interactive file unstage |
| `gcf` | git checkout <file> | Restore files interactively |
| `gcff` | git checkout <file> from <commit> | Restore from specific commit |
| `gct` | git checkout <tag> | Checkout tags interactively |
| `gwt` | git worktree | List worktrees |
| `gwa` | git worktree add | Add worktree interactively |
| `gwd` | git worktree remove | Remove worktree |

### Example Usage

```bash
# Interactive add - see diff preview and select files with fuzzy search
ga

# Interactive log - browse commits with previews, press Enter to see full commit
glo

# Interactive checkout - fuzzy search branches, see latest commits
gco

# Interactive branch delete - select multiple branches to delete
gbd

# Generate .gitignore - search for "python", "node", "macos", etc
gi
```

---

## Oh My Zsh Git Plugin

The bootstrap enables the `git` plugin in Oh My Zsh, which provides additional aliases.

Key aliases from Oh My Zsh (in addition to our custom ones):

| Alias | Command |
|-------|---------|
| `gcm` | `git checkout $(git_main_branch)` |
| `gcd` | `git checkout $(git_develop_branch)` |
| `gf` | `git fetch` |
| `gfo` | `git fetch origin` |
| `gl` | `git pull` |
| `gup` | `git pull --rebase` |
| `gp` | `git push` |
| `gpsup` | `git push --set-upstream origin $(git_current_branch)` |
| `gst` | `git status` |
| `gsta` | `git stash` |
| `gstp` | `git stash pop` |

> **Note:** Some aliases overlap between Oh My Zsh and our custom definitions. Our `.zshrc` aliases are loaded after Oh My Zsh, so they take precedence where there's overlap.

---

## Quick Reference

### Most Used Commands

```bash
# Daily workflow
gs                    # Check status
gaa                   # Add all changes
gcm "message"         # Commit
gp                    # Push

# Branching
gcb feature/name      # Create branch
gco main              # Switch to main
gpr                   # Pull with rebase
glg                   # View graph

# Interactive (requires forgit)
ga                    # Interactive add with preview
glo                   # Interactive log browser
gco                   # Interactive checkout
gbd                   # Interactive branch delete
```

### Configuring forgit

You can customize forgit by setting environment variables in `.zshrc` before sourcing forgit:

```zsh
# Change default aliases
FORGIT_LOG_FORMAT="%C(auto)%h%d %s %C(blue)%an %C(black)%C(bold)%cr"

# Disable all forgit aliases (use git forgit <command> instead)
FORGIT_NO_ALIASES=1

# Custom fzf options for forgit
FORGIT_FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border"
```

### Related Tools to Consider

| Tool | Description | Install |
|------|-------------|---------|
| `lazygit` | Full TUI for git operations | `brew install lazygit` |
| `git-delta` | Syntax-highlighting pager | `brew install git-delta` |
| `gh` | GitHub CLI | `brew install gh` |
| `git-extras` | Extra git utilities | `brew install git-extras` |

---

## Linux/WSL Notes

### forgit Installation

The bootstrap installs forgit manually on Linux since it's not in most package repositories:

```bash
# Downloaded to system location
ls /usr/local/share/forgit/
# forgit.plugin.zsh  git-forgit

# Or user-local
ls ~/.local/share/forgit/
```

The `.zshrc` sources forgit from multiple possible locations (macOS Homebrew, Linux system, user-local).

### Missing bat/fd Commands

Ubuntu uses different package names that are symlinked by the bootstrap:

```bash
# These symlinks are created automatically:
# batcat → bat
# fdfind → fd

# Verify:
which bat fd
```

## Resources

- **forgit**: https://github.com/wfxr/forgit
- **fzf**: https://github.com/junegunn/fzf
- **Oh My Zsh Git Plugin**: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
- **Git Aliases Guide**: https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
- **Linux Setup Guide**: [docs/linux-setup.md](../linux-setup.md)
