#!/usr/bin/env bash
#
# APM Full Validation Runner
# Runs syntax checks, E2E suite, interactive flows, and installer matrix.

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
APM full validation runner

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
            for dir in "${TMP_DIRS[@]}"; do
                echo "  - $dir"
            done
        fi
        return
    fi

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

    # Cursor + RAPID
    out_file="$tmp_parent/int_cursor_rapid.out"
    err_file="$tmp_parent/int_cursor_rapid.err"
    printf "%b" "${tmp_parent}\nint-cursor-rapid\n1\n2\ny\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-cursor-rapid/memory_bank" "Cursor RAPID memory_bank"
    assert_path_exists "$tmp_parent/int-cursor-rapid/memory_bank/TASKS.md" "Cursor RAPID TASKS.md"
    assert_path_exists "$tmp_parent/int-cursor-rapid/.cursor/agents" "Cursor RAPID agents"
    assert_path_exists "$tmp_parent/int-cursor-rapid/.cursor/commands" "Cursor RAPID commands"
    log_pass "interactive Cursor RAPID"

    # Cursor + FULL
    out_file="$tmp_parent/int_cursor_full.out"
    err_file="$tmp_parent/int_cursor_full.err"
    printf "%b" "${tmp_parent}\nint-cursor-full\n1\n1\ny\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-cursor-full/WORKFLOW.md" "Cursor FULL WORKFLOW"
    assert_path_exists "$tmp_parent/int-cursor-full/.apm" "Cursor FULL .apm"
    assert_path_exists "$tmp_parent/int-cursor-full/.cursor/agents" "Cursor FULL agents"
    log_pass "interactive Cursor FULL"

    # OpenCode + DS + local install
    out_file="$tmp_parent/int_opencode_ds_local.out"
    err_file="$tmp_parent/int_opencode_ds_local.err"
    printf "%b" "${tmp_parent}\nint-opencode-ds\n2\n2\ny\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-opencode-ds/memory_bank" "OpenCode DS memory_bank"
    assert_path_exists "$tmp_parent/int-opencode-ds/memory_bank/TASKS.md" "OpenCode DS TASKS.md"
    assert_path_exists "$tmp_parent/int-opencode-ds/.opencode/agents" "OpenCode DS agents"
    assert_path_exists "$tmp_parent/int-opencode-ds/.opencode/commands" "OpenCode DS commands"
    assert_path_exists "$tmp_parent/int-opencode-ds/.opencode/skills" "OpenCode DS skills"
    assert_path_exists "$tmp_parent/int-opencode-ds/.opencode/tools" "OpenCode DS tools"
    assert_path_not_exists "$tmp_parent/int-opencode-ds/.cursor" "OpenCode DS .cursor"
    log_pass "interactive OpenCode DS local"

    # Codex + RAPID + local install
    out_file="$tmp_parent/int_codex_rapid_local.out"
    err_file="$tmp_parent/int_codex_rapid_local.err"
    printf "%b" "${tmp_parent}\nint-codex-rapid\n3\n1\ny\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-codex-rapid/memory_bank" "Codex RAPID memory_bank"
    assert_path_exists "$tmp_parent/int-codex-rapid/memory_bank/TASKS.md" "Codex RAPID TASKS.md"
    assert_path_exists "$tmp_parent/int-codex-rapid/.codex/skills" "Codex RAPID skills"
    assert_path_exists "$tmp_parent/int-codex-rapid/.codex/agents" "Codex RAPID agents"
    assert_path_exists "$tmp_parent/int-codex-rapid/.codex/agents/apm-code-simplifier.toml" "Codex RAPID simplifier agent file"
    assert_path_exists "$tmp_parent/int-codex-rapid/.codex/agents/apm-code-reviewer.toml" "Codex RAPID reviewer agent file"
    assert_path_exists "$tmp_parent/int-codex-rapid/.codex/agents/apm-memory-bank-sync.toml" "Codex RAPID sync agent file"
    assert_path_exists "$tmp_parent/int-codex-rapid/.codex/config.toml" "Codex RAPID config.toml"
    assert_file_contains "$tmp_parent/int-codex-rapid/.codex/config.toml" "multi_agent" "Codex config multi_agent setting"
    assert_file_contains "$tmp_parent/int-codex-rapid/.codex/config.toml" "max_threads" "Codex config max_threads setting"
    assert_file_contains "$tmp_parent/int-codex-rapid/.codex/config.toml" "max_depth" "Codex config max_depth setting"
    log_pass "interactive Codex RAPID local"

    # Claude Code + RAPID + local install
    out_file="$tmp_parent/int_claude_rapid_local.out"
    err_file="$tmp_parent/int_claude_rapid_local.err"
    printf "%b" "${tmp_parent}\nint-claude-rapid\n4\n1\ny\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-claude-rapid/memory_bank" "Claude RAPID memory_bank"
    assert_path_exists "$tmp_parent/int-claude-rapid/memory_bank/TASKS.md" "Claude RAPID TASKS.md"
    assert_path_exists "$tmp_parent/int-claude-rapid/.claude/agents" "Claude RAPID agents"
    assert_path_exists "$tmp_parent/int-claude-rapid/.claude/agents/apm-engineer.md" "Claude RAPID engineer agent file"
    assert_path_exists "$tmp_parent/int-claude-rapid/.claude/agents/apm-team-lead.md" "Claude RAPID team-lead agent file"
    assert_path_exists "$tmp_parent/int-claude-rapid/.claude/skills" "Claude RAPID skills"
    assert_path_not_exists "$tmp_parent/int-claude-rapid/.cursor" "Claude RAPID .cursor"
    log_pass "interactive Claude Code RAPID local"

    # Multi-env: comma-separated "2,4" (OpenCode + Claude) + RAPID + local
    out_file="$tmp_parent/int_multi_comma.out"
    err_file="$tmp_parent/int_multi_comma.err"
    printf "%b" "${tmp_parent}\nint-multi-comma\n2,4\n1\ny\nlocal\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-multi-comma/memory_bank" "multi-env comma memory_bank"
    assert_path_exists "$tmp_parent/int-multi-comma/.opencode/agents" "multi-env comma OpenCode agents"
    assert_path_exists "$tmp_parent/int-multi-comma/.claude/agents" "multi-env comma Claude agents"
    assert_path_not_exists "$tmp_parent/int-multi-comma/.cursor" "multi-env comma no .cursor"
    log_pass "interactive multi-env comma-separated"

    # Multi-env: space-separated "2 4" (OpenCode + Claude) + RAPID + local
    out_file="$tmp_parent/int_multi_space.out"
    err_file="$tmp_parent/int_multi_space.err"
    printf "%b" "${tmp_parent}\nint-multi-space\n2 4\n1\ny\nlocal\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-multi-space/.opencode/agents" "multi-env space OpenCode agents"
    assert_path_exists "$tmp_parent/int-multi-space/.claude/agents" "multi-env space Claude agents"
    log_pass "interactive multi-env space-separated"

    # Multi-env: comma+space "2, 4" (OpenCode + Claude) + RAPID + local
    out_file="$tmp_parent/int_multi_commaspce.out"
    err_file="$tmp_parent/int_multi_commaspce.err"
    printf "%b" "${tmp_parent}\nint-multi-commaspace\n2, 4\n1\ny\nlocal\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-multi-commaspace/.opencode/agents" "multi-env comma-space OpenCode agents"
    assert_path_exists "$tmp_parent/int-multi-commaspace/.claude/agents" "multi-env comma-space Claude agents"
    log_pass "interactive multi-env comma+space separated"

    # Multi-env with Cursor: "1,4" (Cursor + Claude) — Cursor gets pack auto, Claude prompted
    out_file="$tmp_parent/int_multi_cursor.out"
    err_file="$tmp_parent/int_multi_cursor.err"
    printf "%b" "${tmp_parent}\nint-multi-cursor\n1,4\n2\ny\nlocal\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-multi-cursor/.cursor/agents" "multi-env cursor+claude Cursor agents"
    assert_path_exists "$tmp_parent/int-multi-cursor/.claude/agents" "multi-env cursor+claude Claude agents"
    log_pass "interactive multi-env with Cursor"

    # Invalid input loops then valid values (OpenCode + RAPID + skip)
    out_file="$tmp_parent/int_invalid_loops.out"
    err_file="$tmp_parent/int_invalid_loops.err"
    printf "%b" "${tmp_parent}\nint-invalid-loops\n9\n2\n9\n1\ny\nfoo\nskip\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-invalid-loops/memory_bank" "invalid-loop project"
    assert_path_not_exists "$tmp_parent/int-invalid-loops/.opencode" "invalid-loop skip install"
    assert_file_contains "$err_file" "Invalid choice" "invalid choice prompt"
    log_pass "interactive invalid-input loops"

    # Overwrite decline path
    mkdir -p "$tmp_parent/int-overwrite-decline"
    printf "keep\n" > "$tmp_parent/int-overwrite-decline/marker.txt"
    out_file="$tmp_parent/int_overwrite_decline.out"
    err_file="$tmp_parent/int_overwrite_decline.err"
    printf "%b" "${tmp_parent}\nint-overwrite-decline\nn\n" | HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" >"$out_file" 2>"$err_file"
    assert_path_exists "$tmp_parent/int-overwrite-decline/marker.txt" "marker after overwrite decline"
    assert_file_contains "$out_file" "Aborted" "overwrite decline output"
    log_pass "interactive overwrite-decline"
}

