#!/usr/bin/env pwsh
<#
.SYNOPSIS
    APM (Agentic Project Management) - Project Configurator
.DESCRIPTION
    Interactive CLI wizard for creating new projects with APM methodology.
    Supports FULL and RAPID methodologies for AI-driven development in Cursor.
.NOTES
    Author: APM Team
    Version: 1.0.0
#>

param(
    [switch]$Help,
    [switch]$Version,
    # Non-interactive mode parameters for automated testing
    [string]$ProjectName,
    [string]$ProjectPath,
    [ValidateSet("FULL", "RAPID", "")]
    [string]$Methodology,
    [switch]$SkipGitHub,
    [switch]$SkipCursor,
    [switch]$Force,
    [switch]$NonInteractive
)

$ErrorActionPreference = 'Stop'
$Script:AppVersion = "1.0.0"

# ============================================================================
# CONFIGURATION
# ============================================================================

$Script:SourcePath = Join-Path $PSScriptRoot "..\apm_source"

# ============================================================================
# UI FUNCTIONS
# ============================================================================

function Show-Banner {
    $banner = @"

    ___    ____  __  ___
   /   |  / __ \/  |/  /
  / /| | / /_/ / /|_/ / 
 / ___ |/ ____/ /  / /  
/_/  |_/_/   /_/  /_/   
                        
Agentic Project Management v$($Script:AppVersion)
Spec-Driven Development

"@
    Write-Host $banner -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Message)
    Write-Host "`n>> " -ForegroundColor Yellow -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline
    Write-Host $Message
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

function Read-UserInput {
    param(
        [string]$Prompt,
        [string]$Default = ""
    )
    
    if ($Default) {
        Write-Host "$Prompt " -NoNewline
        Write-Host "[$Default]" -ForegroundColor DarkGray -NoNewline
        Write-Host ": " -NoNewline
    } else {
        Write-Host "${Prompt}: " -NoNewline
    }
    
    $input = Read-Host
    if ([string]::IsNullOrWhiteSpace($input) -and $Default) {
        return $Default
    }
    return $input
}

function Read-DirectoryPath {
    param([string]$Prompt)
    
    while ($true) {
        $path = Read-UserInput -Prompt $Prompt -Default (Get-Location).Path
        
        if (Test-Path $path -PathType Container) {
            return (Resolve-Path $path).Path
        }
        
        Write-Error "Directory does not exist: $path"
        $create = Read-UserInput -Prompt "Create it? (y/n)" -Default "n"
        if ($create -eq 'y') {
            try {
                New-Item -Path $path -ItemType Directory -Force | Out-Null
                return (Resolve-Path $path).Path
            } catch {
                Write-Error "Failed to create directory: $_"
            }
        }
    }
}

function Read-ProjectName {
    while ($true) {
        $name = Read-UserInput -Prompt "Project name"
        
        if ([string]::IsNullOrWhiteSpace($name)) {
            Write-Error "Project name cannot be empty"
            continue
        }
        
        # Validate name (alphanumeric, hyphens, underscores)
        if ($name -notmatch '^[a-zA-Z][a-zA-Z0-9_-]*$') {
            Write-Error "Invalid name. Use letters, numbers, hyphens, underscores. Start with a letter."
            continue
        }
        
        return $name
    }
}

