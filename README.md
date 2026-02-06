<div align="center">

# Agentic Project Management

**AI‑driven development framework for Cursor IDE and OpenCode CLI**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Linux%20|%20macOS-lightgrey.svg)]()

</div>

---

## What is APM?

APM is a methodology toolkit that brings structure and predictability to AI‑assisted development. It provides:
- CLI configurator for new projects
- Agent roles and commands
- Memory Bank for durable project context
- Templates for specs, tasks, and reports

---

## Environments

- **Cursor IDE** (interactive): full methodology assets, `.cursor/` commands, `.apm/` templates, `memory bank/`.
- **OpenCode CLI** (global or per‑project): commands/agents/skills installed into OpenCode; projects use `memory-bank/` and minimal structure.

---

## Quick Start

### 1) Run the configurator

**Windows (PowerShell):**
```powershell
.\apm_project\apm.ps1
```

**Linux/macOS:**
```bash
chmod +x ./apm_project/apm.sh
./apm_project/apm.sh
```

### 2) Non‑interactive flags

Shorthands are supported:
- `--opencode` / `--cursor`
- `--rapid` / `--ds` / `--full`
- `--local` / `--global` / `--none` (OpenCode pack install; default is `--none`)

Recommended order for non‑interactive usage: **Environment → Mode → other flags**.

Defaults:
- `--project-path` defaults to the current directory
- `--project-name` defaults to the current directory name

Example:
```bash
./apm_project/apm.sh --opencode --rapid --project-name "my-app" --project-path "/projects" \
  --non-interactive --skip-github --skip-cursor
```

In‑place (inside an existing project directory):
```bash
./apm_project/apm.sh --opencode --rapid --non-interactive --skip-github
```

---

## OpenCode install (global or local)

**Global** (applies to all projects):
```bash
./apm_project/scripts/opencode_install.sh --global
```

**Local** (project‑only):
```bash
./apm_project/scripts/opencode_install.sh --local /path/to/project
```

PowerShell equivalents:
- `apm_project/scripts/opencode_install.ps1 -Global`
- `apm_project/scripts/opencode_install.ps1 -Local -Path <project>`

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
- **DS**: data science workflow (EDA → baseline → experiments → evaluation → finalize).
- **FULL**: deprecated (Cursor‑only).

---

## How it works

1. **/apm-start** runs Vision Alignment (RAPID) or Problem Definition (DS).
2. After your confirmation, APM creates the Memory Bank: `ARCHITECTURE.md`, `TASK.md`, `STATE.md`.
3. You continue with role‑specific commands (/apm-develop, /apm-eda, /apm-experiment, etc.).
4. Every session ends with an update to `STATE.md` (project continuity).

---

## Example flow

**RAPID:** `/apm-start` → `/apm-develop` → `/apm-test` → `/apm-sync`

**DS:** `/apm-start` → `/apm-eda` → `/apm-baseline` → `/apm-experiment` → `/apm-review`

---

## Memory Bank

- Cursor projects: `memory bank/` (with space)
- OpenCode projects: `memory-bank/` (no space)

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
| `/apm-review` | Architecture review & recommendations |
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
| `/apm-baseline` | Build a domain‑credible baseline model |
| `/apm-experiment` | Hypothesis‑driven experiment cycle |

---

## Notes

- OpenCode pack lives in `apm_source/opencode_cli/apm_opencode_pack/`.
- Cursor templates live in `apm_source/interactive_ide/`.

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
