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
   - Utilizes `.cursor/rules/`, `.cursor/commands/`, and `.apm/TEMPLATES/`.
   - Leverages Cursor's native Subagents and Skills system (`SKILL.md`).
   - Memory Bank resides in `memory bank/` (with a space).

2. **Codex CLI (Terminal / Orchestrated):**
   - Utilizes `config.toml` for subagent declarations (`[agents.*]`) and parallel multi-agent threading.
   - Relies on standardized `.codex/skills/` following the `agentskills.io` specification.
   - Memory Bank resides in `memory-bank/` (hyphenated).

3. **OpenCode CLI (Terminal / Extensible):**
   - Implements custom `commands/`, `agents/`, `skills/`, and `tools/` either globally (`~/.config/opencode/`) or locally (`.opencode/`).
   - Memory Bank resides in `memory-bank/`.

---

## 3. Supported Methodologies

APM defines strict workflows based on the nature of the project:

- **RAPID:** Designed for fast, iterative software product development with minimal ceremonial overhead. Focuses on the core `develop -> test -> sync` loop.
- **DS (Data Science):** Specialized workflow for analytical, ML, and research projects. Progresses through `EDA -> Baseline -> Experimentation -> Evaluation -> Finalization`.
- **FULL (Deprecated):** Legacy workflow maintained only for older Cursor projects.

---

## 4. The Memory Bank (SSOT)

The Memory Bank is the heartbeat of any APM project, ensuring context continuity across multiple separate LLM sessions.

**Core Files:**
- `ARCHITECTURE.md` — The SSOT for the project's technical architecture, stack, patterns, and overarching design decisions.
- `TASK.md` — The actionable backlog, task breakdown, or active list of data science experiments.
- `STATE.md` — The dynamic active context. Tracks current progress, immediately resolved blockers, decisions made during the session, and session history. **Must be updated at the end of every meaningful session.**

---

## 5. Agent Roles and Skills System

APM abstracts capabilities into distinct layers: Agents, Commands, and Skills.

### Agent Roles
Agents represent specific "personas" with customized system prompts and constraints.
- **Architect:** Designs system boundaries, reviews structure, updates `ARCHITECTURE.md`.
- **Lead Engineer / Developer:** Focuses on implementation, adhering to specs.
- **SDET (Software Development Engineer in Test):** Focuses entirely on QA, testing, and test automation.
- **Data Scientist:** Executes the DS methodology loop.

### Skills Hierarchy (Dynamic Capabilities)
Skills (`SKILL.md`) are discrete capabilities loaded dynamically.
- **High-Level (Orchestrating) Skills:** Define intent, goals, validation gates, and expected outcomes. They coordinate workflows and can invoke low-level skills.
- **Low-Level (Procedural) Skills:** Define step-by-step tactical execution procedures (e.g., "how to deploy to staging", "how to parse logs").

### Subagents (Parallel Execution)
In modern environments (Cursor 2.5+ and Codex CLI), APM leverages asynchronous/parallel subagents. A primary orchestration thread can fan-out tasks to specialized subagents (e.g., delegating a wide codebase search or concurrent code review) and wait for a consolidated response.

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
│   └── legacy/                  # Frozen legacy assets
│       └── full_deprecated/
├── docs/                        # Extensive ecosystem and CLI documentation
├── APM_ARCHITECTURE.md          # THIS FILE: Framework Architecture
└── README.md                    # Project overview and Quick Start
```

---

## 7. Basic Project Workflow

1. **Initialization:** Run the `apm.sh` configurator to stamp out the methodology, environment, and initial directory structure.
2. **Setup Phase:** Run `/apm-start` to align on vision and generate the initial Memory Bank (`ARCHITECTURE.md`, `TASK.md`).
3. **Execution Loop:** Work through role-specific commands (e.g., `/apm-develop`, `/apm-test` for RAPID; or `/apm-eda`, `/apm-experiment` for DS).
4. **Synchronization:** Invoke `/apm-sync` or manually mandate the LLM to update `STATE.md` at the end of every active session to preserve context for the next iteration.

---

## 8. Core Conventions

- **File Naming:** Core instruction or agent context files strictly use **UPPERCASE** naming conventions (e.g., `AGENTS.md`, `SKILL.md`, `ARCHITECTURE.md`) to distinguish them from standard project documentation.
- **Continuity Guarantee:** Any architectural deviation or significant implementation choice made during a session must immediately be reflected in `STATE.md` (and subsequently `ARCHITECTURE.md` if systemic).
- **Skill Portability:** Whenever possible, logic should be encapsulated in reusable `.md` skills following the `agentskills.io` spec to ensure cross-compatibility between Cursor, Claude Code, and Codex.
