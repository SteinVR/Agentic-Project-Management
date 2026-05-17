#!/usr/bin/env bash
#
# APM Validation Runner
# Runs syntax checks, the current E2E suite, interactive smoke tests,
# and installer matrix checks against the refactored repository layout.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

APM_SCRIPT="$REPO_ROOT/apm_project/apm.sh"
E2E_SCRIPT="$REPO_ROOT/apm_project/tests/e2e_tests.sh"
CODEX_INSTALL="$REPO_ROOT/apm_project/scripts/codex_install.sh"
OPENCODE_INSTALL="$REPO_ROOT/apm_project/scripts/opencode_install.sh"
CURSOR_INSTALL="$REPO_ROOT/apm_project/scripts/cursor_install.sh"
CLAUDE_INSTALL="$REPO_ROOT/apm_project/scripts/claude_install.sh"

VERBOSE=false
KEEP_TEMP=false
WITH_TTY=false
TMP_DIRS=()

usage() {
    cat <<'EOF'
APM validation runner

Usage:
  ./validate_all.sh [options]

Options:
  -v, --verbose     Verbose E2E output
  --keep-temp       Keep temporary test directories
  --with-tty        Add pseudo-TTY interactive check (requires `script`)
  -h, --help        Show this help
EOF
}

log_section() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

log_pass() {
    echo "[PASS] $1"
}

register_tmp_dir() {
    local dir="$1"
    TMP_DIRS+=("$dir")
}

cleanup() {
    if [[ "$KEEP_TEMP" == "true" ]]; then
        if [[ "${#TMP_DIRS[@]}" -gt 0 ]]; then
            echo ""
            echo "Temporary directories preserved:"
            local dir
            for dir in "${TMP_DIRS[@]}"; do
                echo "  - $dir"
            done
        fi
        return
    fi

    local dir
    for dir in "${TMP_DIRS[@]}"; do
        if [[ -d "$dir" ]]; then
            rm -rf "$dir"
        fi
    done
}

assert_path_exists() {
    local path="$1"
    local label="$2"
    if [[ ! -e "$path" ]]; then
        echo "[FAIL] Missing $label: $path" >&2
        exit 1
    fi
}

assert_path_not_exists() {
    local path="$1"
    local label="$2"
    if [[ -e "$path" ]]; then
        echo "[FAIL] Unexpected $label: $path" >&2
        exit 1
    fi
}

assert_file_contains() {
    local file_path="$1"
    local pattern="$2"
    local label="$3"
    if [[ ! -f "$file_path" ]]; then
        echo "[FAIL] Missing file for content check ($label): $file_path" >&2
        exit 1
    fi
    if ! grep -q "$pattern" "$file_path"; then
        echo "[FAIL] Pattern not found ($label): $pattern in $file_path" >&2
        exit 1
    fi
}

run_syntax_checks() {
    log_section "1) Syntax checks"
    bash -n "$APM_SCRIPT"
    bash -n "$CODEX_INSTALL"
    bash -n "$OPENCODE_INSTALL"
    bash -n "$CURSOR_INSTALL"
    bash -n "$CLAUDE_INSTALL"
    bash -n "$E2E_SCRIPT"
    log_pass "bash -n checks"
}

run_e2e_suite() {
    log_section "2) E2E suite"
    if [[ "$VERBOSE" == "true" ]]; then
        bash "$E2E_SCRIPT" --verbose
    else
        bash "$E2E_SCRIPT"
    fi
    log_pass "e2e_tests.sh"
}

