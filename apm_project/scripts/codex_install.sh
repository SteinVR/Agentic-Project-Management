#!/usr/bin/env bash
# Install APM Codex skills into ~/.codex/skills or a local .codex/skills directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/apm_source/skills"

usage() {
  cat << 'EOF'
APM Codex skills installer

Usage:
  ./codex_install.sh              # global install to ~/.codex/skills
  ./codex_install.sh --global     # same as above
  ./codex_install.sh --local      # install to .codex/skills in current directory
  ./codex_install.sh --local /path/to/project

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

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "[ERROR] Codex skills not found: $SKILLS_DIR" >&2
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
  CODEX_DIR="$TARGET_PATH/.codex"
else
  CODEX_DIR="$HOME/.codex"
fi

mkdir -p "$CODEX_DIR/skills"
cp -R "$SKILLS_DIR/." "$CODEX_DIR/skills/"

echo "APM Codex skills installed to $CODEX_DIR/skills"
