#!/usr/bin/env bash
# Install APM OpenCode pack into ~/.config/opencode

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PACK_DIR="$REPO_ROOT/apm_source/cli_ide/apm_opencode_pack"

if [[ ! -d "$PACK_DIR" ]]; then
  echo "[ERROR] Pack not found: $PACK_DIR" >&2
  exit 1
fi

OPENCODE_DIR="$HOME/.config/opencode"
mkdir -p "$OPENCODE_DIR/agents" "$OPENCODE_DIR/commands" "$OPENCODE_DIR/skills" "$OPENCODE_DIR/tools"

cp -R "$PACK_DIR/agent/." "$OPENCODE_DIR/agents/"
cp -R "$PACK_DIR/command/." "$OPENCODE_DIR/commands/"
cp -R "$PACK_DIR/skill/." "$OPENCODE_DIR/skills/"
cp -R "$PACK_DIR/tools/." "$OPENCODE_DIR/tools/"

echo "APM OpenCode pack installed to $OPENCODE_DIR"
