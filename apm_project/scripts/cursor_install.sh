#!/usr/bin/env bash
# Install APM Cursor assets into ~/.cursor or a local .cursor directory.
# Skills are installed globally by default to ~/.cursor/skills.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PACK_DIR="$REPO_ROOT/apm_source/packs/cursor_pack"
SKILLS_DIR="$REPO_ROOT/apm_source/skills"

usage() {
  cat << 'EOF'
APM Cursor assets installer

Usage:
  ./cursor_install.sh                     # global install to ~/.cursor (+ skills)
  ./cursor_install.sh --global            # same as above
  ./cursor_install.sh --local             # install pack to .cursor in current directory (+ global skills)
  ./cursor_install.sh --local /path/to/project
  ./cursor_install.sh --skip-skills       # skip global skills install

EOF
}

TARGET_MODE="global"
TARGET_PATH=""
SKIP_SKILLS="false"

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
    --skip-skills)
      SKIP_SKILLS="true"
      shift
      ;;
    *)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$PACK_DIR" ]]; then
  echo "[ERROR] Cursor pack not found: $PACK_DIR" >&2
  exit 1
fi
if [[ "$SKIP_SKILLS" != "true" && ! -d "$SKILLS_DIR" ]]; then
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
  CURSOR_DIR="$TARGET_PATH/.cursor"
else
  CURSOR_DIR="$HOME/.cursor"
fi

mkdir -p "$CURSOR_DIR/agents" "$CURSOR_DIR/commands"

if [[ -d "$PACK_DIR/agents" ]]; then
  cp -R "$PACK_DIR/agents/." "$CURSOR_DIR/agents/"
fi
if [[ -d "$PACK_DIR/commands" ]]; then
  cp -R "$PACK_DIR/commands/." "$CURSOR_DIR/commands/"
fi

if [[ "$SKIP_SKILLS" != "true" ]]; then
  mkdir -p "$HOME/.cursor/skills"
  cp -R "$SKILLS_DIR/." "$HOME/.cursor/skills/"
fi

echo "APM Cursor pack installed to $CURSOR_DIR"
if [[ "$SKIP_SKILLS" != "true" ]]; then
  echo "APM skills installed to $HOME/.cursor/skills"
fi
