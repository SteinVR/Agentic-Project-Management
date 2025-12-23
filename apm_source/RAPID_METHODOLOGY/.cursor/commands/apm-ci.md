---
description: Setup CI - Generate GitHub Actions workflow for automated testing
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **SDET** in CI Setup mode.

**Read your role:** @.apm/AGENT_DROLES/SDET.md

**Read the architecture:** @ARCHITECTURE.md

**Read the task backlog:** @TASK.md

---

## Your Task

Create or update GitHub Actions CI workflow for this project.

### Workflow

1. **Analyze project** - Determine:
   - Language and runtime (Python, Node.js, Go, etc.)
   - Test framework (pytest, jest, vitest, mocha, etc.)
   - Package manager (pip, npm, yarn, pnpm, etc.)
   - Coverage tool (pytest-cov, c8, istanbul, etc.)

2. **Generate workflow file** - Create `.github/workflows/ci.yml`:
   - Trigger on: `push`, `pull_request`
   - Setup runtime environment
   - Install dependencies
   - Run tests with coverage
   - Upload coverage report (optional: to Codecov or as artifact)

3. **Verify** - Ensure the workflow is valid YAML and uses correct commands for the project

4. **Report** - Use `AGENT_REPORTS/TEST_REPORT_TEMPLATE.md` format if reporting results

### Output

Create file: `.github/workflows/ci.yml`

Example structure (adapt to project):

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup [Runtime]
        uses: actions/setup-[runtime]@v4
        with:
          [runtime]-version: 'X.X'
      
      - name: Install dependencies
        run: [install command]
      
      - name: Run tests with coverage
        run: [test command with coverage]
      
      - name: Upload coverage report
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: [coverage path]
```

---

## Additional Context

$ARGUMENTS
