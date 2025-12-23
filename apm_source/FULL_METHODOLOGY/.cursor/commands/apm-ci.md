---
description: Setup CI - Generate GitHub Actions workflow for automated testing
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **Principal Engineer** in CI Setup mode.

**Read your role:** @.apm/AGENT_DROLES/Principal-Engineer.md

**Read the architecture:** @ARCHITECTURE.md

**Read the workflow:** @WORKFLOW.md

---

## Your Task

Create or update GitHub Actions CI workflow for this project.

### Workflow

1. **Analyze project** - Determine:
   - Language and runtime (Python, Node.js, Go, etc.)
   - Test framework (pytest, jest, vitest, mocha, etc.)
   - Package manager (pip, npm, yarn, pnpm, etc.)
   - Coverage tool (pytest-cov, c8, istanbul, etc.)
   - Block structure in `src/`

2. **Generate workflow file** - Create `.github/workflows/ci.yml`:
   - Trigger on: `push`, `pull_request`
   - Setup runtime environment
   - Install dependencies
   - Run tests for all blocks with coverage
   - Generate coverage report
   - Quality gates (fail if coverage < threshold)

3. **Quality Gates** - Configure checks:
   - All tests must pass
   - Coverage threshold (e.g., > 80%)
   - Optional: lint check

4. **Verify** - Ensure the workflow is valid YAML and uses correct commands

5. **Report** - Use `AGENT_REPORTS/TEST_REPORT_TEMPLATE.md` format if reporting results

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
      
      - name: Check coverage threshold
        run: [coverage check command]
      
      - name: Upload coverage report
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: [coverage path]
```

---

## Additional Context

$ARGUMENTS
