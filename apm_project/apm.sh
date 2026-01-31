#!/usr/bin/env bash
#
# APM (Agentic Project Management) - Project Configurator
# Interactive CLI wizard for creating new projects with APM methodology.
# Supports FULL/RAPID/DS methodologies for Cursor and OpenCode CLI environments.
#
# Author: APM Team
# Version: 1.0.0

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PATH="$SCRIPT_DIR/../apm_source"
APP_VERSION="1.0.0"

# Command line arguments
PROJECT_NAME=""
PROJECT_PATH=""
PROJECT_NAME_SET=false
PROJECT_PATH_SET=false
METHODOLOGY=""
DEV_ENV=""
OPENCODE_INSTALL=""
SKIP_GITHUB=false
SKIP_CURSOR=false
FORCE=false
NON_INTERACTIVE=false
SHOW_HELP=false
SHOW_VERSION=false

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
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
                METHODOLOGY="$2"
                shift 2
                ;;
            --rapid)
                METHODOLOGY="RAPID"
                shift
                ;;
            --ds)
                METHODOLOGY="DS"
                shift
                ;;
            --full)
                METHODOLOGY="FULL"
                shift
                ;;
            --dev-env)
                DEV_ENV="$2"
                shift 2
                ;;
            --opencode)
                DEV_ENV="OPENCODE"
                shift
                ;;
            --cursor)
                DEV_ENV="CURSOR"
                shift
                ;;
            --local)
                OPENCODE_INSTALL="local"
                shift
                ;;
            --global)
                OPENCODE_INSTALL="global"
                shift
                ;;
            --none|--no-opencode-install)
                OPENCODE_INSTALL="skip"
                shift
                ;;
            --skip-github)
                SKIP_GITHUB=true
                shift
                ;;
            --skip-cursor)
                SKIP_CURSOR=true
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
                echo "[ERROR] Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

# ============================================================================
# UI FUNCTIONS
# ============================================================================

show_banner() {
    echo ""
    echo -e "\033[36m    ___    ____  __  ___\033[0m"
    echo -e "\033[36m   /   |  / __ \\/  |/  /\033[0m"
    echo -e "\033[36m  / /| | / /_/ / /|_/ / \033[0m"
    echo -e "\033[36m / ___ |/ ____/ /  / /  \033[0m"
    echo -e "\033[36m/_/  |_/_/   /_/  /_/   \033[0m"
    echo ""
    echo -e "\033[36mAgentic Project Management v${APP_VERSION}\033[0m"
    echo -e "\033[36mSpec-Driven Development\033[0m"
    echo ""
}

write_step() {
    echo ""
    echo -e "\033[33m>> \033[0m\033[37m$1\033[0m"
}

write_success() {
    echo -e "\033[32m[OK] \033[0m$1"
}

write_error() {
    echo -e "\033[31m[ERROR] \033[0m$1"
}

write_info() {
    echo -e "\033[36m[INFO] \033[0m$1"
}

write_warning() {
    echo -e "\033[33m[WARN] \033[0m$1"
}

read_user_input() {
    local prompt="$1"
    local default="$2"
    local input
    
    if [[ -n "$default" ]]; then
        echo -n "$prompt [$default]: "
    else
        echo -n "$prompt: "
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
    local default_path
    default_path="$(pwd)"
    
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
            else
                write_error "Failed to create directory"
            fi
        fi
    done
}

read_project_name() {
    while true; do
        local name
        name=$(read_user_input "Project name" "")
        
        if [[ -z "$name" ]]; then
            write_error "Project name cannot be empty"
            continue
        fi
        
        # Validate name (alphanumeric, hyphens, underscores)
        if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
            write_error "Invalid name. Use letters, numbers, hyphens, underscores. Start with a letter."
            continue
        fi
        
        echo "$name"
        return 0
    done
}

select_dev_environment() {
    echo ""
    echo "Select Development Environment:"
    echo ""
    echo -e "  \033[33m[1] \033[36mCursor IDE\033[0m - Interactive IDE workflow"
    echo -e "      \033[90mIncludes Cursor commands and .apm methodology assets\033[0m"
    echo ""
    echo -e "  \033[33m[2] \033[32mOpenCode CLI\033[0m - CLI-first workflow"
    echo -e "      \033[90mUses OpenCode agents/commands/skills pack and memory-bank/\033[0m"
    echo ""
    
    while true; do
        local choice
        choice=$(read_user_input "Select environment (1 or 2)" "1")
        
        case "$choice" in
            1|CURSOR|cursor)
                echo "CURSOR"
                return 0
                ;;
            2|OPENCODE|opencode|OpenCode|OpenCodeCLI)
                echo "OPENCODE"
                return 0
                ;;
            *)
                write_error "Invalid choice. Enter 1 or 2"
                ;;
        esac
    done
}

