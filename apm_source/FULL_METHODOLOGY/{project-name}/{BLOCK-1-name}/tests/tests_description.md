# Testing Specification

## Test Types

1. **Unit Tests** (`tests/unit/`):
   - Isolate individual functions/classes.
   - Mock all external dependencies (API, DB, File System).
2. **Integration Tests** (`tests/integration/`):
   - Verify interaction between modules.
   - Use temporary/test databases or fixtures.
3. **Others**

## Naming Convention
- Files: `test_{block_name}_{module_name}`
- Functions: `test_{block_name}_{function_name}_{scenario}_{expected_result}`