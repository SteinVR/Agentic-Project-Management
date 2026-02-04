---
name: apm-review
description: Project review and recommendations for RAPID or DS, with optional architecture/model updates.
compatibility: codex
---
## What I do
- Review alignment between implementation and Memory Bank.
- Provide prioritized recommendations and risk notes.
- Update `memory-bank/STATE.md` after the review.
- Update `memory-bank/ARCHITECTURE.md` only after explicit user confirmation.
- For DS: trigger model finalization if targets are met (via apm-finalize-model).

## Required reads
- `memory-bank/ARCHITECTURE.md`
- `memory-bank/TASK.md`
- `memory-bank/STATE.md`

## Review flow
1. Determine methodology from `ARCHITECTURE.md` or user input.
2. **RAPID:**
   - Audit alignment between architecture and current code.
   - Identify missing components, tech debt, and gaps.
   - Provide ranked recommendations.
3. **DS:**
   - Assess progress vs success criteria and experiment history.
   - Identify patterns across experiments and propose next hypotheses.
   - If targets are met, run model finalization (apm-finalize-model).
4. Ask for confirmation before changing `ARCHITECTURE.md`.
5. Update `memory-bank/STATE.md` with review summary and decisions.

## Required outputs
- Review summary (message)
- `memory-bank/STATE.md` (updated)
- `memory-bank/ARCHITECTURE.md` (only if user confirms changes)
- DS only: `models/MODEL_REPORT.md` (if finalized)
