<div align="center">    

# Agentic Project Management

**Standardized AI-driven development framework for Cursor IDE**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Linux%20|%20macOS-lightgrey.svg)]()

</div>

---

## 🎯 What is APM?

APM (Agentic Project Management) is a methodology toolkit that brings structure and predictability to AI-assisted software development in Cursor IDE. It provides:

- **CLI Configurator** - Interactive wizard to bootstrap new projects (Windows, Linux, macOS)
- **Agent Roles** - Pre-defined personas for LLM agents (Architect, Engineer, SDET, Data Scientist)
- **Cursor Commands** - Slash commands for seamless workflow (`/apm-start`, `/apm-develop`, `/apm-scientist`, etc.)
- **Memory Bank** - Persistent project state across sessions stored in `memory bank/` directory
- **Documentation Templates** - Structured specs, tasks, and reports

---

## 📚 Core Principles

### Spec-Driven Development (SDD)

Traditional development starts with code. SDD flips this:

1. **Specify** - Define what you're building in human-readable documents
2. **Plan** - Break down into components and tasks
3. **Implement** - Write code that satisfies the specification
4. **Verify** - Tests validate against the spec, not implementation details

The specification becomes executable through AI agents that understand and follow it.

### Memory Bank Pattern

APM uses a **Memory Bank** pattern to solve the context loss problem in long-running AI-assisted projects:

- All project state is stored in `memory bank/` directory
- `ARCHITECTURE.md` is the single source of truth for design
- `TASK.md` tracks work backlog (features for RAPID, hypotheses for DS)
- `STATE.md` maintains session history and active context
- Agents are required to update Memory Bank at the end of each session

---

## 🔧 Methodologies

### DS Methodology (Data Science)

**For:** Machine Learning projects, data analysis, research experiments

```
project/
├── .apm/
│   ├── AGENT_ROLES/          # Agent role definitions
│   ├── TEMPLATES/            # Document templates
│   └── REPORTS/              # Report storage
├── .cursor/commands/         # Slash commands
├── src/                      # Reusable modules
├── experiments/              # Experiment tracking
│   └── EXP-XXX/              # Individual experiments
├── eda/                      # Exploratory data analysis
├── models/                   # Saved models
├── logs/                     # Execution logs
├── memory bank/              # Memory Bank
│   ├── ARCHITECTURE.md       # Problem definition & architecture
│   ├── TASK.md               # Hypothesis backlog
│   └── STATE.md              # Experiment history & state
├── config.py                 # Project configuration
└── main.py                   # Entry point
```

**Agent Roles:**
| Role | Responsibility |
|------|----------------|
| **System Architect** | Problem definition, success criteria, data architecture |
| **Data Scientist** | EDA, feature engineering, model training, experiments |

**Workflow:** Hypothesis-driven experimentation with rigorous tracking.

---

### RAPID Methodology

**For:** MVPs, prototypes, small software projects

```
project/
├── .apm/
│   ├── AGENT_ROLES/          # Agent role definitions
│   ├── TEMPLATES/            # Document templates
│   └── REPORTS/              # Report storage
├── .cursor/commands/         # Slash commands
├── src/                      # Unified source directory
├── tests/                    # Test suite
├── logs/                     # Execution logs
└── memory bank/              # Memory Bank
    ├── ARCHITECTURE.md       # Project architecture
    ├── TASK.md               # Feature backlog
    └── STATE.md              # Project state & history
```

**Agent Roles:**
| Role | Responsibility |
|------|----------------|
| **System Architect** | Vision alignment, architecture design |
| **Lead Engineer** | Implement features, self-test |
| **SDET** | Test coverage when needed |

Less ceremony, faster iteration, same structured approach.

---

### FULL Methodology (Deprecated)

**Status:** ⚠️ Deprecated - Use RAPID for new projects

The FULL methodology with block-based architecture is no longer actively maintained. For large projects, consider using RAPID methodology with clear module boundaries.

---

## 🚀 Quick Start

### 1. Run the Configurator

**Windows (PowerShell):**
```powershell
.\apm_project\apm.ps1
```

**Windows (Command Prompt):**
```cmd
.\apm_project\apm.bat
```

**Linux / macOS:**
```bash
chmod +x ./apm_project/apm.sh
./apm_project/apm.sh
```

The interactive wizard will guide you through:
1. Select project directory
2. Enter project name
3. Choose methodology (DS / RAPID / FULL)
4. Optional GitHub integration

### 2. Open in Cursor

The configurator will offer to open Cursor automatically.

### 3. Initialize Your Project

In Cursor chat, run:

**For RAPID projects:**
```
/apm-start I want to build a CLI task manager with local JSON storage...
```

**For DS projects:**
```
/apm-start I want to predict customer churn using transaction history...
```

The System Architect will:
- Analyze your request
- Output a structured understanding (Idea, Body, Workflow for RAPID; Problem Statement, Success Criteria for DS)
- Propose improvements
- Wait for your confirmation
- Create `memory bank/ARCHITECTURE.md` and `memory bank/TASK.md`

