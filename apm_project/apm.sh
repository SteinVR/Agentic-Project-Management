#!/usr/bin/env bash
#
# APM (Agentic Project Management) - Project Configurator
# Creates a project from the unified base template and optionally installs
# environment packs for OpenCode, Codex, Claude Code, or legacy Cursor.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PATH="$SCRIPT_DIR/../apm_source"
BASE_TEMPLATE_DIR="$SOURCE_PATH/base"
APP_VERSION="2.0.0"

PROJECT_NAME=""
PROJECT_PATH=""
PROJECT_NAME_SET=false
PROJECT_PATH_SET=false
DEV_ENVS=()
PACK_INSTALL=""
FORCE=false
NON_INTERACTIVE=false
SHOW_HELP=false
SHOW_VERSION=false
LEGACY_PROFILE=""

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                SHOW_HELP=true
                shift
                ;;
            -v|--version)
                SHOW_VERSION=true
                shift
                ;;
            --project-name)
                PROJECT_NAME="$2"
                PROJECT_NAME_SET=true
                shift 2
                ;;
            --project-path)
                PROJECT_PATH="$2"
                PROJECT_PATH_SET=true
                shift 2
                ;;
            --methodology)
                LEGACY_PROFILE="$2"
                shift 2
                ;;
            --rapid|--ds|--full)
                LEGACY_PROFILE="${1#--}"
                shift
                ;;
            --dev-env)
                DEV_ENVS+=("$2")
                shift 2
                ;;
            --opencode)
                DEV_ENVS+=("OPENCODE")
                shift
                ;;
            --codex)
                DEV_ENVS+=("CODEX")
                shift
                ;;
            --claude)
                DEV_ENVS+=("CLAUDE")
                shift
                ;;
            --cursor)
                DEV_ENVS+=("CURSOR")
                shift
                ;;
            --local)
                PACK_INSTALL="local"
                shift
                ;;
            --global)
                PACK_INSTALL="global"
                shift
                ;;
            --none|--no-opencode-install|--no-codex-install)
                PACK_INSTALL="skip"
                shift
                ;;
            --skip-cursor|--skip-github)
                # Deprecated no-ops kept for backward compatibility with old CI/docs.
                shift
                ;;
            --force)
                FORCE=true
                shift
                ;;
            --non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            *)
                echo "[ERROR] Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done
}

show_banner() {
    echo ""
    echo -e "\033[36m    ___    ____  __  ___\033[0m"
    echo -e "\033[36m   /   |  / __ \\/  |/  /\033[0m"
    echo -e "\033[36m  / /| | / /_/ / /|_/ / \033[0m"
    echo -e "\033[36m / ___ |/ ____/ /  / /  \033[0m"
    echo -e "\033[36m/_/  |_/_/   /_/  /_/   \033[0m"
    echo ""
    echo -e "\033[36mAgentic Project Management v${APP_VERSION}\033[0m"
    echo -e "\033[36mUnified base template + environment packs\033[0m"
    echo ""
}

write_step() {
    echo "" >&2
    echo -e "\033[33m>> \033[0m\033[37m$1\033[0m" >&2
}

write_success() {
    echo -e "\033[32m[OK] \033[0m$1" >&2
}

write_error() {
    echo -e "\033[31m[ERROR] \033[0m$1" >&2
}

write_info() {
    echo -e "\033[36m[INFO] \033[0m$1" >&2
}

write_warning() {
    echo -e "\033[33m[WARN] \033[0m$1" >&2
}

read_user_input() {
    local prompt="$1"
    local default="$2"
    local input

    if [[ -n "$default" ]]; then
        echo -n "$prompt [$default]: " >&2
    else
        echo -n "$prompt: " >&2
    fi

    read -r input
    if [[ -z "$input" && -n "$default" ]]; then
        echo "$default"
    else
        echo "$input"
    fi
}

