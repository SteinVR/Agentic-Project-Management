# Install APM Codex assets into ~/.codex or a local .codex directory.
# Assets include:
# - skills
# - subagent role configs (agents/*.toml)
# - non-destructive merge of APM blocks into config.toml

param(
  [switch]$Local,
  [switch]$Global,
  [string]$Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "../..")
$SkillsDir = Join-Path $RepoRoot "apm_source/skills"
$CodexAgentsDir = Join-Path $RepoRoot "apm_source/packs/codex_pack"
if (-not (Test-Path $CodexAgentsDir)) {
  $LegacyCodexAgentsDir = Join-Path $RepoRoot "apm_source/codex_agents"
  if (Test-Path $LegacyCodexAgentsDir) {
    Write-Warning "Using legacy Codex path: apm_source/codex_agents"
    $CodexAgentsDir = $LegacyCodexAgentsDir
  }
}
$AgentsSourceDir = Join-Path $CodexAgentsDir "agents"
$ConfigSourceFile = Join-Path $CodexAgentsDir "config.toml"

if (-not (Test-Path $SkillsDir)) {
  Write-Error "Codex skills not found: $SkillsDir"
  exit 1
}
if (-not (Test-Path $AgentsSourceDir)) {
  Write-Error "Codex agents not found: $AgentsSourceDir"
  exit 1
}
if (-not (Test-Path $ConfigSourceFile)) {
  Write-Error "Codex config source not found: $ConfigSourceFile"
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
$agentsTarget = Join-Path $CodexDir "agents"
$targetConfigFile = Join-Path $CodexDir "config.toml"
New-Item -ItemType Directory -Force -Path $skillsTarget, $agentsTarget | Out-Null

Copy-Item -Recurse -Force (Join-Path $SkillsDir "*") $skillsTarget
Copy-Item -Recurse -Force (Join-Path $AgentsSourceDir "*") $agentsTarget

function Ensure-TrailingNewLine {
  param([string]$Text)
  if ([string]::IsNullOrEmpty($Text)) {
    return ""
  }
  if ($Text.EndsWith("`n")) {
    return $Text
  }
  return "$Text`r`n"
}

function Ensure-KeyInSection {
  param(
    [string]$Content,
    [string]$Section,
    [string]$Key,
    [string]$ValueLine
  )

  $sectionEsc = [regex]::Escape($Section)
  $sectionPattern = "(?ms)^\[$sectionEsc\]\s*\r?\n(.*?)(?=^\[[^\]]+\]\s*$|\z)"
  $keyPattern = "(?m)^\s*$([regex]::Escape($Key))\s*="

  if ([regex]::IsMatch($Content, $sectionPattern)) {
    $sectionMatch = [regex]::Match($Content, $sectionPattern)
    if (-not [regex]::IsMatch($sectionMatch.Groups[1].Value, $keyPattern)) {
      $headerPattern = "(?m)^\[$sectionEsc\]\s*$"
      $headerRegex = [regex]::new($headerPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
      $Content = $headerRegex.Replace(
        $Content,
        { param($match) "$($match.Value)`r`n$ValueLine" },
        1
      )
    }
    return $Content
  }

  $Content = Ensure-TrailingNewLine $Content
  if ($Content.Length -gt 0) {
    $Content += "`r`n"
  }
  $Content += "[$Section]`r`n$ValueLine`r`n"
  return $Content
}

function Get-SectionBlock {
  param(
    [string]$SourceContent,
    [string]$Section
  )

  $sectionEsc = [regex]::Escape($Section)
  $pattern = "(?ms)^\[$sectionEsc\]\s*\r?\n.*?(?=^\[[^\]]+\]\s*$|\z)"
  $sectionMatch = [regex]::Match($SourceContent, $pattern)
  if ($sectionMatch.Success) {
    return $sectionMatch.Value.TrimEnd("`r", "`n")
  }
  return $null
}

function Ensure-SectionBlock {
  param(
    [string]$Content,
    [string]$Section,
    [string]$Block
  )

  $sectionEsc = [regex]::Escape($Section)
  $headerPattern = "(?m)^\[$sectionEsc\]\s*$"
  if ([regex]::IsMatch($Content, $headerPattern)) {
    return $Content
  }

  $Content = Ensure-TrailingNewLine $Content
  if ($Content.Length -gt 0) {
    $Content += "`r`n"
  }
  $Content += "$Block`r`n"
  return $Content
}

$sourceConfigContent = Get-Content -Path $ConfigSourceFile -Raw -Encoding UTF8
$targetConfigContent = ""
if (Test-Path $targetConfigFile) {
  $targetConfigContent = Get-Content -Path $targetConfigFile -Raw -Encoding UTF8
}

$targetConfigContent = Ensure-KeyInSection $targetConfigContent "features" "multi_agent" "multi_agent = true"
$targetConfigContent = Ensure-KeyInSection $targetConfigContent "agents" "max_threads" "max_threads = 6"

$roleSections = @(
  "agents.apm-architect",
  "agents.apm-engineer",
  "agents.apm-sdet",
  "agents.apm-data-scientist"
)

foreach ($roleSection in $roleSections) {
  $block = Get-SectionBlock $sourceConfigContent $roleSection
  if ([string]::IsNullOrWhiteSpace($block)) {
    Write-Warning "Missing section in source config: [$roleSection]"
    continue
  }
  $targetConfigContent = Ensure-SectionBlock $targetConfigContent $roleSection $block
}

Set-Content -Path $targetConfigFile -Value $targetConfigContent -Encoding UTF8

Write-Host "APM Codex assets installed to $CodexDir"
Write-Host "  - skills: $skillsTarget"
Write-Host "  - agents: $agentsTarget"
Write-Host "  - config: $targetConfigFile"
