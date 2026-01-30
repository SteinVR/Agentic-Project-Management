# Install APM OpenCode pack into ~/.config/opencode

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$PackDir = Join-Path $RepoRoot "apm_source/cli_ide/apm_opencode_pack"

if (-not (Test-Path $PackDir)) {
  Write-Error "Pack not found: $PackDir"
  exit 1
}

$OpenCodeDir = Join-Path $HOME ".config/opencode"
$agentsDir = Join-Path $OpenCodeDir "agents"
$commandsDir = Join-Path $OpenCodeDir "commands"
$skillsDir = Join-Path $OpenCodeDir "skills"
$toolsDir = Join-Path $OpenCodeDir "tools"

New-Item -ItemType Directory -Force -Path $agentsDir, $commandsDir, $skillsDir, $toolsDir | Out-Null

Copy-Item -Recurse -Force (Join-Path $PackDir "agent/*") $agentsDir
Copy-Item -Recurse -Force (Join-Path $PackDir "command/*") $commandsDir
Copy-Item -Recurse -Force (Join-Path $PackDir "skill/*") $skillsDir
Copy-Item -Recurse -Force (Join-Path $PackDir "tools/*") $toolsDir

Write-Host "APM OpenCode pack installed to $OpenCodeDir"
