<div align="center">

```
    ___    ____  __  ___
   /   |  / __ \/  |/  /
  / /| | / /_/ / /|_/ / 
 / ___ |/ ____/ /  / /  
/_/  |_/_/   /_/  /_/   
```

# Agentic Project Management

**Standardized AI-driven development framework for Cursor IDE**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)

</div>

---

## 🎯 What is APM?

APM (Agentic Project Management) is a methodology toolkit that brings structure and predictability to AI-assisted software development. It provides:

- **CLI Configurator** - Interactive wizard to bootstrap new projects
- **Agent Roles** - Pre-defined personas for LLM agents (Architect, Engineer, SDET, Principal)
- **Cursor Commands** - Slash commands (`/apm-start`, `/apm-develop`, etc.) for seamless workflow
- **Documentation Templates** - Structured specs, tasks, and reports

> **Philosophy:** The specification is the single source of truth. Code is written to satisfy the specification, not the other way around.

---

## 📚 Core Principles

### Spec-Driven Development (SDD)

Traditional development starts with code. SDD flips this:

1. **Specify** - Define what you're building in human-readable documents
2. **Plan** - Break down into components and tasks
3. **Implement** - Write code that satisfies the specification
4. **Verify** - Tests validate against the spec, not implementation details

The specification (`ARCHITECTURE.md`, `TASK.md`) becomes executable through AI agents that understand and follow it.

### Domain-Driven Design (DDD)

Complex projects are decomposed into **bounded contexts** - isolated functional blocks with clear interfaces. In APM's FULL methodology:

- Each block has its own `task.md`, `src/`, `tests/`, and `logs/`
- Blocks can be developed in parallel by different agents
- Interfaces between blocks are explicitly defined in `ARCHITECTURE.md`

### Test-Driven Development (TDD)

In FULL methodology, the workflow follows strict TDD:

1. **RED** - SDET writes failing tests based on Acceptance Criteria
2. **GREEN** - Lead Engineer implements code to pass tests
3. **REFACTOR** - Code is cleaned up while tests stay green
4. **REVIEW** - Principal Engineer audits for quality and compliance

---

## 🔧 Methodologies

### FULL Methodology

**For:** Large projects, microservices, team collaboration

```
project/
├── .apm/
│   ├── AGENT_DRULES/         # Agent role definitions
│   ├── AGENT_REPORTS/        # Report templates
│   └── AGENT_TOOLS/          # Auxiliary scripts
├── .cursor/commands/         # Slash commands
├── {project-name}/
│   ├── {Block-1}/
│   │   ├── src/
│   │   ├── tests/
│   │   ├── logs/
│   │   └── task.md
│   ├── {Block-2}/
│   │   └── ...
│   └── {Block-N}/
├── external/
├── ARCHITECTURE.md
└── WORKFLOW.md
```

**Agent Roles:**
| Role | Responsibility |
|------|----------------|
| **System Architect** | Vision alignment, architecture design, block decomposition |
| **SDET** | Write tests before implementation (TDD) |
| **Lead Engineer** | Implement features, make tests pass |
| **Principal Engineer** | Quality audit, code review, final approval |

---

### RAPID Methodology

**For:** MVPs, prototypes, small projects

```
project/
├── .apm/
│   ├── AGENT_DROLES/
│   ├── AGENT_REPORTS/
│   └── AGENT_TOOLS/
├── .cursor/commands/
├── src/                      # Unified source directory
├── tests/
├── logs/
├── external/
├── ARCHITECTURE.md
└── TASK.md
```

**Agent Roles:**
| Role | Responsibility |
|------|----------------|
| **System Architect** | Vision alignment, architecture design |
| **Lead Engineer** | Implement features, self-test |
| **SDET** | Test coverage when needed |

Less ceremony, faster iteration, same structured approach.

---

## 🚀 Quick Start

### 1. Run the Configurator

```powershell
.\apm_project\apm.bat
```

The interactive wizard will guide you through:
1. Select project directory
2. Enter project name
3. Choose methodology (FULL / RAPID)
4. Optional GitHub integration

### 2. Open in Cursor

The configurator will offer to open Cursor automatically.

### 3. Initialize Your Project

In Cursor chat, run:

```
/apm-start I want to build a CLI task manager with local JSON storage...
```

The System Architect will:
- Analyze your request
- Output a structured understanding (Idea, Body, Workflow)
- Propose improvements
- Wait for your confirmation
- Create `ARCHITECTURE.md` and task files

### 4. Start Development

```
/apm-develop
```

The Lead Engineer picks up tasks and begins implementation.

---

## 💻 Commands

| Command | Description |
|---------|-------------|
| `/apm-start` | Initialize project with System Architect (Vision Alignment) |
| `/apm-develop` | Activate Lead Engineer for development |
| `/apm-report` | Generate reports using templates (General, Test, E2E, Debug) |
| `/apm-review` | Conduct architecture review and quality audit |

---

## 📋 Documentation Templates

### ARCHITECTURE.md
The master blueprint containing:
- Project Idea & Philosophy
- Form Factor (CLI, Web, API, etc.)
- User Workflow (step-by-step interaction)
- Technology Decisions
- Component Design
- Code Organization

### TASK.md / task.md
Work tracking with:
- Feature Backlog (checklist)
- Current Task in Focus
- Implementation Plan (scratchpad)

### Report Templates
- `GENERAL_REPORT_TEMPLATE.md` - Work summaries
- `TEST_REPORT_TEMPLATE.md` - Test execution results
- `E2E_REPORT_TEMPLATE.md` - User scenario validation
- `DEBUGGING_REPORT_TEMPLATE.md` - TDD cycle diagnostics

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

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

<div align="center">

**APM** - Structure your AI Management.

</div>

