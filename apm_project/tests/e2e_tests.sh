#!/usr/bin/env bash
#
# APM E2E Tests - End-to-End testing for project deployment
# Tests RAPID, DS, and FULL methodologies across Cursor, OpenCode, and Codex environments.
#
# Author: APM Team
# Version: 2.0.0

# Don't exit on error - we handle errors in tests
set +e

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APM_SCRIPT="$SCRIPT_DIR/../apm.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

# Options
VERBOSE=false
KEEP_TEST_PROJECTS=false
TEST_SUITE="All"

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --keep)
                KEEP_TEST_PROJECTS=true
                shift
                ;;
            --rapid)
                TEST_SUITE="RAPID"
                shift
                ;;
            --ds)
                TEST_SUITE="DS"
                shift
                ;;
            --full)
                TEST_SUITE="FULL"
                shift
                ;;
            --help|-h)
                echo "APM E2E Test Suite"
                echo ""
                echo "Usage: ./e2e_tests.sh [options]"
                echo ""
                echo "Options:"
                echo "  --verbose, -v   Show detailed test output"
                echo "  --keep          Keep test projects after completion"
                echo "  --rapid         Run only RAPID methodology tests"
                echo "  --ds            Run only DS methodology tests"
                echo "  --full          Run only FULL methodology tests"
                echo "  --help, -h      Show this help message"
                exit 0
                ;;
            *)
                echo "[ERROR] Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

# ============================================================================
# TEST UTILITIES
# ============================================================================

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
        echo -e "    \033[36m[INFO]\033[0m $1" >&2
    fi
}

assert_path_exists() {
    local path="$1"
    local description="$2"
    local test_context="$3"
    
    if [[ -e "$path" ]]; then
        write_test_pass "$description exists"
        return 0
    else
        write_test_fail "$description does not exist: $path" "$test_context"
        return 1
    fi
}

assert_path_not_exists() {
    local path="$1"
    local description="$2"
    local test_context="$3"
    
    if [[ ! -e "$path" ]]; then
        write_test_pass "$description does not exist (expected)"
        return 0
    else
        write_test_fail "$description should not exist: $path" "$test_context"
        return 1
    fi
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
    else
        write_test_fail "$description - pattern not found: $pattern" "$test_context"
        return 1
    fi
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
    if [[ $count -gt 0 ]]; then
        write_test_pass "$description is not empty ($count items)"
        return 0
    else
        write_test_fail "$description is empty" "$test_context"
        return 1
    fi
}

# ============================================================================
# TEST SETUP & TEARDOWN
# ============================================================================

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

# ============================================================================
# RAPID METHODOLOGY TESTS (Cursor)
# ============================================================================

