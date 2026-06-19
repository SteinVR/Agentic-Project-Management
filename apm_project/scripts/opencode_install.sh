#!/usr/bin/env bash
# Install APM OpenCode assets into ~/.config/opencode or a local .opencode directory.
# Current OpenCode support ships agents plus shared skills.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PACK_DIR="$REPO_ROOT/apm_source/packs/opencode_pack"
if [[ ! -d "$PACK_DIR" && -d "$REPO_ROOT/apm_source/opencode_pack" ]]; then
  echo "[WARN] Using legacy OpenCode path: apm_source/opencode_pack" >&2
  PACK_DIR="$REPO_ROOT/apm_source/opencode_pack"
fi
SKILLS_DIR="$REPO_ROOT/apm_source/skills"

usage() {
  cat << 'EOF'
APM OpenCode pack installer

Usage:
  ./opencode_install.sh              # global install to ~/.config/opencode
  ./opencode_install.sh --global     # same as above
  ./opencode_install.sh --local      # install to .opencode in current directory
  ./opencode_install.sh --local /path/to/project

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
  OPENCODE_DIR="$TARGET_PATH/.opencode"
else
  OPENCODE_DIR="$HOME/.config/opencode"
fi

rm -rf "$OPENCODE_DIR/commands" "$OPENCODE_DIR/tools"
mkdir -p "$OPENCODE_DIR/agents" "$OPENCODE_DIR/skills"

cp -R "$PACK_DIR/agent/." "$OPENCODE_DIR/agents/"
cp -R "$SKILLS_DIR/." "$OPENCODE_DIR/skills/"

echo "APM OpenCode assets installed to $OPENCODE_DIR"
