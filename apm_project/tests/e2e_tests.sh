#!/usr/bin/env bash
#
# APM E2E Tests - validate the current unified configurator and active packs.
#

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APM_SCRIPT="$REPO_ROOT/apm_project/apm.sh"

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

VERBOSE=false
KEEP_TEST_PROJECTS=false

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --keep)
                KEEP_TEST_PROJECTS=true
                shift
                ;;
            --help|-h)
                cat <<'EOF'
APM E2E Test Suite

Usage: ./e2e_tests.sh [options]

Options:
  --verbose, -v   Show detailed test output
  --keep          Keep temporary test projects
  --help, -h      Show this help message
EOF
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done
}

write_test_header() {
    echo ""
    echo -e "\033[36m============================================================\033[0m"
    echo -e "  $1"
    echo -e "\033[36m============================================================\033[0m"
}

write_test_name() {
    echo ""
    echo -e "  \033[33m[TEST]\033[0m $1"
}

write_test_pass() {
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
    echo -e "    \033[32m[PASS]\033[0m $1"
}

write_test_fail() {
    local message="$1"
    local test_name="${2:-Unknown}"
    ((TESTS_RUN++))
    ((TESTS_FAILED++))
    FAILED_TESTS+=("$test_name")
    echo -e "    \033[31m[FAIL]\033[0m $message"
}

write_test_info() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "    \033[36m[INFO]\033[0m $1"
    fi
}

assert_path_exists() {
    local path="$1"
    local description="$2"
    local test_context="$3"

    if [[ -e "$path" ]]; then
        write_test_pass "$description exists"
        return 0
    fi

    write_test_fail "$description does not exist: $path" "$test_context"
    return 1
}

assert_path_not_exists() {
    local path="$1"
    local description="$2"
    local test_context="$3"

    if [[ ! -e "$path" ]]; then
        write_test_pass "$description does not exist (expected)"
        return 0
    fi

    write_test_fail "$description should not exist: $path" "$test_context"
    return 1
}

assert_file_contains() {
    local file_path="$1"
    local pattern="$2"
    local description="$3"
    local test_context="$4"

    if [[ ! -f "$file_path" ]]; then
        write_test_fail "File not found: $file_path" "$test_context"
        return 1
    fi

    if grep -q "$pattern" "$file_path"; then
        write_test_pass "$description - pattern found"
        return 0
    fi

    write_test_fail "$description - pattern not found: $pattern" "$test_context"
    return 1
}

assert_directory_not_empty() {
    local path="$1"
    local description="$2"
    local test_context="$3"

    if [[ ! -d "$path" ]]; then
        write_test_fail "Directory not found: $path" "$test_context"
        return 1
    fi

    local count
    count=$(find "$path" -mindepth 1 -maxdepth 1 | wc -l)
    if [[ "$count" -gt 0 ]]; then
        write_test_pass "$description is not empty ($count items)"
        return 0
    fi

    write_test_fail "$description is empty" "$test_context"
    return 1
}

initialize_test_environment() {
    local test_dir
    test_dir=$(mktemp -d -t apm_e2e_tests_XXXXXX)
    write_test_info "Created test directory: $test_dir"
    echo "$test_dir"
}

remove_test_environment() {
    local test_dir="$1"

    if [[ "$KEEP_TEST_PROJECTS" != "true" && -d "$test_dir" ]]; then
        rm -rf "$test_dir"
        write_test_info "Cleaned up test directory: $test_dir"
    elif [[ "$KEEP_TEST_PROJECTS" == "true" ]]; then
        echo ""
        echo -e "  \033[33mTest projects preserved at: $test_dir\033[0m"
    fi
}

assert_base_template() {
    local project_path="$1"
    local project_name="$2"
    local prefix="$3"
    local mb_dir="$project_path/memory_bank"

    assert_path_exists "$project_path/AGENTS.md" "AGENTS.md" "$prefix-AGENTS"
    assert_path_exists "$project_path/src" "src directory" "$prefix-SRC"
    assert_path_exists "$project_path/tests" "tests directory" "$prefix-TESTS"
    assert_path_exists "$project_path/logs" "logs directory" "$prefix-LOGS"
    assert_path_exists "$project_path/external" "external directory" "$prefix-EXTERNAL"

    assert_path_exists "$mb_dir" "memory_bank" "$prefix-MB"
    assert_path_exists "$mb_dir/ARCHITECTURE.md" "memory_bank/ARCHITECTURE.md" "$prefix-MB-ARCH"
    assert_path_exists "$mb_dir/STATE.md" "memory_bank/STATE.md" "$prefix-MB-STATE"
    assert_path_exists "$mb_dir/TASKS.md" "memory_bank/TASKS.md" "$prefix-MB-TASKS"
    assert_path_exists "$mb_dir/design/SPEC-MODULE.md" "memory_bank/design/SPEC-MODULE.md" "$prefix-MB-DESIGN"
    assert_path_exists "$mb_dir/specs/SPEC_W1A.md" "memory_bank/specs/SPEC_W1A.md" "$prefix-MB-SPEC"
    assert_path_exists "$mb_dir/tasks/W1A.md" "memory_bank/tasks/W1A.md" "$prefix-MB-TASK"
    assert_file_contains "$mb_dir/ARCHITECTURE.md" "$project_name" "ARCHITECTURE.md contains project name" "$prefix-NAME"
}

