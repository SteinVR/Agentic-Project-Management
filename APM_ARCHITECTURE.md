# APM (Agentic Project Management) Architecture

## 1. Overview and Core Principles

**Agentic Project Management (APM)** is an AI-driven development framework designed to standardize and streamline LLM-assisted workflows across multiple environments: **Cursor IDE**, **Codex CLI**, and **OpenCode CLI**.

Core Principles:
- **Spec-Driven Development (SDD):** The specification is the Single Source of Truth (SSOT). Code must follow the documented architecture, not the other way around.
- **Only Essential Memory Bank:** Maintain a minimal, highly structured set of Markdown files to preserve sustainable context across sessions without overwhelming the LLM.
- **Context Engineering:** Emphasize declarative control, predictable determinism, and token efficiency to maximize AI output quality and consistency.
- **Role-Based Execution:** Tasks are delegated to specialized agent profiles (e.g., Team Lead, Architect, Engineer, SDET, Data Scientist, Code Reviewer, Memory Bank Sync) acting sequentially or concurrently.

---

## 2. Environments and Modalities

APM supports three distinct environments (or workflows), tailoring its components for each ecosystem:

1. **Cursor IDE (Interactive UI):**
   - Utilizes `.cursor/agents/`, `.cursor/commands/`, and shared skills.
   - Leverages Cursor's native Subagents and Skills system (`SKILL.md`).
   - Memory Bank resides in `memory_bank/`.

2. **Codex CLI (Terminal / Orchestrated):**
   - Utilizes `config.toml` for subagent declarations (`[agents.*]`) and parallel multi-agent threading.
   - Relies on standardized `.codex/skills/` following the `agentskills.io` specification.
   - Supports optional primary-session operating modes such as `apm-team-lead` and `apm-critical-execution` while keeping specialist subagents narrow.
   - Memory Bank resides in `memory_bank/`.

3. **OpenCode CLI (Terminal / Extensible):**
   - Implements custom `commands/`, `agents/`, `skills/`, and `tools/` either globally (`~/.config/opencode/`) or locally (`.opencode/`).
   - Supports a Team Lead primary-agent mode (`apm-team-lead`) for orchestration-first execution.
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
- `tasks/TASKS.md` — Grouped high-level project tasks.
- `tasks/{TASK_ID}.md` — Per-task execution notes and working plan.

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
- **Team Lead:** Primary orchestration role for complex execution. Delegates execution to specialized subagents, validates what they return, integrates outputs, and handles only small low-risk direct edits when delegation overhead is unjustified.
- **Code Simplifier:** Refactors recently modified code for clarity and simplicity while preserving exact behavior. Applies project coding conventions. Activated via `/apm-simplify` (Cursor) or `apm-code-simplifier` skill.
- **Code Reviewer:** Runs independent verification and review gates, checking task/architecture alignment and ranked code risks before final handoff.
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
| `apm-git-taskflow` | Team Lead/manual git flow: task-scoped branch/worktree, PR flow, and conflict policy under explicit triggers |
| `apm-quality-gate` | Shared final quality gate for code-writing flows: simplify, verify, review, fix, and handoff |
| `apm-code-simplifier` | Behavior-preserving simplification of recently modified code |
| `apm-test` | SDET testing and QA workflow |
| `apm-review` | Architecture and code review |
| `apm-sync` | Explicit Memory Bank synchronization on request |
| `apm-report` | Write a structured agent session log for the current work |
| `apm-logs` | Structured project-log and agent-log taxonomy management |
| `apm-team-lead` | Team Lead orchestration mode for delegation-first execution in Codex and OpenCode |
| `apm-critical-execution` | Codex-only primary-session mode for intent reconstruction, spec challenge, and goal-first execution |
| `apm-subagent` | Role-specific delegation contract skill for current specialist subagents |
| `apm-eda` | Exploratory Data Analysis workflow |
| `apm-deep-feature-engineering` | Deep post-EDA feature engineering analysis |
| `apm-ds-baseline` | Build domain-credible baseline models |
| `apm-ds-exp` | Hypothesis-driven DS experiment cycle |
| `apm-model-report` | DS model evaluation report generation |
| `apm-skill-creator` | Guidance for creating and updating APM skills |

