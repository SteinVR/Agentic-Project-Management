# DS And Codex Corrections Report

## Scope

This report compares files from `external/in_project_corrections/` against the original APM assets in:

- `apm_source/methodologies/ds`
- `apm_source/packs/codex_pack`
- `apm_source/skills`

The report covers:

- DS methodology `AGENTS.md` files
- Memory Bank structure only
- Codex workflow files in `.codex/` (`agents`, `config`, `skills`, `rules`)

It does not compare project-specific factual content in the filled Memory Bank beyond structure, sections, and document contract changes.

---

## File Mapping

The corrected DS `AGENTS` files were exported in flattened form. Their semantic mapping to the original DS methodology is:

| Corrected file | Original source |
|---|---|
| `external/in_project_corrections/AGENTS_4.md` | `apm_source/methodologies/ds/AGENTS.md` |
| `external/in_project_corrections/AGENTS.md` | `apm_source/methodologies/ds/data/AGENTS.md` |
| `external/in_project_corrections/AGENTS_1.md` | `apm_source/methodologies/ds/logs/AGENTS.md` |
| `external/in_project_corrections/AGENTS_2.md` | `apm_source/methodologies/ds/models/AGENTS.md` |
| `external/in_project_corrections/AGENTS_3.md` | `apm_source/methodologies/ds/eda/AGENTS.md` |
| `external/in_project_corrections/AGENTS_5.md` | `apm_source/methodologies/ds/experiments/AGENTS.md` |

Main packaging change:

- The original nested DS structure was flattened into standalone `AGENTS*.md` files.
- The corrected package also includes instantiated Memory Bank files directly in `external/in_project_corrections/` instead of under `memory-bank/`.

---

## DS Methodology Changes

### Root DS instructions

Compared `external/in_project_corrections/AGENTS_4.md` with `apm_source/methodologies/ds/AGENTS.md`.

Added:

- Explicit Memory Bank role split: project information in `ARCHITECTURE.md`, current state in `STATE.md`.
- Mandatory activity report after meaningful work in `logs/activity/<Role>/`.
- Required activity report format: `Metadata + Exact User Request`, `Task Setup`, `Implementation Log`, `Result/Conclusions (Exact Answer to User)`.
- Explicit subagent parallelism limit: up to 6 parallel subagents.
- Explicit instruction to use subagents proactively to save context window.
- Restricted path rule: do not read, write, or traverse `old`, `irrelevant`, or `deprecated` without user permission.

Changed:

- Sequential multi-skill example changed from DS-phase chaining (`apm-eda -> apm-ds-baseline -> apm-ds-exp`) to operational chaining (`apm-dev -> apm-logs -> apm-sync`).

Removed or no longer stated:

- The explicit root-level rule `Always update memory-bank/STATE.md after meaningful work.`
- The `DS updates` block that explicitly prescribed what to maintain inside `TASK.md` and `STATE.md`.
- The `DS workflow` block that explicitly named `apm-start` and the recommended DS flow.
- The note that the agent profile's `Recommended skills` section is the default toolkit.

Interpretation:

- The corrected root DS instructions became more operational and execution-oriented.
- The original methodology guidance became less prescriptive at the phase-flow level and more prescriptive at the session logging / orchestration level.

### Data instructions

Compared `external/in_project_corrections/AGENTS.md` with `apm_source/methodologies/ds/data/AGENTS.md`.

Result:

- No substantive changes detected.

### Logs instructions

Compared `external/in_project_corrections/AGENTS_1.md` with `apm_source/methodologies/ds/logs/AGENTS.md`.

Added:

- Explicit log taxonomy:
  - `training_*.log`
  - `preprocessing_*.log`
  - `evaluation_*.log`

Removed or no longer stated:

- The explicit opening instruction to follow `apm-logs`.

Unchanged:

- `logs/`, `logs/activity/<Role>/`, and `logs/reports/` structure.
- Log line format.
- Activity report filename convention.
- Guardrails for not storing model artifacts or EDA outputs in `logs/`.

### Models instructions

Compared `external/in_project_corrections/AGENTS_2.md` with `apm_source/methodologies/ds/models/AGENTS.md`.

Expanded model artifact contract:

- The folder naming rule remained `models/model_<metric>_<value>/`.
- `MODEL_REPORT.md`, `config.json`, serialized model, and `preprocessor.pkl` remain core artifacts.
- The corrected version additionally allows:
  - `configs/` instead of a single `config.json`
  - a nested `models/` folder for ensembles / blends
  - `src/` snapshot/reference for reproducibility
  - `etc/` for auxiliary artifacts

Added:

- Requirement that the folder and primary model artifact share the same `model_<metric>_<value>` stem.

Interpretation:

