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

- **Cursor IDE** (interactive): methodology assets, `.cursor/` agents and commands, shared skills, `memory_bank/`.
- **Codex CLI** (global or per-project): skills + subagent roles installed into `.codex/`; APM blocks merged into `.codex/config.toml`; projects use `memory_bank/` and minimal structure.
- **OpenCode CLI** (global or per-project): commands/agents/skills installed into OpenCode; projects use `memory_bank/` and minimal structure.

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
- Codex-only primary-session skills from `apm_source/packs/codex_pack/skills/`
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
- **DS**: data science workflow (EDA -> Deep Feature Engineering -> baseline -> experiments -> evaluation -> finalize).
- **FULL**: deprecated (Cursor-only).

---

## How it works

1. **/apm-start** runs Vision Alignment (RAPID) or Problem Definition (DS).
2. After your confirmation, APM creates the Memory Bank: `ARCHITECTURE.md`, `STATE.md`, and `tasks/` (`TASKS.md` + `TASK-001.md` starter).
3. You continue with role-specific commands/skills (e.g., `/apm-develop`, `apm-eda`, `apm-deep-feature-engineering`, `apm-ds-exp`). Development and DS experiment loops use an explicit quality gate: `apm-code-simplifier -> apm-code-reviewer -> fix findings -> completion handoff`.
   - Branch/worktree/PR flow is not part of standard specialist subagent loops.
   - Branch/worktree may be initialized manually by the user, or by Team Lead when explicit `TASK_ID` subtasks (or explicit git-flow request) are provided.
   - OpenCode can run through the `apm-team-lead` primary agent for orchestration-heavy execution.
   - Codex can enable Team Lead behavior by loading the `apm-team-lead` skill in the main session.
   - Codex can enable goal-first spec challenge by loading `apm-critical-execution` in the main session; do not use it for specialist subagents.
4. Memory Bank synchronization is explicit (`/apm-sync`) and can be delegated to a dedicated sync subagent when configured.
5. Logs are split into `logs/project/` for runtime and reports, and `logs/agents/` for main-session agent logs.

---

## Example flow

**RAPID:** `/apm-start` -> `/apm-develop` (includes `simplify -> review -> fix -> completion handoff`) -> `/apm-test`

**DS:** `/apm-start` -> `/apm-eda` (`EDA-Report.md` + `EDA-Insights.md`) -> `/apm-deep-feature-engineering` -> `/apm-baseline` / `/apm-experiment` (`simplify -> review -> fix -> completion handoff`) -> `/apm-review`

---

## Memory Bank

- All environments: `memory_bank/`

Core files:
- `ARCHITECTURE.md`
- `STATE.md`
- `tasks/TASKS.md`
- `tasks/{TASK_ID}.md`

Line budget:
- Keep `STATE.md` and `tasks/TASKS.md` under 150 lines (compress when exceeded).

## Logs

- `logs/project/runtime/` stores runtime, training, evaluation, metrics, and error logs.
- `logs/project/reports/` stores generated reports such as test, review, and model reports.
- `logs/agents/` stores main-session agent logs written via `apm-report`.
- In Codex, spawned roles get their human-readable identity only from their agent config files. The primary session is recorded as `PrimarySession`.

## Git Isolation

- Git flow is opt-in and outside standard specialist subagent skills.
- Branch/worktree initialization is done manually by the user, or by Team Lead for explicitly assigned `TASK_ID` streams (or direct git-flow request).
- Team Lead uses `apm-git-taskflow` only under those explicit triggers.

---

## Commands

### Common

| Command | Description |
|---------|-------------|
| `/apm-start` | Vision Alignment / Problem Definition + Memory Bank initialization + environment proposal |
| `/apm-architect` | Strategic architecture decisions, trade-off analysis, and architecture-governance updates (with user confirmation for major changes) |
| `/apm-review` | Architecture review and recommendations |
| `/apm-sync` | Explicit Memory Bank synchronization on request |
| `/apm-report` | Write a consolidated agent log from the current main session |

### RAPID

| Command | Description |
|---------|-------------|
| `/apm-develop` | Lead Engineer implementation loop |
| `/apm-simplify` | Behavior-preserving simplification pass (maps to `apm-code-simplifier`) |
| `/apm-test` | SDET testing / QA |

### DS

| Command | Description |
|---------|-------------|
| `/apm-eda` | Exploratory Data Analysis workflow |
| `/apm-deep-feature-engineering` | Deep post-EDA feature engineering analysis |
| `/apm-baseline` | Build a domain-credible baseline model |
| `/apm-experiment` | Hypothesis-driven experiment cycle |

---

## Notes

- OpenCode pack lives in `apm_source/packs/opencode_pack/`.
- Shared CLI skills live in `apm_source/skills/`.
- Example shared skills: `apm-dev`, `apm-team-lead`, `apm-code-simplifier`, `apm-test`, `apm-review`, `apm-logs`, `apm-report`.
- Codex pack source lives in `apm_source/packs/codex_pack/` (subagent roles plus Codex-only primary-session skills), including `apm-critical-execution` and dedicated sync/review roles (`apm-memory-bank-sync`, `apm-code-reviewer`) in source profiles.
- Cursor agents/commands pack lives in `apm_source/packs/cursor_pack/`.
- Methodology templates live in `apm_source/methodologies/{rapid,ds}/`.
- Legacy FULL methodology is stored in `apm_source/_legacy/cursor_ide/full_deprecated/`.

---

## OpenCode CLI architecture

- **Commands** = playbooks the user runs (`/apm-*`). They set the phase and required context.
- **Agents** = role profiles plus optional Team Lead primary orchestrator (`apm-team-lead`) for delegation-first execution.
- **Skills** = modular knowledge chunks loaded on demand (governance, arch, team-lead mode, dev, simplification, test, logs, DS workflows).
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
