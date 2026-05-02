# APM (Agentic Project Management) Architecture

## 1. Overview and Core Principles

**Agentic Project Management (APM)** is a framework for agentic development across **Codex CLI**, **OpenCode CLI**, and **Claude Code**.

APM is built around two core responsibilities:

1. **Flow management**
   Defines how work proceeds, in what sequence, and through which decision and verification gates.
   This includes workflow skills, planning, artifact-mode decisions, review loops, delegation flow, and integration gates.

2. **Context management**
   Ensures the agent receives the right context, in the right scope, at the right time.
   This includes SSOT artifacts, Memory Bank files, frozen specs, nested `AGENTS.md`, skills as incremental context, and delegation contracts that pass the correct pointers forward.

These two responsibilities are tightly linked. In APM, flow is also a mechanism for controlling context: it determines which artifacts must exist, which SSOT files are binding, and what the agent must load before continuing.

Core Principles:
- **Spec-Driven Development (SDD):** Specifications and SSOT artifacts define the intended system behavior and constraints.
- **Only Essential Memory Bank:** Keep durable context minimal, structured, and sustainable across sessions.
- **Explicit Flow Control:** Development proceeds through declared workflow skills, decision gates, and verification loops.
- **Context Engineering:** APM treats context quality as the central variable in agent reliability.
- **Layered Instruction Model:** Shared rules, local rules, skills, and role configs each own a distinct part of the agent context.

---

## 2. Environments and Modalities

APM supports three active environments, tailoring its components for each ecosystem:

1. **Codex CLI (Terminal / Orchestrated):**
   - Utilizes `config.toml` for subagent declarations (`[agents.*]`) and parallel multi-agent threading.
   - Relies on standardized `.codex/skills/` following the `agentskills.io` specification.
   - Memory Bank resides in `memory_bank/`.

2. **OpenCode CLI (Terminal / Extensible):**
   - Installs OpenCode agents plus shared skills either globally (`~/.config/opencode/`) or locally (`.opencode/`).
   - Memory Bank resides in `memory_bank/`.

3. **Claude Code (Terminal / Agentic):**
   - Subagent roles in `.claude/agents/` (Markdown + YAML frontmatter), with role-level tool allowlists and optional runtime controls.
   - Skills in `.claude/skills/` following the `agentskills.io` specification.
   - Memory Bank resides in `memory_bank/`.

---

## 3. Workflow Model

APM uses a single base project template. Workflow is controlled through explicitly invoked skills, not rigid methodology boundaries.

Conceptually, APM operates through two linked layers:

- **Flow layer** -- methodology, sequence, decision gates, review loops, delegation flow.
- **Context layer** -- SSOT files, Memory Bank, specs, nested `AGENTS.md`, skills as incremental context, and selective artifact loading.

The framework works only when these two layers stay aligned: flow determines which context must be present, and context determines whether flow can continue safely.

- **Base structure** (`apm_source/base/`) provides the minimal project scaffold: `src/`, `tests/`, `logs/`, `external/`, `memory_bank/` with template files.
- **`apm-start`** initializes the project, bootstraps the dual-branch git layout (`main` clean, `dev` working), and selects the appropriate `ARCHITECTURE.md` template (product-oriented or DS/experiment-oriented) based on the project domain.
- **Workflow skills** extend the project structure on demand. For example, `apm-eda` creates `eda/` and `data/` directories; `apm-exp` creates `experiments/` and `models/`. A project may use any combination of skills as needed.

---

## 4. The Memory Bank (SSOT)

The Memory Bank ensures context continuity across multiple separate LLM sessions.

**Core Files:**
- `ARCHITECTURE.md` — The SSOT for the project's technical architecture, stack, patterns, and overarching design decisions.
- `STATE.md` — Compact operational status and continuity context.
- `TASKS.md` — High-level task overview.
- `design/SPEC-{module}.md` — Global module specifications: contracts, ready interfaces, typecheck gates, invariants, data formats. Updated only with explicit approval.
- `specs/SPEC_{id}.md` — Frozen task specification: goal, pipeline, contracts, ready interfaces, typecheck automation, Definition of Done. Read-only during execution.
- `tasks/{id}.md` — Working journal: notes, review findings, outcome.

Size guardrail:
- Keep `STATE.md` and `TASKS.md` under 120 lines; compress when limits are exceeded.

---

## 5. Agent Roles and Skills System

APM abstracts capabilities into distinct layers: agents, skills, and shared context artifacts.

