# dev-bootstrap

Personal macOS developer bootstrap for a fast, repeatable workstation setup.

This repository installs and configures the tools I use most often, including Homebrew packages, terminal tooling, VS Code extensions, and personal utilities.

## Goals

- Fast setup with retryable, idempotent modules
- Easy customization and extension for new tooling
- Safe reruns without redoing completed work
- Clear status and module-level control

## Requirements

- macOS 12+ with network access
- No need to run as root
- Xcode command line tools are installed automatically if missing

## Installation

```bash
chmod +x setup.sh
./setup.sh
```

## Usage

Run setup with these supported options:

```bash
./setup.sh --mode all
./setup.sh --mode select
./setup.sh --mode step
./setup.sh --task vscode
./setup.sh --retry vscode
./setup.sh --reset
./setup.sh --status
```

## Modules

Modules are implemented as independent shell scripts in `modules/` and tracked with `state/installed.log`.

- `core` — Homebrew, Brewfile, Xcode CLI, and system prerequisites
- `terminal` — iTerm2, Ghostty, Zsh, Oh My Zsh, Powerlevel10k, shell plugins, and terminal config
- `vscode` — Visual Studio Code and default extensions
- `cursor` — Cursor app installation
- `claude` — Claude CLI installation and environment reminder

## Configuration

- `Brewfile` manages Homebrew packages and casks
- `config/zsh/.zshrc` is copied to `~/.zshrc`
- `config/ghostty/config` is copied to `~/.config/ghostty/config`
- Add a new module by creating `modules/<name>.sh` and adding it to the `MODULES` array in `setup.sh`

## Re-run and cleanup

- Show completed modules:
  ```bash
  ./setup.sh --status
  ```
- Retry a module even if it was completed:
  ```bash
  ./setup.sh --retry terminal
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

## Troubleshooting

- If the VS Code CLI is not available, open VS Code and run `Shell Command: Install 'code' command in PATH`
- If the `code` commands fail, retry the `vscode` module once the CLI is available
- If a module fails repeatedly, remove the module from `state/installed.log` and rerun it