test_rapid_methodology_deployment() {
    local test_dir="$1"
    
    write_test_header "RAPID Methodology Deployment Tests (Cursor)"
    
    local project_name="test-rapid-project"
    local project_path="$test_dir/$project_name"
    
    write_test_name "Creating RAPID project via apm.sh"
    
    if bash "$APM_SCRIPT" \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --cursor \
        --rapid \
        --non-interactive \
        --skip-cursor; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "RAPID-Creation"
        return
    fi
    
    # Test project root structure
    write_test_name "Verifying RAPID project root structure"
    assert_path_exists "$project_path" "Project root" "RAPID-Root"
    assert_path_exists "$project_path/src" "src directory" "RAPID-Src"
    assert_path_exists "$project_path/logs" "logs directory" "RAPID-Logs"
    assert_path_exists "$project_path/tests" "tests directory" "RAPID-Tests"
    assert_path_exists "$project_path/external" "external directory" "RAPID-External"
    assert_path_exists "$project_path/AGENTS.md" "AGENTS.md" "RAPID-Agents"
    
    # Test memory-bank directory
    write_test_name "Verifying RAPID memory-bank"
    local mb_dir="$project_path/memory-bank"
    assert_path_exists "$mb_dir" "memory-bank directory" "RAPID-MemoryBank"
    assert_path_exists "$mb_dir/ARCHITECTURE.md" "memory-bank/ARCHITECTURE.md" "RAPID-MBArch"
    assert_path_exists "$mb_dir/STATE.md" "memory-bank/STATE.md" "RAPID-MBState"
    assert_path_exists "$mb_dir/TASK.md" "memory-bank/TASK.md" "RAPID-MBTask"
    
    # Verify project name was substituted in ARCHITECTURE.md
    assert_file_contains "$mb_dir/ARCHITECTURE.md" "$project_name" \
        "ARCHITECTURE.md contains project name" "RAPID-ArchName"
    
    # No legacy .apm/ directory
    write_test_name "Verifying no legacy artifacts"
    assert_path_not_exists "$project_path/.apm" ".apm directory" "RAPID-NoAPM"
    assert_path_not_exists "$project_path/ARCHITECTURE.md" "Root ARCHITECTURE.md" "RAPID-NoRootArch"
    assert_path_not_exists "$project_path/TASK.md" "Root TASK.md" "RAPID-NoRootTask"
    assert_path_not_exists "$project_path/{project-name}" "{project-name} placeholder" "RAPID-NoPlaceholder"
    
    # Test cursor pack installation
    write_test_name "Verifying Cursor pack (agents)"
    local agents_dir="$project_path/.cursor/agents"
    assert_path_exists "$agents_dir" ".cursor/agents directory" "RAPID-CursorAgents"
    assert_path_exists "$agents_dir/apm-architect.md" "apm-architect agent" "RAPID-ArchitectAgent"
    assert_path_exists "$agents_dir/apm-engineer.md" "apm-engineer agent" "RAPID-EngineerAgent"
    assert_path_exists "$agents_dir/apm-sdet.md" "apm-sdet agent" "RAPID-SDETAgent"
    
    write_test_name "Verifying Cursor pack (commands)"
    local commands_dir="$project_path/.cursor/commands"
    assert_path_exists "$commands_dir" ".cursor/commands directory" "RAPID-CursorCommands"
    assert_path_exists "$commands_dir/apm-start.md" "apm-start command" "RAPID-StartCmd"
    assert_path_exists "$commands_dir/apm-develop.md" "apm-develop command" "RAPID-DevelopCmd"
    assert_path_exists "$commands_dir/apm-test.md" "apm-test command" "RAPID-TestCmd"
    assert_path_exists "$commands_dir/apm-sync.md" "apm-sync command" "RAPID-SyncCmd"
    assert_path_exists "$commands_dir/apm-architect.md" "apm-architect command" "RAPID-ArchCmd"
    assert_path_exists "$commands_dir/apm-review.md" "apm-review command" "RAPID-ReviewCmd"
}

# ============================================================================
# DS METHODOLOGY TESTS (Cursor)
# ============================================================================

test_ds_methodology_deployment() {
    local test_dir="$1"
    
    write_test_header "DS Methodology Deployment Tests (Cursor)"
    
    local project_name="test-ds-project"
    local project_path="$test_dir/$project_name"
    
    write_test_name "Creating DS project via apm.sh"
    
    if bash "$APM_SCRIPT" \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --cursor \
        --ds \
        --non-interactive \
        --skip-cursor; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "DS-Creation"
        return
    fi
    
    # Test DS-specific directories
    write_test_name "Verifying DS project root structure"
    assert_path_exists "$project_path" "Project root" "DS-Root"
    assert_path_exists "$project_path/src" "src directory" "DS-Src"
    assert_path_exists "$project_path/eda" "eda directory" "DS-EDA"
    assert_path_exists "$project_path/experiments" "experiments directory" "DS-Experiments"
    assert_path_exists "$project_path/data" "data directory" "DS-Data"
    assert_path_exists "$project_path/models" "models directory" "DS-Models"
    assert_path_exists "$project_path/logs" "logs directory" "DS-Logs"
    assert_path_exists "$project_path/AGENTS.md" "AGENTS.md" "DS-Agents"
    assert_path_exists "$project_path/config.py" "config.py" "DS-Config"
    assert_path_exists "$project_path/main.py" "main.py" "DS-Main"
    
    # Test memory-bank
    write_test_name "Verifying DS memory-bank"
    local mb_dir="$project_path/memory-bank"
    assert_path_exists "$mb_dir" "memory-bank directory" "DS-MemoryBank"
    assert_path_exists "$mb_dir/ARCHITECTURE.md" "memory-bank/ARCHITECTURE.md" "DS-MBArch"
    assert_path_exists "$mb_dir/STATE.md" "memory-bank/STATE.md" "DS-MBState"
    assert_path_exists "$mb_dir/TASK.md" "memory-bank/TASK.md" "DS-MBTask"
    
    # No legacy artifacts
    write_test_name "Verifying no legacy artifacts"
    assert_path_not_exists "$project_path/.apm" ".apm directory" "DS-NoAPM"
    
    # Cursor pack
    write_test_name "Verifying Cursor pack"
    assert_path_exists "$project_path/.cursor/agents/apm-architect.md" "apm-architect agent" "DS-ArchitectAgent"
    assert_path_exists "$project_path/.cursor/agents/apm-data-scientist.md" "apm-data-scientist agent" "DS-DSAgent"
    assert_path_exists "$project_path/.cursor/commands/apm-start.md" "apm-start command" "DS-StartCmd"
    assert_path_exists "$project_path/.cursor/commands/apm-eda.md" "apm-eda command" "DS-EDACmd"
    assert_path_exists "$project_path/.cursor/commands/apm-baseline.md" "apm-baseline command" "DS-BaselineCmd"
    assert_path_exists "$project_path/.cursor/commands/apm-experiment.md" "apm-experiment command" "DS-ExpCmd"
}