### Subagents and Orchestration
In modern environments (Cursor 2.5+, Codex CLI, and OpenCode), APM leverages subagents coordinated by the orchestrating session. Subagent configs are mode-agnostic: they work identically whether the orchestrator is Team Lead, a standard main session, or a workflow skill. `apm-subagent` standardizes how delegation requests are framed for current specialist roles.

**Two interaction modes:**
1. **Standard mode (sequential):** The user drives work through the main session, which delegates to specialist subagents for localized execution via workflow skills. One task at a time, user validates between steps.
2. **Team Lead mode (orchestration-first):** The user assigns one or more tasks to Team Lead, which orchestrates parallel subagent streams, validates results, integrates outputs, and returns one compact final handoff. Activated via Shift+Tab in OpenCode (cycle to Team Lead primary agent) or by loading the `apm-team-lead` skill in Codex.

**Orchestration paradigm (fan-out/fan-in):**
1. **Frame (sequential):** Analyze the task, identify scope, success criteria, and dependencies.
2. **Decompose (when needed):** Split multi-part work into delegation units with explicit TASK_ID boundaries. Skip when tasks arrive pre-decomposed.
3. **Delegate (fan-out):** Assign units to subagents with precise invocations. Each contract specifies scope, owned file paths, done criteria, output format, and constraints.
4. **Validate:** Review returned handoffs, inspect diffs, artifacts, and verification evidence.
5. **Integrate (fan-in):** Merge results, resolve mechanical conflicts, run integration verification.
6. **Handoff:** Return compact final handoff to the user.

**Default policy:** Hybrid -- sequential framing/decomposition, parallel execution where ownership zones do not overlap, sequential integration.

Every subagent invocation must include: concrete scope, file references, success criteria, expected output format, and constraints.
`apm-subagent` is the low-level skill for role-specific prompt framing; it does not choose execution mode or perform integration.
Subagents return compact handoffs and write `apm-report` logs under `logs/agents/{TASK_ID}/`. The orchestrating session writes its consolidated log under `logs/agents/{TASK_ID}/` (single-task) or `logs/agents/` root (multi-task). In Team Lead mode, the final user-facing handoff is a separate artifact: compact, decision-ready, and organized by task.
`apm-critical-execution` is primary-session only; do not load it into specialist subagents.
For development and DS code-writing loops, the default post-implementation quality gate is:
`initial verification -> apm-quality-gate`, where `apm-quality-gate` runs
`apm-code-simplifier -> verification -> apm-code-reviewer -> main-agent remediation -> completion handoff`.
Specialist subagents that run quality-gate-prescribing skills (e.g., `apm-dev`, `apm-ds-baseline`) may spawn sub-subagents for the quality gate chain (max 1 additional layer).
Git branch/worktree/PR flow is opt-in and is initialized manually by the user, or by Team Lead when explicit TASK_ID subtasks (or direct git-flow request) are provided.
For explicit synchronization requests, `apm-sync` may delegate reconciliation to `apm-memory-bank-sync`.

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
3. **Execution Loop:** Work through role-specific commands (e.g., `/apm-develop`, `/apm-simplify`, `/apm-test` for RAPID; or `/apm-eda`, `/apm-deep-feature-engineering`, `/apm-experiment` for DS). Write-capable tasks use simplify/review/remediation and end with a verified completion handoff.
4. **Synchronization:** Run `/apm-sync` on explicit request whenever continuity updates are needed.

---

## 8. Core Conventions

- **File Naming:** Core instruction or agent context files strictly use **UPPERCASE** naming conventions (e.g., `AGENTS.md`, `SKILL.md`, `ARCHITECTURE.md`) to distinguish them from standard project documentation.
- **Continuity Guarantee:** Use `tasks/{TASK_ID}.md` and agent logs as primary working memory during execution; sync into Memory Bank only when explicitly requested.
- **Git Isolation:** Branch/worktree/PR flow is opt-in and managed manually by user or by Team Lead only under explicit triggers (`TASK_ID` streams or direct request).
- **Skill Portability:** Whenever possible, logic should be encapsulated in reusable `.md` skills following the `agentskills.io` spec to ensure cross-compatibility between Cursor, Claude Code, and Codex.