test_opencode_local() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-opencode"
    mkdir -p "$tmp_home"

    write_test_header "OpenCode local install"
    local project_name="test-opencode"
    local project_path="$test_dir/$project_name"

    write_test_name "Creating OpenCode project with local assets"
    if HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
        --opencode \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --local \
        --non-interactive; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "OC-CREATE"
        return
    fi

    assert_base_template "$project_path" "$project_name" "OC"
    assert_path_exists "$project_path/.opencode/agents" ".opencode/agents" "OC-AGENTS"
    assert_path_exists "$project_path/.opencode/skills" ".opencode/skills" "OC-SKILLS"
    assert_path_exists "$project_path/.opencode/agents/apm-worker.md" "OpenCode worker agent" "OC-WORKER"
    assert_path_exists "$project_path/.opencode/agents/apm-co-founder.md" "OpenCode co-founder agent" "OC-COFOUNDER"
    assert_directory_not_empty "$project_path/.opencode/skills/apm-start" "OpenCode apm-start skill" "OC-SKILL-CONTENT"
    assert_path_not_exists "$project_path/.opencode/commands" ".opencode/commands" "OC-NO-COMMANDS"
    assert_path_not_exists "$project_path/.opencode/tools" ".opencode/tools" "OC-NO-TOOLS"
}

test_codex_local() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-codex"
    mkdir -p "$tmp_home"

    write_test_header "Codex local install"
    local project_name="test-codex"
    local project_path="$test_dir/$project_name"

    write_test_name "Creating Codex project with local assets"
    if HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
        --codex \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --local \
        --non-interactive; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "CX-CREATE"
        return
    fi

    assert_base_template "$project_path" "$project_name" "CX"
    assert_path_exists "$project_path/.codex/skills" ".codex/skills" "CX-SKILLS"
    assert_path_exists "$project_path/.codex/agents" ".codex/agents" "CX-AGENTS"
    assert_path_exists "$project_path/.codex/agents/apm-worker.toml" "Codex worker agent" "CX-WORKER"
    assert_path_exists "$project_path/.codex/agents/apm-reviewer.toml" "Codex reviewer agent" "CX-REVIEWER"
    assert_path_exists "$project_path/.codex/config.toml" "Codex config" "CX-CONFIG"
    assert_file_contains "$project_path/.codex/config.toml" "multi_agent = true" "Codex config multi_agent" "CX-CONFIG-MA"
    assert_file_contains "$project_path/.codex/config.toml" "max_threads = 6" "Codex config max_threads" "CX-CONFIG-THREADS"
}

test_claude_local() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-claude"
    mkdir -p "$tmp_home"

    write_test_header "Claude Code local install"
    local project_name="test-claude"
    local project_path="$test_dir/$project_name"

    write_test_name "Creating Claude Code project with local assets"
    if HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
        --claude \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --local \
        --non-interactive; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "CC-CREATE"
        return
    fi

    assert_base_template "$project_path" "$project_name" "CC"
    assert_path_exists "$project_path/.claude/agents" ".claude/agents" "CC-AGENTS"
    assert_path_exists "$project_path/.claude/skills" ".claude/skills" "CC-SKILLS"
    assert_path_exists "$project_path/.claude/agents/apm-worker.md" "Claude worker agent" "CC-WORKER"
    assert_path_exists "$project_path/.claude/agents/apm-reviewer.md" "Claude reviewer agent" "CC-REVIEWER"
    assert_path_exists "$project_path/.claude/agents/apm-co-founder.md" "Claude co-founder agent" "CC-COFOUNDER"
}

test_cursor_local_legacy() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-cursor"
    mkdir -p "$tmp_home"

    write_test_header "Cursor local install (legacy)"
    local project_name="test-cursor"
    local project_path="$test_dir/$project_name"

    write_test_name "Creating Cursor project with local legacy assets"
    if HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
        --cursor \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --local \
        --non-interactive; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "CURSOR-CREATE"
        return
    fi

    assert_base_template "$project_path" "$project_name" "CURSOR"
    assert_path_exists "$project_path/.cursor/agents" ".cursor/agents" "CURSOR-AGENTS"
    assert_path_exists "$project_path/.cursor/commands" ".cursor/commands" "CURSOR-COMMANDS"
    assert_path_exists "$project_path/.cursor/agents/apm-engineer.md" "Cursor engineer agent" "CURSOR-ENGINEER"
    assert_path_exists "$project_path/.cursor/commands/apm-start.md" "Cursor apm-start command" "CURSOR-START"
}

