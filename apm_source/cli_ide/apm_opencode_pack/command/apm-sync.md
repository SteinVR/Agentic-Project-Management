---
description: Sync Memory Bank state with current project status
agent: apm-architect
subtask: true
---

## User Input

```text
$ARGUMENTS
```

## Required Reads
@memory-bank/STATE.md
@memory-bank/ARCHITECTURE.md
@memory-bank/TASK.md

## Required Outputs
- memory-bank/STATE.md (updated)

## Skills to Load
- apm-gov
- apm-logs

## Workflow
Scan recent changes, update Active Context, Decision Log, Known Issues, and Session History. Summarize the updates.
