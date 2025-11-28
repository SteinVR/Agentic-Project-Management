# Project Workflow: AI-Driven, Spec-First Development

## 1. Core Principles

This project is governed by the following principles. All agents must adhere to them.

1. **Spec-Driven (SDD)**: The specification (`ARCHITECTURE.md`, `task.md`) is the single source of truth. Code is written to satisfy the specification.
2. **Test-First (TDD)**: Tests are written *before* implementation code. Tests are the primary definition of "done".
3. **Immutable Tests**: Tests are a contract. If a test fails, the code is wrong, not the test. Tests may only be changed if the specification (`task.md`) changes.
4. **Modularity (DDD)**: The project is divided into isolated functional blocks (Bounded Contexts). Agents must respect these boundaries to ensure low coupling.
5. **Fail-Fast**: Feedback loops are designed to catch errors as early as possible, ideally before code is committed.

## 2. Agent Team & Responsibilities

- **System Architect**: The strategic planner. Translates the manager's vision into a technical blueprint (`ARCHITECTURE.md`) and decomposes the work into modular tasks (`task.md`).
- **Senior Software Development Engineer in Test (SDET)**: The quality guardian. Writes comprehensive tests based on `task.md` *before* implementation begins. Thinks adversarially to find edge cases.
- **Senior Software Engineer**: The implementer. Writes clean, efficient code to pass the tests provided by the Tester, strictly following architectural guidelines.
- **Principal Engineer**: The final quality gate. Audits code, tests, and coverage. Verifies compliance with `ARCHITECTURE.md` and provides structured feedback.

## 3. Development Flow

The development of each functional block follows these strict phases:

### **Phase 1: Architecture & Specification (System Architect)**

1. Receives high-level requirements from the Manager.
2. Creates/updates the master `ARCHITECTURE.md` file.
3. Defines the interfaces and contracts between all blocks.
4. Creates a `task.md` file for each block with detailed `Business Context` and `Acceptance Criteria`.

### **Phase 2: Test-First Implementation (SDET -> Engineer)**

1. **Tester**: Reads `task.md` and writes a complete suite of *failing* tests that cover all acceptance criteria. (RED phase).
2. **Developer**: Receives the `task.md` and the failing tests. Implements the feature code until all tests pass. (GREEN phase).
3. **Developer**: Refactors the code for clarity and efficiency while ensuring all tests continue to pass. (REFACTOR phase).
4. This cycle is repeated until all criteria in `task.md` are met and test coverage goals are achieved.

### **Phase 3: Quality Audit & Integration (Principal Engineer)**

1. Receives the implemented code and the passing test suite.
2. Performs a final audit based on its internal checklist (code quality, architectural compliance, test coverage).
3. If accepted, approves the block for integration.
4. If rejected, creates a detailed report using the **Agent Feedback Protocol** and assigns the task back to the Developer or Tester.

## 4. Agent Feedback Protocol

//TO-DO

Расширить AFP: Разделить на inline часть и на Direct Feedback / Report файлы

The Agent Feedback Protocol is used for structured, actionable communication between agents, primarily from the Team Lead. It is written directly into source code as comments or in review reports.

- `// FOR-[AGENT_ROLE]-TODO: [Concise and actionable task]`
    - **Purpose:** Assign a specific correction.
    - **Example:** `// FOR-DEVELOPER-TODO: Refactor this function to use the utility from /TOOLS/validators.js.`
    - **Example:** `// FOR-TESTER-TODO: Add a test case for null input on this function.`
- `// [AGENT_ROLE]-NOTE: [An observation or explanation]`
    - **Purpose:** To provide context or explain a decision.
    - **Example:** `// TEAM-LEAD-NOTE: The current implementation violates the single-responsibility principle. See ARCHITECTURE.md section 3.2.`