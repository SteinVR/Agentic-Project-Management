# Testing Specification

## Test Types

1. **Unit Tests** (`tests/unit/`):
   - Isolate individual functions/classes.
   - Mock all external dependencies (API, DB, File System).
2. **Integration Tests** (`tests/integration/`):
   - Verify interaction between modules.
   - Use temporary/test databases or fixtures.
3. **E2E Tests** (`tests/e2e/`):
   - Simulate full user workflows (CLI commands, API calls).
   - Validate against `User Workflow` in `ARCHITECTURE.md`.
4. **Others**

## Naming Convention
- Files: `test_{module_name}`
- Functions: `test_{function_name}_{scenario}_{expected_result}`