# ============================================================================
# FULL METHODOLOGY TESTS (Cursor-only)
# ============================================================================

test_full_methodology_deployment() {
    local test_dir="$1"
    
    write_test_header "FULL Methodology Deployment Tests (Cursor)"
    
    local project_name="test-full-project"
    local project_path="$test_dir/$project_name"
    
    write_test_name "Creating FULL project via apm.sh"
    
    if bash "$APM_SCRIPT" \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --cursor \
        --full \
        --non-interactive \
        --skip-cursor; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "FULL-Creation"
        return
    fi
    
    # Test project root structure
    write_test_name "Verifying FULL project root structure"
    assert_path_exists "$project_path" "Project root" "FULL-Root"
    assert_path_exists "$project_path/WORKFLOW.md" "WORKFLOW.md" "FULL-Workflow"
    assert_path_exists "$project_path/external" "external directory" "FULL-External"
    
    # Test project name directory (renamed from {project-name})
    write_test_name "Verifying FULL project name directory structure"
    local project_sub_dir="$project_path/$project_name"
    assert_path_exists "$project_sub_dir" "Project name directory" "FULL-ProjectDir"
    
    # Test block structure
    write_test_name "Verifying FULL block structure"
    local block1="$project_sub_dir/{BLOCK-1-name}"
    local block2="$project_sub_dir/{BLOCK-2-name}"
    local block3="$project_sub_dir/{BLOCK-3-name}"
    
    assert_path_exists "$block1" "BLOCK-1 directory" "FULL-Block1"
    assert_path_exists "$block2" "BLOCK-2 directory" "FULL-Block2"
    assert_path_exists "$block3" "BLOCK-3 directory" "FULL-Block3"
    
    # Test block internal structure
    write_test_name "Verifying FULL block internal structure"
    for block in "$block1" "$block2" "$block3"; do
        local block_name
        block_name=$(basename "$block")
        assert_path_exists "$block/logs" "$block_name/logs" "FULL-BlockLogs"
        assert_path_exists "$block/tests" "$block_name/tests" "FULL-BlockTests"
        assert_path_exists "$block/task.md" "$block_name/task.md" "FULL-BlockTask"
    done
    
    # Test .apm directory structure
    write_test_name "Verifying FULL .apm directory structure"
    local apm_dir="$project_path/.apm"
    assert_path_exists "$apm_dir" ".apm directory" "FULL-APM"
    assert_path_exists "$apm_dir/AGENT_DROLES" "AGENT_DROLES directory" "FULL-AgentRoles"
    assert_path_exists "$apm_dir/MEMORY" "MEMORY directory" "FULL-Memory"
    
    # Test FULL-specific agent role files
    write_test_name "Verifying FULL agent role files"
    local roles_dir="$apm_dir/AGENT_DROLES"
    assert_path_exists "$roles_dir/System_Architect.md" "System_Architect.md" "FULL-Architect"
    assert_path_exists "$roles_dir/Lead-Engineer.md" "Lead-Engineer.md" "FULL-LeadEngineer"
    assert_path_exists "$roles_dir/Principal-Engineer.md" "Principal-Engineer.md" "FULL-PrincipalEngineer"
    assert_path_exists "$roles_dir/SDET.md" "SDET.md" "FULL-SDET"
    
    # Test cursor pack installed on top of legacy commands
    write_test_name "Verifying Cursor pack"
    assert_path_exists "$project_path/.cursor/agents" ".cursor/agents directory" "FULL-CursorAgents"
    assert_path_exists "$project_path/.cursor/commands" ".cursor/commands directory" "FULL-CursorCommands"
    
    # Verify placeholder was renamed correctly
    write_test_name "Verifying placeholder renaming"
    assert_path_not_exists "$project_path/{project-name}" "{project-name} placeholder" "FULL-NoPlaceholder"
}