function Select-Methodology {
    Write-Host "`nAvailable Methodologies:" -ForegroundColor White
    Write-Host ""
    
    Write-Host "  [1] " -ForegroundColor Yellow -NoNewline
    Write-Host "FULL" -ForegroundColor Green -NoNewline
    Write-Host " - Enterprise methodology"
    Write-Host "      " -NoNewline
    Write-Host "Block-based architecture, 4 agent roles (Architect, SDET, Engineer, Principal)" -ForegroundColor DarkGray
    Write-Host "      " -NoNewline
    Write-Host "TDD workflow, isolated components, comprehensive documentation" -ForegroundColor DarkGray
    Write-Host "      " -NoNewline
    Write-Host "Best for: Large projects, microservices, team collaboration" -ForegroundColor DarkGray
    
    Write-Host ""
    
    Write-Host "  [2] " -ForegroundColor Yellow -NoNewline
    Write-Host "RAPID" -ForegroundColor Cyan -NoNewline
    Write-Host " - Startup methodology"
    Write-Host "      " -NoNewline
    Write-Host "Unified src/ structure, 3 agent roles (Architect, Engineer, SDET)" -ForegroundColor DarkGray
    Write-Host "      " -NoNewline
    Write-Host "Faster iteration, simpler setup, less ceremony" -ForegroundColor DarkGray
    Write-Host "      " -NoNewline
    Write-Host "Best for: MVPs, prototypes, small projects" -ForegroundColor DarkGray
    
    Write-Host ""
    
    while ($true) {
        $choice = Read-UserInput -Prompt "Select methodology (1 or 2)" -Default "2"
        
        switch ($choice) {
            "1" { return "FULL" }
            "2" { return "RAPID" }
            "FULL" { return "FULL" }
            "RAPID" { return "RAPID" }
            default {
                Write-Error "Invalid choice. Enter 1, 2, FULL, or RAPID"
            }
        }
    }
}

function Confirm-GitHubIntegration {
    Write-Host "`nGitHub Integration:" -ForegroundColor White
    
    # Check if gh CLI is available
    $ghAvailable = $null -ne (Get-Command gh -ErrorAction SilentlyContinue)
    
    if (-not $ghAvailable) {
        Write-Warning "GitHub CLI (gh) not found. GitHub integration will be skipped."
        Write-Host "      Install from: https://cli.github.com/" -ForegroundColor DarkGray
        return $false
    }
    
    # Check authentication status
    try {
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Not authenticated with GitHub CLI."
            Write-Host "      Run 'gh auth login' to authenticate." -ForegroundColor DarkGray
            return $false
        }
        Write-Success "GitHub CLI authenticated"
    } catch {
        Write-Warning "Could not check GitHub authentication."
        return $false
    }
    
    $enable = Read-UserInput -Prompt "Create GitHub repository? (y/n)" -Default "y"
    return ($enable -eq 'y' -or $enable -eq 'Y')
}

function Show-Summary {
    param(
        [string]$ProjectPath,
        [string]$ProjectName,
        [string]$Methodology,
        [bool]$GitHubEnabled
    )
    
    Write-Host "`n" + ("=" * 50) -ForegroundColor DarkGray
    Write-Host "Configuration Summary" -ForegroundColor White
    Write-Host ("=" * 50) -ForegroundColor DarkGray
    
    Write-Host "  Project Name:  " -NoNewline
    Write-Host $ProjectName -ForegroundColor Green
    
    Write-Host "  Location:      " -NoNewline
    Write-Host $ProjectPath -ForegroundColor Green
    
    Write-Host "  Methodology:   " -NoNewline
    Write-Host $Methodology -ForegroundColor Green
    
    Write-Host "  GitHub:        " -NoNewline
    if ($GitHubEnabled) {
        Write-Host "Yes (will create repository)" -ForegroundColor Green
    } else {
        Write-Host "No" -ForegroundColor Yellow
    }
    
    Write-Host ("=" * 50) -ForegroundColor DarkGray
    
    $confirm = Read-UserInput -Prompt "`nProceed with these settings? (y/n)" -Default "y"
    return ($confirm -eq 'y' -or $confirm -eq 'Y')
}

# ============================================================================
# PROJECT CREATION FUNCTIONS
# ============================================================================

function Copy-MethodologyTemplate {
    param(
        [string]$Methodology,
        [string]$TargetPath
    )
    
    $sourcePath = Join-Path $Script:SourcePath "${Methodology}_METHODOLOGY"
    
    if (-not (Test-Path $sourcePath)) {
        throw "Methodology template not found: $sourcePath"
    }
    
    Write-Info "Copying $Methodology methodology template..."
    
    # Copy all files and directories
    Copy-Item -Path "$sourcePath\*" -Destination $TargetPath -Recurse -Force
    
    Write-Success "Template copied"
}

