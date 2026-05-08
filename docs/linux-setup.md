# Linux & WSL Setup Guide

This guide covers platform-specific details for running the bootstrap on Linux (Ubuntu/Debian) and WSL (Windows Subsystem for Linux).

## Quick Start (Ubuntu/WSL)

```bash
# Clone the repository
git clone <repo-url> ~/dev-bootstrap
cd ~/dev-bootstrap

# Make executable and run
chmod +x setup.sh
./setup.sh --mode all --file-mode merge
```

## Platform-Specific Details

### Ubuntu/Debian

**Package Manager:** apt

**What gets installed:**
- CLI tools: git, zsh, fzf, bat, exa, ripgrep, fd-find
- Development: build-essential, pkg-config
- Node.js (via apt or NodeSource)
- Oh My Zsh with plugins and Powerlevel10k theme
- forgit (downloaded to `/usr/local/share/forgit/`)

**Tool name mappings:**
The bootstrap creates symlinks for tools with different names on Ubuntu:
- `batcat` → `bat`
- `fdfind` → `fd`

**Fonts:**
You need to manually install a Nerd Font for Powerlevel10k icons:
1. Download [MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts)
2. Install system-wide or for your user
3. Configure your terminal to use the font

### WSL (Windows Subsystem for Linux)

**Recommended Terminal:** Windows Terminal (install from Microsoft Store)

**Setup workflow:**
1. Install Windows Terminal on Windows side
2. Install [MesloLGS NF font on Windows](https://github.com/romkatv/powerlevel10k#fonts)
3. Configure Windows Terminal to use the Nerd Font
4. Run bootstrap in WSL Ubuntu
5. Use VS Code with WSL extension (install on Windows, works seamlessly in WSL)

**WSL-specific notes:**
- GUI apps (iTerm2, Ghostty) are not available - use Windows Terminal
- VS Code: Install on Windows, access via `code .` in WSL
- Cursor: Install on Windows side
- Fonts must be installed on Windows host for Windows Terminal

### Fedora/RHEL

**Package Manager:** dnf

```bash
# Bootstrap will try to install:
sudo dnf install -y git zsh fzf bat eza ripgrep fd-find
```

### Arch Linux

**Package Manager:** pacman

```bash
# Bootstrap will try to install:
sudo pacman -S --needed git zsh fzf bat eza ripgrep fd forgit
```

Note: forgit is in the AUR, may need manual installation:
```bash
yay -S forgit  # or paru -S forgit
```

## Manual Steps for Linux

### 1. Install a Nerd Font

```bash
# Download MesloLGS NF
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -L -o "MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -L -o "MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl -L -o "MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl -L -o "MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

# Refresh font cache
fc-cache -fv
```

### 2. Configure Terminal

**GNOME Terminal:**
```bash
# Install dconf-editor or use gsettings
gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS NF 11'
```

**Alacritty:**
Edit `~/.config/alacritty/alacritty.yml`:
```yaml
font:
  normal:
    family: MesloLGS NF
  size: 11
```

**Windows Terminal (WSL):**
1. Open Windows Terminal settings (Ctrl+,)
2. Go to Profiles → Ubuntu → Appearance
3. Set Font face to "MesloLGS NF"

### 3. Install VS Code

```bash
# Method 1: snap (recommended for Ubuntu)
sudo snap install code --classic

# Method 2: Download .deb
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install code
```

### 4. Install Ghostty (optional)

Ghostty is not yet in most Linux repositories:

```bash
# Follow official instructions: https://ghostty.org/docs/install/binary
# Or build from source
```

## Troubleshooting

### forgit not loading

Check if forgit is installed:
```bash
# Should show the plugin path
ls -la /usr/local/share/forgit/

# If missing, install manually:
sudo mkdir -p /usr/local/share/forgit
sudo curl -fsSL https://raw.githubusercontent.com/wfxr/forgit/main/forgit.plugin.zsh \
  -o /usr/local/share/forgit/forgit.plugin.zsh
```

### bat/fd not found

Ubuntu uses different names:
```bash
# Check if symlinks exist
ls -la /usr/local/bin/bat
ls -la /usr/local/bin/fd

# If missing, create them:
sudo ln -sf $(which batcat) /usr/local/bin/bat
sudo ln -sf $(which fdfind) /usr/local/bin/fd
```

### Icons not showing in prompt

The terminal font is not a Nerd Font:
1. Install MesloLGS NF as described above
2. Configure your terminal to use it
3. Run `p10k configure` to regenerate the prompt config

### WSL: VS Code command not found

```bash
# Add VS Code from Windows to WSL PATH
echo 'export PATH="$PATH:/mnt/c/Users/$USER/AppData/Local/Programs/Microsoft VS Code/bin"' >> ~/.zshrc
# Replace $USER with your Windows username if different
```

Or install VS Code inside WSL:
```bash
sudo snap install code --classic
```

### Permission denied during setup

Some steps require sudo. The bootstrap will prompt when needed, but you can also run with sudo preserved:

```bash
sudo -v  # Cache sudo credentials
./setup.sh --mode all
```

## Recommended Linux Terminal Emulators

| Terminal | Features | Install |
|----------|----------|---------|
| Alacritty | GPU-accelerated, minimal | `sudo apt install alacritty` |
| WezTerm | Rich features, Lua config | Download from GitHub |
| Kitty | Fast, featureful | `sudo apt install kitty` |
| GNOME Terminal | Default on Ubuntu | `sudo apt install gnome-terminal` |
| Windows Terminal | Best for WSL | Microsoft Store |

## Post-Setup Checklist

- [ ] Font shows icons correctly (run `echo "\ue0b0 \ue0a0"` - should show triangles)
- [ ] `which zsh` returns path
- [ ] `echo $SHELL` shows zsh (logout/login to apply if changed)
- [ ] `fzf --version` works
- [ ] `ga` command opens forgit interactive add
- [ ] Git aliases work: `gcm`, `gco`, `glg`
- [ ] VS Code opens with `code .`

## Differences from macOS

| Feature | macOS | Linux/WSL |
|---------|-------|-----------|
| GUI apps | iTerm2, Ghostty, VS Code, Cursor via Homebrew | Manual install or snap |
| Fonts | Homebrew cask | Manual download |
| forgit | Homebrew formula | Manual download/curl |
| Node.js | Homebrew | apt or NodeSource |
| Package manager | Homebrew | apt/dnf/pacman |

## Resources

- [Powerlevel10k Font Installation](https://github.com/romkatv/powerlevel10k#fonts)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Windows Terminal Customization](https://docs.microsoft.com/en-us/windows/terminal/customize-settings/appearance)