### Context Layering
APM separates shared context, dynamic procedures, and role contracts into different artifact types.

- **`AGENTS.md` = common context and rules**
  Global and local instruction layer for all agents and subagents in a given area.
  The root `AGENTS.md` defines general project-wide contracts and rules.
  Nested `AGENTS.md` files define local contracts and rules for a specific area, subtree, or artifact type.
  Example: `src/AGENTS.md` carries implementation code conventions for the `src/` tree.

- **`SKILLS` = attachable procedures**
  Mechanism for dynamic, incremental instruction loading.
  Skills load only what is needed at the current moment, only for the agent that needs it, reducing context duplication and noise.

- **Agent and subagent `CONFIGS` = behavioral role contracts**
  Define the role, behavior, boundaries, and global goals of a specific agent or subagent.

### Agent Roles
- **Worker:** Universal execution unit. Receives a task, breaks it down via todo list, delivers results with self-review gate before handoff. Specifics come from the loaded skill and delegation instruction.
- **Co-Founder:** Primary project partner concept for strategic collaboration: co-owns vision, architecture, and direction. Equal strategic partner, not an assistant.
- **Code Simplifier:** Refactors recently modified code for clarity and simplicity while preserving exact behavior. Applies project coding conventions.
- **Reviewer:** Independent verification gate. Determines review scope autonomously, checks architecture alignment and ranked code risks.
- **Memory Bank Sync:** Reconciles Memory Bank files with recent work. Keeps `STATE.md`, `TASKS.md`, and task files aligned with actual project state. Proposes architecture updates with explicit approval gate.
- **Web-Explorer:** Lightweight web research specialist. Receives a focused question, returns a condensed answer with sources. Saves the caller's context window from web-fetch noise.

### Skills (Dynamic Capabilities)
Skills (`SKILL.md`) are discrete, self-contained capabilities loaded on demand. Each skill is a folder containing a required `SKILL.md` with YAML frontmatter metadata and Markdown instructions, and optional bundled resources (`scripts/`, `references/`).

Workflow skills describe HOW to work. The scenario (which artifacts exist, whether specs are involved, whether to run quality gate) is determined by the user, prompt, or delegation instruction -- not hardcoded in the skill.

In APM, a workflow skill is a skill marked as `Workflow skill` in its description. It defines the execution flow for a class of work and serves as the procedural layer the agent follows for that task type.

Primary sessions use `apm` as the main-session context-engineering overlay: it connects flow and context. It provides workflow instructions to the main agent, decides which workflow skill governs the task, binds the task to the relevant SSOT files, and keeps subagents isolated from unnecessary main-session context unless the delegation explicitly passes it.

If a frozen task spec exists, it is binding for both the main session and delegated subagents. If no task/spec is established, the main session raises an artifact-mode question: create the formal task flow or continue ad hoc.

**Available skills:**

| Skill | Purpose |
|-------|---------|
| `apm` | Main-session context-engineering overlay: load workflow instructions for the main agent, bind to SSOT files, route task flow, and isolate subagents from unnecessary context |
| `apm-start` | Project kickoff: Vision Alignment, dual-branch git bootstrap, Memory Bank initialization, environment setup |
| `apm-dev` | Workflow skill for iterative development: plan, implement, verify, self-review |
| `apm-exp` | Workflow skill for experiments (covers baselines, model variants, hypothesis-driven experiments) |
| `apm-eda` | Workflow skill for Exploratory Data Analysis: distributions, missingness, correlations, leakage risks |
| `apm-deep-feature-engineering` | Workflow skill for post-EDA feature engineering analysis with ranked candidates |
| `apm-test` | Workflow skill for testing: per-module smoke + smoke E2E, with narrow integration tests when needed |
| `apm-quality-gate` | Post-implementation quality gate: simplify, verify, review, fix loop, accept |
| `apm-git-taskflow` | Git branch/worktree isolation from `dev` with shared runtime management |
| `apm-sync` | Workflow skill for explicit Memory Bank synchronization on request |
| `apm-subagent` | Delegation contract for specialist subagents, including SSOT and frozen-spec pointers |
| `apm-logs` | Runtime logging conventions |
| `apm-autoresearch` | Workflow skill for branch-scoped autonomous research with isolated context, post-run reporting, and keep/discard logic |
| `apm-compression-mode` | Communication compression skill for explicitly requested terse replies without loss of technical meaning |

### Subagents and Delegation
In active environments, APM leverages subagents coordinated by the main session or user. Subagent configs are minimal and scenario-agnostic. `apm-subagent` standardizes how delegation requests are framed.

