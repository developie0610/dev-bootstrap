#!/usr/bin/env bash
set -euo pipefail

source ./modules/utils.sh

echo "== Cursor =="

run "brew install --cask cursor || true"