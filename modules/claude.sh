#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== Claude CLI =="

run "brew install node || true"
run "npm install -g @anthropic-ai/claude-cli || true"

echo "👉 याद: export ANTHROPIC_API_KEY=your_key"