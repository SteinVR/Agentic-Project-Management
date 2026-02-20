# Install APM OpenCode pack into ~/.config/opencode or a local .opencode directory

param(
  [switch]$Local,
  [switch]$Global,
  [string]$Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../..")
$PackDir = Join-Path $RepoRoot "apm_source/opencode_pack"
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
$commandsDir = Join-Path $OpenCodeDir "commands"
$skillsDir = Join-Path $OpenCodeDir "skills"
$toolsDir = Join-Path $OpenCodeDir "tools"

New-Item -ItemType Directory -Force -Path $agentsDir, $commandsDir, $skillsDir, $toolsDir | Out-Null

Copy-Item -Recurse -Force (Join-Path $PackDir "agent/*") $agentsDir
Copy-Item -Recurse -Force (Join-Path $PackDir "command/*") $commandsDir
Copy-Item -Recurse -Force (Join-Path $PackDir "tools/*") $toolsDir
Copy-Item -Recurse -Force (Join-Path $SkillsSourceDir "*") $skillsDir

Write-Host "APM OpenCode pack installed to $OpenCodeDir"