select_methodology() {
    local dev_env="$1"

    echo ""
    echo "Available Methodologies:"
    echo ""
    if [[ "$dev_env" != "OPENCODE" ]]; then
        echo -e "  \033[33m[1] \033[32mFULL\033[0m - Enterprise methodology"
        echo -e "      \033[90mBlock-based architecture, 4 agent roles (Architect, SDET, Engineer, Principal)\033[0m"
        echo -e "      \033[90mTDD workflow, isolated components, comprehensive documentation\033[0m"
        echo -e "      \033[90mBest for: Large projects, microservices, team collaboration\033[0m"
        echo ""
        echo -e "  \033[33m[2] \033[36mRAPID\033[0m - Startup methodology"
        echo -e "      \033[90mUnified src/ structure, 3 agent roles (Architect, Engineer, SDET)\033[0m"
        echo -e "      \033[90mFaster iteration, simpler setup, less ceremony\033[0m"
        echo -e "      \033[90mBest for: MVPs, prototypes, small projects\033[0m"
        echo ""
        echo -e "  \033[33m[3] \033[35mDS\033[0m - Data Science methodology"
        echo -e "      \033[90mML/DS projects with experiment tracking, 2 agent roles (Architect, Data Scientist)\033[0m"
        echo -e "      \033[90mEDA pipeline, hypothesis-driven experiments, model finalization\033[0m"
        echo -e "      \033[90mBest for: Kaggle, ML research, data analysis\033[0m"
        echo ""
    else
        echo -e "  \033[33m[1] \033[36mRAPID\033[0m - Startup methodology"
        echo -e "      \033[90mUnified src/ structure, 3 agent roles (Architect, Engineer, SDET)\033[0m"
        echo -e "      \033[90mFaster iteration, simpler setup, less ceremony\033[0m"
        echo -e "      \033[90mBest for: MVPs, prototypes, small projects\033[0m"
        echo ""
        echo -e "  \033[33m[2] \033[35mDS\033[0m - Data Science methodology"
        echo -e "      \033[90mML/DS projects with experiment tracking, 2 agent roles (Architect, Data Scientist)\033[0m"
        echo -e "      \033[90mEDA pipeline, hypothesis-driven experiments, model finalization\033[0m"
        echo ""
    fi
    
    while true; do
        local choice
        if [[ "$dev_env" == "OPENCODE" ]]; then
            choice=$(read_user_input "Select methodology (1 or 2)" "1")
        else
            choice=$(read_user_input "Select methodology (1, 2, or 3)" "2")
        fi
        
        if [[ "$dev_env" == "OPENCODE" ]]; then
            case "$choice" in
                1|RAPID|rapid)
                    echo "RAPID"
                    return 0
                    ;;
                2|DS|ds)
                    echo "DS"
                    return 0
                    ;;
                *)
                    write_error "Invalid choice. Enter 1 or 2"
                    ;;
            esac
        else
            case "$choice" in
                1|FULL|full)
                    echo "FULL"
                    return 0
                    ;;
                2|RAPID|rapid)
                    echo "RAPID"
                    return 0
                    ;;
                3|DS|ds)
                    echo "DS"
                    return 0
                    ;;
                *)
                    write_error "Invalid choice. Enter 1, 2, 3, FULL, RAPID, or DS"
                    ;;
            esac
        fi
    done
}