function Initialize-GitRepository {
    param(
        [string]$ProjectPath,
        [string]$ProjectName,
        [bool]$CreateRemote
    )
    
    Push-Location $ProjectPath
    
    try {
        Write-Info "Initializing Git repository..."
        git init --quiet
        git add .
        git commit -m "Initial commit: APM project setup" --quiet
        Write-Success "Git repository initialized"
        
        if ($CreateRemote) {
            Write-Info "Creating GitHub repository..."
            gh repo create $ProjectName --private --source=. --push
            Write-Success "GitHub repository created and pushed"
        }
    } catch {
        Write-Error "Git operation failed: $_"
    } finally {
        Pop-Location
    }
}

function Rename-ProjectPlaceholders {
    param(
        [string]$ProjectPath,
        [string]$ProjectName
    )
    
    # Rename {project-name} directory if exists (FULL methodology)
    $placeholderDir = Join-Path $ProjectPath "{project-name}"
    if (Test-Path $placeholderDir) {
        $newDir = Join-Path $ProjectPath $ProjectName
        Rename-Item -Path $placeholderDir -NewName $ProjectName
        Write-Info "Renamed project directory to: $ProjectName"
    }
    
    # Update project name in ARCHITECTURE.md
    $archFile = Join-Path $ProjectPath "ARCHITECTURE.md"
    if (Test-Path $archFile) {
        $content = Get-Content $archFile -Raw
        $content = $content -replace '\[Project Name\]', $ProjectName
        Set-Content -Path $archFile -Value $content
        Write-Info "Updated ARCHITECTURE.md with project name"
    }
}

function Open-Cursor {
    param([string]$ProjectPath)
    
    $open = Read-UserInput -Prompt "`nOpen project in Cursor? (y/n)" -Default "y"
    
    if ($open -eq 'y' -or $open -eq 'Y') {
        try {
            # Try cursor command first
            $cursorCmd = Get-Command cursor -ErrorAction SilentlyContinue
            if ($cursorCmd) {
                Write-Info "Opening Cursor..."
                Start-Process cursor -ArgumentList $ProjectPath
                return
            }
            
            # Try code command as fallback (VS Code)
            $codeCmd = Get-Command code -ErrorAction SilentlyContinue
            if ($codeCmd) {
                Write-Warning "Cursor not found, opening VS Code..."
                Start-Process code -ArgumentList $ProjectPath
                return
            }
            
            Write-Warning "Neither Cursor nor VS Code found in PATH"
            Write-Host "      Open the project manually: $ProjectPath" -ForegroundColor DarkGray
        } catch {
            Write-Error "Failed to open editor: $_"
        }
    }
}

# ============================================================================
# MAIN FUNCTION
# ============================================================================

