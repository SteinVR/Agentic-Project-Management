# Task Board (DS): [Project Name]

> Frozen specs in `memory_bank/specs/SPEC_{TASK_ID}.md`. Working notes in `memory_bank/tasks/{TASK_ID}.md`.

## Wave Protocol

Tasks are organized in **waves**. Waves execute sequentially; tasks within a wave execute in parallel.

- **Naming:** `W1A`, `W1B`, `W1C` (Wave 1, tasks A–C), `W2A` (Wave 2, task A), etc.
- **Backlog items:** `BL-001`, `BL-002`, etc.
- A wave is complete when all its tasks pass the quality gate and are integrated.
- The next wave starts only after the current wave is fully integrated.
- New tasks discovered mid-wave go into the next wave or backlog — never into the active wave.
- **SPEC freeze:** No SPEC changes after delegation begins.

## 1. Active Plan (Ordered)

### Wave 1: Foundation
- [ ] [W1A](./specs/SPEC_W1A.md) Setup reproducible baseline and evaluator: establish first trusted benchmark and artifact contract.
- [ ] [W1B] Complete EDA package: finalize `EDA-Report.md`, charts, and core risk findings.

**Wave DoD:**
- [ ] [Wave-specific completion criteria]

### Wave 2: Deep Feature Engineering
- [ ] [W2A] Produce deep feature candidates: rank feature ideas by expected impact, leakage risk, and runtime cost.
- [ ] [W2B] Select production-safe feature subset: confirm top candidates for baseline and experiment loops.

**Wave DoD:**
- [ ] [Wave-specific completion criteria]

### Wave 3: Experimentation
- [ ] [W3A] Run first hypothesis cycle: implement and evaluate one controlled experiment against baseline.

**Wave DoD:**
- [ ] [Wave-specific completion criteria]

## 2. Low Priority / Ideas
- [ ] [BL-001] [Idea title]: [1-2 line description]

## 3. Review Findings (Cross-Module)

> Findings from quality gate reviews that span multiple tasks or affect shared architecture. Task-specific findings stay in `{TASK_ID}.md`.

| ID | Source | Severity | Summary | Status |
|----|--------|----------|---------|--------|

### Error Patterns

> Recurring issues identified across multiple reviews. Agents must proactively check for these patterns during implementation and review.

| Pattern | Occurrences | Example Tasks | Guidance |
|---------|-------------|---------------|----------|
