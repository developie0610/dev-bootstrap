# dev-bootstrap

Cross-platform developer bootstrap for macOS, Linux, and WSL (Ubuntu).

This repository installs and configures the tools I use most often, including Homebrew/apt packages, terminal tooling (Zsh, Oh My Zsh, Powerlevel10k), VS Code extensions, and personal utilities — with 80+ git aliases and interactive git tools.

## Goals

- Fast setup with retryable, idempotent modules
- Easy customization and extension for new tooling
- Safe reruns without redoing completed work
- Clear status and module-level control

## Requirements

- **macOS**: macOS 12+ with network access
- **Linux/WSL**: Ubuntu 20.04+ (or other Debian-based distro), sudo access
- No need to run as root (will use sudo where needed)
- **macOS only**: Xcode command line tools are installed automatically if missing

## Supported Platforms

| Platform | Package Manager | Notes |
|----------|-----------------|-------|
| macOS 12+ | Homebrew | Full GUI app support (iTerm2, Ghostty, VS Code, Cursor) |
| Ubuntu/Debian | apt | CLI tools + manual installs for GUI apps |
| WSL (Ubuntu) | apt | Use Windows Terminal + install fonts on Windows host |
| Fedora | dnf | Partial support |
| Arch Linux | pacman | Partial support (forgit in AUR) |

## Installation

```bash
chmod +x setup.sh
./setup.sh
```

### Platform-Specific Notes

**macOS:**
```bash
# Standard installation
./setup.sh --mode all
```

**Ubuntu/WSL:**
```bash
# May need sudo password for package installation
./setup.sh --mode all --file-mode merge

# Or set file handling via environment
FILE_MODE=merge ./setup.sh --mode all
```

**All platforms - choose how to handle existing config files:**

```bash
# Interactive mode (default) - prompts for each existing file
./setup.sh --mode all

# Merge mode - appends new content to existing files
./setup.sh --mode all --file-mode merge

# Backup mode - backs up existing, replaces with new
./setup.sh --mode all --file-mode backup

# Skip mode - keeps existing files unchanged
./setup.sh --mode all --file-mode skip
```

## Usage

Run setup with these supported options:

```bash
./setup.sh --mode all
./setup.sh --mode select
./setup.sh --mode step
./setup.sh --task terminal
./setup.sh --task vscode
./setup.sh --status
./setup.sh --reset
```

### File Handling Options

When config files (like `~/.zshrc`) already exist, the script offers several strategies:

| Mode | Behavior | Use Case |
|------|----------|----------|
| `interactive` (default) | Prompt: Replace/Merge/Skip/Diff | Manual control per file |
| `backup` | Backup existing, copy new | Fresh start with safety net |
| `merge` | Append new content to existing | Combine your config with bootstrap |
| `skip` | Keep existing unchanged | Protect your current setup |
| `force` | Replace without backup | ⚠️ Dangerous, use with caution |

Set mode via CLI flag or environment variable:
```bash
./setup.sh --mode all --file-mode merge
FILE_MODE=skip ./setup.sh --task terminal
./setup.sh --retry terminal --file-mode backup
```

### Recommended Workflow for Existing Setups

If you already have a configured environment:

```bash
# 1. First run - use merge mode to safely combine configs
./setup.sh --mode all --file-mode merge

# 2. Review what was added to your .zshrc, then reload
source ~/.zshrc

# 3. If something goes wrong, restore from backup
mv ~/.zshrc.bak.20250115_143022 ~/.zshrc

# 4. Or retry a specific module with different handling
./setup.sh --retry terminal --file-mode interactive
```

## Modules

Modules are implemented as independent shell scripts in `modules/` and tracked with `state/installed.log`.

- `core` — Homebrew/apt packages, Xcode CLI (macOS), and system prerequisites
- `terminal` — iTerm2/Ghostty (macOS), Zsh, Oh My Zsh, Powerlevel10k, shell plugins, fzf, forgit, and terminal config
- `vscode` — Visual Studio Code and default extensions
- `cursor` — Cursor app installation
- `claude` — Claude CLI installation and environment reminder

**Platform-specific details:**
- **macOS**: Full GUI app support via Homebrew
- **Linux/WSL**: See [docs/linux-setup.md](docs/linux-setup.md) for detailed setup instructions

## Git Toolchain & Aliases

