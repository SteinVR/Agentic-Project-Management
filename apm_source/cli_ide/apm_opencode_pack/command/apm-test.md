---
description: Testing and QA for RAPID projects (SDET)
agent: apm-sdet
subtask: true
---

## User Input

```text
$ARGUMENTS
```

## Required Reads
- memory-bank/ARCHITECTURE.md
- memory-bank/TASK.md
- memory-bank/STATE.md

## Required Outputs
- tests in tests/
- memory-bank/STATE.md (session update)
- optional report in logs/reports/

## Skills to Load
- apm-test
- apm-gov
- apm-logs

## Workflow
Follow apm-test. If the user requests a report, use apm-gov templates.