read_directory_path() {
    local prompt="$1"
    local default_path="${2:-$(pwd)}"

    while true; do
        local path
        path=$(read_user_input "$prompt" "$default_path")

        if [[ -d "$path" ]]; then
            local resolved
            resolved="$(cd "$path" && pwd)"
            write_info "Selected directory: $resolved"
            echo "$resolved"
            return 0
        fi

        write_error "Directory does not exist: $path"
        local create
        create=$(read_user_input "Create it? (y/n)" "n")
        if [[ "$create" == "y" ]]; then
            if mkdir -p "$path" 2>/dev/null; then
                local created
                created="$(cd "$path" && pwd)"
                write_info "Selected directory: $created"
                echo "$created"
                return 0
            fi
            write_error "Failed to create directory"
        fi
    done
}

read_project_name() {
    local default_name="${1:-}"
    while true; do
        local name
        name=$(read_user_input "Project name" "$default_name")

        if [[ -z "$name" ]]; then
            write_error "Project name cannot be empty"
            continue
        fi

        if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
            write_error "Invalid name. Use letters, numbers, hyphens, underscores. Start with a letter."
            continue
        fi

        echo "$name"
        return 0
    done
}

normalize_env_token() {
    case "$1" in
        1|OPENCODE|opencode) echo "OPENCODE" ;;
        2|CODEX|codex) echo "CODEX" ;;
        3|CLAUDE|claude) echo "CLAUDE" ;;
        4|CURSOR|cursor) echo "CURSOR" ;;
        *) return 1 ;;
    esac
}

select_dev_environment() {
    echo "" >&2
    echo "Select Development Environment(s):" >&2
    echo -e "\033[90mYou can select multiple environments (comma-separated, e.g. 1,3)\033[0m" >&2
    echo "" >&2
    echo -e "  \033[33m[1] \033[32mOpenCode CLI\033[0m - Agents + shared skills" >&2
    echo -e "  \033[33m[2] \033[35mCodex CLI\033[0m - Skills + subagent roles" >&2
    echo -e "  \033[33m[3] \033[34mClaude Code\033[0m - Agents + shared skills" >&2
    echo -e "  \033[33m[4] \033[90mCursor (legacy)\033[0m - Legacy pack under apm_source/_legacy/" >&2
    echo "" >&2

    while true; do
        local raw_choice
        raw_choice=$(read_user_input "Select environment(s)" "1")

        local normalized
        normalized="$(echo "$raw_choice" | tr ',' ' ' | xargs)"

        local valid=true
        local results=()
        local token
        for token in $normalized; do
            local normalized_token
            if ! normalized_token="$(normalize_env_token "$token")"; then
                write_error "Invalid choice: $token. Use 1-4 or environment names."
                valid=false
                break
            fi
            results+=("$normalized_token")
        done

        if [[ "$valid" == "true" && ${#results[@]} -gt 0 ]]; then
            echo "${results[*]}"
            return 0
        fi
    done
}

env_to_label() {
    case "$1" in
        OPENCODE) echo "OpenCode CLI" ;;
        CODEX) echo "Codex CLI" ;;
        CLAUDE) echo "Claude Code" ;;
        CURSOR) echo "Cursor (legacy)" ;;
        *) echo "$1" ;;
    esac
}

show_summary() {
    local project_path="$1"
    local project_name="$2"
    shift 2
    local envs=("$@")

    echo "" >&2
    echo -e "\033[90m==================================================\033[0m" >&2
    echo "Configuration Summary" >&2
    echo -e "\033[90m==================================================\033[0m" >&2
    echo -n "  Project Name:  " >&2
    echo -e "\033[32m$project_name\033[0m" >&2
    echo -n "  Location:      " >&2
    echo -e "\033[32m$project_path\033[0m" >&2

    local env_labels=""
    local env
    for env in "${envs[@]}"; do
        if [[ -n "$env_labels" ]]; then
            env_labels+=", "
        fi
        env_labels+="$(env_to_label "$env")"
    done
    echo -n "  Environment:   " >&2
    echo -e "\033[32m$env_labels\033[0m" >&2
    echo -e "\033[90m==================================================\033[0m" >&2

    local confirm
    confirm=$(read_user_input "Proceed with these settings? (y/n)" "y")
    [[ "$confirm" == "y" || "$confirm" == "Y" ]]
}

warn_on_legacy_profile() {
    if [[ -n "$LEGACY_PROFILE" ]]; then
        write_warning "Legacy methodology flags are ignored. APM now uses one unified base template; project shape is extended later by workflow skills."
    fi
}

