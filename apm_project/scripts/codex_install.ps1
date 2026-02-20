# Install APM Codex skills into ~/.codex/skills or a local .codex/skills directory

param(
  [switch]$Local,
  [switch]$Global,
  [string]$Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../..")
$SkillsDir = Join-Path $RepoRoot "apm_source/skills"

if (-not (Test-Path $SkillsDir)) {
  Write-Error "Codex skills not found: $SkillsDir"
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
  $CodexDir = Join-Path $Path ".codex"
} else {
  $CodexDir = Join-Path $HOME ".codex"
}

$skillsTarget = Join-Path $CodexDir "skills"
New-Item -ItemType Directory -Force -Path $skillsTarget | Out-Null

Copy-Item -Recurse -Force (Join-Path $SkillsDir "*") $skillsTarget

Write-Host "APM Codex skills installed to $skillsTarget"
