#!/usr/bin/env bash
# setup.sh — Ensure mmdc (Mermaid CLI) is available.
#
# Checks for a global mmdc install first. If not found, installs
# @mermaid-js/mermaid-cli locally inside the skill's tools/ directory.
#
# Usage: setup.sh
# Output: prints the resolved mmdc command to stdout (last line)
# Exit: 0 on success, 1 on failure

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_BIN="$SCRIPT_DIR/node_modules/.bin/mmdc"

# 1. Already installed locally (from a previous run)
if [ -x "$LOCAL_BIN" ]; then
  echo "mmdc already installed at $LOCAL_BIN" >&2
  echo "$LOCAL_BIN"
  exit 0
fi

# 2. Available globally on PATH
if command -v mmdc &>/dev/null; then
  GLOBAL=$(command -v mmdc)
  echo "Found global mmdc at $GLOBAL" >&2
  echo "$GLOBAL"
  exit 0
fi

# 3. Install locally via npm
echo "mmdc not found. Installing @mermaid-js/mermaid-cli locally..." >&2

if ! command -v npm &>/dev/null; then
  echo "Error: npm is not installed. Install Node.js from https://nodejs.org" >&2
  exit 1
fi

npm install --prefix "$SCRIPT_DIR" --save-dev @mermaid-js/mermaid-cli >&2

if [ ! -x "$LOCAL_BIN" ]; then
  echo "Error: mmdc not found after install at $LOCAL_BIN" >&2
  exit 1
fi

echo "Installed mmdc at $LOCAL_BIN" >&2
echo "$LOCAL_BIN"
