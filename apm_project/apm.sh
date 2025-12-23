#!/usr/bin/env bash
#
# APM (Agentic Project Management) - Project Configurator
# Interactive CLI wizard for creating new projects with APM methodology.
# Supports FULL and RAPID methodologies for AI-driven development in Cursor.
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
METHODOLOGY=""
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
                shift 2
                ;;
            --project-path)
                PROJECT_PATH="$2"
                shift 2
                ;;
            --methodology)
                METHODOLOGY="$2"
                shift 2
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
            echo "$(cd "$path" && pwd)"
            return 0
        fi
        
        write_error "Directory does not exist: $path"
        local create
        create=$(read_user_input "Create it? (y/n)" "n")
        if [[ "$create" == "y" ]]; then
            if mkdir -p "$path" 2>/dev/null; then
                echo "$(cd "$path" && pwd)"
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

select_methodology() {
    echo ""
    echo "Available Methodologies:"
    echo ""
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
    
    while true; do
        local choice
        choice=$(read_user_input "Select methodology (1 or 2)" "2")
        
        case "$choice" in
            1|FULL|full)
                echo "FULL"
                return 0
                ;;
            2|RAPID|rapid)
                echo "RAPID"
                return 0
                ;;
            *)
                write_error "Invalid choice. Enter 1, 2, FULL, or RAPID"
                ;;
        esac
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
    local github_enabled="$4"
    
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
    
    local source_path="$SOURCE_PATH/${methodology}_METHODOLOGY"
    
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
    
    # Rename {project-name} directory if exists (FULL methodology)
    local placeholder_dir="$project_path/{project-name}"
    if [[ -d "$placeholder_dir" ]]; then
        mv "$placeholder_dir" "$project_path/$project_name"
        write_info "Renamed project directory to: $project_name"
    fi
    
    # Update project name in ARCHITECTURE.md
    local arch_file="$project_path/ARCHITECTURE.md"
    if [[ -f "$arch_file" ]]; then
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS sed requires empty string after -i
            sed -i '' "s/\[Project Name\]/$project_name/g" "$arch_file"
        else
            sed -i "s/\[Project Name\]/$project_name/g" "$arch_file"
        fi
        write_info "Updated ARCHITECTURE.md with project name"
    fi
}

open_cursor() {
    local project_path="$1"
    
    local open_choice
    open_choice=$(read_user_input "Open project in Cursor? (y/n)" "y")
    
    if [[ "$open_choice" == "y" || "$open_choice" == "Y" ]]; then
        # Try cursor command first
        if command -v cursor &> /dev/null; then
            write_info "Opening Cursor..."
            cursor "$project_path" &
            return 0
        fi
        
        # Try code command as fallback (VS Code)
        if command -v code &> /dev/null; then
            write_warning "Cursor not found, opening VS Code..."
            code "$project_path" &
            return 0
        fi
        
        write_warning "Neither Cursor nor VS Code found in PATH"
        echo -e "      \033[90mOpen the project manually: $project_path\033[0m"
    fi
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
    --project-name      Name of the project to create
    --project-path      Parent directory where project will be created
    --methodology       FULL or RAPID
    --skip-github       Skip GitHub repository creation
    --skip-cursor       Skip opening Cursor IDE
    --force             Overwrite existing project without prompting
    --non-interactive   Run without any user prompts

Example:
    ./apm.sh --project-name "my-app" --project-path "/projects" --methodology RAPID --non-interactive --skip-github --skip-cursor

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
    local github_enabled
    local project_path
    
    # Check if running in non-interactive mode
    if [[ "$NON_INTERACTIVE" == "true" ]]; then
        # Validate required parameters
        if [[ -z "$PROJECT_NAME" ]]; then
            write_error "--project-name is required in non-interactive mode"
            exit 1
        fi
        if [[ -z "$PROJECT_PATH" ]]; then
            write_error "--project-path is required in non-interactive mode"
            exit 1
        fi
        if [[ -z "$METHODOLOGY" ]]; then
            write_error "--methodology is required in non-interactive mode"
            exit 1
        fi
        
        # Validate methodology
        if [[ "$METHODOLOGY" != "FULL" && "$METHODOLOGY" != "RAPID" ]]; then
            write_error "Invalid methodology: $METHODOLOGY. Use FULL or RAPID."
            exit 1
        fi
        
        # Resolve paths
        if [[ ! -d "$PROJECT_PATH" ]]; then
            write_error "Project path does not exist: $PROJECT_PATH"
            exit 1
        fi
        
        directory="$(cd "$PROJECT_PATH" && pwd)"
        project_name="$PROJECT_NAME"
        methodology="$METHODOLOGY"
        github_enabled="false"
        if [[ "$SKIP_GITHUB" != "true" ]]; then
            github_enabled="true"
        fi
        project_path="$directory/$project_name"
        
        write_info "Non-interactive mode: Creating $methodology project '$project_name'"
        
        # Check if project exists
        if [[ -d "$project_path" ]]; then
            if [[ "$FORCE" == "true" ]]; then
                write_warning "Overwriting existing project: $project_path"
                rm -rf "$project_path"
            else
                write_error "Project already exists: $project_path. Use --force to overwrite."
                exit 1
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
        
        # Step 3: Select methodology
        write_step "Step 3: Select Methodology"
        methodology=$(select_methodology)
        
        # Step 4: GitHub integration
        write_step "Step 4: GitHub Integration"
        github_enabled=$(confirm_github_integration)
        
        # Show summary and confirm
        if ! show_summary "$project_path" "$project_name" "$methodology" "$github_enabled"; then
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
    copy_methodology_template "$methodology" "$project_path"
    
    # Rename placeholders
    rename_project_placeholders "$project_path" "$project_name"
    
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
    echo "  1. Open the project in Cursor"
    echo -n "  2. Run "
    echo -e "\033[33m/apm-start\033[0m and describe your project idea"
    echo "  3. The System Architect will guide you through the setup"
    echo ""
    
    # Offer to open Cursor (skip in non-interactive mode or if SKIP_CURSOR is set)
    if [[ "$NON_INTERACTIVE" != "true" && "$SKIP_CURSOR" != "true" ]]; then
        open_cursor "$project_path"
    elif [[ "$NON_INTERACTIVE" == "true" ]]; then
        write_info "Skipping Cursor launch (non-interactive mode)"
    fi
    
    echo ""
    echo -e "\033[36mHappy coding!\033[0m"
}

# Run main
main "$@"

