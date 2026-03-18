#!/usr/bin/env bash
# Install APM Codex assets into ~/.codex or a local .codex directory.
# Assets include:
# - skills
# - subagent role configs (agents/*.toml)
# - non-destructive merge of APM blocks into config.toml

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/apm_source/skills"
CODEX_AGENTS_DIR="$REPO_ROOT/apm_source/packs/codex_pack"
if [[ ! -d "$CODEX_AGENTS_DIR" && -d "$REPO_ROOT/apm_source/codex_agents" ]]; then
  echo "[WARN] Using legacy Codex path: apm_source/codex_agents" >&2
  CODEX_AGENTS_DIR="$REPO_ROOT/apm_source/codex_agents"
fi
PACK_SKILLS_DIR="$CODEX_AGENTS_DIR/skills"
SOURCE_AGENTS_DIR="$CODEX_AGENTS_DIR/agents"

usage() {
  cat << 'EOF'
APM Codex assets installer

Usage:
  ./codex_install.sh              # global install to ~/.codex
  ./codex_install.sh --global     # same as above
  ./codex_install.sh --local      # install to .codex in current directory
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
if [[ ! -d "$SOURCE_AGENTS_DIR" ]]; then
  echo "[ERROR] Codex agents not found: $SOURCE_AGENTS_DIR" >&2
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

has_section() {
  local file_path="$1"
  local section_name="$2"
  awk -v section="[$section_name]" '
    BEGIN { found=0 }
    {
      line=$0
      sub(/^[[:space:]]+/, "", line)
      sub(/[[:space:]]+$/, "", line)
      if (line == section) {
        found=1
      }
    }
    END { exit(found ? 0 : 1) }
  ' "$file_path"
}

section_has_key() {
  local file_path="$1"
  local section_name="$2"
  local key_name="$3"
  awk -v section="[$section_name]" -v key="$key_name" '
    BEGIN { in_section=0; found=0 }
    {
      line=$0
      sub(/^[[:space:]]+/, "", line)
      sub(/[[:space:]]+$/, "", line)
      if (line == section) {
        in_section=1
        next
      }
      if (in_section && line ~ /^\[[^]]+\]$/) {
        in_section=0
      }
      if (in_section && line ~ ("^" key "[[:space:]]*=")) {
        found=1
      }
    }
    END { exit(found ? 0 : 1) }
  ' "$file_path"
}

insert_key_after_section_header() {
  local file_path="$1"
  local section_name="$2"
  local key_line="$3"
  local tmp_file
  tmp_file="$(mktemp)"
  awk -v section="[$section_name]" -v key_line="$key_line" '
    BEGIN { inserted=0 }
    {
      print $0
      if (!inserted) {
        line=$0
        sub(/^[[:space:]]+/, "", line)
        sub(/[[:space:]]+$/, "", line)
        if (line == section) {
          print key_line
          inserted=1
        }
      }
    }
  ' "$file_path" > "$tmp_file"
  mv "$tmp_file" "$file_path"
}

ensure_key_in_section() {
  local file_path="$1"
  local section_name="$2"
  local key_name="$3"
  local key_line="$4"

  if ! has_section "$file_path" "$section_name"; then
    if [[ -s "$file_path" ]]; then
      printf '\n' >> "$file_path"
    fi
    printf '[%s]\n%s\n' "$section_name" "$key_line" >> "$file_path"
    return
  fi

  if section_has_key "$file_path" "$section_name" "$key_name"; then
    return
  fi

  insert_key_after_section_header "$file_path" "$section_name" "$key_line"
}

merge_apm_config() {
  local target_config="$1"

  touch "$target_config"

  ensure_key_in_section "$target_config" "features" "multi_agent" "multi_agent = true"
  ensure_key_in_section "$target_config" "agents" "max_threads" "max_threads = 6"
  ensure_key_in_section "$target_config" "agents" "max_depth" "max_depth = 2"
}

mkdir -p "$CODEX_DIR/skills" "$CODEX_DIR/agents"
cp -R "$SKILLS_DIR/." "$CODEX_DIR/skills/"
if [[ -d "$PACK_SKILLS_DIR" ]]; then
  cp -R "$PACK_SKILLS_DIR/." "$CODEX_DIR/skills/"
fi
cp -R "$SOURCE_AGENTS_DIR/." "$CODEX_DIR/agents/"

merge_apm_config "$CODEX_DIR/config.toml"

echo "APM Codex assets installed to $CODEX_DIR"
echo "  - skills: $CODEX_DIR/skills"
echo "  - agents: $CODEX_DIR/agents"
echo "  - config: $CODEX_DIR/config.toml"
