Файл описывающий структуру команды разработки и архитектурный подход к разработке.

Примерный шаблон:
# Project Workflow: Spec-Driven Agile Development

## Architecture Approach
- **Domain-Driven Design** with Bounded Contexts
- **Microservices/Modular** architecture
- **Contract-First** Contracts/Interfaces
- **Test-Driven Development** (TDD)

## Development Methodology
**Spec-Driven Development** — comprehensive upfront planning, 
modular execution, continuous feedback loops.

## Agent Team Structure

### 1. System Architect (Orchestrator)
- Defines Bounded Contexts
- Creates ARCHITECTURE.md and API contracts
- Monitors technical debt
- Context: Full project access

### 2. Developer (Implementation)
- Implements task.md following architecture
- Passes Tester's tests
- Cannot modify tests or contracts

### 3. Tester (Quality Assurance - TDD)
- Writes tests BEFORE implementation (Red phase)
- Adversarial testing mindset
- Ensures > 80% coverage

### 4. Team Lead (Integration & DevOps)
- Final quality gate
- CI/CD management
- Production monitoring
- Context: Full project + metrics/logs

## Feedback Loop Stages

### Code-Level Feedback (< 1s)
- LSP type checking (real-time)
- Pre-commit hooks (typecheck, security, tests)
- Linters and formatters

### Environment Feedback (< 5min)
- Unit tests (after each commit)
- Contract tests (on interface changes)
- Integration tests (before merge)

### Contextual Feedback (< 30min)
- CI/CD pipeline (staging deployment)
- E2E tests (nightly builds)
- Performance benchmarks

### Human Feedback (hours-days)
- Team Lead review
- User acceptance testing
- Production monitoring

## Development Flow

### Phase 1: Planning (System Architect)
1. Define Bounded Contexts
2. Create API contracts for each module
3. Write task.md for each module
4. Setup pre-commit hooks and CI/CD

### Phase 2: Test-First Implementation (Tester → Developer)
1. **Tester**: Write failing tests based on task.md (Red)
2. **Developer**: Implement code until tests pass (Green)
3. **Tester**: Add edge case tests (adversarial)
4. **Developer**: Fix until all tests green
5. Repeat until coverage > 80%

### Phase 3: Quality Review (Team Lead)
1. Verify all tests passing
2. Check contract compliance
3. Audit test quality and coverage
4. Review architectural alignment
5. **Accept** → CI/CD pipeline
6. **Reject** → detailed protocol → back to Developer/Tester

### Phase 4: CI/CD Automation
1. Run full test suite
2. Security scan
3. Deploy to staging
4. Smoke tests on staging
5. **Green** → progressive production rollout
6. **Red** → automated rollback + report to Developer


## Quality Gates (Cannot Bypass)

### Developer Gates
- ✅ TypeScript typecheck passing
- ✅ Pre-commit hooks green
- ✅ Tester's tests passing
- ✅ No security vulnerabilities

### Tester Gates
- ✅ Unit test coverage > 80%
- ✅ Contract tests validate APIs(If is it used)
- ✅ Integration tests confirm module interaction
- ✅ Edge cases documented and tested

### Team Lead Gates
- ✅ All test suites passing
- ✅ Architecture compliance verified
- ✅ Technical debt documented
- ✅ Staging smoke tests green

### CI/CD Gates
- ✅ Main part of pipeline green
- ✅ Staging metrics stable
- ✅ Security scan clean
- ✅ Production SLO maintained

## Key Principles

1. **Spec-Driven**: Comprehensive planning before execution
2. **Test-First**: Tests written before implementation (TDD)
3. **Contract-First**: Interfaces/Contracts defined upfront
4. **Fail-Fast**: Immediate feedback at every stage
5. **Immutable Tests**: Tests are specifications, not suggestions
6. **Automated Quality**: No manual gates, only automated checks
7. **Incremental Deployment**: Progressive rollout with rollback
8. **Observability**: Continuous monitoring and metrics

