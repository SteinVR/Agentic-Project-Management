# APM (Agentic Project Management) Architecture

## 1. Overview and Core Principles

**Agentic Project Management (APM)** is an AI-driven development framework designed to standardize and streamline LLM-assisted workflows across multiple environments: **Cursor IDE**, **Codex CLI**, **OpenCode CLI**, and **Claude Code**.

Core Principles:
- **Spec-Driven Development (SDD):** The specification is the Single Source of Truth (SSOT). Code must follow the documented architecture, not the other way around.
- **Only Essential Memory Bank:** Maintain a minimal, highly structured set of Markdown files to preserve sustainable context across sessions without overwhelming the LLM.
- **Context Engineering:** Emphasize declarative control, predictable determinism, and token efficiency to maximize AI output quality and consistency.
- **Skill-Driven Workflow:** Workflow is controlled through explicitly invoked skills, not rigid methodology boundaries. Skills define how to work; the user/prompt defines what to work on and with which artifacts.

---

## 2. Environments and Modalities

APM supports four distinct environments, tailoring its components for each ecosystem:

1. **Cursor IDE (Interactive UI):**
   - Utilizes `.cursor/agents/`, `.cursor/commands/`, and shared skills.
   - Leverages Cursor's native Subagents and Skills system (`SKILL.md`).
   - Memory Bank resides in `memory_bank/`.

2. **Codex CLI (Terminal / Orchestrated):**
   - Utilizes `config.toml` for subagent declarations (`[agents.*]`) and parallel multi-agent threading.
   - Relies on standardized `.codex/skills/` following the `agentskills.io` specification.
   - Supports `apm-co-founder` as a primary-session operating mode.
   - Memory Bank resides in `memory_bank/`.

3. **OpenCode CLI (Terminal / Extensible):**
   - Implements custom `commands/`, `agents/`, `skills/`, and `tools/` either globally (`~/.config/opencode/`) or locally (`.opencode/`).
   - Supports Co-Founder (`apm-co-founder`) as a primary agent.
   - Memory Bank resides in `memory_bank/`.