This bootstrap includes a powerful git setup:

- **80+ git aliases** for common operations (`gco`, `gcb`, `gl`, `gss`, etc.)
- **forgit** — Interactive git TUI powered by fzf (`ga` for interactive add, `glo` for log browser, etc.)
- **Oh My Zsh git plugin** with additional aliases

See the full documentation: [`docs/git-toolchain.md`](docs/git-toolchain.md)

### Quick Examples

```bash
gs              # git status
gaa             # git add --all
gcm "message"   # git commit -m
glg             # git log --oneline --decorate --graph --all

# Interactive commands (via forgit)
ga              # Interactive add with diff preview
glo             # Interactive log browser
gco             # Interactive branch checkout
gbd             # Interactive branch delete
gi              # Interactive .gitignore generator
```

## Configuration

- `Brewfile` manages Homebrew packages and casks (macOS only)
- `config/zsh/.zshrc` is installed to `~/.zshrc` (with smart merge/backup options, cross-platform)
- `config/ghostty/config` is installed to `~/.config/ghostty/config` (when Ghostty is available)
- Add a new module by creating `modules/<name>.sh` and adding it to the `MODULES` array in `setup.sh`

### Platform Differences

**macOS:**
- Uses Homebrew for all packages
- Installs GUI apps: iTerm2, Ghostty, VS Code, Cursor
- Installs fonts via Homebrew casks

**Linux/WSL:**
- Uses apt/dnf/pacman for CLI tools
- GUI apps need manual installation or alternative methods
- Fonts must be installed manually (see Powerlevel10k docs)
- Creates symlinks for tools with different names (`batcat` → `bat`, `fdfind` → `fd`)

### Smart File Handling

When installing config files that already exist:

1. **Backup first** - All destructive operations create timestamped backups (`.bak.YYYYMMDD_HHMMSS`)
2. **Merge mode** - Appends bootstrap content with clear section markers, avoiding duplicates
3. **Diff viewer** - Interactive mode can show differences before deciding
4. **Non-interactive fallback** - Defaults to `backup` mode when running in CI/automation

## Re-run and cleanup

- Show completed modules:
  ```bash
  ./setup.sh --status
  ```
- Retry a specific module (removes from state and re-runs):
  ```bash
  ./setup.sh --retry terminal
  ```
- Run a single module (skips if already in state):
  ```bash
  ./setup.sh --task terminal
  ```
- Reset state and rerun everything:
  ```bash
  ./setup.sh --reset
  ```

## Recommended workflow

1. Run `./setup.sh --mode all`
2. Open a new shell or run `source ~/.zshrc`
3. If a module fails, fix the issue and rerun only that module:
   ```bash
   ./setup.sh --retry <module>
   ```

## Best practices

- Keep tool versions in `Brewfile` and `modules/*` if specific versions are needed
- Keep shell and app config under `config/`
- Keep installation logic small and idempotent per module
- Use `--file-mode merge` when adding to existing setups to preserve your customizations
- Use `--file-mode backup` for clean installs when you're sure you want the bootstrap configs
- Use `--file-mode skip` in CI/CD environments to avoid overwriting user configs
- Always review merged configs after running - the script adds markers like `# DEV-BOOTSTRAP CONFIGURATION`

## Troubleshooting

- **macOS only**: If VS Code CLI is not available, open VS Code and run `Shell Command: Install 'code' command in PATH`
- **Linux**: VS Code can be installed via snap: `sudo snap install code --classic` or downloaded from https://code.visualstudio.com
- **WSL**: VS Code with WSL extension works best - install on Windows, access via `code .` in WSL
- **Missing fonts**: Install a Nerd Font manually: https://github.com/romkatv/powerlevel10k#fonts
- **forgit not found**: On Linux, forgit is installed to `/usr/local/share/forgit/` or `~/.local/share/forgit/`
- If a module fails repeatedly: `./setup.sh --retry <module>`
- **Config file conflicts**: Run with `--file-mode interactive` to choose per-file, or use `--file-mode merge` to append content
- **Restore from backup**: Backups are created with timestamps (`.bak.YYYYMMDD_HHMMS`):
  ```bash
  mv ~/.zshrc.bak.20240608_103022 ~/.zshrc
  ```
- **Duplicate content after merge**: If you run merge mode twice, the script detects existing markers and skips duplicates

