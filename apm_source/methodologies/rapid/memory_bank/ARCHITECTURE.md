# Project Architecture: [Project Name]

> Note: This document is the single source of truth for the project's logic, design, and behavior. It describes what we are building and how it works logically.
> 

---

## 1. Project Idea & Philosophy

> Context: Describe the core essence, need, and vision of the project. What problem does it solve? Why does it exist?
> 

[Example: "The project is an Agentic LLM Evaluation tool. The core need is to automate the tedious process of benchmarking different LLMs against specific business tasks using a multi-agent approach. The philosophy is 'Agent-driven Quality Assurance'."]

---

## 2. Project Body (Form Factor)

> Context: In what form will the project be realized?
> 
- **Type:** [e.g., CLI Application / Python Script / Web Service / Telegram Bot]
- **Interface:** [e.g., Terminal interaction via arguments / REST API / Interactive Chat]

---

## 3. User Workflow (Operational Principle)

> Context: A step-by-step narrative of how the user interacts with the finished product. This defines the flow of the application.
> 

[Example Step-by-Step Description:

1. **User Action:** User inputs a command (e.g., `/start_eval`).
    - **System Reaction:** The system initializes the `TaskAnalyst` agent.
    - **Outcome:** A specification file is generated.
2. **User Action:** User reviews the spec and inputs `/generate_dataset`.
    - **System Reaction:** The system initializes the `DatasetSpecialist` agent.
    - **Outcome:** A JSON dataset is created or fetched.
3. ... (Continue describing the flow)
]

---

## 4. Technology Decisions

> Context: The chosen stack, libraries, and tools.
> 
- **Language:** [e.g., Python 3.11]
- **Core Libraries:** [e.g., LangChain, Pydantic, Typer]
- **Storage:** [e.g., Local JSON files, SQLite]

---

## 5. System Design

> Context: High-level architecture of the system — how modules interact, data flows between them, and what each subsystem is responsible for.

[Describe the system's major subsystems, their responsibilities, and how they connect. Include data flow direction and key boundaries.]

### Global Specifications

> Detailed module-level specs live in `memory_bank/design/SPEC-{module}.md`. Each covers one domain/subsystem: contracts, invariants, data formats, rules. Frozen after design, updated only with explicit approval.

| Spec | Scope |
|------|-------|
| [e.g. `SPEC-data.md`] | [e.g. Corpus, data splits, leakage rules] |
| [e.g. `SPEC-evaluation.md`] | [e.g. Metrics, scoring, judge config] |

### Wave Definition of Done

> Global DoD applied to every wave in addition to per-task DoD. All items must pass before a wave is considered complete.

- [ ] All task-level DoDs met (per `specs/SPEC_{TASK_ID}.md`)
- [ ] Cross-task contracts verified (type check passes)
- [ ] Wave Integration Gate passes (build, tests, dependency audit)
- [ ] No unresolved P0/P1 findings across wave tasks
- [ ] All artifacts committed and migrated from worktrees
- [ ] [Project-specific criteria added here]

---

## 6. Code Organization Pattern

> The mandatory file and code structure within the src/ directory. This pattern promotes a clear separation of concerns.
> 

[Example:

- `main.py`: **The Entrypoint & Orchestrator.** This is the only file that should be directly executed. It is responsible for parsing command-line arguments, initializing services, and coordinating the overall application flow. It should contain minimal business logic.
- `config.py`: **Configuration.** Stores all static configuration, constants, file paths (e.g., `DATABASE_FILE = "tasks.json"`), and settings.
- `utils/`: **Utilities Directory.** Contains specific, reusable helper functions that are not part of the core business logic.
    - Example: `parser.py` for validating user input, or `formatter.py` for creating styled console output.

]

---

## 7. Key Conventions & Logging

- **Modularity:** Code must be logically separated into classes and modules within `src/`.
- **Logging:** All significant events must be logged to `logs/`.
    - **Format:** `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`
- **Tools:** Reusable scripts created during development should be saved in `tools/`.