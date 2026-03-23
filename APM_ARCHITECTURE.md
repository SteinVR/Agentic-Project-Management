# APM (Agentic Project Management) Architecture

## 1. Overview and Core Principles

**Agentic Project Management (APM)** is an AI-driven development framework designed to standardize and streamline LLM-assisted workflows across multiple environments: **Cursor IDE**, **Codex CLI**, **OpenCode CLI**, and **Claude Code**.

Core Principles:
- **Spec-Driven Development (SDD):** The specification is the Single Source of Truth (SSOT). Code must follow the documented architecture, not the other way around.
- **Only Essential Memory Bank:** Maintain a minimal, highly structured set of Markdown files to preserve sustainable context across sessions without overwhelming the LLM.
- **Context Engineering:** Emphasize declarative control, predictable determinism, and token efficiency to maximize AI output quality and consistency.
- **Role-Based Execution:** Tasks are delegated to specialized agent profiles (e.g., Team Lead, Architect, Engineer, SDET, Data Scientist, Code Reviewer, Memory Bank Sync) acting sequentially or concurrently.

---

## 2. Environments and Modalities

APM supports four distinct environments (or workflows), tailoring its components for each ecosystem:

1. **Cursor IDE (Interactive UI):**
   - Utilizes `.cursor/agents/`, `.cursor/commands/`, and shared skills.
   - Leverages Cursor's native Subagents and Skills system (`SKILL.md`).
   - Memory Bank resides in `memory_bank/`.

2. **Codex CLI (Terminal / Orchestrated):**
   - Utilizes `config.toml` for subagent declarations (`[agents.*]`) and parallel multi-agent threading.
   - Relies on standardized `.codex/skills/` following the `agentskills.io` specification.
   - Supports primary-session operating modes: `apm-co-founder` (collaborative partner) and `apm-team-lead` (WAVE orchestrator).
   - Memory Bank resides in `memory_bank/`.

3. **OpenCode CLI (Terminal / Extensible):**
   - Implements custom `commands/`, `agents/`, `skills/`, and `tools/` either globally (`~/.config/opencode/`) or locally (`.opencode/`).
   - Supports Co-Founder (`apm-co-founder`) and Team Lead (`apm-team-lead`) primary agents.
   - Memory Bank resides in `memory_bank/`.