# ============================================================================
# CLI ENVIRONMENT TESTS
# ============================================================================

test_rapid_opencode_deployment() {
    local test_dir="$1"
    
    write_test_header "RAPID OpenCode CLI Deployment Tests"
    
    local project_name="test-rapid-opencode"
    local project_path="$test_dir/$project_name"
    
    write_test_name "Creating RAPID OpenCode project"
    
    if bash "$APM_SCRIPT" \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --opencode \
        --rapid \
        --none \
        --non-interactive; then
        write_test_pass "apm.sh executed successfully"
    else
        write_test_fail "apm.sh execution failed" "RAPID-OC-Creation"
        return
    fi
    
    write_test_name "Verifying OpenCode RAPID structure"
    assert_path_exists "$project_path/memory-bank" "memory-bank directory" "RAPID-OC-MB"
    assert_path_exists "$project_path/memory-bank/ARCHITECTURE.md" "ARCHITECTURE.md" "RAPID-OC-Arch"
    assert_path_exists "$project_path/src" "src directory" "RAPID-OC-Src"
    assert_path_exists "$project_path/tests" "tests directory" "RAPID-OC-Tests"
    assert_path_exists "$project_path/AGENTS.md" "AGENTS.md" "RAPID-OC-Agents"
    
    # No Cursor-specific artifacts
    assert_path_not_exists "$project_path/.cursor" ".cursor directory" "RAPID-OC-NoCursor"
    assert_path_not_exists "$project_path/.apm" ".apm directory" "RAPID-OC-NoAPM"
}

# ============================================================================
# ADDITIONAL VALIDATION TESTS
# ============================================================================

test_project_overwrite() {
    local test_dir="$1"
    
    write_test_header "Project Overwrite Tests"
    
    local project_name="test-overwrite-project"
    local project_path="$test_dir/$project_name"
    
    # Create initial project
    write_test_name "Creating initial project"
    bash "$APM_SCRIPT" \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --cursor \
        --rapid \
        --non-interactive \
        --skip-cursor
    
    # Add marker file
    local marker_file="$project_path/initial_marker.txt"
    echo "This should be removed after overwrite" > "$marker_file"
    
    # Overwrite with --force
    write_test_name "Overwriting project with --force flag"
    if bash "$APM_SCRIPT" \
        --project-name "$project_name" \
        --project-path "$test_dir" \
        --cursor \
        --rapid \
        --non-interactive \
        --skip-cursor \
        --force; then
        write_test_pass "Project overwritten successfully"
    else
        write_test_fail "Project overwrite failed" "Overwrite-Force"
        return
    fi
    
    # Verify marker file is gone
    assert_path_not_exists "$marker_file" "Marker file after overwrite" "Overwrite-Marker"
    
    # Verify project structure is intact
    assert_path_exists "$project_path/memory-bank/ARCHITECTURE.md" "memory-bank/ARCHITECTURE.md after overwrite" "Overwrite-Structure"
}