copy_base_template() {
    local target_path="$1"

    if [[ ! -d "$BASE_TEMPLATE_DIR" ]]; then
        write_error "Base template not found: $BASE_TEMPLATE_DIR"
        exit 1
    fi

    write_info "Copying unified base template..."
    cp -R "$BASE_TEMPLATE_DIR/." "$target_path/"
    write_success "Template copied"
}

replace_project_name_placeholders() {
    local project_path="$1"
    local project_name="$2"
    local target_file

    while IFS= read -r -d '' target_file; do
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s/\\[Project Name\\]/$project_name/g" "$target_file"
        else
            sed -i "s/\\[Project Name\\]/$project_name/g" "$target_file"
        fi
    done < <(find "$project_path" -type f -name "*.md" -print0)

    write_info "Applied project name placeholders"
}

remove_path_if_exists() {
    local path="$1"
    if [[ -e "$path" ]]; then
        rm -rf "$path"
    fi
}

reset_apm_managed_paths() {
    local project_path="$1"
    local managed_rel_path
    local managed_paths=(
        "AGENTS.md"
        "src"
        "tests"
        "logs"
        "external"
        "memory_bank"
        ".opencode"
        ".codex"
        ".claude"
        ".cursor"
    )

    for managed_rel_path in "${managed_paths[@]}"; do
        remove_path_if_exists "$project_path/$managed_rel_path"
    done
}

prepare_target_directory() {
    local project_path="$1"
    local current_dir
    current_dir="$(pwd)"

    if [[ ! -d "$project_path" ]]; then
        return 0
    fi

    if [[ "$project_path" == "$current_dir" ]]; then
        if [[ "$FORCE" == "true" ]]; then
            write_warning "Refreshing managed APM files in-place: $project_path"
            reset_apm_managed_paths "$project_path"
        else
            write_warning "Project directory already exists; proceeding in-place: $project_path"
        fi
        return 0
    fi

    if [[ "$FORCE" == "true" ]]; then
        write_warning "Overwriting existing project: $project_path"
        rm -rf "$project_path"
        return 0
    fi

    if [[ "$NON_INTERACTIVE" == "true" ]]; then
        write_error "Project already exists: $project_path. Use --force to overwrite."
        exit 1
    fi

    write_warning "Project already exists: $project_path"
    local overwrite
    overwrite=$(read_user_input "Overwrite it? (y/n)" "n")
    if [[ "$overwrite" == "y" || "$overwrite" == "Y" ]]; then
        rm -rf "$project_path"
        return 0
    fi

    echo "" >&2
    echo -e "\033[33mAborted.\033[0m" >&2
    exit 0
}

install_opencode_pack() {
    local mode="$1"
    local project_path="$2"
    local pack_dir="$SOURCE_PATH/packs/opencode_pack"
    local skills_dir="$SOURCE_PATH/skills"

    if [[ ! -d "$pack_dir" ]]; then
        write_warning "OpenCode pack not found: $pack_dir"
        return 0
    fi

    local target_dir
    if [[ "$mode" == "local" ]]; then
        target_dir="$project_path/.opencode"
    else
        target_dir="$HOME/.config/opencode"
    fi

    remove_path_if_exists "$target_dir/commands"
    remove_path_if_exists "$target_dir/tools"
    mkdir -p "$target_dir/agents" "$target_dir/skills"
    if [[ -d "$pack_dir/agent" ]]; then
        cp -R "$pack_dir/agent/." "$target_dir/agents/"
    fi
    if [[ -d "$skills_dir" ]]; then
        cp -R "$skills_dir/." "$target_dir/skills/"
    fi

    write_success "OpenCode assets installed to $target_dir"
}

install_codex_pack() {
    local mode="$1"
    local project_path="$2"
    local installer_path="$SCRIPT_DIR/scripts/codex_install.sh"

    if [[ ! -f "$installer_path" ]]; then
        write_warning "Codex installer not found: $installer_path"
        return 0
    fi

    if [[ "$mode" == "local" ]]; then
        bash "$installer_path" --local "$project_path"
        write_success "Codex assets installed to $project_path/.codex"
    else
        bash "$installer_path" --global
        write_success "Codex assets installed to $HOME/.codex"
    fi
}

