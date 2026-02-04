# [YYYY-MM-DD] - TDD Cycle Report (Red/Green Phase)
**Phase:** 🔴 RED (Tests Failing - Implementation Needed) / 🟢 GREEN (Tests Passing)

## 1. Requirements Covered (Acceptance Criteria)
> Linking tests to specific requirements from TASK.md

- [x] Feature A (Covered by `test_feature_a.py`)
- [ ] Feature B (Not yet implemented/tested)

## 2. Diagnostic Logs
> Detailed output for the Lead Engineer to debug.

```text
FAILED tests/test_core.py::test_calculation - ValueError: math domain error
   Traceback:
   File "src/calc.py", line 12, in divide
     return x / y
   ZeroDivisionError: division by zero
```

## 3. Missing Scenarios (Gaps)
> What logic is NOT yet covered by tests?
- No test for negative inputs.
- No test for file permission errors.

## 4. Instruction for Developer
- **Priority:** Fix the `ZeroDivisionError` in `calc.py` immediately.
- **Suggestion:** Add a guard clause `if y == 0: raise ValueError(...)`.
