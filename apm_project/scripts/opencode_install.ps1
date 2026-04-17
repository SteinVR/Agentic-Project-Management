# Install APM OpenCode assets into ~/.config/opencode or a local .opencode directory.
# Current OpenCode support ships agents plus shared skills.

param(
  [switch]$Local,
  [switch]$Global,
  [string]$Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../..")
$PackDir = Join-Path $RepoRoot "apm_source/packs/opencode_pack"
if (-not (Test-Path $PackDir)) {
  $LegacyPackDir = Join-Path $RepoRoot "apm_source/opencode_pack"
  if (Test-Path $LegacyPackDir) {
    Write-Warning "Using legacy OpenCode path: apm_source/opencode_pack"
    $PackDir = $LegacyPackDir
  }
}
$SkillsSourceDir = Join-Path $RepoRoot "apm_source/skills"

if (-not (Test-Path $PackDir)) {
  Write-Error "Pack not found: $PackDir"
  exit 1
}
if (-not (Test-Path $SkillsSourceDir)) {
  Write-Error "Skills not found: $SkillsSourceDir"
  exit 1
}

$useLocal = $false
if ($Local) { $useLocal = $true }
if ($Global) { $useLocal = $false }

if ($useLocal) {
  if (-not $Path) { $Path = (Get-Location).Path }
  if (-not (Test-Path $Path)) {
    Write-Error "Project path not found: $Path"
    exit 1
  }
  $OpenCodeDir = Join-Path $Path ".opencode"
} else {
  $OpenCodeDir = Join-Path $HOME ".config/opencode"
}

$agentsDir = Join-Path $OpenCodeDir "agents"
$skillsDir = Join-Path $OpenCodeDir "skills"
$legacyCommandsDir = Join-Path $OpenCodeDir "commands"
$legacyToolsDir = Join-Path $OpenCodeDir "tools"

if (Test-Path $legacyCommandsDir) {
  Remove-Item -Recurse -Force $legacyCommandsDir
}
if (Test-Path $legacyToolsDir) {
  Remove-Item -Recurse -Force $legacyToolsDir
}

New-Item -ItemType Directory -Force -Path $agentsDir, $skillsDir | Out-Null

Copy-Item -Recurse -Force (Join-Path $PackDir "agent/*") $agentsDir
Copy-Item -Recurse -Force (Join-Path $SkillsSourceDir "*") $skillsDir

Write-Host "APM OpenCode assets installed to $OpenCodeDir"
