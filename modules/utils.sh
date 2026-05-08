set -euo pipefail

STATE_FILE="./state/installed.log"

# Mode: interactive (default), backup, merge, skip
FILE_MODE="${FILE_MODE:-interactive}"

mark_done() {
  echo "$1" >> "$STATE_FILE"
}

is_done() {
  grep -q "^$1$" "$STATE_FILE" 2>/dev/null
}

run() {
  echo "▶ $1"
  eval "$1"
  if [ $? -ne 0 ]; then
    echo "❌ Failed: $1"
    return 1
  fi
}

# ============================================
# OS Detection Utilities
# ============================================

# Detect operating system
get_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] || [ -f /proc/version ] && grep -q Microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

# Check if running on macOS
is_macos() {
  [ "$(get_os)" = "macos" ]
}

# Check if running on Linux (native)
is_linux() {
  [ "$(get_os)" = "linux" ]
}

# Check if running on WSL
is_wsl() {
  [ "$(get_os)" = "wsl" ]
}

# Check if running on Linux or WSL
is_linux_or_wsl() {
  is_linux || is_wsl
}

# Get package manager
get_pkg_manager() {
  if is_macos; then
    echo "brew"
  elif is_linux_or_wsl; then
    if command -v apt >/dev/null 2>&1; then
      echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
      echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then
      echo "pacman"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

# ============================================
# Smart File Handling Utilities
# ============================================

# Check if running in interactive mode (has TTY)
is_interactive() {
  [ -t 0 ] && [ -t 1 ]
}

# Prompt user for choice (yes/no/skip/merge)
# Returns: replace|backup|merge|skip
prompt_file_action() {
  local target="$1"
  local source="$2"

  if [ "$FILE_MODE" = "backup" ]; then
    echo "backup"
    return
  elif [ "$FILE_MODE" = "merge" ]; then
    echo "merge"
    return
  elif [ "$FILE_MODE" = "skip" ]; then
    echo "skip"
    return
  fi

  # Non-interactive fallback
  if ! is_interactive; then
    echo "backup"
    return
  fi

  echo ""
  echo "⚠️  File already exists: $target"
  echo "   Source: $source"
  echo ""
  echo "   [r] Replace (backup existing to .bak)"
  echo "   [m] Merge/Append (add new content to existing)"
  echo "   [s] Skip (keep existing)"
  echo "   [d] Diff (show differences)"
  echo ""

  while true; do
    read -rp "   Choice [r/m/s/d]: " choice
    case "$choice" in
      [Rr]) echo "backup"; return ;;
      [Mm]) echo "merge"; return ;;
      [Ss]) echo "skip"; return ;;
      [Dd])
        if command -v diff >/dev/null 2>&1; then
          echo ""
          diff -u "$target" "$source" 2>/dev/null || diff "$target" "$source" || echo "   (Files are too different for unified diff)"
          echo ""
        else
          echo "   diff command not available"
        fi
        ;;
      *) echo "   Invalid choice. Please enter r, m, s, or d." ;;
    esac
  done
}

# Backup a file with timestamp
backup_file() {
  local file="$1"
  local backup="${file}.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$file" "$backup"
  echo "   💾 Backed up to: $backup"
}

# Install a file with smart handling
# Usage: install_file <source> <target> [options]
# Options: --merge-comment="# Bootstrap additions" --merge-position=end|start
install_file() {
  local source="$1"
  local target="$2"
  local merge_comment="${3:-# Added by dev-bootstrap}"
  local merge_position="${4:-end}"

  # If target doesn't exist, just copy
  if [ ! -e "$target" ]; then
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
    echo "✅ Created: $target"
    return 0
  fi

  # File exists - determine action
  local action
  action=$(prompt_file_action "$target" "$source")

  case "$action" in
    backup)
      backup_file "$target"
      cp "$source" "$target"
      echo "✅ Replaced (with backup): $target"
      ;;
    replace)
      backup_file "$target"
      cp "$source" "$target"
      echo "✅ Replaced (with backup): $target"
      ;;
    merge)
      merge_files "$source" "$target" "$merge_comment" "$merge_position"
      ;;
    skip)
      echo "⏭️  Skipped: $target (kept existing)"
      return 0
      ;;
  esac
}

# Merge source content into target file
# Usage: merge_files <source> <target> <comment> <position>
merge_files() {
  local source="$1"
  local target="$2"
  local comment="$3"
  local position="$4"

  # Create backup first
  backup_file "$target"

  # Check if our content marker already exists (avoid duplicates)
  if grep -q "$comment" "$target" 2>/dev/null; then
    echo "⏭️  Skipped merge: $target already has bootstrap content"
    return 0
  fi

  if [ "$position" = "start" ]; then
    # Prepend content
    {
      echo "$comment"
      echo "# Merged on $(date)"
      cat "$source"
      echo ""
      cat "$target"
    } > "${target}.tmp"
  else
    # Append content (default)
    {
      cat "$target"
      echo ""
      echo "$comment"
      echo "# Merged on $(date)"
      cat "$source"
    } > "${target}.tmp"
  fi

  mv "${target}.tmp" "$target"
  echo "✅ Merged into: $target (backup created)"
}

# Interactive confirmation for destructive operations
confirm() {
  local message="$1"

  if [ "$FILE_MODE" = "force" ]; then
    return 0
  fi

  if ! is_interactive; then
    return 1
  fi

  read -rp "$message [y/N]: " response
  [[ "$response" =~ ^[Yy]$ ]]
}

# Set file handling mode
set_file_mode() {
  local mode="$1"
  case "$mode" in
    interactive|backup|merge|skip|force)
      FILE_MODE="$mode"
      ;;
    *)
      echo "Unknown file mode: $mode. Using: interactive, backup, merge, skip, force"
      return 1
      ;;
  esac
}