function Main {
    # Handle help and version flags
    if ($Help) {
        Write-Host @"
APM (Agentic Project Management) - Project Configurator

Usage: .\apm.ps1 [options]

Options:
    -Help           Show this help message
    -Version        Show version information

Non-Interactive Mode (for automation/testing):
    -ProjectName    Name of the project to create
    -ProjectPath    Parent directory where project will be created
    -Methodology    FULL or RAPID
    -SkipGitHub     Skip GitHub repository creation
    -SkipCursor     Skip opening Cursor IDE
    -Force          Overwrite existing project without prompting
    -NonInteractive Run without any user prompts

Example:
    .\apm.ps1 -ProjectName "my-app" -ProjectPath "C:\Projects" -Methodology RAPID -NonInteractive -SkipGitHub -SkipCursor

This interactive wizard will guide you through creating a new APM project.
"@
        return
    }
    
    if ($Version) {
        Write-Host "APM v$($Script:AppVersion)"
        return
    }
    
    # Verify source path exists
    if (-not (Test-Path $Script:SourcePath)) {
        Write-Error "APM source templates not found at: $Script:SourcePath"
        Write-Host "Make sure apm_source directory is in the correct location." -ForegroundColor DarkGray
        exit 1
    }
    
    # Check if running in non-interactive mode
    if ($NonInteractive) {
        # Validate required parameters for non-interactive mode
        if ([string]::IsNullOrWhiteSpace($ProjectName)) {
            Write-Error "-ProjectName is required in non-interactive mode"
            exit 1
        }
        if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
            Write-Error "-ProjectPath is required in non-interactive mode"
            exit 1
        }
        if ([string]::IsNullOrWhiteSpace($Methodology)) {
            Write-Error "-Methodology is required in non-interactive mode"
            exit 1
        }
        
        # Resolve paths
        if (-not (Test-Path $ProjectPath -PathType Container)) {
            Write-Error "Project path does not exist: $ProjectPath"
            exit 1
        }
        $directory = (Resolve-Path $ProjectPath).Path
        $projectName = $ProjectName
        $methodology = $Methodology
        $githubEnabled = -not $SkipGitHub
        $projectPath = Join-Path $directory $projectName
        
        Write-Info "Non-interactive mode: Creating $methodology project '$projectName'"
        
        # Check if project exists
        if (Test-Path $projectPath) {
            if ($Force) {
                Write-Warning "Overwriting existing project: $projectPath"
                Remove-Item -Path $projectPath -Recurse -Force
            } else {
                Write-Error "Project already exists: $projectPath. Use -Force to overwrite."
                exit 1
            }
        }
    } else {
        # Interactive mode
        Clear-Host
        Show-Banner
        
        # Step 1: Get project directory
        Write-Step "Step 1: Project Location"
        $directory = Read-DirectoryPath -Prompt "Parent directory for the project"
        
        # Step 2: Get project name
        Write-Step "Step 2: Project Name"
        $projectName = Read-ProjectName
        
        # Check if project already exists
        $projectPath = Join-Path $directory $projectName
        if (Test-Path $projectPath) {
            Write-Error "A folder named '$projectName' already exists at this location."
            $overwrite = Read-UserInput -Prompt "Overwrite? (y/n)" -Default "n"
            if ($overwrite -ne 'y') {
                Write-Host "`nAborted." -ForegroundColor Yellow
                exit 0
            }
            Remove-Item -Path $projectPath -Recurse -Force
        }
        
        # Step 3: Select methodology
        Write-Step "Step 3: Select Methodology"
        $methodology = Select-Methodology
        
        # Step 4: GitHub integration
        Write-Step "Step 4: GitHub Integration"
        $githubEnabled = Confirm-GitHubIntegration
        
        # Show summary and confirm
        if (-not (Show-Summary -ProjectPath $projectPath -ProjectName $projectName -Methodology $methodology -GitHubEnabled $githubEnabled)) {
            Write-Host "`nAborted." -ForegroundColor Yellow
            exit 0
        }
    }
    
    # Create project
    Write-Host "`n"
    Write-Step "Creating Project..."
    
    try {
        # Create project directory
        New-Item -Path $projectPath -ItemType Directory -Force | Out-Null
        Write-Success "Created project directory"
        
        # Copy methodology template
        Copy-MethodologyTemplate -Methodology $methodology -TargetPath $projectPath
        
        # Rename placeholders
        Rename-ProjectPlaceholders -ProjectPath $projectPath -ProjectName $projectName
        
        # Initialize git
        Initialize-GitRepository -ProjectPath $projectPath -ProjectName $projectName -CreateRemote $githubEnabled
        
    } catch {
        Write-Error "Project creation failed: $_"
        exit 1
    }
    
    # Success message
    Write-Host "`n" + ("=" * 50) -ForegroundColor Green
    Write-Host "Project created successfully!" -ForegroundColor Green
    Write-Host ("=" * 50) -ForegroundColor Green
    Write-Host "`nLocation: $projectPath" -ForegroundColor White
    Write-Host "`nNext steps:" -ForegroundColor White
    Write-Host "  1. Open the project in Cursor"
    Write-Host "  2. Run " -NoNewline
    Write-Host "/apm-start" -ForegroundColor Yellow -NoNewline
    Write-Host " and describe your project idea"
    Write-Host "  3. The System Architect will guide you through the setup"
    Write-Host ""
    
    # Offer to open Cursor (skip in non-interactive mode or if SkipCursor is set)
    if (-not $NonInteractive -and -not $SkipCursor) {
        Open-Cursor -ProjectPath $projectPath
    } elseif ($NonInteractive) {
        Write-Info "Skipping Cursor launch (non-interactive mode)"
    }
    
    Write-Host "`nHappy coding!" -ForegroundColor Cyan
}

# Run main
Main

