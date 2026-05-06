set -euo pipefail

STATE_FILE="./state/installed.log"

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