run_interactive_stdin_cases() {
    log_section "3) Interactive (stdin) scenarios"

    local tmp_parent
    local tmp_home
    tmp_parent="$(mktemp -d -t apm_validate_int_XXXXXX)"
    tmp_home="$(mktemp -d -t apm_validate_home_XXXXXX)"
    register_tmp_dir "$tmp_parent"
    register_tmp_dir "$tmp_home"

    local out_file
    local err_file

    out_file="$tmp_parent/int_opencode.out"
    err_file="$tmp_parent/int_opencode.err"
    printf "%b" "${tmp_parent}\nint-opencode\n1\ny\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-opencode/memory_bank/TASKS.md" "interactive OpenCode TASKS.md"
    assert_path_exists "$tmp_parent/int-opencode/.opencode/agents/apm-worker.md" "interactive OpenCode worker agent"
    assert_path_exists "$tmp_parent/int-opencode/.opencode/skills/apm-start/SKILL.md" "interactive OpenCode skill"
    assert_path_not_exists "$tmp_parent/int-opencode/.opencode/commands" "interactive OpenCode commands"
    log_pass "interactive OpenCode local"

    out_file="$tmp_parent/int_multi.out"
    err_file="$tmp_parent/int_multi.err"
    printf "%b" "${tmp_parent}\nint-multi\n1,3\ny\nlocal\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-multi/.opencode/agents/apm-worker.md" "interactive multi OpenCode worker"
    assert_path_exists "$tmp_parent/int-multi/.claude/agents/apm-worker.md" "interactive multi Claude worker"
    assert_path_exists "$tmp_parent/int-multi/memory_bank/ARCHITECTURE.md" "interactive multi memory bank"
    log_pass "interactive multi-env local"

    mkdir -p "$tmp_parent/int-overwrite"
    printf "stale\n" > "$tmp_parent/int-overwrite/marker.txt"
    out_file="$tmp_parent/int_overwrite.out"
    err_file="$tmp_parent/int_overwrite.err"
    printf "%b" "${tmp_parent}\nint-overwrite\n1\ny\ny\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-overwrite/memory_bank/TASKS.md" "interactive overwrite memory bank"
    assert_path_not_exists "$tmp_parent/int-overwrite/marker.txt" "interactive overwrite removed stale marker"
    log_pass "interactive overwrite flow"
}

run_tty_case() {
    if [[ "$WITH_TTY" != "true" ]]; then
        return
    fi

    if ! command -v script >/dev/null 2>&1; then
        echo "[WARN] Skipping TTY check because \`script\` is unavailable"
        return
    fi

    log_section "4) Pseudo-TTY smoke check"
    local tmp_parent
    local tmp_home
    tmp_parent="$(mktemp -d -t apm_validate_tty_XXXXXX)"
    tmp_home="$(mktemp -d -t apm_validate_tty_home_XXXXXX)"
    register_tmp_dir "$tmp_parent"
    register_tmp_dir "$tmp_home"

    local cmd
    cmd="cd '$REPO_ROOT' && HOME='$tmp_home' TERM=xterm bash '$APM_SCRIPT' --local"
    feed_tty_inputs() {
        sleep 0.2
        printf "%s\n" "$tmp_parent"
        sleep 0.1
        printf "tty-opencode\n"
        sleep 0.1
        printf "1\n"
        sleep 0.1
        printf "y\n"
    }
    if script -q -c "true" /dev/null >/dev/null 2>&1; then
        feed_tty_inputs | script -q -c "$cmd" /dev/null >/dev/null
    else
        feed_tty_inputs | script -q /dev/null /bin/bash -c "$cmd" >/dev/null
    fi
    assert_path_exists "$tmp_parent/tty-opencode/.opencode/agents/apm-worker.md" "TTY OpenCode worker"
    assert_path_exists "$tmp_parent/tty-opencode/memory_bank/ARCHITECTURE.md" "TTY memory_bank"
    log_pass "TTY interactive OpenCode local"
}

