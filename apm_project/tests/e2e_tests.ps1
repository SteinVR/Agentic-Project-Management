#!/usr/bin/env pwsh
<#
.SYNOPSIS
    APM E2E Tests - End-to-End testing for project deployment
.DESCRIPTION
    Comprehensive E2E tests for APM project creation via apm.ps1 script.
    Tests both RAPID and FULL methodologies.
.NOTES
    Author: APM Team
    Version: 1.0.0
#>

param(
    [switch]$Verbose,
    [switch]$KeepTestProjects,
    [ValidateSet("All", "RAPID", "FULL")]
    [string]$TestSuite = "All"
)

$ErrorActionPreference = 'Stop'
$Script:TestsRun = 0
$Script:TestsPassed = 0
$Script:TestsFailed = 0
$Script:FailedTests = @()

# ============================================================================
# TEST UTILITIES
# ============================================================================

function Write-TestHeader {
    param([string]$Title)
    Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor White
    Write-Host ("=" * 60) -ForegroundColor Cyan
}

function Write-TestName {
    param([string]$Name)
    Write-Host "`n  [TEST] " -ForegroundColor Yellow -NoNewline
    Write-Host $Name -ForegroundColor White
}

function Write-TestPass {
    param([string]$Message)
    $Script:TestsRun++
    $Script:TestsPassed++
    Write-Host "    [PASS] " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-TestFail {
    param([string]$Message, [string]$TestName = "Unknown")
    $Script:TestsRun++
    $Script:TestsFailed++
    $Script:FailedTests += $TestName
    Write-Host "    [FAIL] " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

function Write-TestInfo {
    param([string]$Message)
    if ($Verbose) {
        Write-Host "    [INFO] " -ForegroundColor Cyan -NoNewline
        Write-Host $Message
    }
}

function Assert-PathExists {
    param(
        [string]$Path,
        [string]$Description,
        [string]$TestContext
    )
    
    if (Test-Path $Path) {
        Write-TestPass "$Description exists"
        return $true
    } else {
        Write-TestFail "$Description does not exist: $Path" -TestName $TestContext
        return $false
    }
}

function Assert-PathNotExists {
    param(
        [string]$Path,
        [string]$Description,
        [string]$TestContext
    )
    
    if (-not (Test-Path $Path)) {
        Write-TestPass "$Description does not exist (expected)"
        return $true
    } else {
        Write-TestFail "$Description should not exist: $Path" -TestName $TestContext
        return $false
    }
}

function Assert-FileContains {
    param(
        [string]$FilePath,
        [string]$Pattern,
        [string]$Description,
        [string]$TestContext
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-TestFail "File not found: $FilePath" -TestName $TestContext
        return $false
    }
    
    $content = Get-Content $FilePath -Raw
    if ($content -match $Pattern) {
        Write-TestPass "$Description - pattern found"
        return $true
    } else {
        Write-TestFail "$Description - pattern not found: $Pattern" -TestName $TestContext
        return $false
    }
}

function Assert-DirectoryNotEmpty {
    param(
        [string]$Path,
        [string]$Description,
        [string]$TestContext
    )
    
    if (-not (Test-Path $Path -PathType Container)) {
        Write-TestFail "Directory not found: $Path" -TestName $TestContext
        return $false
    }
    
    $items = Get-ChildItem $Path -Force
    if ($items.Count -gt 0) {
        Write-TestPass "$Description is not empty ($($items.Count) items)"
        return $true
    } else {
        Write-TestFail "$Description is empty" -TestName $TestContext
        return $false
    }
}

# ============================================================================
# TEST SETUP & TEARDOWN
# ============================================================================

function Initialize-TestEnvironment {
    $testDir = Join-Path ([System.IO.Path]::GetTempPath()) "apm_e2e_tests_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -Path $testDir -ItemType Directory -Force | Out-Null
    Write-TestInfo "Created test directory: $testDir"
    return $testDir
}

function Remove-TestEnvironment {
    param([string]$TestDir)
    
    if (-not $KeepTestProjects -and (Test-Path $TestDir)) {
        Remove-Item -Path $TestDir -Recurse -Force
        Write-TestInfo "Cleaned up test directory: $TestDir"
    } elseif ($KeepTestProjects) {
        Write-Host "`n  Test projects preserved at: $TestDir" -ForegroundColor Yellow
    }
}

# ============================================================================
# RAPID METHODOLOGY TESTS
# ============================================================================

function Test-RapidMethodologyDeployment {
    param([string]$TestDir)
    
    Write-TestHeader "RAPID Methodology Deployment Tests"
    
    $projectName = "test-rapid-project"
    $projectPath = Join-Path $TestDir $projectName
    $apmScript = Join-Path $PSScriptRoot "..\apm.ps1"
    
    Write-TestName "Creating RAPID project via apm.ps1"
    
    # Run apm.ps1 in non-interactive mode
    try {
        & $apmScript `
            -ProjectName $projectName `
            -ProjectPath $TestDir `
            -Methodology "RAPID" `
            -NonInteractive `
            -SkipGitHub `
            -SkipCursor `
            -Force
        
        Write-TestPass "apm.ps1 executed successfully"
    } catch {
        Write-TestFail "apm.ps1 execution failed: $_" -TestName "RAPID-Creation"
        return
    }
    
    # Test project root structure
    Write-TestName "Verifying RAPID project root structure"
    Assert-PathExists -Path $projectPath -Description "Project root" -TestContext "RAPID-Root"
    Assert-PathExists -Path (Join-Path $projectPath "ARCHITECTURE.md") -Description "ARCHITECTURE.md" -TestContext "RAPID-Architecture"
    Assert-PathExists -Path (Join-Path $projectPath "TASK.md") -Description "TASK.md" -TestContext "RAPID-Task"
    Assert-PathExists -Path (Join-Path $projectPath "src") -Description "src directory" -TestContext "RAPID-Src"
    Assert-PathExists -Path (Join-Path $projectPath "logs") -Description "logs directory" -TestContext "RAPID-Logs"
    Assert-PathExists -Path (Join-Path $projectPath "tests") -Description "tests directory" -TestContext "RAPID-Tests"
    Assert-PathExists -Path (Join-Path $projectPath "external") -Description "external directory" -TestContext "RAPID-External"
    
    # Test .apm directory structure
    Write-TestName "Verifying RAPID .apm directory structure"
    $apmDir = Join-Path $projectPath ".apm"
    Assert-PathExists -Path $apmDir -Description ".apm directory" -TestContext "RAPID-APM"
    Assert-PathExists -Path (Join-Path $apmDir "AGENT_DROLES") -Description "AGENT_DROLES directory" -TestContext "RAPID-AgentRoles"
    Assert-PathExists -Path (Join-Path $apmDir "AGENT_REPORTS") -Description "AGENT_REPORTS directory" -TestContext "RAPID-AgentReports"
    Assert-PathExists -Path (Join-Path $apmDir "AGENT_TOOLS") -Description "AGENT_TOOLS directory" -TestContext "RAPID-AgentTools"
    
    # Test agent role files
    Write-TestName "Verifying RAPID agent role files"
    $rolesDir = Join-Path $apmDir "AGENT_DROLES"
    Assert-PathExists -Path (Join-Path $rolesDir "System_Architect.md") -Description "System_Architect.md" -TestContext "RAPID-Architect"
    Assert-PathExists -Path (Join-Path $rolesDir "Lead_Engineer.md") -Description "Lead_Engineer.md" -TestContext "RAPID-Engineer"
    Assert-PathExists -Path (Join-Path $rolesDir "SDET.md") -Description "SDET.md" -TestContext "RAPID-SDET"
    
    # Test .cursor directory structure
    Write-TestName "Verifying RAPID .cursor commands"
    $cursorDir = Join-Path $projectPath ".cursor"
    $commandsDir = Join-Path $cursorDir "commands"
    Assert-PathExists -Path $cursorDir -Description ".cursor directory" -TestContext "RAPID-Cursor"
    Assert-PathExists -Path $commandsDir -Description "commands directory" -TestContext "RAPID-Commands"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-start.md") -Description "apm-start.md" -TestContext "RAPID-StartCmd"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-develop.md") -Description "apm-develop.md" -TestContext "RAPID-DevelopCmd"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-architect.md") -Description "apm-architect.md" -TestContext "RAPID-ArchitectCmd"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-tester.md") -Description "apm-tester.md" -TestContext "RAPID-TesterCmd"
    
    # Test Git repository
    Write-TestName "Verifying Git repository initialization"
    $gitDir = Join-Path $projectPath ".git"
    Assert-PathExists -Path $gitDir -Description ".git directory" -TestContext "RAPID-Git"
    
    # Verify no placeholder directories remain
    Write-TestName "Verifying no placeholder artifacts"
    Assert-PathNotExists -Path (Join-Path $projectPath "{project-name}") -Description "{project-name} placeholder" -TestContext "RAPID-NoPlaceholder"
}

# ============================================================================
# FULL METHODOLOGY TESTS
# ============================================================================

function Test-FullMethodologyDeployment {
    param([string]$TestDir)
    
    Write-TestHeader "FULL Methodology Deployment Tests"
    
    $projectName = "test-full-project"
    $projectPath = Join-Path $TestDir $projectName
    $apmScript = Join-Path $PSScriptRoot "..\apm.ps1"
    
    Write-TestName "Creating FULL project via apm.ps1"
    
    # Run apm.ps1 in non-interactive mode
    try {
        & $apmScript `
            -ProjectName $projectName `
            -ProjectPath $TestDir `
            -Methodology "FULL" `
            -NonInteractive `
            -SkipGitHub `
            -SkipCursor `
            -Force
        
        Write-TestPass "apm.ps1 executed successfully"
    } catch {
        Write-TestFail "apm.ps1 execution failed: $_" -TestName "FULL-Creation"
        return
    }
    
    # Test project root structure
    Write-TestName "Verifying FULL project root structure"
    Assert-PathExists -Path $projectPath -Description "Project root" -TestContext "FULL-Root"
    Assert-PathExists -Path (Join-Path $projectPath "ARCHITECTURE.md") -Description "ARCHITECTURE.md" -TestContext "FULL-Architecture"
    Assert-PathExists -Path (Join-Path $projectPath "WORKFLOW.md") -Description "WORKFLOW.md" -TestContext "FULL-Workflow"
    Assert-PathExists -Path (Join-Path $projectPath "external") -Description "external directory" -TestContext "FULL-External"
    
    # Test project name directory (renamed from {project-name})
    Write-TestName "Verifying FULL project name directory structure"
    $projectSubDir = Join-Path $projectPath $projectName
    Assert-PathExists -Path $projectSubDir -Description "Project name directory" -TestContext "FULL-ProjectDir"
    
    # Test block structure
    Write-TestName "Verifying FULL block structure"
    $block1 = Join-Path $projectSubDir "{BLOCK-1-name}"
    $block2 = Join-Path $projectSubDir "{BLOCK-2-name}"
    $block3 = Join-Path $projectSubDir "{BLOCK-3-name}"
    
    Assert-PathExists -Path $block1 -Description "BLOCK-1 directory" -TestContext "FULL-Block1"
    Assert-PathExists -Path $block2 -Description "BLOCK-2 directory" -TestContext "FULL-Block2"
    Assert-PathExists -Path $block3 -Description "BLOCK-3 directory" -TestContext "FULL-Block3"
    
    # Test block internal structure
    Write-TestName "Verifying FULL block internal structure"
    foreach ($block in @($block1, $block2, $block3)) {
        $blockName = Split-Path $block -Leaf
        Assert-PathExists -Path (Join-Path $block "src") -Description "$blockName/src" -TestContext "FULL-BlockSrc"
        Assert-PathExists -Path (Join-Path $block "logs") -Description "$blockName/logs" -TestContext "FULL-BlockLogs"
        Assert-PathExists -Path (Join-Path $block "tests") -Description "$blockName/tests" -TestContext "FULL-BlockTests"
        Assert-PathExists -Path (Join-Path $block "task.md") -Description "$blockName/task.md" -TestContext "FULL-BlockTask"
    }
    
    # Test .apm directory structure
    Write-TestName "Verifying FULL .apm directory structure"
    $apmDir = Join-Path $projectPath ".apm"
    Assert-PathExists -Path $apmDir -Description ".apm directory" -TestContext "FULL-APM"
    Assert-PathExists -Path (Join-Path $apmDir "AGENT_DROLES") -Description "AGENT_DROLES directory" -TestContext "FULL-AgentRoles"
    Assert-PathExists -Path (Join-Path $apmDir "AGENT_REPORTS") -Description "AGENT_REPORTS directory" -TestContext "FULL-AgentReports"
    Assert-PathExists -Path (Join-Path $apmDir "MEMORY") -Description "MEMORY directory" -TestContext "FULL-Memory"
    
    # Test FULL-specific agent role files (4 roles including Principal Engineer)
    Write-TestName "Verifying FULL agent role files"
    $rolesDir = Join-Path $apmDir "AGENT_DROLES"
    Assert-PathExists -Path (Join-Path $rolesDir "System_Architect.md") -Description "System_Architect.md" -TestContext "FULL-Architect"
    Assert-PathExists -Path (Join-Path $rolesDir "Lead-Engineer.md") -Description "Lead-Engineer.md" -TestContext "FULL-LeadEngineer"
    Assert-PathExists -Path (Join-Path $rolesDir "Principal-Engineer.md") -Description "Principal-Engineer.md" -TestContext "FULL-PrincipalEngineer"
    Assert-PathExists -Path (Join-Path $rolesDir "SDET.md") -Description "SDET.md" -TestContext "FULL-SDET"
    
    # Test .cursor directory structure
    Write-TestName "Verifying FULL .cursor commands"
    $cursorDir = Join-Path $projectPath ".cursor"
    $commandsDir = Join-Path $cursorDir "commands"
    Assert-PathExists -Path $cursorDir -Description ".cursor directory" -TestContext "FULL-Cursor"
    Assert-PathExists -Path $commandsDir -Description "commands directory" -TestContext "FULL-Commands"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-start.md") -Description "apm-start.md" -TestContext "FULL-StartCmd"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-develop.md") -Description "apm-develop.md" -TestContext "FULL-DevelopCmd"
    Assert-PathExists -Path (Join-Path $commandsDir "apm-principal.md") -Description "apm-principal.md" -TestContext "FULL-PrincipalCmd"
    
    # Test Git repository
    Write-TestName "Verifying Git repository initialization"
    $gitDir = Join-Path $projectPath ".git"
    Assert-PathExists -Path $gitDir -Description ".git directory" -TestContext "FULL-Git"
    
    # Verify placeholder was renamed correctly
    Write-TestName "Verifying placeholder renaming"
    Assert-PathNotExists -Path (Join-Path $projectPath "{project-name}") -Description "{project-name} placeholder" -TestContext "FULL-NoPlaceholder"
}

# ============================================================================
# ADDITIONAL VALIDATION TESTS
# ============================================================================

function Test-ProjectOverwrite {
    param([string]$TestDir)
    
    Write-TestHeader "Project Overwrite Tests"
    
    $projectName = "test-overwrite-project"
    $projectPath = Join-Path $TestDir $projectName
    $apmScript = Join-Path $PSScriptRoot "..\apm.ps1"
    
    # Create initial project
    Write-TestName "Creating initial project"
    & $apmScript `
        -ProjectName $projectName `
        -ProjectPath $TestDir `
        -Methodology "RAPID" `
        -NonInteractive `
        -SkipGitHub `
        -SkipCursor
    
    # Add marker file
    $markerFile = Join-Path $projectPath "initial_marker.txt"
    Set-Content -Path $markerFile -Value "This should be removed after overwrite"
    
    # Overwrite with Force
    Write-TestName "Overwriting project with -Force flag"
    try {
        & $apmScript `
            -ProjectName $projectName `
            -ProjectPath $TestDir `
            -Methodology "RAPID" `
            -NonInteractive `
            -SkipGitHub `
            -SkipCursor `
            -Force
        
        Write-TestPass "Project overwritten successfully"
    } catch {
        Write-TestFail "Project overwrite failed: $_" -TestName "Overwrite-Force"
        return
    }
    
    # Verify marker file is gone
    Assert-PathNotExists -Path $markerFile -Description "Marker file after overwrite" -TestContext "Overwrite-Marker"
    
    # Verify project structure is intact
    Assert-PathExists -Path (Join-Path $projectPath "ARCHITECTURE.md") -Description "ARCHITECTURE.md after overwrite" -TestContext "Overwrite-Structure"
}

function Test-ErrorHandling {
    param([string]$TestDir)
    
    Write-TestHeader "Error Handling Tests"
    
    $apmScript = Join-Path $PSScriptRoot "..\apm.ps1"
    
    # Test missing required parameters in non-interactive mode
    Write-TestName "Testing missing ProjectName parameter"
    $errorThrown = $false
    try {
        & $apmScript `
            -ProjectPath $TestDir `
            -Methodology "RAPID" `
            -NonInteractive `
            -SkipGitHub `
            -SkipCursor 2>$null
    } catch {
        $errorThrown = $true
    }
    
    # Check exit code instead if no exception
    if ($LASTEXITCODE -ne 0 -or $errorThrown) {
        Write-TestPass "Error correctly thrown for missing ProjectName"
    } else {
        Write-TestFail "No error thrown for missing ProjectName" -TestName "Error-MissingProjectName"
    }
    
    # Test invalid methodology
    Write-TestName "Testing invalid Methodology parameter"
    $errorThrown = $false
    try {
        & $apmScript `
            -ProjectName "test-invalid" `
            -ProjectPath $TestDir `
            -Methodology "INVALID" `
            -NonInteractive `
            -SkipGitHub `
            -SkipCursor 2>$null
    } catch {
        $errorThrown = $true
    }
    
    if ($errorThrown) {
        Write-TestPass "Error correctly thrown for invalid Methodology"
    } else {
        Write-TestFail "No error thrown for invalid Methodology" -TestName "Error-InvalidMethodology"
    }
}

# ============================================================================
# MAIN TEST RUNNER
# ============================================================================

function Show-TestSummary {
    Write-Host "`n" + ("=" * 60) -ForegroundColor White
    Write-Host "  TEST SUMMARY" -ForegroundColor White
    Write-Host ("=" * 60) -ForegroundColor White
    
    Write-Host "`n  Total Tests: " -NoNewline
    Write-Host $Script:TestsRun -ForegroundColor Cyan
    
    Write-Host "  Passed:      " -NoNewline
    Write-Host $Script:TestsPassed -ForegroundColor Green
    
    Write-Host "  Failed:      " -NoNewline
    if ($Script:TestsFailed -gt 0) {
        Write-Host $Script:TestsFailed -ForegroundColor Red
    } else {
        Write-Host $Script:TestsFailed -ForegroundColor Green
    }
    
    if ($Script:FailedTests.Count -gt 0) {
        Write-Host "`n  Failed Tests:" -ForegroundColor Red
        foreach ($test in $Script:FailedTests) {
            Write-Host "    - $test" -ForegroundColor Red
        }
    }
    
    $passRate = if ($Script:TestsRun -gt 0) { [math]::Round(($Script:TestsPassed / $Script:TestsRun) * 100, 1) } else { 0 }
    Write-Host "`n  Pass Rate:   " -NoNewline
    if ($passRate -eq 100) {
        Write-Host "$passRate%" -ForegroundColor Green
    } elseif ($passRate -ge 80) {
        Write-Host "$passRate%" -ForegroundColor Yellow
    } else {
        Write-Host "$passRate%" -ForegroundColor Red
    }
    
    Write-Host "`n" + ("=" * 60) -ForegroundColor White
    
    return $Script:TestsFailed -eq 0
}

function Main {
    Write-Host "`n"
    Write-Host "  APM E2E Test Suite" -ForegroundColor Cyan
    Write-Host "  ==================" -ForegroundColor Cyan
    Write-Host "  Testing project deployment via apm.ps1" -ForegroundColor DarkGray
    
    # Initialize test environment
    $testDir = Initialize-TestEnvironment
    
    try {
        # Run test suites based on selection
        switch ($TestSuite) {
            "RAPID" {
                Test-RapidMethodologyDeployment -TestDir $testDir
            }
            "FULL" {
                Test-FullMethodologyDeployment -TestDir $testDir
            }
            "All" {
                Test-RapidMethodologyDeployment -TestDir $testDir
                Test-FullMethodologyDeployment -TestDir $testDir
                Test-ProjectOverwrite -TestDir $testDir
                Test-ErrorHandling -TestDir $testDir
            }
        }
    } finally {
        # Cleanup
        Remove-TestEnvironment -TestDir $testDir
    }
    
    # Show summary and exit with appropriate code
    $allPassed = Show-TestSummary
    
    if ($allPassed) {
        Write-Host "  All tests passed!" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "  Some tests failed." -ForegroundColor Red
        exit 1
    }
}

# Run main
Main