test_multi_env_local() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-multi"
    mkdir -p "$tmp_home"

    write_test_header "Multi-environment local install"
    local project_name="test-multi"
    local project_path="$test_dir/$project_name"

    write_test_name "Creating project with OpenCode + Codex + Claude"
    if HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
        --opencode \
        --codex \
        --claude \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --local \
        --non-interactive; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "MULTI-CREATE"
        return
    fi

    assert_base_template "$project_path" "$project_name" "MULTI"
    assert_path_exists "$project_path/.opencode/agents" "OpenCode agents" "MULTI-OC"
    assert_path_exists "$project_path/.codex/agents" "Codex agents" "MULTI-CX"
    assert_path_exists "$project_path/.claude/agents" "Claude agents" "MULTI-CC"
    assert_path_not_exists "$project_path/.cursor" "Cursor assets" "MULTI-NO-CURSOR"
}

test_in_place_and_legacy_flags() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-inplace"
    mkdir -p "$tmp_home"

    write_test_header "In-place setup + legacy flag compatibility"
    local project_path="$test_dir/in-place-project"
    mkdir -p "$project_path"
    printf '# scratch\n' > "$project_path/local.md"

    write_test_name "Running in-place setup with deprecated methodology flag"
    if (
        cd "$project_path" &&
        HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
            --opencode \
            --rapid \
            --non-interactive
    ); then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "INPLACE-CREATE"
        return
    fi

    assert_base_template "$project_path" "in-place-project" "INPLACE"
    assert_path_exists "$project_path/local.md" "existing local file preserved" "INPLACE-PRESERVE"
    assert_path_not_exists "$project_path/.opencode" "OpenCode assets skipped by default" "INPLACE-SKIP"
}

test_force_in_place_refresh() {
    local test_dir="$1"
    local tmp_home="$test_dir/home-force"
    mkdir -p "$tmp_home"

    write_test_header "In-place force refresh"
    local project_path="$test_dir/force-project"
    mkdir -p "$project_path"

    write_test_name "Initial local OpenCode setup"
    if (
        cd "$project_path" &&
        HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
            --opencode \
            --local \
            --non-interactive
    ); then
        write_test_pass "initial apm.sh execution succeeded"
    else
        write_test_fail "initial apm.sh execution failed" "FORCE-INITIAL"
        return
    fi

    mkdir -p "$project_path/.opencode/commands" "$project_path/.opencode/tools"
    printf 'stale\n' > "$project_path/.opencode/commands/legacy.txt"
    printf 'stale\n' > "$project_path/.opencode/tools/legacy.txt"
    printf 'stale\n' > "$project_path/memory_bank/stale.txt"
    printf 'keep\n' > "$project_path/local.md"

    write_test_name "Re-running in place with --force refresh"
    if (
        cd "$project_path" &&
        HOME="$tmp_home" TERM=xterm bash "$APM_SCRIPT" \
            --opencode \
            --local \
            --force \
            --non-interactive
    ); then
        write_test_pass "forced refresh succeeded"
    else
        write_test_fail "forced refresh failed" "FORCE-REFRESH"
        return
    fi

    assert_base_template "$project_path" "force-project" "FORCE"
    assert_path_exists "$project_path/local.md" "unmanaged local file preserved" "FORCE-PRESERVE"
    assert_path_not_exists "$project_path/memory_bank/stale.txt" "stale managed file removed" "FORCE-MB-CLEAN"
    assert_path_not_exists "$project_path/.opencode/commands" "stale OpenCode commands removed" "FORCE-OC-COMMANDS"
    assert_path_not_exists "$project_path/.opencode/tools" "stale OpenCode tools removed" "FORCE-OC-TOOLS"
}

print_summary() {
    echo ""
    echo -e "\033[36m============================================================\033[0m"
    echo -e "  E2E Test Summary"
    echo -e "\033[36m============================================================\033[0m"
    echo "  Tests Run:    $TESTS_RUN"
    echo "  Passed:       $TESTS_PASSED"
    echo "  Failed:       $TESTS_FAILED"

    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo ""
        echo "  Failed Tests:"
        local failed_test
        for failed_test in "${FAILED_TESTS[@]}"; do
            echo "    - $failed_test"
        done
    fi
    echo ""
}

main() {
    parse_args "$@"

    local test_dir
    test_dir=$(initialize_test_environment)

    test_opencode_local "$test_dir"
    test_codex_local "$test_dir"
    test_claude_local "$test_dir"
    test_cursor_local_legacy "$test_dir"
    test_multi_env_local "$test_dir"
    test_in_place_and_legacy_flags "$test_dir"
    test_force_in_place_refresh "$test_dir"

    print_summary

    local exit_code=0
    if [[ $TESTS_FAILED -gt 0 ]]; then
        exit_code=1
    fi

    remove_test_environment "$test_dir"
    exit "$exit_code"
}

main "$@"