4. **Claude Code (Terminal / Agentic):**
   - Subagent roles in `.claude/agents/` (Markdown + YAML frontmatter) with explicit tool allowlists, permission modes, and turn limits.
   - Skills in `.claude/skills/` following the `agentskills.io` specification (shared with Cursor).
   - Project instructions in `CLAUDE.md` (Claude Code's equivalent of `AGENTS.md`).
   - Supports Co-Founder (`apm-co-founder`) as a primary agent via `claude --agent apm-co-founder`.
   - Native worktree isolation (`isolation: worktree`) and persistent subagent memory (`memory: project`).
   - Memory Bank resides in `memory_bank/`.

---

## 3. Workflow Model

APM uses a single base project template. Workflow is controlled through explicitly invoked skills, not rigid methodology boundaries.

- **Base structure** (`apm_source/base/`) provides the minimal project scaffold: `src/`, `tests/`, `logs/`, `external/`, `memory_bank/` with template files.
- **`apm-start`** initializes the project and selects the appropriate `ARCHITECTURE.md` template (product-oriented or DS/experiment-oriented) based on the project domain.
- **Workflow skills** extend the project structure on demand. For example, `apm-eda` creates `eda/` and `data/` directories; `apm-exp` creates `experiments/` and `models/`. A project may use any combination of skills as needed.

---

## 4. The Memory Bank (SSOT)

The Memory Bank ensures context continuity across multiple separate LLM sessions.

**Core Files:**
- `ARCHITECTURE.md` — The SSOT for the project's technical architecture, stack, patterns, and overarching design decisions.
- `STATE.md` — Compact operational status and continuity context.
- `tasks/TASKS.md` — High-level task overview.
- `design/SPEC-{module}.md` — Global module specifications: contracts, invariants, data formats. Updated only with explicit approval.
- `specs/SPEC_{id}.md` — Frozen task specification: goal, pipeline, contracts, Definition of Done. Read-only during execution.
- `tasks/{id}.md` — Working journal: notes, review findings, outcome.

Size guardrail:
- Keep `STATE.md` and `tasks/TASKS.md` under 120 lines; compress when limits are exceeded.

---

## 5. Agent Roles and Skills System

APM abstracts capabilities into distinct layers: Agents, Commands, and Skills.

### Context Layering
APM separates shared context, dynamic procedures, and role contracts into different artifact types.

- **`AGENTS.md` = common context and rules**
  Global and local instruction layer for all agents and subagents in a given area.
  The root `AGENTS.md` defines general project-wide contracts and rules.
  Nested `AGENTS.md` files define local contracts and rules for a specific area, subtree, or artifact type.

- **`SKILLS` = attachable procedures**
  Mechanism for dynamic, incremental instruction loading.
  Skills load only what is needed at the current moment, only for the agent that needs it, reducing context duplication and noise.

- **Agent and subagent `CONFIGS` = behavioral role contracts**
  Define the role, behavior, boundaries, and global goals of a specific agent or subagent.

### Agent Roles
- **Worker:** Universal execution unit. Receives a task, breaks it down via todo list, delivers results with self-review gate before handoff. Specifics come from the loaded skill and delegation instruction.
- **Co-Founder:** Primary project partner who co-owns vision, architecture, and direction. Equal strategic partner, not an assistant. Available as a primary agent in OpenCode, Claude Code, or as a skill in Codex.
- **Code Simplifier:** Refactors recently modified code for clarity and simplicity while preserving exact behavior. Applies project coding conventions.
- **Reviewer:** Independent verification gate. Determines review scope autonomously, checks architecture alignment and ranked code risks. Persistent memory across sessions.
- **Memory Bank Sync:** Reconciles Memory Bank files with recent work. Keeps `STATE.md`, `TASKS.md`, and task files aligned with actual project state. Proposes architecture updates with explicit approval gate.
- **Web-Explorer:** Lightweight web research specialist. Receives a focused question, returns a condensed answer with sources. Saves the caller's context window from web-fetch noise.

### Skills (Dynamic Capabilities)
Skills (`SKILL.md`) are discrete, self-contained capabilities loaded on demand. Each skill is a folder containing a required `SKILL.md` with YAML frontmatter metadata and Markdown instructions, and optional bundled resources (`scripts/`, `references/`).

Workflow skills describe HOW to work. The scenario (which artifacts exist, whether specs are involved, whether to run quality gate) is determined by the user, prompt, or delegation instruction -- not hardcoded in the skill.

Primary sessions also use `apm` as the core session overlay: it adds the main-agent operating loop (`plan -> execute -> self-review`), workflow-skill selection, and delegation boundaries on top of the shared `AGENTS.md` rules.

**Available skills:**

| Skill | Purpose |
|-------|---------|
| `apm` | Core main-session operating frame: choose workflow skill, plan -> execute -> self-review, keep context narrow |
| `apm-start` | Project kickoff: Vision Alignment, Memory Bank initialization, environment setup |
| `apm-dev` | Iterative development workflow: plan, implement, verify, self-review |
| `apm-exp` | Experiment workflow (covers baselines, model variants, hypothesis-driven experiments) |
| `apm-eda` | Exploratory Data Analysis: distributions, missingness, correlations, leakage risks |
| `apm-deep-feature-engineering` | Post-EDA feature engineering analysis with ranked candidates |
| `apm-test` | Testing workflow prioritizing comprehensive smoke tests |
| `apm-quality-gate` | Post-implementation quality gate: simplify, verify, review, fix loop, accept |
| `apm-git-taskflow` | Git branch/worktree isolation with shared runtime management |
| `apm-sync` | Explicit Memory Bank synchronization on request |
| `apm-subagent` | Delegation contract for specialist subagents |
| `apm-logs` | Runtime logging conventions |
| `apm-autoresearch` | Autonomous experiment loop: rapid metric optimization with keep/discard logic |

### Subagents and Delegation
In modern environments (Cursor 2.5+, Codex CLI, OpenCode, and Claude Code), APM leverages subagents coordinated by the main session or user. Subagent configs are minimal and scenario-agnostic. `apm-subagent` standardizes how delegation requests are framed.

**Two interaction modes:**
1. **Standard mode:** The user drives work through the main session, optionally delegating to specialist subagents. User validates between steps.
2. **Co-Founder mode:** The user works with an equal project partner who co-owns vision, architecture, and direction. Activated via Shift+Tab in OpenCode, `claude --agent apm-co-founder` in Claude Code, or by loading the skill in Codex.

**Delegation contract:** Task description, context pointers (relevant files, worktree path if applicable), optional clarification. Subagents self-orient from the project structure and memory bank.

---

## 6. APM Repository Structure

```text
APM/
├── apm_project/                 # Framework orchestrators
│   ├── apm.sh                   # Main Configurator (TUI / CLI)
│   ├── scripts/                 # Installers (Codex, OpenCode, Cursor) for Bash/PS
│   └── tests/                   # Framework E2E tests
├── apm_source/                  # Framework Source of Truth (Payloads)
│   ├── base/                    # Unified project template (structure, Memory Bank templates, AGENTS.md)
│   ├── skills/                  # Shared skills source
│   ├── packs/                   # Environment-specific packs
│   │   ├── codex_pack/          # Subagent roles for Codex CLI
│   │   ├── opencode_pack/       # Native OpenCode agents/skills
│   │   ├── claude_pack/         # Subagent roles for Claude Code
│   │   └── cursor_pack/         # Cursor agents and command wrappers
│   └── _legacy/                 # Frozen legacy assets
│       └── cursor_ide/
│           └── full_deprecated/
├── docs/                        # Extensive ecosystem and CLI documentation
├── APM_ARCHITECTURE.md          # THIS FILE: Framework Architecture
└── README.md                    # Project overview and Quick Start
```

---

## 7. Basic Project Workflow

1. **Initialization:** Run the `apm.sh` configurator to create the base project structure and install environment packs.
2. **Setup Phase:** Run `/apm-start` to align on vision, select the architecture template, and generate the initial Memory Bank (`ARCHITECTURE.md`, `STATE.md`, `tasks/TASKS.md`, initial spec and task files).
3. **Execution Loop:** Work through workflow skills (`apm-dev`, `apm-test`, `apm-eda`, `apm-exp`, `apm-deep-feature-engineering`, etc.). Domain-specific skills create their required directories on first use. Use `apm-quality-gate` when independent verification is needed.
4. **Git Isolation:** When parallel or isolated execution is needed, use `apm-git-taskflow` for branch/worktree management with shared runtime.
5. **Synchronization:** Run `/apm-sync` on explicit request whenever continuity updates are needed.

---

## 8. Core Conventions

- **File Naming:** Core instruction or agent context files strictly use **UPPERCASE** naming conventions (e.g., `AGENTS.md`, `SKILL.md`, `ARCHITECTURE.md`) to distinguish them from standard project documentation.
- **Git Isolation:** One branch per execution stream (`task/<identifier>`), one worktree per stream (`.apm/worktrees/<identifier>`). Heavy untracked resources are shared at repo level. New artifacts are produced locally in the worktree and migrated during integration.
- **Skill Portability:** Whenever possible, logic should be encapsulated in reusable `.md` skills following the `agentskills.io` spec to ensure cross-compatibility between Cursor, Claude Code, and Codex.
