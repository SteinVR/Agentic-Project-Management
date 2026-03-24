# Task Board (RAPID): [Project Name]

> Keep this file concise (max 150 lines). Store only grouped high-level tasks. Detailed plans, specs, and notes live in `memory_bank/tasks/{TASK_ID}.md`.

## Wave Protocol

Tasks are organized in **waves**. Waves execute sequentially; tasks within a wave execute in parallel.

- **Naming:** `W1A`, `W1B`, `W1C` (Wave 1, tasks A–C), `W2A` (Wave 2, task A), etc.
- **Backlog items:** `BL-001`, `BL-002`, etc.
- A wave is complete when all its tasks pass the quality gate and are integrated.
- The next wave starts only after the current wave is fully integrated.
- New tasks discovered mid-wave go into the next wave or backlog — never into the active wave.

## 1. Active Plan (Ordered)

### Wave 1: Architecture
- [ ] [W1A](./tasks/W1A.md) Define MVP architecture and delivery boundaries.

### Wave 2: Core Implementation
- [ ] [W2A] Implement core user flow in `src/`.
- [ ] [W2B] Add core tests and failure handling.

## 2. Backlog

- [ ] [BL-001] [Future feature title]: [short description]
- [ ] [BL-002] [Future improvement title]: [short description]

## 3. Review Findings (Cross-Module)

> Findings from quality gate reviews that span multiple tasks or affect shared architecture. Task-specific findings stay in `{TASK_ID}.md`. Resolved entries are compressed during sync — only open items and patterns remain here.

| ID | Source | Severity | Summary | Status |
|----|--------|----------|---------|--------|

### Error Patterns

> Recurring issues identified across multiple reviews. Agents must proactively check for these patterns during implementation and review.

| Pattern | Occurrences | Example Tasks | Guidance |
|---------|-------------|---------------|----------|
