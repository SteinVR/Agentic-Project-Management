<div align="center">

# Agentic Project Management

**AI-driven development framework for Cursor IDE, Codex CLI, and OpenCode CLI**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Linux%20|%20macOS-lightgrey.svg)]()

</div>

---

## Review

APM is a configurable SDD-based framework that brings structure and predictability to LLM-assisted development across Cursor IDE, Codex CLI, and OpenCode CLI. It standardizes project setup, roles, and documentation so teams keep continuity with minimal overhead.

Ideology: configured SDD, only-essential Memory Bank, context engineering, agents and skills, with an emphasis on declarative control, determinism, and token efficiency.

Usage: run the TUI configurator (`apm.sh`) to generate a project, then drive work via environment-specific commands and skills. For automation or CI, use non-interactive flags.

---

## What you get

- CLI configurator for new projects
- Agent roles and commands
- Memory Bank for durable project context
- Templates for specs, tasks, and reports

---

## Environments

- **Cursor IDE** (interactive): full methodology assets, `.cursor/` commands, `.apm/` templates, `memory bank/`.
- **Codex CLI** (global or per-project): skills + subagent roles installed into `.codex/`; APM blocks merged into `.codex/config.toml`; projects use `memory-bank/` and minimal structure.
- **OpenCode CLI** (global or per-project): commands/agents/skills installed into OpenCode; projects use `memory-bank/` and minimal structure.

---

## Quick Start

### 1) Run the configurator

**Linux/macOS (and Windows via WSL/Git Bash):**
```bash
chmod +x ./apm_project/apm.sh
./apm_project/apm.sh
```

### 2) Non-interactive flags

Shorthands are supported:
- `--opencode` / `--codex` / `--cursor`
- `--rapid` / `--ds` / `--full`
- `--local` / `--global` / `--none` (CLI pack install; default is `--none`)

Recommended order for non-interactive usage: **Environment -> Mode -> other flags**.

Defaults:
- `--project-path` defaults to the current directory
- `--project-name` defaults to the current directory name

Example:
```bash
./apm_project/apm.sh --opencode --rapid --project-name "my-app" --project-path "/projects" \
  --non-interactive --skip-cursor
```

In-place (inside an existing project directory):
```bash
./apm_project/apm.sh --opencode --rapid --non-interactive
```

---

## OpenCode install (global or local)

**Global** (applies to all projects):
```bash
./apm_project/scripts/opencode_install.sh --global
```

**Local** (project-only):
```bash
./apm_project/scripts/opencode_install.sh --local /path/to/project
```

PowerShell equivalents:
- `apm_project/scripts/opencode_install.ps1 -Global`
- `apm_project/scripts/opencode_install.ps1 -Local -Path <project>`

---

## Codex install (global or local)

**Global** (applies to all projects):
```bash
./apm_project/scripts/codex_install.sh --global
```

**Local** (project-only):
```bash
./apm_project/scripts/codex_install.sh --local /path/to/project
```

PowerShell equivalents:
- `apm_project/scripts/codex_install.ps1 -Global`
- `apm_project/scripts/codex_install.ps1 -Local -Path <project>`

Codex install adds:
- Skills to `.codex/skills/`
- Subagent role configs to `.codex/agents/`
- Missing APM sections in `.codex/config.toml` (`features.multi_agent`, `agents.max_threads`, `agents.apm-*`)

---

## Alias suggestions

```bash
# run configurator from anywhere
alias apm='/path/to/Agentic-Project-Management/apm_project/apm.sh'

# optional: quick cd into repo
alias apm-cd='cd /path/to/Agentic-Project-Management'
```

---

## Methodologies

- **RAPID**: fast product iterations, minimal ceremony.
- **DS**: data science workflow (EDA -> baseline -> experiments -> evaluation -> finalize).
- **FULL**: deprecated (Cursor-only).

---

## How it works

1. **/apm-start** runs Vision Alignment (RAPID) or Problem Definition (DS).
2. After your confirmation, APM creates the Memory Bank: `ARCHITECTURE.md`, `TASK.md`, `STATE.md`.
3. You continue with role-specific commands/skills (e.g., `/apm-develop`, `apm-eda`, `apm-ds-exp`).
4. Every session ends with an update to `STATE.md` (project continuity).

---

## Example flow

**RAPID:** `/apm-start` -> `/apm-develop` -> `/apm-test` -> `/apm-sync`

**DS:** `/apm-start` -> `/apm-eda` -> `/apm-baseline` -> `/apm-experiment` -> `/apm-review`

---

## Memory Bank

- Cursor projects: `memory bank/` (with space)
- CLI projects (Codex/OpenCode): `memory-bank/` (no space)

Core files:
- `ARCHITECTURE.md`
- `TASK.md`
- `STATE.md`

---

## Commands

### Common

| Command | Description |
|---------|-------------|
| `/apm-start` | Vision Alignment / Problem Definition + Memory Bank initialization + environment proposal |
| `/apm-architect` | Architecture consultation or updates |
| `/apm-review` | Architecture review and recommendations |
| `/apm-sync` | Sync current project state into `STATE.md` |
| `/apm-report` | Generate reports from templates |

### RAPID

| Command | Description |
|---------|-------------|
| `/apm-develop` | Lead Engineer implementation loop |
| `/apm-test` | SDET testing / QA |

### DS

| Command | Description |
|---------|-------------|
| `/apm-eda` | Exploratory Data Analysis workflow |
| `/apm-baseline` | Build a domain-credible baseline model |
| `/apm-experiment` | Hypothesis-driven experiment cycle |

---

## Notes

- OpenCode pack lives in `apm_source/packs/opencode_pack/`.
- Shared CLI skills live in `apm_source/skills/`.
- Codex subagent config source lives in `apm_source/packs/codex_pack/`.
- Cursor agents/commands pack lives in `apm_source/packs/cursor_pack/`.
- Methodology templates live in `apm_source/methodologies/{rapid,ds}/`.
- Legacy FULL methodology is stored in `apm_source/legacy/full_deprecated/`.

---

## OpenCode CLI architecture

- **Commands** = playbooks the user runs (`/apm-*`). They set the phase and required context.
- **Agents** = role profiles (Architect/Engineer/SDET/DS). They keep behavior consistent.
- **Skills** = modular knowledge chunks loaded on demand (governance, arch, dev, test, logs, DS workflows).
- **Tools** = custom actions (e.g., `apm_init_structure`) used by commands.
- **Install targets**:
  - Global: `~/.config/opencode/{commands,agents,skills,tools}`
  - Local: `.opencode/{commands,agents,skills,tools}` inside a project

---

## Inspiration

APM is inspired by:
- [GitHub Spec Kit](https://github.com/github/spec-kit) - Spec-Driven Development toolkit
- Enterprise software development practices
- Domain-Driven Design by Eric Evans
- Test-Driven Development by Kent Beck
