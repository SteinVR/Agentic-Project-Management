#!/usr/bin/env bash
# Install APM Claude Code pack into ~/.claude or a local .claude directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PACK_DIR="$REPO_ROOT/apm_source/packs/claude_pack"
SKILLS_DIR="$REPO_ROOT/apm_source/skills"

usage() {
  cat << 'EOF'
APM Claude Code pack installer

Usage:
  ./claude_install.sh              # global install to ~/.claude
  ./claude_install.sh --global     # same as above
  ./claude_install.sh --local      # install to .claude in current directory
  ./claude_install.sh --local /path/to/project

EOF
}

TARGET_MODE="global"
TARGET_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --global)
      TARGET_MODE="global"
      shift
      ;;
    --local)
      TARGET_MODE="local"
      if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then
        TARGET_PATH="$2"
        shift 2
      else
        TARGET_PATH="$(pwd)"
        shift
      fi
      ;;
    *)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$PACK_DIR" ]]; then
  echo "[ERROR] Pack not found: $PACK_DIR" >&2
  exit 1
fi
if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "[ERROR] Skills not found: $SKILLS_DIR" >&2
  exit 1
fi

if [[ "$TARGET_MODE" == "local" ]]; then
  if [[ -z "$TARGET_PATH" ]]; then
    TARGET_PATH="$(pwd)"
  fi
  if [[ ! -d "$TARGET_PATH" ]]; then
    echo "[ERROR] Project path not found: $TARGET_PATH" >&2
    exit 1
  fi
  CLAUDE_DIR="$TARGET_PATH/.claude"
else
  CLAUDE_DIR="$HOME/.claude"
fi

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills"

cp -R "$PACK_DIR/agents/." "$CLAUDE_DIR/agents/"
cp -R "$SKILLS_DIR/." "$CLAUDE_DIR/skills/"

echo "APM Claude Code pack installed to $CLAUDE_DIR"