- The corrected version upgrades the model directory from a minimal artifact drop to a fuller experiment bundle with code snapshotting and ensemble support.

### EDA instructions

Compared `external/in_project_corrections/AGENTS_3.md` with `apm_source/methodologies/ds/eda/AGENTS.md`.

Expanded structure:

- Original minimal EDA contract:
  - `eda.py`
  - `results/figures/`
  - `results/tables/`
  - `EDA_REPORT.md`

- Corrected EDA contract:
  - `src/eda.py`
  - `src/deep_eda.py`
  - `results/figures/`
  - `results/tables/`
  - `results/tables/deep/`
  - `reports/EDA_REPORT.md`
  - `reports/EDA-Insights.md`
  - `old/`

Interpretation:

- EDA was turned from a single-script, single-report area into a deeper analysis workspace with separate source code, deep-analysis outputs, multi-report output, and archival storage.

### Experiment instructions

Compared `external/in_project_corrections/AGENTS_5.md` with `apm_source/methodologies/ds/experiments/AGENTS.md`.

Result:

- No substantive changes detected.

---

## Memory Bank Structure Changes

### General pattern

Across all three documents:

- The original DS Memory Bank top-level template structure was largely preserved.
- The corrected files are not just filled templates; they also introduce structural specialization for an enterprise / competition-style DS workflow.

### `ARCHITECTURE.md`

Compared `external/in_project_corrections/ARCHITECTURE.md` with `apm_source/methodologies/ds/memory-bank/ARCHITECTURE.md`.

Preserved:

- The same 8 top-level sections:
  1. Problem Statement & Success Criteria
  2. Data Architecture
  3. Experiment Pipeline
  4. Technology Stack
  5. Model Architecture
  6. Feature Engineering Strategy
  7. Validation Strategy
  8. Code Organization & Conventions

Structural expansions:

- Section 4 adds:
  - `Local Environment (uv)`
  - `Activation`


Interpretation:

- The corrected `ARCHITECTURE.md` preserves the template skeleton while converting the middle of the document into an operational system design spec rather than a planning placeholder.

### `TASK.md`

Compared `external/in_project_corrections/TASK.md` with `apm_source/methodologies/ds/memory-bank/TASK.md`.

Preserved:

- The same 4 top-level sections:
  1. Hypothesis Backlog
  2. Active Experiment
  3. Experiment Plan
  4. Quick Reference: Metrics Progress

Changed structure:

- Section 1 changed priority buckets from:
  - `High Priority`
  - `Medium Priority`
  - `Low Priority / Ideas`
  - `Completed Hypotheses`

  to:
  - `Active Plan`
  - `Low Priority / Ideas`
  - `Completed Hypotheses`

- Section 3 changed from a scratchpad workflow:
  - `Setup`
  - `Implementation`
  - `Execution`
  - `Evaluation`

  to a roadmap organized by execution waves:
  - `Wave 1: Foundation`
  - `Wave 2: Expert Models`
  - `Wave 3: Residual Correction`
  - `Wave 4: Ensemble & Calibration`

- Section 3 is also explicitly renamed from `Experiment Plan (Scratchpad)` to `Experiment Plan (SOTA Pipeline)`.

- Section 4 simplified the metrics table from:
  - `Experiment | Date | Primary Metric | Secondary Metric | Notes`

  to:
  - `Experiment | Date | ρ_w | Notes`

- The metrics footer was specialized from separate template placeholders (`Target`, `Best So Far`) into a compact target/current-best statement centered on the single competition metric.

Interpretation:

- The corrected `TASK.md` is no longer a generic current-experiment scratchpad.
- It becomes a program board for a multi-wave DS campaign with explicit sequencing of major workstreams.

### `STATE.md`

Compared `external/in_project_corrections/STATE.md` with `apm_source/methodologies/ds/memory-bank/STATE.md`.

Preserved:

- `Active Context`
- `Best Model Tracker`
- `Experiment History`
- `Decision Log`
- `Known Issues / Technical Debt`
- `Session History`
- `Accumulated Context`

Changed structure:

- `Active Context` remains present, but its original `Working on` field is no longer part of the document contract.
- `Best Model Tracker` remains a 2-column attribute table, but field labels were specialized:
  - `Training Date` became `Evaluation Date`

- `Experiment History` was simplified from:
  - `ID | Date | Hypothesis | Approach | Primary | Secondary | Result | Notes`

  to:
  - `ID | Date | Hypothesis | Approach | Primary | Result | Notes`

- `Experiment History` also changed its framing from a complete running log to a recent-experiments view with legacy runs treated as archived/compressed context.

- `Decision Log` was simplified from:
  - `Date | Decision | Rationale | Impact`

  to:
  - `Date | Decision | Impact`