confirm_github_integration() {
    echo ""
    echo "GitHub Integration:"
    
    # Check if gh CLI is available
    if ! command -v gh &> /dev/null; then
        write_warning "GitHub CLI (gh) not found. GitHub integration will be skipped."
        echo -e "      \033[90mInstall from: https://cli.github.com/\033[0m"
        echo "false"
        return 0
    fi
    
    # Check authentication status
    if ! gh auth status &> /dev/null; then
        write_warning "Not authenticated with GitHub CLI."
        echo -e "      \033[90mRun 'gh auth login' to authenticate.\033[0m"
        echo "false"
        return 0
    fi
    
    write_success "GitHub CLI authenticated"
    
    local enable
    enable=$(read_user_input "Create GitHub repository? (y/n)" "y")
    if [[ "$enable" == "y" || "$enable" == "Y" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

show_summary() {
    local project_path="$1"
    local project_name="$2"
    local methodology="$3"
    local dev_env="$4"
    local github_enabled="$5"
    
    echo ""
    echo -e "\033[90m==================================================\033[0m"
    echo "Configuration Summary"
    echo -e "\033[90m==================================================\033[0m"
    echo -n "  Project Name:  "
    echo -e "\033[32m$project_name\033[0m"
    echo -n "  Location:      "
    echo -e "\033[32m$project_path\033[0m"
    echo -n "  Methodology:   "
    echo -e "\033[32m$methodology\033[0m"
    local env_label="$dev_env"
    if [[ "$dev_env" == "OPENCODE" ]]; then
        env_label="OpenCode CLI"
    elif [[ "$dev_env" == "CURSOR" ]]; then
        env_label="Cursor IDE"
    fi
    echo -n "  Environment:  "
    echo -e "\033[32m$env_label\033[0m"
    echo -n "  GitHub:        "
    if [[ "$github_enabled" == "true" ]]; then
        echo -e "\033[32mYes (will create repository)\033[0m"
    else
        echo -e "\033[33mNo\033[0m"
    fi
    echo -e "\033[90m==================================================\033[0m"
    
    local confirm
    confirm=$(read_user_input "Proceed with these settings? (y/n)" "y")
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# PROJECT CREATION FUNCTIONS
# ============================================================================

copy_methodology_template() {
    local methodology="$1"
    local target_path="$2"
    local dev_env="$3"
    
    local source_root="$SOURCE_PATH/interactive_ide"
    if [[ "$dev_env" == "OPENCODE" ]]; then
        source_root="$SOURCE_PATH/cli_ide"
    fi
    
    local source_path="$source_root/${methodology}_METHODOLOGY"
    if [[ "$methodology" == "FULL" && ! -d "$source_path" ]]; then
        local deprecated_path="$source_root/FULL_METHODOLOGY (Deprecated)"
        if [[ -d "$deprecated_path" ]]; then
            source_path="$deprecated_path"
        fi
    fi
    
    if [[ ! -d "$source_path" ]]; then
        write_error "Methodology template not found: $source_path"
        exit 1
    fi
    
    write_info "Copying $methodology methodology template..."
    
    # Copy all files and directories (including hidden)
    cp -r "$source_path/"* "$target_path/" 2>/dev/null || true
    cp -r "$source_path/".* "$target_path/" 2>/dev/null || true
    
    write_success "Template copied"
}

install_opencode_pack() {
    local mode="$1"
    local project_path="$2"
    local pack_dir="$SOURCE_PATH/cli_ide/apm_opencode_pack"
    
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
    
    mkdir -p "$target_dir/agents" "$target_dir/commands" "$target_dir/skills" "$target_dir/tools"
    cp -R "$pack_dir/agent/." "$target_dir/agents/"
    cp -R "$pack_dir/command/." "$target_dir/commands/"
    cp -R "$pack_dir/skill/." "$target_dir/skills/"
    cp -R "$pack_dir/tools/." "$target_dir/tools/"
    
    write_success "OpenCode pack installed to $target_dir"
}

initialize_git_repository() {
    local project_path="$1"
    local project_name="$2"
    local create_remote="$3"
    
    pushd "$project_path" > /dev/null
    
    write_info "Initializing Git repository..."
    git init --quiet
    git add .
    git commit -m "Initial commit: APM project setup" --quiet
    write_success "Git repository initialized"
    
    if [[ "$create_remote" == "true" ]]; then
        write_info "Creating GitHub repository..."
        if gh repo create "$project_name" --private --source=. --push; then
            write_success "GitHub repository created and pushed"
        else
            write_warning "Failed to create GitHub repository"
        fi
    fi
    
    popd > /dev/null
}

rename_project_placeholders() {
    local project_path="$1"
    local project_name="$2"
    local dev_env="$3"
    
    # Rename {project-name} directory if exists (FULL methodology)
    local placeholder_dir="$project_path/{project-name}"
    if [[ -d "$placeholder_dir" ]]; then
        mv "$placeholder_dir" "$project_path/$project_name"
        write_info "Renamed project directory to: $project_name"
    fi
    
    # Update project name in ARCHITECTURE.md
    local replace_in_file
    replace_in_file() {
        local target_file="$1"
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s/\\[Project Name\\]/$project_name/g" "$target_file"
        else
            sed -i "s/\\[Project Name\\]/$project_name/g" "$target_file"
        fi
    }

    local arch_file="$project_path/ARCHITECTURE.md"
    if [[ -f "$arch_file" ]]; then
        replace_in_file "$arch_file"
        write_info "Updated ARCHITECTURE.md with project name"
    fi

    local memory_bank_dir="$project_path/memory bank"
    if [[ "$dev_env" == "OPENCODE" ]]; then
        memory_bank_dir="$project_path/memory-bank"
    fi
    local mb_file
    for mb_file in "$memory_bank_dir/ARCHITECTURE.md" "$memory_bank_dir/TASK.md" "$memory_bank_dir/STATE.md"; do
        if [[ -f "$mb_file" ]]; then
            replace_in_file "$mb_file"
            write_info "Updated $(basename "$mb_file") in $(basename "$memory_bank_dir") with project name"
        fi
    done
}

initialize_memory_bank() {
    local project_path="$1"
    local methodology="$2"
    local dev_env="$3"
    
    if [[ "$methodology" == "FULL" ]]; then
        return 0
    fi
    if [[ "$dev_env" == "OPENCODE" ]]; then
        return 0
    fi
    
    local memory_bank_dir="$project_path/memory bank"
    mkdir -p "$memory_bank_dir"
    
    local templates_dir="$project_path/.apm/TEMPLATES"
    resolve_template() {
        local base_name="$1"
        local candidate
        for candidate in "${base_name}_TEMPLATE.md" "${base_name}_TMP.md" "${base_name}_TEMPLATE_TMP.md"; do
            if [[ -f "$templates_dir/$candidate" ]]; then
                echo "$templates_dir/$candidate"
                return 0
            fi
        done
        return 1
    }
    
    local file_name
    for file_name in ARCHITECTURE.md STATE.md TASK.md; do
        local root_file="$project_path/$file_name"
        local bank_file="$memory_bank_dir/$file_name"
        local template_file
        
        if [[ -f "$root_file" && ! -f "$bank_file" ]]; then
            mv "$root_file" "$bank_file"
            write_info "Moved $file_name to memory bank/"
            continue
        fi
        
        if [[ ! -f "$bank_file" ]]; then
            if template_file="$(resolve_template "${file_name%.md}")"; then
                cp "$template_file" "$bank_file"
                write_info "Initialized memory bank/$file_name from template"
            else
                echo "# ${file_name%.md}" > "$bank_file"
                write_warning "Initialized memory bank/$file_name as empty file (template missing)"
            fi
        fi
    done
}

initialize_agent_reports() {
    local project_path="$1"
    local methodology="$2"
    local dev_env="$3"
    
    if [[ "$methodology" == "FULL" || "$dev_env" == "OPENCODE" ]]; then
        return 0
    fi
    
    local roles_dir="$project_path/.apm/AGENT_ROLES"
    if [[ ! -d "$roles_dir" ]]; then
        roles_dir="$project_path/.apm/AGENT_DROLES"
    fi
    local reports_root="$project_path/.apm/Agent Reports"
    
    if [[ ! -d "$roles_dir" ]]; then
        return 0
    fi
    
    mkdir -p "$reports_root"
    
    local role_file
    for role_file in "$roles_dir"/*.md; do
        [[ -f "$role_file" ]] || continue
        
        local base
        base="$(basename "$role_file" .md)"
        local role_name="${base//_/ }"
        role_name="${role_name//-/ }"
        
        local role_dir="$reports_root/$role_name"
        mkdir -p "$role_dir"
        : > "$role_dir/.gitkeep"
    done
}

# ============================================================================
# MAIN FUNCTION
# ============================================================================

main() {
    parse_args "$@"
    
    # Handle help flag
    if [[ "$SHOW_HELP" == "true" ]]; then
        cat << EOF
APM (Agentic Project Management) - Project Configurator

Usage: ./apm.sh [options]

Options:
    -h, --help          Show this help message
    -v, --version       Show version information

Non-Interactive Mode (for automation/testing):
    --opencode          Shorthand for --dev-env OPENCODE
    --cursor            Shorthand for --dev-env CURSOR
    --rapid             Shorthand for --methodology RAPID
    --ds                Shorthand for --methodology DS
    --full              Shorthand for --methodology FULL
    --project-name      Project name (defaults to current directory name)
    --project-path      Target directory or parent directory (default: current directory)
    --methodology       FULL, RAPID, or DS
    --dev-env           CURSOR or OPENCODE (default: CURSOR)
    --local             Install OpenCode pack locally into .opencode/
    --global            Install OpenCode pack globally into ~/.config/opencode/
    --none              Skip OpenCode pack install (default when OPENCODE)
    --skip-github       Skip GitHub repository creation
    --skip-cursor       Deprecated (no auto-open)
    --force             Overwrite existing project without prompting
    --non-interactive   Run without any user prompts

Example:
    ./apm.sh --opencode --rapid --project-name "my-app" --project-path "/projects" --non-interactive --skip-github --skip-cursor
    ./apm.sh --opencode --ds --project-name "ml-project" --project-path "/projects" --non-interactive --skip-github --skip-cursor

This interactive wizard will guide you through creating a new APM project.
EOF
        exit 0
    fi
    
    # Handle version flag
    if [[ "$SHOW_VERSION" == "true" ]]; then
        echo "APM v$APP_VERSION"
        exit 0
    fi
    
    # Verify source path exists
    if [[ ! -d "$SOURCE_PATH" ]]; then
        write_error "APM source templates not found at: $SOURCE_PATH"
        echo -e "\033[90mMake sure apm_source directory is in the correct location.\033[0m"
        exit 1
    fi
    
    local directory
    local project_name
    local methodology
    local dev_env
    local github_enabled
    local project_path
    
    # Check if running in non-interactive mode
    if [[ "$NON_INTERACTIVE" == "true" ]]; then
        # Resolve defaults
        if [[ -z "$PROJECT_PATH" ]]; then
            PROJECT_PATH="$(pwd)"
        fi
        if [[ -z "$PROJECT_NAME" ]]; then
            PROJECT_NAME="$(basename "$PROJECT_PATH")"
        fi
        if [[ -z "$METHODOLOGY" ]]; then
            write_error "--methodology is required in non-interactive mode"
            exit 1
        fi
        if [[ -z "$DEV_ENV" ]]; then
            DEV_ENV="CURSOR"
        fi
        if [[ "$DEV_ENV" != "CURSOR" && "$DEV_ENV" != "OPENCODE" ]]; then
            write_error "Invalid --dev-env: $DEV_ENV. Use CURSOR or OPENCODE."
            exit 1
        fi
        if [[ "$DEV_ENV" == "OPENCODE" && -z "$OPENCODE_INSTALL" ]]; then
            OPENCODE_INSTALL="skip"
        fi
        if [[ "$DEV_ENV" == "OPENCODE" ]]; then
            case "$OPENCODE_INSTALL" in
                local|global|skip|"") ;;
                *)
                    write_error "Invalid OpenCode install option. Use --local, --global, or --none."
                    exit 1
                    ;;
            esac
        fi
        
        # Validate methodology
        if [[ "$METHODOLOGY" != "FULL" && "$METHODOLOGY" != "RAPID" && "$METHODOLOGY" != "DS" ]]; then
            write_error "Invalid methodology: $METHODOLOGY. Use FULL, RAPID, or DS."
            exit 1
        fi
        if [[ "$DEV_ENV" == "OPENCODE" && "$METHODOLOGY" == "FULL" ]]; then
            write_error "FULL methodology is not available for OpenCode CLI projects."
            exit 1
        fi
        
        # Resolve paths (support parent path or full project path)
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
        project_path="$resolved_parent/$(basename "$base_path")"

        project_name="$PROJECT_NAME"
        methodology="$METHODOLOGY"
        dev_env="$DEV_ENV"
        github_enabled="false"
        if [[ "$SKIP_GITHUB" != "true" ]]; then
            github_enabled="true"
        fi
        directory="$resolved_parent"
        
        write_info "Non-interactive mode: Creating $methodology project '$project_name' ($dev_env)"
        
        # Check if project exists
        if [[ -d "$project_path" ]]; then
            local current_dir
            current_dir="$(pwd)"
            if [[ "$project_path" == "$current_dir" ]]; then
                if [[ "$FORCE" == "true" ]]; then
                    write_warning "--force ignored for in-place setup: $project_path"
                fi
                write_warning "Project directory already exists; proceeding in-place: $project_path"
            else
                if [[ "$FORCE" == "true" ]]; then
                    write_warning "Overwriting existing project: $project_path"
                    rm -rf "$project_path"
                else
                    write_error "Project already exists: $project_path. Use --force to overwrite."
                    exit 1
                fi
            fi
        fi
    else
        # Interactive mode
        clear
        show_banner
        
        # Step 1: Get project directory
        write_step "Step 1: Project Location"
        directory=$(read_directory_path "Parent directory for the project")
        
        # Step 2: Get project name
        write_step "Step 2: Project Name"
        project_name=$(read_project_name)
        
        # Check if project already exists
        project_path="$directory/$project_name"
        if [[ -d "$project_path" ]]; then
            write_error "A folder named '$project_name' already exists at this location."
            local overwrite
            overwrite=$(read_user_input "Overwrite? (y/n)" "n")
            if [[ "$overwrite" != "y" ]]; then
                echo ""
                echo -e "\033[33mAborted.\033[0m"
                exit 0
            fi
            rm -rf "$project_path"
        fi
        
        # Step 3: Select development environment
        write_step "Step 3: Select Development Environment"
        dev_env=$(select_dev_environment)
        
        # Step 4: Select methodology
        write_step "Step 4: Select Methodology"
        methodology=$(select_methodology "$dev_env")
        
        # Step 5: GitHub integration
        write_step "Step 5: GitHub Integration"
        github_enabled=$(confirm_github_integration)
        
        # Show summary and confirm
        if ! show_summary "$project_path" "$project_name" "$methodology" "$dev_env" "$github_enabled"; then
            echo ""
            echo -e "\033[33mAborted.\033[0m"
            exit 0
        fi
    fi
    
    # Create project
    echo ""
    write_step "Creating Project..."
    
    # Create project directory
    mkdir -p "$project_path"
    write_success "Created project directory"
    
    # Copy methodology template
    copy_methodology_template "$methodology" "$project_path" "$dev_env"
    
    # Rename placeholders
    rename_project_placeholders "$project_path" "$project_name" "$dev_env"

    # Initialize Memory Bank and Agent Reports
    initialize_memory_bank "$project_path" "$methodology" "$dev_env"
    initialize_agent_reports "$project_path" "$methodology" "$dev_env"

    # Optional: install OpenCode pack
    if [[ "$dev_env" == "OPENCODE" ]]; then
        if [[ "$NON_INTERACTIVE" != "true" ]]; then
            while true; do
                local install_choice
                install_choice=$(read_user_input "Install OpenCode pack? (local/global/skip)" "skip")
                case "$install_choice" in
                    local|global|skip)
                        OPENCODE_INSTALL="$install_choice"
                        break
                        ;;
                    *)
                        write_error "Invalid choice. Enter local, global, or skip"
                        ;;
                esac
            done
        fi
        if [[ "$OPENCODE_INSTALL" == "local" ]]; then
            install_opencode_pack "local" "$project_path"
        elif [[ "$OPENCODE_INSTALL" == "global" ]]; then
            install_opencode_pack "global" ""
        fi
    fi
    
    # Initialize git (skip github in non-interactive mode if SKIP_GITHUB is set)
    if [[ "$NON_INTERACTIVE" == "true" && "$SKIP_GITHUB" == "true" ]]; then
        github_enabled="false"
    fi
    initialize_git_repository "$project_path" "$project_name" "$github_enabled"
    
    # Success message
    echo ""
    echo -e "\033[32m==================================================\033[0m"
    echo -e "\033[32mProject created successfully!\033[0m"
    echo -e "\033[32m==================================================\033[0m"
    echo ""
    echo "Location: $project_path"
    echo ""
    echo "Next steps:"
    echo "  1. Open the project in your preferred environment"
    echo -n "  2. Run "
    echo -e "\033[33m/apm-start\033[0m and describe your project idea"
    echo "  3. The System Architect will guide you through the setup"
    echo ""

    echo ""
    echo -e "\033[36mHappy coding!\033[0m"
}

# Run main
main "$@"
