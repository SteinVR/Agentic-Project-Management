---
description: Project review and recommendations (RAPID or DS)
agent: apm-architect
subtask: true
---

## User Input

```text
$ARGUMENTS
```

## Required Reads
@memory-bank/ARCHITECTURE.md
@memory-bank/TASK.md
@memory-bank/STATE.md

## Required Outputs
- Review summary (message)
- memory-bank/ARCHITECTURE.md (only if user accepts changes)
- memory-bank/STATE.md (session update)
- DS only: models/MODEL_REPORT.md (if finalizing)

## Skills to Load
- apm-arch
- apm-gov
- apm-finalize-model (DS only)
- apm-logs

## Review flow
Determine methodology from ARCHITECTURE.md or user input.

### If RAPID
- Audit alignment between ARCHITECTURE.md and current implementation.
- Assess technical debt and missing components.
- Provide prioritized recommendations.
- Ask for confirmation before updating architecture.

### If DS
- Assess progress to target metrics using STATE.md.
- Identify patterns across experiments.
- Provide next hypotheses and strategic recommendations.
- If targets are met, run model finalization using apm-finalize-model.
