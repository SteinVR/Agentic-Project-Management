<div align="center">

# Agentic Project Management

**AI-driven development framework for Cursor IDE, Codex CLI, OpenCode CLI, and Claude Code**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Linux%20|%20macOS-lightgrey.svg)]()

</div>

---

## 📋 Review

APM is a configurable SDD-based framework that brings structure and predictability to LLM-assisted development across Cursor IDE, Codex CLI, OpenCode CLI, and Claude Code. It standardizes project setup, roles, and documentation so teams keep continuity with minimal overhead.

Ideology: configured SDD, only-essential Memory Bank, context engineering, agents and skills, with an emphasis on declarative control, determinism, and token efficiency.

Usage: run the TUI configurator (`apm.sh`) to generate a project, then drive work via environment-specific commands and skills. For automation or CI, use non-interactive flags.

---

## 📦 What you get

- CLI configurator for new projects
- Agent roles (worker, co-founder, reviewer, code-simplifier, memory-bank-sync, web-explorer)
- Workflow skills loaded on demand
- Memory Bank for durable project context
- Templates for specs, tasks, and reports

---

## 🌐 Environments

- **Cursor IDE** (interactive): `.cursor/` agents and commands, shared skills, `memory_bank/`.
- **Codex CLI** (global or per-project): skills + subagent roles installed into `.codex/`; APM blocks merged into `.codex/config.toml`; projects use `memory_bank/` and minimal structure.
- **OpenCode CLI** (global or per-project): commands/agents/skills installed into OpenCode; projects use `memory_bank/` and minimal structure.
- **Claude Code** (global or per-project): subagent roles in `.claude/agents/`, skills in `.claude/skills/`, instructions in `CLAUDE.md`; projects use `memory_bank/` and minimal structure.

---

## 🚀 Quick Start

### 1) Run the configurator

**Linux/macOS (and Windows via WSL/Git Bash):**
```bash
chmod +x ./apm_project/apm.sh
./apm_project/apm.sh
```

### 2) Non-interactive flags

Shorthands are supported:
- `--opencode` / `--codex` / `--cursor` / `--claude`
- `--local` / `--global` / `--none` (CLI pack install; default is `--none`)

Defaults:
- `--project-path` defaults to the current directory
- `--project-name` defaults to the current directory name

Example:
```bash
./apm_project/apm.sh --opencode --project-name "my-app" --project-path "/projects" \
  --non-interactive
```

In-place (inside an existing project directory):
```bash
./apm_project/apm.sh --opencode --non-interactive
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
- Standalone subagent role configs to `.codex/agents/`
- Global multi-agent settings in `.codex/config.toml`

---

## Alias suggestions

```bash
# run configurator from anywhere
alias apm='/path/to/Agentic-Project-Management/apm_project/apm.sh'

