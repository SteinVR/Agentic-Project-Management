# SPEC: TASK-AR-001 -- Autoresearch Cycle

## Goal

Run a continuous autoresearch cycle against a single measurable objective, with mandatory artifact analysis and a report after every run.

## Contracts

| Interface | Location | Owner |
|-----------|----------|-------|
| Runner command | project-defined | TASK-AR-001 |
| Greppable metric output | `run.log` or task-defined output | TASK-AR-001 |
| Compact results tracker | `results.tsv` | TASK-AR-001 |
| Post-run report | project-defined run reports directory | TASK-AR-001 |

## Frozen decisions

| Decision | Value |
|----------|-------|
| Workflow | Strict `apm-autoresearch` keep/discard loop |
| Objective | Single primary metric |
| Research stream | `autoresearch/<tag>` |
| Reporting gate | Mandatory after every run |
| Sync-back | Selective promotion to `dev` only |

## Definition of Done

- [ ] Baseline run is recorded
- [ ] Every run has artifact-backed analysis
- [ ] Every run has a report before the next run starts
- [ ] Keep/discard decisions are traceable
- [ ] Only approved deliverables are promoted back to `dev`