run_optional_tty_case() {
    if [[ "$WITH_TTY" != "true" ]]; then
        return
    fi

    log_section "4) Interactive pseudo-TTY scenario"

    if ! command -v script >/dev/null 2>&1; then
        echo "[WARN] 'script' is not available, skipping --with-tty check"
        return
    fi

    local tmp_parent
    local tmp_home
    tmp_parent="$(mktemp -d -t apm_validate_tty_XXXXXX)"
    tmp_home="$(mktemp -d -t apm_validate_tty_home_XXXXXX)"
    register_tmp_dir "$tmp_parent"
    register_tmp_dir "$tmp_home"

    local cmd
    cmd="HOME='$tmp_home' TERM=xterm bash '$APM_SCRIPT'"
    printf "%b" "${tmp_parent}\ntty-cursor-rapid\n1\n2\ny\n" | script -q -c "$cmd" /dev/null >/dev/null

    assert_path_exists "$tmp_parent/tty-cursor-rapid/.cursor/agents" "TTY Cursor agents"
    assert_path_exists "$tmp_parent/tty-cursor-rapid/memory_bank/ARCHITECTURE.md" "TTY memory_bank"
    log_pass "interactive pseudo-TTY Cursor RAPID"
}

run_non_interactive_matrix_and_installers() {
    log_section "5) Non-interactive matrix + installers"

    local tmp_root
    local tmp_home
    tmp_root="$(mktemp -d -t apm_validate_matrix_XXXXXX)"
    tmp_home="$(mktemp -d -t apm_validate_matrix_home_XXXXXX)"
    register_tmp_dir "$tmp_root"
    register_tmp_dir "$tmp_home"

    local projects_dir
    projects_dir="$tmp_root/projects"
    mkdir -p "$projects_dir"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --codex --rapid --project-name ni-codex-rapid-local --project-path "$projects_dir" --non-interactive --local --skip-cursor
    assert_path_exists "$projects_dir/ni-codex-rapid-local/.codex/skills" "ni codex rapid local skills"
    assert_path_exists "$projects_dir/ni-codex-rapid-local/.codex/config.toml" "ni codex rapid local config"
    log_pass "non-interactive Codex RAPID local"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --codex --ds --project-name ni-codex-ds-skip --project-path "$projects_dir" --non-interactive --none --skip-cursor
    assert_path_exists "$projects_dir/ni-codex-ds-skip/memory_bank" "ni codex ds memory_bank"
    assert_path_exists "$projects_dir/ni-codex-ds-skip/memory_bank/TASKS.md" "ni codex ds TASKS.md"
    assert_file_contains "$projects_dir/ni-codex-ds-skip/AGENTS.md" "Activity log" "ni codex ds activity log section"
    assert_file_contains "$projects_dir/ni-codex-ds-skip/AGENTS.md" "apm-report" "ni codex ds apm-report skill mention"
    assert_file_contains "$projects_dir/ni-codex-ds-skip/logs/AGENTS.md" "logs/agents/" "ni codex ds agent log path"
    assert_path_not_exists "$projects_dir/ni-codex-ds-skip/.codex" "ni codex ds skip install"
    log_pass "non-interactive Codex DS skip"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --opencode --ds --project-name ni-opencode-ds-local --project-path "$projects_dir" --non-interactive --local --skip-cursor
    assert_path_exists "$projects_dir/ni-opencode-ds-local/.opencode/commands" "ni opencode ds local commands"
    assert_path_exists "$projects_dir/ni-opencode-ds-local/memory_bank" "ni opencode ds memory_bank"
    assert_path_exists "$projects_dir/ni-opencode-ds-local/memory_bank/TASKS.md" "ni opencode ds TASKS.md"
    log_pass "non-interactive OpenCode DS local"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --opencode --rapid --project-name ni-opencode-rapid-global --project-path "$projects_dir" --non-interactive --global --skip-cursor
    assert_path_exists "$tmp_home/.config/opencode/agents" "global opencode agents"
    assert_path_exists "$tmp_home/.config/opencode/skills" "global opencode skills"
    log_pass "non-interactive OpenCode RAPID global"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --codex --rapid --project-name ni-codex-rapid-global --project-path "$projects_dir" --non-interactive --global --skip-cursor
    assert_path_exists "$tmp_home/.codex/agents" "global codex agents"
    assert_path_exists "$tmp_home/.codex/config.toml" "global codex config"
    log_pass "non-interactive Codex RAPID global"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --claude --rapid --project-name ni-claude-rapid-local --project-path "$projects_dir" --non-interactive --local --skip-cursor
    assert_path_exists "$projects_dir/ni-claude-rapid-local/.claude/agents" "ni claude rapid local agents"
    assert_path_exists "$projects_dir/ni-claude-rapid-local/.claude/skills" "ni claude rapid local skills"
    assert_path_exists "$projects_dir/ni-claude-rapid-local/.claude/agents/apm-engineer.md" "ni claude rapid engineer agent"
    assert_path_exists "$projects_dir/ni-claude-rapid-local/.claude/agents/apm-team-lead.md" "ni claude rapid team-lead agent"
    log_pass "non-interactive Claude Code RAPID local"

    HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" --claude --rapid --project-name ni-claude-rapid-global --project-path "$projects_dir" --non-interactive --global --skip-cursor
    assert_path_exists "$tmp_home/.claude/agents" "global claude agents"
    assert_path_exists "$tmp_home/.claude/skills" "global claude skills"
    log_pass "non-interactive Claude Code RAPID global"

    local installer_projects
    installer_projects="$tmp_root/installers"
    mkdir -p "$installer_projects/p1" "$installer_projects/p2" "$installer_projects/p3" "$installer_projects/p4"

    HOME="$tmp_home" TERM=xterm bash "$CODEX_INSTALL" --local "$installer_projects/p1"
    assert_path_exists "$installer_projects/p1/.codex/skills" "codex_install local skills"
    assert_path_exists "$installer_projects/p1/.codex/agents" "codex_install local agents"
    assert_path_exists "$installer_projects/p1/.codex/agents/apm-code-simplifier.toml" "codex_install local simplifier agent file"
    assert_path_exists "$installer_projects/p1/.codex/agents/apm-code-reviewer.toml" "codex_install local reviewer agent file"
    assert_path_exists "$installer_projects/p1/.codex/agents/apm-memory-bank-sync.toml" "codex_install local sync agent file"
    assert_path_exists "$installer_projects/p1/.codex/config.toml" "codex_install local config"
    assert_file_contains "$installer_projects/p1/.codex/config.toml" "multi_agent" "codex_install local multi_agent setting"
    assert_file_contains "$installer_projects/p1/.codex/config.toml" "max_threads" "codex_install local max_threads setting"
    assert_file_contains "$installer_projects/p1/.codex/config.toml" "max_depth" "codex_install local max_depth setting"
    assert_file_contains "$installer_projects/p1/.codex/skills/apm-report/SKILL.md" "logs/agents/" "codex_install local apm-report log path"
    assert_file_contains "$installer_projects/p1/.codex/skills/apm-team-lead/SKILL.md" "apm-subagent" "codex_install local team-lead delegation skill"
    log_pass "codex_install local"

    HOME="$tmp_home" TERM=xterm bash "$CODEX_INSTALL" --global
    assert_path_exists "$tmp_home/.codex/skills" "codex_install global skills"
    assert_path_exists "$tmp_home/.codex/config.toml" "codex_install global config"
    log_pass "codex_install global"

    HOME="$tmp_home" TERM=xterm bash "$OPENCODE_INSTALL" --local "$installer_projects/p2"
    assert_path_exists "$installer_projects/p2/.opencode/agents" "opencode_install local agents"
    assert_path_exists "$installer_projects/p2/.opencode/agents/apm-code-simplifier.md" "opencode_install local simplifier agent file"
    assert_path_exists "$installer_projects/p2/.opencode/commands" "opencode_install local commands"
    assert_path_exists "$installer_projects/p2/.opencode/tools" "opencode_install local tools"
    assert_path_exists "$installer_projects/p2/.opencode/skills" "opencode_install local skills"
    log_pass "opencode_install local"

    HOME="$tmp_home" TERM=xterm bash "$OPENCODE_INSTALL" --global
    assert_path_exists "$tmp_home/.config/opencode/agents" "opencode_install global agents"
    assert_path_exists "$tmp_home/.config/opencode/commands" "opencode_install global commands"
    assert_path_exists "$tmp_home/.config/opencode/tools" "opencode_install global tools"
    assert_path_exists "$tmp_home/.config/opencode/skills" "opencode_install global skills"
    log_pass "opencode_install global"

    HOME="$tmp_home" TERM=xterm bash "$CURSOR_INSTALL" --local "$installer_projects/p3" --skip-skills
    assert_path_exists "$installer_projects/p3/.cursor/agents" "cursor_install local agents"
    assert_path_exists "$installer_projects/p3/.cursor/agents/apm-code-simplifier.md" "cursor_install local simplifier agent file"
    assert_path_exists "$installer_projects/p3/.cursor/commands" "cursor_install local commands"
    log_pass "cursor_install local --skip-skills"

    HOME="$tmp_home" TERM=xterm bash "$CURSOR_INSTALL" --global
    assert_path_exists "$tmp_home/.cursor/agents" "cursor_install global agents"
    assert_path_exists "$tmp_home/.cursor/commands" "cursor_install global commands"
    assert_path_exists "$tmp_home/.cursor/skills" "cursor_install global skills"
    log_pass "cursor_install global"

    HOME="$tmp_home" TERM=xterm bash "$CLAUDE_INSTALL" --local "$installer_projects/p4"
    assert_path_exists "$installer_projects/p4/.claude/agents" "claude_install local agents"
    assert_path_exists "$installer_projects/p4/.claude/agents/apm-engineer.md" "claude_install local engineer agent file"
    assert_path_exists "$installer_projects/p4/.claude/agents/apm-code-reviewer.md" "claude_install local reviewer agent file"
    assert_path_exists "$installer_projects/p4/.claude/agents/apm-team-lead.md" "claude_install local team-lead agent file"
    assert_path_exists "$installer_projects/p4/.claude/skills" "claude_install local skills"
    assert_path_exists "$installer_projects/p4/.claude/skills/apm-report/SKILL.md" "claude_install local apm-report skill"
    assert_path_exists "$installer_projects/p4/.claude/skills/apm-team-lead/SKILL.md" "claude_install local apm-team-lead skill"
    log_pass "claude_install local"

    HOME="$tmp_home" TERM=xterm bash "$CLAUDE_INSTALL" --global
    assert_path_exists "$tmp_home/.claude/agents" "claude_install global agents"
    assert_path_exists "$tmp_home/.claude/skills" "claude_install global skills"
    log_pass "claude_install global"
}

main() {
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

    trap cleanup EXIT

    log_section "APM Validation: full regression"
    run_syntax_checks
    run_e2e_suite
    run_interactive_stdin_cases
    run_optional_tty_case
    run_non_interactive_matrix_and_installers

    log_section "Validation completed successfully"
}

main "$@"