# optional: quick cd into repo
alias apm-cd='cd /path/to/Agentic-Project-Management'
```

---

## How it works

Primary/main agents use the core skill `apm` as the session overlay: first resolve the implementation mode for non-trivial work, then choose the relevant workflow skill, decompose work into todo items, execute, and self-review before handoff. If key details are missing or the agent wants to expand scope beyond the direct request, it raises a question first.

Workflow skills are the skills marked as `Workflow skill` in their descriptions. They define the execution flow for a class of work.

1. **/apm-start** runs Vision Alignment, determines the project domain, initializes the dual-branch git layout, and selects the matching architecture template.
2. During initialization, APM bootstraps two independent branches:
   - `main` stays clean and free of APM working artifacts.
   - `dev` contains the full working layer (`AGENTS.md`, `memory_bank/`, `external/`, `docs/`, and similar assets) and becomes the default branch for development.
3. After your confirmation, APM creates the Memory Bank on `dev`: `ARCHITECTURE.md`, `STATE.md`, `specs/`, and `tasks/`.
4. You continue with workflow skills:
   - `apm-dev` for implementation, `apm-test` for testing, `apm-quality-gate` for independent verification.
   - `apm-eda`, `apm-deep-feature-engineering`, `apm-exp` for DS/ML workflows.
   - Domain-specific skills create their required directories on first use (e.g., `apm-eda` creates `eda/` and `data/`).
   - **Co-Founder mode** provides a collaborative primary partner who co-owns project vision, architecture, and direction. Activate via Shift+Tab in OpenCode, `claude --agent apm-co-founder` in Claude Code, or by loading `apm-co-founder` in Codex.
5. Memory Bank synchronization is explicit (`/apm-sync`) and delegated to the `apm-memory-bank-sync` subagent.
6. Git isolation via `apm-git-taskflow` when parallel or isolated execution streams are needed. Task branches and worktrees are created from `dev`, not from `main`.

---

## Example flows

**Product:** `/apm-start` -> `apm-dev` -> `apm-test` -> `apm-quality-gate` (optional) -> `/apm-sync`

**DS/ML:** `/apm-start` -> `apm-eda` -> `apm-deep-feature-engineering` -> `apm-exp` (baseline + experiments) -> `/apm-sync`

**Mixed:** combine skills from both as needed within the same project.

---

## Memory Bank

- All environments: `memory_bank/`

Core files:
- `ARCHITECTURE.md`
- `STATE.md`
- `tasks/TASKS.md`
- `design/SPEC-{module}.md` -- global module specifications (contracts, ready interfaces, typecheck gates, invariants, data formats). Updated only with approval.
- `specs/SPEC_{id}.md` -- frozen task specification (goal, pipeline, contracts, ready interfaces, typecheck automation, DoD). Read-only during execution.
- `tasks/{id}.md` -- working journal (notes, review findings, outcome).

Line budget:
- Keep `STATE.md` and `tasks/TASKS.md` under 120 lines (compress when exceeded).

## Logs

- `logs/runtime/` stores runtime, training, evaluation, metrics, and error logs.
- `logs/project/reports/` stores generated reports such as test, review, and model reports.

## Git Isolation

- Managed via `apm-git-taskflow` when isolated execution streams are needed.
- Repository bootstrap creates two independent branches: clean `main` and working `dev`.
- Day-to-day implementation happens on `dev`.
- One branch per stream from `dev`: `task/<identifier>`. One worktree per stream: `.apm/worktrees/<identifier>`.
- Heavy untracked resources (runtime, data, models) are shared at repo level -- not copied per worktree.
- New artifacts are produced locally in the worktree and migrated back to `dev` or shared repo-level storage after merge.

## Code Conventions

- Prefer runtime fail-fast over layered fallback logic.
- Keep files single-role and ideally within 100-600 LOC; allow 600-800 only when preserving a clear semantic boundary.
- Use smoke-first testing: per-module smoke and smoke E2E are primary; keep integration tests narrow.
- Inspect runtime logs and produced results after test runs.
- Keep concise docstrings and a `README.md` in `src/` and every `src/` subdirectory with a local script graph and script descriptions.
- In generated projects, these implementation conventions live in `src/AGENTS.md`.

---

## Skills

| Skill | Description |
|-------|-------------|
| `apm` | Core main-session operating frame: resolve task mode, choose workflow skill, ask before scope expansion, plan -> execute -> self-review |
| `apm-start` | Project kickoff: Vision Alignment + dual-branch git bootstrap + Memory Bank initialization |
| `apm-dev` | Workflow skill for iterative development: plan, implement, verify, self-review |
| `apm-exp` | Workflow skill for experiments (baselines, model variants, hypothesis-driven experiments) |
| `apm-eda` | Workflow skill for Exploratory Data Analysis |
| `apm-deep-feature-engineering` | Workflow skill for post-EDA feature engineering analysis |
| `apm-test` | Workflow skill for testing: per-module smoke + smoke E2E, with narrow integration tests when needed |
| `apm-quality-gate` | Post-implementation quality gate: simplify, verify, review, fix loop |
| `apm-git-taskflow` | Git branch/worktree isolation from `dev` with shared runtime management |
| `apm-sync` | Workflow skill for explicit Memory Bank synchronization |
| `apm-subagent` | Delegation contract for specialist subagents |
| `apm-logs` | Runtime logging conventions |
| `apm-autoresearch` | Autonomous experiment loop for rapid metric optimization |

---

## Agent roles

| Role | Description |
|------|-------------|
| `apm-worker` | Universal execution unit: receives task, delivers results with self-review |
| `apm-co-founder` | Primary project partner, equal strategic collaborator |
| `apm-code-simplifier` | Behavior-preserving code simplification |
| `apm-reviewer` | Independent verification gate with persistent memory |
| `apm-memory-bank-sync` | Memory Bank reconciliation specialist |
| `apm-web-explorer` | Web research specialist |

---

## Notes

- Base project template lives in `apm_source/base/`.
- Shared skills live in `apm_source/skills/`.
- OpenCode pack lives in `apm_source/packs/opencode_pack/`.
- Codex pack source lives in `apm_source/packs/codex_pack/`.
- Cursor agents/commands pack lives in `apm_source/packs/cursor_pack/`.
- Claude Code pack source lives in `apm_source/packs/claude_pack/`.
- Legacy FULL methodology is stored in `apm_source/_legacy/cursor_ide/full_deprecated/`.

---

## OpenCode CLI architecture

- **Commands** = playbooks the user runs (`/apm-*`). They set the phase and required context.
- **Agents** = role profiles plus primary agent: Co-Founder (`apm-co-founder`) for strategic partnership. Switch via Shift+Tab.
- **Skills** = modular knowledge chunks loaded on demand (dev, test, DS workflows, subagent delegation, git isolation, logs).
- **Tools** = custom actions used by commands.
- **Install targets**:
  - Global: `~/.config/opencode/{commands,agents,skills,tools}`
  - Local: `.opencode/{commands,agents,skills,tools}` inside a project

---

## Claude Code architecture

- **Subagents** = specialist roles in `.claude/agents/` (Markdown + YAML frontmatter). Each subagent has explicit tool allowlists, permission modes, effort levels, and turn limits.
- **Primary agents** = Co-Founder (`apm-co-founder`). Activated via `claude --agent apm-co-founder`.
- **Skills** = shared `agentskills.io` skills in `.claude/skills/`. Same format as Cursor.
- **Instructions** = `CLAUDE.md` (equivalent of `AGENTS.md`). Supports subdirectory discovery, `@import` syntax, and `.claude/rules/` for path-scoped modular rules.
- **Tool control** = per-subagent `tools` (allowlist) and `disallowedTools` (denylist).
- **Persistent memory** = `memory: project` gives subagents cross-session learning (e.g., reviewer accumulates project patterns).
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