### 4. Start Development

**For RAPID:**
```
/apm-develop
```
The Lead Engineer picks up tasks and begins implementation.

**For DS:**
```
/apm-scientist
```
The Data Scientist begins exploratory analysis and experiments.

---

## 💻 Commands

### Core Commands (RAPID & DS)

| Command | Description |
|---------|-------------|
| `/apm-start` | Initialize project with System Architect (Vision Alignment / Problem Definition) |
| `/apm-architect` | Activate System Architect for consultation or review |
| `/apm-review` | Conduct architecture review and quality audit |
| `/apm-report` | Generate reports using templates |
| `/apm-sync` | Sync Memory Bank - update `memory bank/STATE.md` with current project state |

### RAPID Methodology Commands

| Command | Description |
|---------|-------------|
| `/apm-develop` | Activate Lead Engineer for development |
| `/apm-tester` | Activate SDET role for quality assurance |
| `/apm-ci` | Generate GitHub Actions CI workflow (tests, coverage) |

### DS Methodology Commands

| Command | Description |
|---------|-------------|
| `/apm-scientist` | Activate Data Scientist for experiments |
| `/apm-eda` | Exploratory Data Analysis workflow |
| `/apm-experiment` | Run a hypothesis-driven experiment |
| `/apm-baseline` | Create baseline model |
| `/apm-env` | Setup project environment (dependencies, config) |

---

## 🧠 Memory Bank

Memory Bank provides persistent context across agent sessions, solving the "context loss" problem in long-running projects. All Memory Bank files are stored in the `memory bank/` directory.

### Components

**`memory bank/ARCHITECTURE.md`** - Single source of truth
- Project Idea & Philosophy (RAPID) or Problem Statement (DS)
- Form Factor and User Workflow
- Technology Decisions
- Component Design
- Code Organization Pattern

**`memory bank/TASK.md`** - Work tracking
- Feature Backlog (RAPID) or Hypothesis Backlog (DS)
- Current Task/Hypothesis in Focus
- Implementation/Experiment Plan

**`memory bank/STATE.md`** - Active project state
- Current focus and blockers
- Session history for continuity
- Experiment History (DS) or Decision Log (RAPID)
- Best Model Tracker (DS) or Known Issues (RAPID)

### Sync Workflow

Run `/apm-sync` periodically to:
1. Scan recent changes in `src/`, `logs/`, `experiments/`, and docs
2. Update `memory bank/STATE.md` with current project state
3. Document any architecture deviations

**Important:** Agents are required to update `memory bank/STATE.md` at the end of each session to maintain context continuity.

---

## 📋 Documentation Templates

All templates are stored in `.apm/TEMPLATES/` and copied to `memory bank/` during project initialization.

### `memory bank/ARCHITECTURE.md`
The master blueprint containing:
- Project Idea & Philosophy (RAPID) or Problem Statement & Success Criteria (DS)
- Form Factor (CLI, Web, API, etc.)
- User Workflow (step-by-step interaction)
- Technology Decisions
- Component Design
- Code Organization

### `memory bank/TASK.md`
Work tracking with:
- Feature Backlog (RAPID) or Hypothesis Backlog (DS)
- Current Task/Hypothesis in Focus
- Implementation/Experiment Plan

### `memory bank/STATE.md`
Project state tracking:
- Active Context (current focus, blockers)
- Session History
- Experiment History (DS) or Decision Log (RAPID)
- Best Model Tracker (DS) or Known Issues (RAPID)

### Report Templates (`.apm/TEMPLATES/AGENT_REPORTS_TMP/`)
- `GENERAL_REPORT_TMP.md` - Work summaries
- `TEST_REPORT_TMP.md` - Test execution results
- `E2E_REPORT_TMP.md` - User scenario validation
- `DEBUGGING_REPORT_TMP.md` - TDD cycle diagnostics
- `EDA_REPORT_TMP.md` (DS) - Exploratory Data Analysis findings
- `EXPERIMENT_REPORT_TMP.md` (DS) - Experiment results and analysis
- `MODEL_REPORT_TMP.md` (DS) - Model evaluation and comparison

---

## 💡 Recommendations

### Context Engineering with Shotgun Code

For complex projects, I recommend using [**Shotgun Code**](https://github.com/glebkudr/shotgun_code) - a desktop tool that:

- **Auto-Context** - AI analyzes your task and selects relevant files automatically
- **Smart Packaging** - Structures your codebase into LLM-optimized payloads
- **Direct Execution** - Send prompts to OpenAI, Gemini, or OpenRouter
- **History Tracking** - Audit all prompts and responses

> **Workflow:** Use Shotgun to prepare context for complex refactoring tasks, then paste into Cursor with `/apm-develop` for structured execution.

---

## 🔗 Inspiration

APM is inspired by:
- [GitHub Spec Kit](https://github.com/github/spec-kit) - Spec-Driven Development toolkit
- Enterprise software development practices
- Domain-Driven Design by Eric Evans
- Test-Driven Development by Kent Beck