install_claude_pack() {
    local mode="$1"
    local project_path="$2"
    local installer_path="$SCRIPT_DIR/scripts/claude_install.sh"

    if [[ ! -f "$installer_path" ]]; then
        write_warning "Claude Code installer not found: $installer_path"
        return 0
    fi

    if [[ "$mode" == "local" ]]; then
        bash "$installer_path" --local "$project_path"
        write_success "Claude Code assets installed to $project_path/.claude"
    else
        bash "$installer_path" --global
        write_success "Claude Code assets installed to $HOME/.claude"
    fi
}

install_cursor_pack() {
    local mode="$1"
    local project_path="$2"
    local installer_path="$SCRIPT_DIR/scripts/cursor_install.sh"

    if [[ ! -f "$installer_path" ]]; then
        write_warning "Cursor installer not found: $installer_path"
        return 0
    fi

    if [[ "$mode" == "local" ]]; then
        bash "$installer_path" --local "$project_path"
        write_success "Cursor legacy assets installed to $project_path/.cursor"
    else
        bash "$installer_path" --global
        write_success "Cursor legacy assets installed to $HOME/.cursor"
    fi
}

resolve_project_path() {
    local base_path
    if [[ "$PROJECT_PATH_SET" == "true" && "$PROJECT_NAME_SET" == "true" ]]; then
        if [[ "$(basename "$PROJECT_PATH")" == "$PROJECT_NAME" ]]; then
            base_path="$PROJECT_PATH"
        else
            base_path="$PROJECT_PATH/$PROJECT_NAME"
        fi
    elif [[ "$PROJECT_PATH_SET" == "true" && "$PROJECT_NAME_SET" != "true" ]]; then
        base_path="$PROJECT_PATH"
    elif [[ "$PROJECT_PATH_SET" != "true" && "$PROJECT_NAME_SET" == "true" ]]; then
        base_path="$PROJECT_PATH/$PROJECT_NAME"
    else
        base_path="$PROJECT_PATH"
    fi

    local parent_dir
    parent_dir="$(dirname "$base_path")"
    if [[ ! -d "$parent_dir" ]]; then
        write_error "Parent directory does not exist: $parent_dir"
        exit 1
    fi

    local resolved_parent
    resolved_parent="$(cd "$parent_dir" && pwd)"
    echo "$resolved_parent/$(basename "$base_path")"
}

