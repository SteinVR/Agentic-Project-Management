#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <worktree_id>" >&2
  exit 1
fi

WT_ID="$1"
WT_DIR=".apm/worktrees/${WT_ID}"

if [[ ! -d "$WT_DIR" ]]; then
  echo "Worktree not found: $WT_DIR" >&2
  exit 1
fi

MAIN_TREE="$(git -C "$WT_DIR" rev-parse --path-format=absolute --git-common-dir | xargs -I{} dirname {})"

[[ -d "$MAIN_TREE/.venv" ]] && ln -sfn "$MAIN_TREE/.venv" "$WT_DIR/.venv"
[[ -d "$MAIN_TREE/node_modules" ]] && ln -sfn "$MAIN_TREE/node_modules" "$WT_DIR/node_modules"
[[ -d "$MAIN_TREE/data" ]] && ln -sfn "$MAIN_TREE/data" "$WT_DIR/data"

echo "Symlinks configured for $WT_DIR"
