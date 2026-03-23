<div align="center">

# Agentic Project Management

**AI-driven development framework for Cursor IDE, Codex CLI, OpenCode CLI, and Claude Code**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Linux%20|%20macOS-lightgrey.svg)]()

</div>

---

## Review

APM is a configurable SDD-based framework that brings structure and predictability to LLM-assisted development across Cursor IDE, Codex CLI, OpenCode CLI, and Claude Code. It standardizes project setup, roles, and documentation so teams keep continuity with minimal overhead.

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
- **Claude Code** (global or per-project): subagent roles in `.claude/agents/`, skills in `.claude/skills/`, instructions in `CLAUDE.md` (Claude Code's equivalent of `AGENTS.md`); projects use `memory_bank/` and minimal structure.

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
- Standalone subagent role configs to `.codex/agents/` (each file includes `name`, `description`, `developer_instructions`)
- Global multi-agent settings in `.codex/config.toml` (`features.multi_agent`, `agents.max_threads`, `agents.max_depth`)

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
2. After your confirmation, APM creates the Memory Bank: `ARCHITECTURE.md`, `STATE.md`, and `tasks/` (`TASKS.md` + `W1A.md` starter).
3. You continue with role-specific commands/skills (e.g., `/apm-develop`, `apm-eda`, `apm-deep-feature-engineering`, `apm-ds-exp`).
   - **Co-Founder mode** provides a collaborative primary partner who co-owns project vision, architecture, and direction. Strategic discussion partner -- does not orchestrate by default. Activate via Shift+Tab in OpenCode, `claude --agent apm-co-founder` in Claude Code, or by loading `apm-co-founder` in Codex.
   - **Team Lead mode** enables WAVE-based orchestration: Team Lead creates worktrees, delegates with minimal contracts, waits, runs quality gate per task (simplify + review), integrates per wave, and returns one compact final handoff. Activate via Shift+Tab in OpenCode, `claude --agent apm-team-lead` in Claude Code, or by loading `apm-team-lead` in Codex.
   - Codex can enable goal-first spec challenge by loading `apm-critical-execution` in the main session; do not use it for specialist subagents.
4. Memory Bank synchronization is explicit (`/apm-sync`) and can be delegated to a dedicated sync subagent when configured.
5. Logs are split into `logs/project/` for runtime and reports, and `logs/agents/{TASK_ID}/` for task-scoped agent logs. Team Lead writes consolidated logs under `logs/agents/` root.

---

## Example flow

**RAPID:** `/apm-start` -> `/apm-develop` (includes `apm-quality-gate`) -> `/apm-test`

**DS:** `/apm-start` -> `/apm-eda` (`EDA-Report.md` + `EDA-Insights.md`) -> `/apm-deep-feature-engineering` -> `/apm-baseline` / `/apm-experiment` (includes `apm-quality-gate`) -> `/apm-review`

---

## Memory Bank

- All environments: `memory_bank/`

Core files:
- `ARCHITECTURE.md`
- `STATE.md`
- `tasks/TASKS.md`
- `tasks/{TASK_ID}.md`

WAVE naming: `W1A`, `W1B`, `W2A`, etc. Waves are sequential; tasks within a wave are parallel. Backlog items use `BL-NNN`.

Line budget:
- Keep `STATE.md` and `tasks/TASKS.md` under 150 lines (compress when exceeded).

## Logs

- `logs/project/runtime/` stores runtime, training, evaluation, metrics, and error logs.
- `logs/project/reports/` stores generated reports such as test, review, and model reports.
- `logs/agents/{TASK_ID}/` stores task-scoped agent logs written via `apm-report`. Each agent working on a task writes here.
- Team Lead writes consolidated orchestration logs under `logs/agents/` root.
- In Codex, spawned roles get their human-readable identity only from their agent config files.

## Git Isolation

- Git flow is managed by Team Lead during WAVE execution via `apm-git-taskflow`.
- One branch per task: `wave/{TASK_ID}`. One worktree per task: `.apm/worktrees/{TASK_ID}`.
- Heavy untracked resources (runtime, data, models) are shared at repo level -- not copied per worktree.
- New artifacts are produced locally in the worktree and migrated during wave integration.

---

## Commands

### Common

| Command | Description |
|---------|-------------|
| `/apm-start` | Vision Alignment / Problem Definition + Memory Bank initialization + environment proposal |
| `/apm-architect` | Strategic architecture decisions, trade-off analysis, and architecture-governance updates (with user confirmation for major changes) |
| `/apm-review` | Architecture review and recommendations |
| `/apm-sync` | Explicit Memory Bank synchronization on request |
| `/apm-report` | Write a structured agent log for a delegated task stream or the primary session |

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
- Codex pack source lives in `apm_source/packs/codex_pack/` (subagent roles plus Codex-only primary-session skills).
- Cursor agents/commands pack lives in `apm_source/packs/cursor_pack/`.
- Claude Code pack source lives in `apm_source/packs/claude_pack/` (subagent roles for Claude Code).
- Methodology templates live in `apm_source/methodologies/{rapid,ds}/`.
- Legacy FULL methodology is stored in `apm_source/_legacy/cursor_ide/full_deprecated/`.

---

## OpenCode CLI architecture

- **Commands** = playbooks the user runs (`/apm-*`). They set the phase and required context.
- **Agents** = role profiles plus primary agents: Co-Founder (`apm-co-founder`) for strategic partnership, Team Lead (`apm-team-lead`) for WAVE orchestration. Switch via Shift+Tab (cycle primary agents).
- **Skills** = modular knowledge chunks loaded on demand (governance, arch, team-lead mode, subagent delegation contracts, dev, simplification, test, logs, DS workflows).
- **Tools** = custom actions (e.g., `apm_init_structure`) used by commands.
- **Install targets**:
  - Global: `~/.config/opencode/{commands,agents,skills,tools}`
  - Local: `.opencode/{commands,agents,skills,tools}` inside a project

---

## Claude Code architecture

- **Subagents** = specialist roles in `.claude/agents/` (Markdown + YAML frontmatter). Each subagent has explicit tool allowlists, permission modes, effort levels, and turn limits. Spawned automatically or via `@"agent-name"`.
- **Primary agents** = Co-Founder (`apm-co-founder`) and Team Lead (`apm-team-lead`). Activated via `claude --agent <name>` or `"agent"` in `.claude/settings.json`.
- **Skills** = shared `agentskills.io` skills in `.claude/skills/`. User-invocable via `/apm-*`. Same format as Cursor.
- **Instructions** = `CLAUDE.md` (equivalent of `AGENTS.md`). Supports subdirectory discovery, `@import` syntax, and `.claude/rules/` for path-scoped modular rules.
- **Tool control** = per-subagent `tools` (allowlist) and `disallowedTools` (denylist). Code-reviewer gets read-only tools; Team Lead gets scoped `Agent()` for known specialists only.
- **Persistent memory** = `memory: project` gives subagents cross-session learning (e.g., code-reviewer accumulates project patterns).
- **Install targets**:
  - Global: `~/.claude/{agents,skills}`
  - Local: `.claude/{agents,skills}` inside a project

---

## Inspiration

APM is inspired by:
- [GitHub Spec Kit](https://github.com/github/spec-kit) - Spec-Driven Development toolkit
- Enterprise software development practices
- Domain-Driven Design by Eric Evans
- Test-Driven Development by Kent Beck