test_error_handling() {
    local test_dir="$1"
    
    write_test_header "Error Handling Tests"
    
    # Test invalid methodology
    write_test_name "Testing invalid methodology parameter"
    if bash "$APM_SCRIPT" \
        --project-name "test-invalid" \
        --project-path "$test_dir" \
        --methodology "INVALID" \
        --non-interactive \
        --skip-cursor 2>/dev/null; then
        write_test_fail "No error thrown for invalid methodology" "Error-InvalidMethodology"
    else
        write_test_pass "Error correctly thrown for invalid methodology"
    fi
    
    # Test FULL not available for CLI environments
    write_test_name "Testing FULL methodology rejected for OpenCode"
    if bash "$APM_SCRIPT" \
        --project-name "test-full-oc" \
        --project-path "$test_dir" \
        --opencode \
        --full \
        --non-interactive 2>/dev/null; then
        write_test_fail "No error for FULL+OpenCode" "Error-FullOpenCode"
    else
        write_test_pass "Error correctly thrown for FULL+OpenCode"
    fi
}

# ============================================================================
# TEST SUMMARY
# ============================================================================

show_test_summary() {
    echo ""
    echo -e "\033[37m============================================================\033[0m"
    echo -e "  TEST SUMMARY"
    echo -e "\033[37m============================================================\033[0m"
    
    echo ""
    echo -n "  Total Tests: "
    echo -e "\033[36m$TESTS_RUN\033[0m"
    
    echo -n "  Passed:      "
    echo -e "\033[32m$TESTS_PASSED\033[0m"
    
    echo -n "  Failed:      "
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "\033[31m$TESTS_FAILED\033[0m"
    else
        echo -e "\033[32m$TESTS_FAILED\033[0m"
    fi
    
    if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        echo ""
        echo -e "  \033[31mFailed Tests:\033[0m"
        for test in "${FAILED_TESTS[@]}"; do
            echo -e "    - $test"
        done
    fi
    
    local pass_rate=0
    if [[ $TESTS_RUN -gt 0 ]]; then
        pass_rate=$((TESTS_PASSED * 100 / TESTS_RUN))
    fi
    
    echo ""
    echo -n "  Pass Rate:   "
    if [[ $pass_rate -eq 100 ]]; then
        echo -e "\033[32m${pass_rate}%\033[0m"
    elif [[ $pass_rate -ge 80 ]]; then
        echo -e "\033[33m${pass_rate}%\033[0m"
    else
        echo -e "\033[31m${pass_rate}%\033[0m"
    fi
    
    echo ""
    echo -e "\033[37m============================================================\033[0m"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    parse_args "$@"
    
    echo ""
    echo -e "  \033[36mAPM E2E Test Suite v2.0\033[0m"
    echo -e "  \033[36m=======================\033[0m"
    echo -e "  \033[90mTesting project deployment via apm.sh\033[0m"
    
    # Check if apm.sh exists
    if [[ ! -f "$APM_SCRIPT" ]]; then
        echo -e "\033[31m[ERROR] apm.sh not found at: $APM_SCRIPT\033[0m"
        exit 1
    fi
    
    # Make apm.sh executable
    chmod +x "$APM_SCRIPT"
    
    # Initialize test environment
    local test_dir
    test_dir=$(initialize_test_environment)
    
    # Run test suites based on selection
    case "$TEST_SUITE" in
        RAPID)
            test_rapid_methodology_deployment "$test_dir"
            ;;
        DS)
            test_ds_methodology_deployment "$test_dir"
            ;;
        FULL)
            test_full_methodology_deployment "$test_dir"
            ;;
        All)
            test_rapid_methodology_deployment "$test_dir"
            test_ds_methodology_deployment "$test_dir"
            test_full_methodology_deployment "$test_dir"
            test_rapid_opencode_deployment "$test_dir"
            test_project_overwrite "$test_dir"
            test_error_handling "$test_dir"
            ;;
    esac
    
    # Cleanup
    remove_test_environment "$test_dir"
    
    # Show summary and exit with appropriate code
    if show_test_summary; then
        echo -e "  \033[32mAll tests passed!\033[0m"
        exit 0
    else
        echo -e "  \033[31mSome tests failed.\033[0m"
        exit 1
    fi
}

# Run main
main "$@"