4. **Claude Code (Terminal / Agentic):**
   - Subagent roles in `.claude/agents/` (Markdown + YAML frontmatter) with explicit tool allowlists, permission modes, and turn limits.
   - Skills in `.claude/skills/` following the `agentskills.io` specification (shared with Cursor).
   - Project instructions in `CLAUDE.md` (Claude Code's equivalent of `AGENTS.md`; `AGENTS.md` support pending).
   - Supports Co-Founder (`apm-co-founder`) and Team Lead (`apm-team-lead`) primary agents via `claude --agent <name>`.
   - Native worktree isolation (`isolation: worktree`) and persistent subagent memory (`memory: project`).
   - Memory Bank resides in `memory_bank/`.

---

## 3. Supported Methodologies

APM defines strict workflows based on the nature of the project:

- **RAPID:** Designed for fast, iterative software product development with minimal ceremonial overhead. Focuses on the core `develop -> test -> sync` loop.
- **DS (Data Science):** Specialized workflow for analytical, ML, and research projects. Progresses through `EDA -> Deep Feature Engineering -> Baseline -> Experimentation -> Evaluation -> Finalization`.
- **FULL (Deprecated):** Legacy workflow maintained only for older Cursor projects.

---

## 4. The Memory Bank (SSOT)

The Memory Bank is the heartbeat of any APM project, ensuring context continuity across multiple separate LLM sessions.

**Core Files:**
- `ARCHITECTURE.md` — The SSOT for the project's technical architecture, stack, patterns, and overarching design decisions.
- `STATE.md` — Compact operational status and continuity context.
- `tasks/TASKS.md` — Grouped high-level tasks organized by waves.
- `tasks/{TASK_ID}.md` — Per-task execution notes and working plan.

**WAVE naming:** Tasks use wave-based IDs: `W1A`, `W1B`, `W2A`, etc. Waves are sequential; tasks within a wave are parallel.

Size guardrail:
- Keep `STATE.md` and `tasks/TASKS.md` under 150 lines; compress when limits are exceeded.

---

## 5. Agent Roles and Skills System

APM abstracts capabilities into distinct layers: Agents, Commands, and Skills.

### Context Layering
APM separates shared context, dynamic procedures, and role contracts into different artifact types.

- **`AGENTS.md` = common context and rules**
  Global and local instruction layer for all agents and subagents in a given area.
  The root `AGENTS.md` defines general project-wide contracts and rules.
  Nested `AGENTS.md` files define local contracts and rules for a specific area, subtree, or artifact type.
  It answers: "What must an agent always know in this area?"

- **`SKILLS` = attachable procedures**
  Mechanism for dynamic, incremental instruction loading.
  Used for specific tasks, processes, and strictly defined action sequences.
  Skills load only what is needed at the current moment, only for the agent that needs it, reducing context duplication and noise.
  They answer: "What must the agent do right now?"

- **Agent and subagent `CONFIGS` = behavioral role contracts**
  Define the role, behavior, boundaries, and global goals of a specific agent or subagent.
  They answer: "How must this type of agent behave?"

### Agent Roles
Agents represent specific "personas" with customized system prompts and constraints.
- **Architect:** Strategic architecture owner. Keeps global project goals coherent, drives system-level decisions with explicit trade-offs, governs architecture consistency, and updates `ARCHITECTURE.md` (approval-gated for significant changes).
- **Lead Engineer / Developer:** Focuses on implementation, adhering to specs.
- **SDET (Software Development Engineer in Test):** Focuses entirely on QA, testing, and test automation.
- **Data Scientist:** Executes the DS methodology loop.
- **Co-Founder:** Primary project partner who co-owns vision, architecture, and direction. Strategic discussion partner with deep project understanding. Does not orchestrate by default -- orchestration goes through Team Lead. Available as a primary agent in OpenCode (`apm-co-founder`), Claude Code (`claude --agent apm-co-founder`), or as a skill in Codex (`apm-co-founder`).
- **Team Lead:** Formalized WAVE-based orchestrator. Receives task waves, creates worktrees per task, delegates to specialist subagents with minimal contracts, runs quality gate per task, integrates per wave. Does not write implementation code (mechanical fixes only). Available as a primary agent in OpenCode (`apm-team-lead`), Claude Code (`claude --agent apm-team-lead`), or as a skill in Codex (`apm-team-lead`).
- **Code Simplifier:** Refactors recently modified code for clarity and simplicity while preserving exact behavior. Applies project coding conventions.
- **Code Reviewer:** Fully independent verification and review gate. Receives only TASK_ID and independently determines review scope, checking task/architecture alignment and ranked code risks.
- **Memory Bank Sync:** Runs explicit Memory Bank synchronization (`STATE`, `tasks/TASKS`, `{TASK_ID}`) with line-budget compression and approval-gated architecture updates.

### Skills (Dynamic Capabilities)
Skills (`SKILL.md`) are discrete, self-contained capabilities loaded on demand. Each skill is a folder containing a required `SKILL.md` with YAML frontmatter metadata and Markdown instructions, and optional bundled resources (`scripts/`, `references/`, `agents/`).

**Two-level hierarchy:**
- **High-level (orchestrating) skills:** Define what to do, in which order, and when to switch modes. Delegate specialized execution to low-level skills.
- **Low-level (atomic) skills:** Define how to execute one specific process end-to-end, with steps, checklists, and edge cases. Self-contained; do not call other skills.

**Available skills:**

| Skill | Purpose |
|-------|---------|
| `apm-start` | Vision Alignment (RAPID) or Problem Definition (DS); initializes the Memory Bank |
| `apm-dev` | Lead Engineer implementation loop |
| `apm-git-taskflow` | WAVE-based git flow: one branch/worktree per TASK_ID, PR flow, conflict policy, and worktree resource management |
| `apm-quality-gate` | Post-task quality gate orchestrated by Team Lead: simplify, verify, review, fix, accept |
| `apm-code-simplifier` | Behavior-preserving simplification of recently modified code |
| `apm-test` | SDET testing and QA workflow |
| `apm-review` | Architecture and code review |
| `apm-sync` | Explicit Memory Bank synchronization on request |
| `apm-report` | Write a structured agent session log for the current work |
| `apm-logs` | Structured project-log and agent-log taxonomy management |
| `apm-co-founder` | Co-Founder mode: strategic project partner for collaborative discussion |
| `apm-team-lead` | Team Lead mode: WAVE-based orchestration with delegation, quality gate, and integration |
| `apm-critical-execution` | Codex-only primary-session mode for intent reconstruction, spec challenge, and goal-first execution |
| `apm-subagent` | Minimal delegation contract for specialist subagents (TASK_ID + worktree path + optional clarification) |
| `apm-eda` | Exploratory Data Analysis workflow |
| `apm-deep-feature-engineering` | Deep post-EDA feature engineering analysis |
| `apm-ds-baseline` | Build domain-credible baseline models |
| `apm-ds-exp` | Hypothesis-driven DS experiment cycle |
| `apm-model-report` | DS model evaluation report generation |
| `apm-skill-creator` | Guidance for creating and updating APM skills |

### Subagents and Orchestration
In modern environments (Cursor 2.5+, Codex CLI, OpenCode, and Claude Code), APM leverages subagents coordinated by the orchestrating session. Subagent configs are mode-agnostic: they work identically whether the orchestrator is Team Lead, a standard main session, or a workflow skill. `apm-subagent` standardizes how delegation requests are framed for current specialist roles.

**Three interaction modes:**
1. **Standard mode (sequential):** The user drives work through the main session, which delegates to specialist subagents for localized execution via workflow skills. One task at a time, user validates between steps.
2. **Co-Founder mode (collaborative):** The user works with an equal project partner who co-owns vision, architecture, and direction. Natural, informal communication. Does not orchestrate by default; task execution goes through Team Lead. Activated via Shift+Tab in OpenCode (cycle to Co-Founder primary agent), `claude --agent apm-co-founder` in Claude Code, or by loading the `apm-co-founder` skill in Codex.
3. **Team Lead mode (WAVE orchestration):** The user assigns a wave of tasks to Team Lead. Team Lead creates worktrees, delegates with minimal contracts, waits for completion, runs quality gate per task (simplify + review), integrates per wave, and returns one compact final handoff. Activated via Shift+Tab in OpenCode (cycle to Team Lead primary agent), `claude --agent apm-team-lead` in Claude Code, or by loading the `apm-team-lead` skill in Codex.

**WAVE execution protocol:**
1. **Setup:** Create a worktree per task via `apm-git-taskflow`.
2. **Delegate (fan-out):** Spawn a specialist subagent per task with a minimal contract: TASK_ID + worktree path + optional clarification. Do not pre-gather context for subagents.
3. **Wait:** Do not rush subagents. Do not write code.
4. **Quality gate (per task):** As each subagent completes, run `apm-quality-gate` (simplify -> verify -> review -> fix/re-delegate).
5. **Integrate wave (fan-in):** Merge branches, resolve mechanical conflicts, migrate untracked artifacts.
6. **Next wave / Final handoff.**

**Delegation contract:** Minimal -- TASK_ID, worktree path, and optional clarification only. Subagents self-orient from task files and `memory_bank/`. Orchestrators do not pre-collect context.

**Subagent constraints:**
- Max 3 concurrent subagents per orchestrating agent.
- Max depth 1 (subagents do not spawn sub-subagents).

Subagents return compact handoffs and write `apm-report` logs under `logs/agents/{TASK_ID}/`. Team Lead writes a consolidated log under `logs/agents/` root.
`apm-critical-execution` is primary-session only; do not load it into specialist subagents.
Git branch/worktree/PR flow is managed by Team Lead via `apm-git-taskflow` when processing waves.

---

## 6. APM Repository Structure

The source repository for the APM framework itself is organized as follows:

```text
APM/
├── apm_project/                 # Framework orchestrators
│   ├── apm.sh                   # Main Configurator (TUI / CLI)
│   ├── scripts/                 # Installers (Codex, OpenCode, Cursor) for Bash/PS
│   └── tests/                   # Framework E2E tests
├── apm_source/                  # Framework Source of Truth (Payloads)
│   ├── methodologies/           # Templates and instructions per methodology
│   │   ├── rapid/               # RAPID workflow template
│   │   └── ds/                  # DS workflow template
│   ├── skills/                  # Shared skills source
│   ├── packs/                   # Environment-specific packs
│   │   ├── codex_pack/          # Subagent roles for Codex CLI
│   │   ├── opencode_pack/       # Native OpenCode agents/commands/tools
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

1. **Initialization:** Run the `apm.sh` configurator to stamp out the methodology, environment, and initial directory structure.
2. **Setup Phase:** Run `/apm-start` to align on vision and generate the initial Memory Bank (`ARCHITECTURE.md`, `STATE.md`, `tasks/TASKS.md`, starter task file).
3. **Execution Loop:** Work through role-specific commands (e.g., `/apm-develop`, `/apm-simplify`, `/apm-test` for RAPID; or `/apm-eda`, `/apm-deep-feature-engineering`, `/apm-experiment` for DS). Quality gate is orchestrated by Team Lead after each task completes.
4. **WAVE Orchestration:** Assign a wave of tasks to Team Lead. Team Lead creates worktrees, delegates, waits, runs quality gate per task, integrates per wave, returns final handoff.
5. **Synchronization:** Run `/apm-sync` on explicit request whenever continuity updates are needed.

---

## 8. Core Conventions

- **File Naming:** Core instruction or agent context files strictly use **UPPERCASE** naming conventions (e.g., `AGENTS.md`, `SKILL.md`, `ARCHITECTURE.md`) to distinguish them from standard project documentation.
- **WAVE Naming:** Tasks use wave-based IDs (`W1A`, `W1B`, `W2A`). Waves are sequential; tasks within a wave are parallel. Backlog items use `BL-NNN`.
- **Continuity Guarantee:** Use `tasks/{TASK_ID}.md` and agent logs as primary working memory during execution; sync into Memory Bank only when explicitly requested.
- **Git Isolation:** Branch/worktree flow is managed by Team Lead during WAVE execution. One branch per task (`wave/{TASK_ID}`), one worktree per task (`.apm/worktrees/{TASK_ID}`). Heavy untracked resources are shared at repo level. New artifacts are produced locally in the worktree and migrated during integration.
- **Skill Portability:** Whenever possible, logic should be encapsulated in reusable `.md` skills following the `agentskills.io` spec to ensure cross-compatibility between Cursor, Claude Code, and Codex.