- `Known Issues / Technical Debt` changed from a checklist list into a dated table:
  - `Date | Issue | Status`

Removed:

- The standalone section `5. Data Drift & Changes Log`.
- The `Experiment History` legend no longer includes `= = no change`; only `+` and `-` remain documented.

Observed side effect:

- After removing the data-drift section, the numbering in the corrected document jumps from `4` to `6`.

Interpretation:

- The corrected `STATE.md` became a denser operational log centered on experiments, decisions, and blockers.
- Data evolution tracking was de-emphasized or absorbed into other sections instead of being kept as a dedicated register.

---

## Codex Workflow Changes

### `.codex/config.toml`

Compared `external/in_project_corrections/.codex/config.toml` with `apm_source/packs/codex_pack/config.toml`.

Result:

- No changes detected.

### `.codex/agents/*.toml`

Compared all corrected agent configs with `apm_source/packs/codex_pack/agents/*.toml`.

Result:

- `apm-architect.toml`: unchanged
- `apm-code-simplifier.toml`: unchanged
- `apm-data-scientist.toml`: unchanged
- `apm-engineer.toml`: unchanged
- `apm-sdet.toml`: unchanged

Interpretation:

- The agent role layer was reused as-is.
- The customization happened in skills and project-side rules, not in agent definitions.

### `.codex/skills/*.md`

Compared corrected `.codex/skills/*/SKILL.md` files against `apm_source/skills/*/SKILL.md`.

Unchanged:

- `apm-arch`
- `apm-code-simplifier`
- `apm-dev`
- `apm-eda`
- `apm-orchestrate`
- `apm-report`
- `apm-review`
- `apm-skill-creator`
- `apm-start`
- `apm-test`

Changed:

#### `apm-ds-baseline`

Added a new mandatory step after implementation:

- Run subagent `apm-code-simplifier` on new/changed code before validation.

Changed:

- Quick validation is no longer hand-offable. The original fallback `or provide commands for the user to run` was removed, so the skill now requires actually running a quick validation step.

Effect:

- Baseline creation was tightened to include both a built-in simplification / cleanup pass and a mandatory validation run.

#### `apm-ds-exp`

Added a new mandatory step after creating experiment files:

- Run subagent `apm-code-simplifier` on new/changed code before smoke testing.

Effect:

- Experiment implementation now explicitly bakes in post-coding cleanup before execution.

#### `apm-logs`

Changed activity report contract from 3 parts to 4 parts:

- Added `Metadata + Exact User Request`
- Kept `Task Setup`
- Kept `Implementation Log`
- Expanded `Result / Conclusions` to require the exact answer to the user

Effect:

- Logging became more audit-like and more tightly tied to the original user ask.

#### `apm-model-report`

Expanded expected model artifact contents:

- Added `models/model_<metric>_<value>/src`

Effect:

- Model reports now expect a colocated source snapshot/reference as part of the deliverable bundle.

#### `apm-sync`

Expanded workflow:

- Added explicit scan of `git status`, `git diff`, and `git log` or equivalents.
- Added explicit scan of latest activity reports in `logs/activity/<Role>/`.
- Changed `TASK.md` handling from:
  - propose updates and ask for approval

  to:
  - update `TASK.md` directly with the current context and decisions

Effect:

- Sync became more autonomous and more tightly coupled to both Git state and activity logs.
- `TASK.md` ceased to be approval-gated during routine sync.

### `.codex/rules/default.rules`

Compared presence of this file against `apm_source`.

Result:

- No source counterpart exists in the repository.
- This is a project-local addition.

Behavior introduced:

- `rm`
- `rm -rf`

are explicitly configured to require prompting before execution.

Interpretation:

- This is an extra safety rail added at the project level, outside the shipped APM Codex pack.

### `.codex/session_index.jsonl`

Result:

- No source counterpart exists in `apm_source`.
- This is a local runtime/state artifact, not a framework source asset.

---

## Consolidated Summary

The corrections fall into three categories:

1. **Operational hardening of DS workflow**
   - more explicit activity-reporting
   - stronger subagent usage rules
   - restricted-path safety

2. **Specialization of DS structure for a serious experiment program**
   - richer EDA layout
   - expanded model artifact bundle
   - wave-based experiment planning
   - more operational `STATE.md`

3. **Selective Codex workflow customization**
   - agents and global Codex config unchanged
   - most skills unchanged
   - five skills tightened for cleanup, logging, reproducibility, and autonomous sync
   - extra local rules added for destructive shell safety

The net effect is not a rewrite of the DS methodology or Codex environment. It is a focused operational extension of the original assets around:

- stronger execution discipline
- better auditability
- richer experiment packaging
- safer local CLI behavior