---

Вторая версия шаблона:
# Project Workflow: AI-Driven, Spec-First Development

## 1. Core Principles

This project is governed by the following principles. All agents must adhere to them.

1.  **Spec-Driven**: The specification (`ARCHITECTURE.md`, `task.md`) is the single source of truth. Code is written to satisfy the specification.
2.  **Test-First (TDD)**: Tests are written *before* implementation code. Tests are the primary definition of "done".
3.  **Immutable Tests**: Tests are a contract. If a test fails, the code is wrong, not the test. Tests may only be changed if the specification (`task.md`) changes.
4.  **Modularity**: The project is divided into isolated functional blocks (Bounded Contexts). Agents must respect these boundaries to ensure low coupling.
5.  **Fail-Fast**: Feedback loops are designed to catch errors as early as possible, ideally before code is committed.
6.  **Stateless Agents**: Agents should not rely on memory of previous interactions. All necessary context must be provided in the input files for a given task.

## 2. Agent Team & Responsibilities

-   **System Architect**: The strategic planner. Translates the manager's vision into a technical blueprint (`ARCHITECTURE.md`) and decomposes the work into modular tasks (`task.md`).
-   **Senior Software Development Engineer in Test (SDET)**: The quality guardian. Writes comprehensive tests based on `task.md` *before* implementation begins. Thinks adversarially to find edge cases.
-   **Senior Software Engineer**: The implementer. Writes clean, efficient code to pass the tests provided by the Tester, strictly following architectural guidelines.
-   **Principal Engineer**: The final quality gate. Audits code, tests, and coverage. Verifies compliance with `ARCHITECTURE.md` and provides structured feedback.

## 3. Development Flow

The development of each functional block follows these strict phases:

### **Phase 1: Architecture & Specification (System Architect)**
1.  Receives high-level requirements from the Manager.
2.  Creates/updates the master `ARCHITECTURE.md` file.
3.  Defines the interfaces and contracts between all blocks.
4.  Creates a `task.md` file for each block with detailed `Business Context` and `Acceptance Criteria`.

### **Phase 2: Test-First Implementation (Tester -> Developer)**
1.  **Tester**: Reads `task.md` and writes a complete suite of *failing* tests that cover all acceptance criteria. (RED phase).
2.  **Developer**: Receives the `task.md` and the failing tests. Implements the feature code until all tests pass. (GREEN phase).
3.  **Developer**: Refactors the code for clarity and efficiency while ensuring all tests continue to pass. (REFACTOR phase).
4.  This cycle is repeated until all criteria in `task.md` are met and test coverage goals are achieved.

### **Phase 3: Quality Audit & Integration (Team Lead)**
1.  Receives the implemented code and the passing test suite.
2.  Performs a final audit based on its internal checklist (code quality, architectural compliance, test coverage).
3.  If accepted, approves the block for integration.
4.  If rejected, creates a detailed report using the **Agent Feedback Protocol** and assigns the task back to the Developer or Tester.

## 4. Agent Feedback Protocol

The Agent Feedback Protocol is used for structured, actionable communication between agents, primarily from the Team Lead. It is written directly into source code as comments or in review reports.

-   `// FOR-[AGENT_ROLE]-TODO: [Concise and actionable task]`
    -   **Purpose:** Assign a specific correction.
    -   **Example:** `// FOR-DEVELOPER-TODO: Refactor this function to use the utility from /TOOLS/validators.js.`
    -   **Example:** `// FOR-TESTER-TODO: Add a test case for null input on this function.`

-   `// [AGENT_ROLE]-NOTE: [An observation or explanation]`
    -   **Purpose:** To provide context or explain a decision.
    -   **Example:** `// TEAM-LEAD-NOTE: The current implementation violates the single-responsibility principle. See ARCHITECTURE.md section 3.2.`