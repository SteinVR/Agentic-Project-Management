---
description: Generate a report from templates (General/Test/E2E/Debug)
agent: apm-engineer
subtask: true
---

## User Input

```text
$ARGUMENTS
```

## Required Reads
- memory-bank/TASK.md
- memory-bank/STATE.md
- relevant files in src/, tests/, logs/

## Required Outputs
- report file in logs/reports/

## Skills to Load
- apm-gov
- apm-logs

## Workflow
1. Determine report type from user input (default: General).
2. Use the corresponding template from apm-gov.
3. Fill with real project data and save to `logs/reports/`.
