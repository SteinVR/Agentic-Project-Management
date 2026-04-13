#!/usr/bin/env bash
#
# git-branch-sync.sh
#
# Selective file sync between branches.
# Transfers all tracked files from <source> into the current branch,
# skipping paths listed in .gitbranchignore.
#
# Usage:
#   ./git-branch-sync.sh <source-branch> [--apply]
#
# Default mode is dry-run (preview only).

set -euo pipefail

IGNOREFILE=".gitbranchignore"

# ── Args ──────────────────────────────────────────────────────────
SOURCE=""
DRY_RUN=true

for arg in "$@"; do
    case "$arg" in
        --apply) DRY_RUN=false ;;
        --help|-h)
            cat <<'HELP'
Usage: git-branch-sync.sh <source-branch> [--apply]

Sync tracked files from <source-branch> into the current branch,
excluding every path (file or directory tree) listed in .gitbranchignore.

  --apply   Execute for real (default is dry-run preview).
  --help    Show this message.

.gitbranchignore format:
  One path per line. Lines starting with # and blank lines are ignored.
  A bare name matches both the file and the entire subtree:
    docs        -> skips docs and docs/**
    AGENTS.md   -> skips AGENTS.md exactly
HELP
            exit 0
            ;;
        -*) echo "Unknown flag: $arg"; exit 1 ;;
        *)  SOURCE="$arg" ;;
    esac
done

if [[ -z "$SOURCE" ]]; then
    echo "Error: source branch required."
    echo "Run with --help for usage."
    exit 1
fi

TARGET=$(git branch --show-current)
if [[ -z "$TARGET" ]]; then
    echo "Error: detached HEAD. Checkout a branch first."
    exit 1
fi

if [[ "$SOURCE" == "$TARGET" ]]; then
    echo "Error: source and target are the same branch ($SOURCE)."
    exit 1
fi

if ! git rev-parse --verify "$SOURCE" &>/dev/null; then
    echo "Error: branch '$SOURCE' does not exist."
    exit 1
fi

# ── Clean working tree guard (tracked files only) ────────────────
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "Error: tracked files have uncommitted changes. Commit or stash first."
    exit 1
fi

# ── Read .gitbranchignore ─────────────────────────────────────────
if [[ ! -f "$IGNOREFILE" ]]; then
    echo "Error: $IGNOREFILE not found in repo root."
    exit 1
fi

mapfile -t IGNORES < <(sed '/^\s*$/d; /^\s*#/d' "$IGNOREFILE")

# .gitbranchignore itself is always branch-local
IGNORES+=("$IGNOREFILE")

is_ignored() {
    local path="$1"
    for pattern in "${IGNORES[@]}"; do
        if [[ "$path" == "$pattern" || "$path" == "$pattern"/* ]]; then
            return 0
        fi
    done
    return 1
}

echo "Source : $SOURCE"
echo "Target : $TARGET (current)"
echo "Ignored: ${IGNORES[*]}"
echo ""

# ── Collect sync candidates from source ──────────────────────────
SYNC_FILES=()
while IFS= read -r file; do
    is_ignored "$file" || SYNC_FILES+=("$file")
done < <(git ls-tree -r --name-only "$SOURCE")

# ── Detect deletions (on target but missing on source, not ignored) ─
DELETE_FILES=()
while IFS= read -r file; do
    if ! is_ignored "$file"; then
        if ! git cat-file -e "${SOURCE}:${file}" 2>/dev/null; then
            DELETE_FILES+=("$file")
        fi
    fi
done < <(git ls-tree -r --name-only HEAD)

# ── Preview / Apply ──────────────────────────────────────────────
echo "Files to sync  : ${#SYNC_FILES[@]}"
echo "Files to delete: ${#DELETE_FILES[@]}"

if $DRY_RUN; then
    echo ""
    echo "── Dry run (pass --apply to execute) ──"

    if [[ ${#SYNC_FILES[@]} -gt 0 ]]; then
        echo ""
        echo "Sync:"
        printf '  %s\n' "${SYNC_FILES[@]}"
    fi
    if [[ ${#DELETE_FILES[@]} -gt 0 ]]; then
        echo ""
        echo "Delete:"
        printf '  %s\n' "${DELETE_FILES[@]}"
    fi
    exit 0
fi

# ── Apply sync ────────────────────────────────────────────────────
if [[ ${#SYNC_FILES[@]} -gt 0 ]]; then
    printf '%s\n' "${SYNC_FILES[@]}" | xargs -d '\n' git checkout "$SOURCE" --
fi

for file in "${DELETE_FILES[@]}"; do
    git rm --quiet "$file" 2>/dev/null || true
done

echo ""
echo "Changes staged. Review with:"
echo "  git diff --cached --stat"
echo "Then commit when ready."
