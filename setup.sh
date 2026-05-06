#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$script_dir"

source ./modules/utils.sh

MODULES=(core terminal vscode cursor claude)
STATE_DIR="./state"
STATE_FILE="$STATE_DIR/installed.log"

print_help() {
  cat <<'HELP'
Usage: ./setup.sh [OPTIONS]

Options:
  -h, --help          Show this help text
  -m, --mode MODE     Run mode: all | select | step
  -t, --task NAME     Run a single module by name
  -r, --reset         Remove module state and rerun everything
  -s, --status        Show completed modules
HELP
}

show_status() {
  echo "== Installed modules =="
  if [ ! -s "$STATE_FILE" ]; then
    echo "No modules have been marked complete yet."
    return
  fi
  cat "$STATE_FILE"
}

reset_state() {
  rm -f "$STATE_FILE"
  mkdir -p "$STATE_DIR"
  touch "$STATE_FILE"
  echo "✅ Reset completed module state"
}

contains_module() {
  local needle=$1
  for m in "${MODULES[@]}"; do
    if [ "$m" = "$needle" ]; then
      return 0
    fi
  done
  return 1
}

prompt_mode() {
  PS3="Select mode: "
  select choice in ALL SELECT STEP QUIT; do
    case $choice in
      ALL|SELECT|STEP) echo "${choice,,}"; return 0 ;;
      QUIT) echo "quit"; return 0 ;;
      *) echo "Invalid selection." ;;
    esac
  done
}

run_module() {
  local module=$1

  if ! contains_module "$module"; then
    echo "❌ Unknown module: $module"
    return 1
  fi

  if is_done "$module"; then
    echo "⏭ Skipping $module (already installed)"
    return 0
  fi

  echo "▶ Installing module: $module"
  if bash "./modules/${module}.sh"; then
    mark_done "$module"
    return 0
  fi

  echo "⚠️ Module failed: $module"
  return 1
}

main() {
  mkdir -p "$STATE_DIR"
  touch "$STATE_FILE"

  local mode=""
  local requested_module=""

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -h|--help)
        print_help
        exit 0
        ;;
      -m|--mode)
        shift
        mode="${1:-}"
        ;;
      -t|--task|--module)
        shift
        requested_module="${1:-}"
        ;;
      -r|--reset)
        reset_state
        ;;
      -s|--status)
        show_status
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        print_help
        exit 1
        ;;
    esac
    shift
  done

  if [ -n "$requested_module" ]; then
    run_module "$requested_module"
    exit $?
  fi

  if [ -z "$mode" ]; then
    mode="$(prompt_mode)"
    if [ "$mode" = "QUIT" ]; then
      echo "Aborted."
      exit 0
    fi
  fi

  case "$mode" in
    all)
      for m in "${MODULES[@]}"; do
        run_module "$m" || true
      done
      ;;
    select)
      echo "Choose a module:"
      PS3="Module: "
      select m in "${MODULES[@]}" "QUIT"; do
        if [ "$m" = "QUIT" ]; then
          echo "Aborted."
          break
        fi
        if [ -n "$m" ]; then
          run_module "$m"
        else
          echo "Invalid selection."
        fi
      done
      ;;
    step)
      for m in "${MODULES[@]}"; do
        read -rp "Install $m? (y/n): " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
          run_module "$m" || true
        fi
      done
      ;;
    *)
      echo "Unknown mode: $mode"
      print_help
      exit 1
      ;;
  esac

  echo
  echo "✅ Setup complete"
  echo "👉 Next step: source ~/.zshrc or run 'p10k configure' if you want to finish shell prompt setup"
}

main "$@"