run_installer_matrix() {
    log_section "5) Installer matrix"

    local tmp_home
    local installer_projects
    tmp_home="$(mktemp -d -t apm_validate_inst_home_XXXXXX)"
    installer_projects="$(mktemp -d -t apm_validate_inst_projects_XXXXXX)"
    register_tmp_dir "$tmp_home"
    register_tmp_dir "$installer_projects"

    mkdir -p "$installer_projects/p1" "$installer_projects/p2" "$installer_projects/p3" "$installer_projects/p4"

    HOME="$tmp_home" bash "$CODEX_INSTALL" --local "$installer_projects/p1"
    assert_path_exists "$installer_projects/p1/.codex/skills/apm-start/SKILL.md" "codex_install local skill"
    assert_path_exists "$installer_projects/p1/.codex/agents/apm-worker.toml" "codex_install local worker"
    assert_path_exists "$installer_projects/p1/.codex/config.toml" "codex_install local config"
    log_pass "codex_install local"

    HOME="$tmp_home" bash "$CODEX_INSTALL" --global
    assert_path_exists "$tmp_home/.codex/skills/apm-start/SKILL.md" "codex_install global skill"
    assert_path_exists "$tmp_home/.codex/agents/apm-reviewer.toml" "codex_install global reviewer"
    log_pass "codex_install global"

    HOME="$tmp_home" bash "$OPENCODE_INSTALL" --local "$installer_projects/p2"
    assert_path_exists "$installer_projects/p2/.opencode/agents/apm-worker.md" "opencode_install local worker"
    assert_path_exists "$installer_projects/p2/.opencode/skills/apm-start/SKILL.md" "opencode_install local skill"
    assert_path_not_exists "$installer_projects/p2/.opencode/commands" "opencode_install local commands"
    assert_path_not_exists "$installer_projects/p2/.opencode/tools" "opencode_install local tools"
    log_pass "opencode_install local"

    mkdir -p "$installer_projects/p2/.opencode/commands" "$installer_projects/p2/.opencode/tools"
    printf "legacy\n" > "$installer_projects/p2/.opencode/commands/legacy.txt"
    printf "legacy\n" > "$installer_projects/p2/.opencode/tools/legacy.txt"
    HOME="$tmp_home" bash "$OPENCODE_INSTALL" --local "$installer_projects/p2"
    assert_path_not_exists "$installer_projects/p2/.opencode/commands" "opencode_install local stale commands removed"
    assert_path_not_exists "$installer_projects/p2/.opencode/tools" "opencode_install local stale tools removed"
    log_pass "opencode_install local upgrade cleanup"

    HOME="$tmp_home" bash "$OPENCODE_INSTALL" --global
    assert_path_exists "$tmp_home/.config/opencode/agents/apm-reviewer.md" "opencode_install global reviewer"
    assert_path_exists "$tmp_home/.config/opencode/skills/apm-start/SKILL.md" "opencode_install global skill"
    assert_path_not_exists "$tmp_home/.config/opencode/commands" "opencode_install global commands"
    assert_path_not_exists "$tmp_home/.config/opencode/tools" "opencode_install global tools"
    log_pass "opencode_install global"

    mkdir -p "$tmp_home/.config/opencode/commands" "$tmp_home/.config/opencode/tools"
    printf "legacy\n" > "$tmp_home/.config/opencode/commands/legacy.txt"
    printf "legacy\n" > "$tmp_home/.config/opencode/tools/legacy.txt"
    HOME="$tmp_home" bash "$OPENCODE_INSTALL" --global
    assert_path_not_exists "$tmp_home/.config/opencode/commands" "opencode_install global stale commands removed"
    assert_path_not_exists "$tmp_home/.config/opencode/tools" "opencode_install global stale tools removed"
    log_pass "opencode_install global upgrade cleanup"

    HOME="$tmp_home" bash "$CURSOR_INSTALL" --local "$installer_projects/p3" --skip-skills
    assert_path_exists "$installer_projects/p3/.cursor/agents/apm-engineer.md" "cursor_install local engineer"
    assert_path_exists "$installer_projects/p3/.cursor/commands/apm-start.md" "cursor_install local command"
    log_pass "cursor_install local --skip-skills"

    HOME="$tmp_home" bash "$CURSOR_INSTALL" --global
    assert_path_exists "$tmp_home/.cursor/agents/apm-engineer.md" "cursor_install global engineer"
    assert_path_exists "$tmp_home/.cursor/commands/apm-sync.md" "cursor_install global command"
    assert_path_exists "$tmp_home/.cursor/skills/apm-start/SKILL.md" "cursor_install global shared skill"
    log_pass "cursor_install global"

    HOME="$tmp_home" bash "$CLAUDE_INSTALL" --local "$installer_projects/p4"
    assert_path_exists "$installer_projects/p4/.claude/agents/apm-worker.md" "claude_install local worker"
    assert_path_exists "$installer_projects/p4/.claude/agents/apm-co-founder.md" "claude_install local co-founder"
    assert_path_exists "$installer_projects/p4/.claude/skills/apm-start/SKILL.md" "claude_install local skill"
    log_pass "claude_install local"

    HOME="$tmp_home" bash "$CLAUDE_INSTALL" --global
    assert_path_exists "$tmp_home/.claude/agents/apm-reviewer.md" "claude_install global reviewer"
    assert_path_exists "$tmp_home/.claude/skills/apm-start/SKILL.md" "claude_install global skill"
    log_pass "claude_install global"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            --keep-temp)
                KEEP_TEMP=true
                shift
                ;;
            --with-tty)
                WITH_TTY=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1" >&2
                usage
                exit 1
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    trap cleanup EXIT

    run_syntax_checks
    run_e2e_suite
    run_interactive_stdin_cases
    run_tty_case
    run_installer_matrix

    log_section "Validation complete"
    log_pass "all checks passed"
}

main "$@"
