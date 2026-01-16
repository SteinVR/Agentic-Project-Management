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

Use the appropriate template from `.apm/AGENT_REPORTS_TMP/`:

| Report Type | Template | When to Use |
|-------------|----------|-------------|
| **General** | @.apm/AGENT_REPORTS_TMP/GENERAL_REPORT_TEMPLATE.md | Work summary, implementation snapshot, general status |
| **Test** | @.apm/AGENT_REPORTS_TMP/TEST_REPORT_TEMPLATE.md | Test execution results, coverage, failure analysis |
| **E2E** | @.apm/AGENT_REPORTS_TMP/E2E_REPORT_TEMPLATE.md | User scenario validation, workflow verification |
| **Debug** | @.apm/AGENT_REPORTS_TMP/DEBUGGING_REPORT_TEMPLATE.md | TDD cycle status, diagnostic logs, fix instructions |

---

## How to Use

1. Determine report type from user input (default: General)
2. Read the corresponding template
3. Run the necessary tests and fill the chosen template with actual project data from `src/`, `logs/`, `tests/`, `TASK.md`
4. Output the completed report

---

## User Request

$ARGUMENTS
