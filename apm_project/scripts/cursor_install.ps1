# Install APM Cursor assets into ~/.cursor or a local .cursor directory.
# Skills are installed globally by default to ~/.cursor/skills.

param(
  [switch]$Local,
  [switch]$Global,
  [string]$Path,
  [switch]$SkipSkills
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../..")
$PackDir = Join-Path $RepoRoot "apm_source/packs/cursor_pack"
$SkillsDir = Join-Path $RepoRoot "apm_source/skills"

if (-not (Test-Path $PackDir)) {
  Write-Error "Cursor pack not found: $PackDir"
  exit 1
}
if (-not $SkipSkills -and -not (Test-Path $SkillsDir)) {
  Write-Error "Skills not found: $SkillsDir"
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
  $CursorDir = Join-Path $Path ".cursor"
} else {
  $CursorDir = Join-Path $HOME ".cursor"
}

$AgentsDir = Join-Path $CursorDir "agents"
$CommandsDir = Join-Path $CursorDir "commands"
New-Item -ItemType Directory -Force -Path $AgentsDir, $CommandsDir | Out-Null

if (Test-Path (Join-Path $PackDir "agents")) {
  Copy-Item -Recurse -Force (Join-Path $PackDir "agents/*") $AgentsDir
}
if (Test-Path (Join-Path $PackDir "commands")) {
  Copy-Item -Recurse -Force (Join-Path $PackDir "commands/*") $CommandsDir
}

if (-not $SkipSkills) {
  $CursorSkillsDir = Join-Path (Join-Path $HOME ".cursor") "skills"
  New-Item -ItemType Directory -Force -Path $CursorSkillsDir | Out-Null
  Copy-Item -Recurse -Force (Join-Path $SkillsDir "*") $CursorSkillsDir
}

Write-Host "APM Cursor pack installed to $CursorDir"
if (-not $SkipSkills) {
  Write-Host "APM skills installed to $HOME/.cursor/skills"
}