ensure_valid_envs() {
    local normalized_envs=()
    local env

    if [[ ${#DEV_ENVS[@]} -eq 0 ]]; then
        DEV_ENVS=("OPENCODE")
    fi

    for env in "${DEV_ENVS[@]}"; do
        local normalized_env
        if ! normalized_env="$(normalize_env_token "$env")"; then
            write_error "Invalid environment: $env. Use OpenCode, Codex, Claude, or Cursor."
            exit 1
        fi
        normalized_envs+=("$normalized_env")
    done

    DEV_ENVS=("${normalized_envs[@]}")
}

main() {
    parse_args "$@"

    if [[ "$SHOW_HELP" == "true" ]]; then
        cat <<'EOF'
APM (Agentic Project Management) - Project Configurator

Usage: ./apm.sh [options]

Options:
    -h, --help          Show this help message
    -v, --version       Show version information
    --project-name      Project name (defaults to current directory name)
    --project-path      Target directory or parent directory (default: current directory)
    --opencode          Add OpenCode environment
    --codex             Add Codex environment
    --claude            Add Claude Code environment
    --cursor            Add legacy Cursor environment
    --dev-env           Environment name or index (repeatable)
    --local             Install environment assets locally into the project config directory
    --global            Install environment assets globally into the user config directory
    --none              Skip environment asset install (default)
    --force             Overwrite an existing target directory, or refresh managed APM files in place
    --non-interactive   Run without prompts

Legacy compatibility flags accepted as no-ops:
    --methodology, --rapid, --ds, --full, --skip-cursor, --skip-github

Examples:
    ./apm.sh --opencode --project-name "my-app" --project-path "/projects" --non-interactive
    ./apm.sh --codex --claude --project-name "my-app" --project-path "/projects" --local --non-interactive
    ./apm.sh --cursor --project-name "legacy-app" --project-path "/projects" --local --non-interactive
EOF
        exit 0
    fi

    if [[ "$SHOW_VERSION" == "true" ]]; then
        echo "APM v$APP_VERSION"
        exit 0
    fi

    if [[ ! -d "$SOURCE_PATH" ]]; then
        write_error "APM source templates not found at: $SOURCE_PATH"
        exit 1
    fi

    warn_on_legacy_profile

    local directory
    local project_name
    local project_path

    if [[ "$NON_INTERACTIVE" == "true" ]]; then
        if [[ -z "$PROJECT_PATH" ]]; then
            PROJECT_PATH="$(pwd)"
        fi
        if [[ -z "$PROJECT_NAME" ]]; then
            PROJECT_NAME="$(basename "$PROJECT_PATH")"
        fi
        if [[ -z "$PACK_INSTALL" ]]; then
            PACK_INSTALL="skip"
        fi
        case "$PACK_INSTALL" in
            local|global|skip) ;;
            *)
                write_error "Invalid install option. Use --local, --global, or --none."
                exit 1
                ;;
        esac

        ensure_valid_envs
        project_path="$(resolve_project_path)"
        directory="$(dirname "$project_path")"
        project_name="$PROJECT_NAME"

        write_info "Non-interactive mode: creating '$project_name' for ${DEV_ENVS[*]}"
    else
        clear
        show_banner

        write_step "Step 1: Project Location"
        local cwd
        local default_parent
        local default_name
        cwd="$(pwd)"
        default_parent="$(dirname "$cwd")"
        default_name="$(basename "$cwd")"
        directory=$(read_directory_path "Parent directory for the project" "$default_parent")

        write_step "Step 2: Project Name"
        project_name=$(read_project_name "$default_name")
        PROJECT_NAME="$project_name"
        PROJECT_NAME_SET=true
        PROJECT_PATH="$directory"
        PROJECT_PATH_SET=true

        write_step "Step 3: Select Development Environment(s)"
        local env_selection
        env_selection=$(select_dev_environment)
        read -ra DEV_ENVS <<< "$env_selection"
        ensure_valid_envs

        project_path="$directory/$project_name"
        if ! show_summary "$project_path" "$project_name" "${DEV_ENVS[@]}"; then
            echo "" >&2
            echo -e "\033[33mAborted.\033[0m" >&2
            exit 0
        fi
    fi

    prepare_target_directory "$project_path"

    echo "" >&2
    write_step "Creating Project"

    mkdir -p "$project_path"
    write_success "Created project directory"

    copy_base_template "$project_path"
    replace_project_name_placeholders "$project_path" "$project_name"

    local env
    for env in "${DEV_ENVS[@]}"; do
        local install_mode="$PACK_INSTALL"

        if [[ "$NON_INTERACTIVE" != "true" && -z "$install_mode" ]]; then
            local prompt
            prompt="Install $(env_to_label "$env") assets? (local/global/skip)"
            while true; do
                local choice
                choice=$(read_user_input "$prompt" "skip")
                case "$choice" in
                    local|global|skip)
                        install_mode="$choice"
                        break
                        ;;
                    *)
                        write_error "Invalid choice. Enter local, global, or skip."
                        ;;
                esac
            done
        fi

        if [[ "$install_mode" == "skip" ]]; then
            continue
        fi

        case "$env" in
            OPENCODE) install_opencode_pack "$install_mode" "$project_path" ;;
            CODEX) install_codex_pack "$install_mode" "$project_path" ;;
            CLAUDE) install_claude_pack "$install_mode" "$project_path" ;;
            CURSOR) install_cursor_pack "$install_mode" "$project_path" ;;
        esac
    done

    echo "" >&2
    echo -e "\033[32m==================================================\033[0m" >&2
    echo -e "\033[32mProject created successfully\033[0m" >&2
    echo -e "\033[32m==================================================\033[0m" >&2
    echo "" >&2
    echo "Location: $project_path" >&2
    echo "" >&2
    echo "Next steps:" >&2
    echo "  1. Open the project in your selected environment." >&2
    echo "  2. Use the \`apm-start\` workflow skill to align on project vision and bootstrap the working flow." >&2
    echo "  3. Continue with the relevant workflow skills for implementation, testing, and sync." >&2
}

main "$@"
