---
description: Generate a report using templates
---

## User Input

```text
$ARGUMENTS
```

## Instructions

Generate a report based on user request.

---

## Report Templates

Use the appropriate template from `.apm/AGENT_REPORTS/`:

| Report Type | Template | When to Use |
|-------------|----------|-------------|
| **General** | @.apm/AGENT_REPORTS/GENERAL_REPORT_TEMPLATE.md | Work summary, implementation snapshot, general status |
| **Test** | @.apm/AGENT_REPORTS/TEST_REPORT_TEMPLATE.md | Test execution results, coverage, failure analysis |
| **E2E** | @.apm/AGENT_REPORTS/E2E_REPORT_TEMPLATE.md | User scenario validation, workflow verification |
| **Debug** | @.apm/AGENT_REPORTS/DEBUGGING_REPORT_TEMPLATE.md | TDD cycle status, diagnostic logs, fix instructions |

---

## How to Use

1. Determine report type from user input (default: General)
2. Read the corresponding template
3. Fill it with actual project data from `src/`, `logs/`, `tests/`, `TASK.md`
4. Output the completed report

---

## User Request

$ARGUMENTS
