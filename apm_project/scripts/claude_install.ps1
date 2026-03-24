# Install APM Claude Code pack into ~/.claude or a local .claude directory

param(
  [switch]$Local,
  [switch]$Global,
  [string]$Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../..")
$PackDir = Join-Path $RepoRoot "apm_source/packs/claude_pack"
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
  $ClaudeDir = Join-Path $Path ".claude"
} else {
  $ClaudeDir = Join-Path $HOME ".claude"
}

$agentsDir = Join-Path $ClaudeDir "agents"
$skillsDir = Join-Path $ClaudeDir "skills"

New-Item -ItemType Directory -Force -Path $agentsDir, $skillsDir | Out-Null

Copy-Item -Recurse -Force (Join-Path $PackDir "agents/*") $agentsDir
Copy-Item -Recurse -Force (Join-Path $SkillsSourceDir "*") $skillsDir

Write-Host "APM Claude Code pack installed to $ClaudeDir"
