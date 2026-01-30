---
name: apm-gov
description: Governance for APM Memory Bank updates, session reporting, and report templates. Use for STATE/TASK maintenance and activity reports.
compatibility: opencode
---
## What I do
- Define Memory Bank update rules (`memory-bank/ARCHITECTURE.md`, `memory-bank/TASK.md`, `memory-bank/STATE.md`).
- Define compact activity report conventions for all agents.
- Provide report templates (General/Test/E2E/Debug) for `/apm-report`.

## Memory Bank rules (SSOT)
- **Directory name is `memory-bank/`**.
- **Always update `memory-bank/STATE.md` at the end of a session** if any work was performed.
- Keep the main headers from the templates intact; add sub-sections only when needed.

## Logging and feedback loop
Logging conventions and feedback-loop rules live in **apm-logs**. Use that skill when writing or interpreting logs.

### RAPID updates
- **ARCHITECTURE.md**: update only when scope or architecture changes.
- **TASK.md**:
  - keep **Feature Backlog** as the source of work;
  - update **Current Task in Focus** and **Implementation Plan** before coding;
  - mark completed items with `[x]`.
- **STATE.md**:
  - update **Active Context**, **Decision Log**, **Known Issues / Tech Debt**, **Architecture Deviations**, and **Session History**.

### DS updates
- **TASK.md**:
  - manage hypotheses and **Active Experiment**;
  - maintain **Experiment Plan** and mark tested hypotheses.
- **STATE.md**:
  - update **Best Model Tracker** and **Experiment History**;
  - keep **Decision Log** and **Session History** current;
  - record data drift in **Data Drift & Changes Log**.

## Activity reports (compact)
- **Location:** `logs/activity/<Role>/`
- **Filename:** `<Role>_YYYY-MM-DD_HH-mm_short-title.md`
- **When:** end of each session and after any non-trivial work.
- **Structure (3 parts):**
  1. **Task Setup (Given / Goal)**
  2. **Implementation Log (Steps & Decisions)**
  3. **Result / Conclusions**

> Create the directory on demand if it does not exist.

## Report templates for /apm-report
- **General:** `references/GENERAL_REPORT_TMP.md`
- **Test:** `references/TEST_REPORT_TMP.md`
- **E2E:** `references/E2E_REPORT_TMP.md`
- **Debug:** `references/DEBUGGING_REPORT_TMP.md`

**Recommended output location:** `logs/reports/` with filename
`<type>_YYYY-MM-DD_HH-mm.md` (create the folder if missing).

## Templates (Memory Bank)
- RAPID:
  - `references/ARCHITECTURE_RAPID_TMP.md` (in apm-arch)
  - `references/TASK_RAPID_TMP.md`
  - `references/STATE_RAPID_TMP.md`
- DS:
  - `references/ARCHITECTURE_DS_TMP.md` (in apm-arch)
  - `references/TASK_DS_TMP.md`
  - `references/STATE_DS_TMP.md`