**Two interaction modes:**
1. **Standard mode:** The user drives work through the main session, optionally delegating to specialist subagents. User validates between steps.
2. **Co-Founder mode:** The user works with an equal project partner who co-owns vision, architecture, and direction.

**Delegation contract:** Task description, SSOT pointers (`ARCHITECTURE.md`, module spec, frozen task spec when it exists), additional context pointers, optional clarification. Subagents self-orient from the project structure and memory bank, but a frozen task spec is binding when passed.

---

## 6. APM Repository Structure

```text
APM/
├── apm_project/                 # Framework orchestrators
│   ├── apm.sh                   # Main Configurator (TUI / CLI)
│   ├── scripts/                 # Environment installers for Bash/PowerShell
│   └── tests/                   # Framework E2E tests
├── apm_source/                  # Framework Source of Truth (Payloads)
│   ├── base/                    # Unified project template (structure, Memory Bank templates, AGENTS.md)
│   ├── skills/                  # Shared skills source
│   ├── packs/                   # Active environment-specific packs
│   │   ├── codex_pack/          # Codex config and subagent role configs
│   │   ├── opencode_pack/       # OpenCode agents
│   │   └── claude_pack/         # Claude Code agents
├── docs/                        # Ecosystem and CLI documentation
├── external/                    # Incubating or third-party skill prototypes
├── APM_ARCHITECTURE.md          # THIS FILE: Framework Architecture
└── README.md                    # Project overview and Quick Start
```

---

## 7. Basic Project Workflow

1. **Initialization:** Run the `apm.sh` configurator to create the base project structure and install environment packs.
2. **Setup Phase:** Use `apm-start` to align on vision, bootstrap two independent branches (`main` clean, `dev` working), select the architecture template, and generate the initial Memory Bank on `dev` (`ARCHITECTURE.md`, `STATE.md`, `TASKS.md`, initial spec and task files).
3. **Execution Loop:** Work through workflow skills (`apm-dev`, `apm-test`, `apm-eda`, `apm-exp`, `apm-deep-feature-engineering`, etc.) on `dev`. Domain-specific skills create their required directories on first use. Use `apm-quality-gate` when independent verification is needed.
4. **Git Isolation:** When parallel or isolated execution is needed, use `apm-git-taskflow` for `dev`-based branch/worktree management with shared runtime.
5. **Synchronization:** Use `apm-sync` on explicit request whenever continuity updates are needed.

---

## 8. Core Conventions

- **File Naming:** Core instruction or agent context files strictly use **UPPERCASE** naming conventions (e.g., `AGENTS.md`, `SKILL.md`, `ARCHITECTURE.md`) to distinguish them from standard project documentation.
- **Dual-Branch Bootstrap:** `main` is a clean branch without APM working artifacts. `dev` is the primary development branch and carries the full APM working layer (`AGENTS.md`, `memory_bank/`, `external/`, `docs/`, and similar assets). The two branches are initialized with independent history.
- **Git Isolation:** One branch per execution stream from `dev` (`task/<identifier>`), one worktree per stream (`.apm/worktrees/<identifier>`). Heavy untracked resources are shared at repo level. New artifacts are produced locally in the worktree and migrated back to `dev` or shared storage during integration.
- **Implementation Conventions Layering:** Implementation code conventions are carried by `src/AGENTS.md` inside generated projects. Workflow skills and subagents should rely on that local instruction layer rather than duplicating code rules.
- **Fail-fast Runtime:** Prefer minimal fallback logic. Invalid or contradictory runtime states should fail loudly unless a fallback is explicitly required by an external contract.
- **Single-Role Files:** One file, one role. Split orchestration, domain logic, adapters, reporting, and helpers when responsibilities diverge.
- **File Size Guardrail:** Keep files ideally between 100 and 600 LOC. Allow 600-800 only when preserving a clear semantic boundary; otherwise refactor or decompose.
- **Smoke-First Testing:** Prefer per-module smoke tests and smoke E2E tests. Allow only narrow integration tests when they add unique signal. Inspect runtime logs and produced results after runs.
- **Local Source Documentation:** `src/` and every subdirectory inside `src/` should contain a `README.md` with a local script graph and a flat descriptive list of contained scripts. Keep docstrings concise.
- **Skill Portability:** Whenever possible, logic should be encapsulated in reusable `.md` skills following the `agentskills.io` spec to keep workflow instructions portable across active environments.
