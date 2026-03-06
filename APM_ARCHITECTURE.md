# APM (Agentic Project Management) Architecture

## 1. Overview and Core Principles

**Agentic Project Management (APM)** is an AI-driven development framework designed to standardize and streamline LLM-assisted workflows across multiple environments: **Cursor IDE**, **Codex CLI**, and **OpenCode CLI**.

Core Principles:
- **Spec-Driven Development (SDD):** The specification is the Single Source of Truth (SSOT). Code must follow the documented architecture, not the other way around.
- **Only Essential Memory Bank:** Maintain a minimal, highly structured set of Markdown files to preserve sustainable context across sessions without overwhelming the LLM.
- **Context Engineering:** Emphasize declarative control, predictable determinism, and token efficiency to maximize AI output quality and consistency.
- **Role-Based Execution:** Tasks are delegated to specialized agent profiles (e.g., Architect, Engineer, SDET, Data Scientist) acting sequentially or concurrently.

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
   - Memory Bank resides in `memory_bank/`.

3. **OpenCode CLI (Terminal / Extensible):**
   - Implements custom `commands/`, `agents/`, `skills/`, and `tools/` either globally (`~/.config/opencode/`) or locally (`.opencode/`).
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

### Agent Roles
Agents represent specific "personas" with customized system prompts and constraints.
- **Architect:** Designs system boundaries, reviews structure, updates `ARCHITECTURE.md`.
- **Lead Engineer / Developer:** Focuses on implementation, adhering to specs.
- **SDET (Software Development Engineer in Test):** Focuses entirely on QA, testing, and test automation.
- **Data Scientist:** Executes the DS methodology loop.
- **Code Simplifier:** Refactors recently modified code for clarity and simplicity while preserving exact behavior. Applies project coding conventions. Activated via `/apm-simplify` (Cursor) or `apm-code-simplifier` skill.

### Skills (Dynamic Capabilities)
Skills (`SKILL.md`) are discrete, self-contained capabilities loaded on demand. Each skill is a folder containing a required `SKILL.md` with YAML frontmatter metadata and Markdown instructions, and optional bundled resources (`scripts/`, `references/`, `agents/`).

**Two-level hierarchy:**
- **High-level (orchestrating) skills:** Define what to do, in which order, and when to switch modes. Delegate specialized execution to low-level skills.
- **Low-level (atomic) skills:** Define how to execute one specific process end-to-end, with steps, checklists, and edge cases. Self-contained; do not call other skills.

**Available skills:**

| Skill | Purpose |
|-------|---------|
| `apm-start` | Vision Alignment (RAPID) or Problem Definition (DS); initializes the Memory Bank |
| `apm-arch` | Architecture consultation and `ARCHITECTURE.md` updates |
| `apm-dev` | Lead Engineer implementation loop |
| `apm-code-simplifier` | Behavior-preserving simplification of recently modified code |
| `apm-test` | SDET testing and QA workflow |
| `apm-review` | Architecture and code review |
| `apm-sync` | Explicit Memory Bank synchronization on request |
| `apm-report` | Generate reports from templates |
| `apm-logs` | Structured activity log management |
| `apm-orchestrate` | Orchestrate complex tasks across subagents (fan-out/fan-in) |
| `apm-eda` | Exploratory Data Analysis workflow |
| `apm-deep-feature-engineering` | Deep post-EDA feature engineering analysis |
| `apm-ds-baseline` | Build domain-credible baseline models |
| `apm-ds-exp` | Hypothesis-driven DS experiment cycle |
| `apm-model-report` | DS model evaluation report generation |
| `apm-skill-creator` | Guidance for creating and updating APM skills |

### Subagents and Orchestration
In modern environments (Cursor 2.5+ and Codex CLI), APM leverages asynchronous/parallel subagents managed by the `apm-orchestrate` skill.

**Orchestration paradigm (fan-out/fan-in):**
1. **Plan (sequential):** Analyze the task, map subtask dependencies, choose execution mode (sequential / parallel / hybrid), define delegation contracts per subtask.
2. **Execute (fan-out):** Delegate subtasks to subagents with precise invocations. Each contract specifies scope, owned file paths, done criteria, output format, and constraints.
3. **Integrate (fan-in):** Collect outputs, apply aggregation strategy (diff merge by ownership, set-union for findings, LLM synthesis for narratives), run verification, update Memory Bank.

**Default policy:** Hybrid — sequential planning phase, parallel read-mostly phase (research/analysis/drafts), sequential integration phase.

Every subagent invocation must include: concrete scope, file references, success criteria, expected output format, and constraints.

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
│   │   ├── codex_pack/          # Subagent roles (.toml) for Codex CLI
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
3. **Execution Loop:** Work through role-specific commands (e.g., `/apm-develop`, `/apm-simplify`, `/apm-test` for RAPID; or `/apm-eda`, `/apm-deep-feature-engineering`, `/apm-experiment` for DS).
4. **Synchronization:** Invoke `/apm-sync` when explicit synchronization is requested.

---

## 8. Core Conventions

- **File Naming:** Core instruction or agent context files strictly use **UPPERCASE** naming conventions (e.g., `AGENTS.md`, `SKILL.md`, `ARCHITECTURE.md`) to distinguish them from standard project documentation.
- **Continuity Guarantee:** Use `tasks/{TASK_ID}.md` and activity reports as primary working memory during execution; sync into Memory Bank only when explicitly requested.
- **Skill Portability:** Whenever possible, logic should be encapsulated in reusable `.md` skills following the `agentskills.io` spec to ensure cross-compatibility between Cursor, Claude Code, and Codex.
