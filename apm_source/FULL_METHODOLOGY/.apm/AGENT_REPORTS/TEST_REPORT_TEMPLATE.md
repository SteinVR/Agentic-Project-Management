# [YYYY-MM-DD] - Test Execution Report: [Scope/Feature Name]
**Tester:** SDET Agent
**Trigger:** [Task ID / Commit Hash / Manual Request]

## Executive Summary
- **Overall Status:** 🟢 PASS / 🟡 WARN / 🔴 FAIL
- **Total Tests:** [N]
- **Passed:** [N] | **Failed:** [N] | **Skipped:** [N]
- **Code Coverage:** [X]% (Change: +/- Y%)

## Failure Analysis (The "Fix List")
> Only populated if failures exist. Grouped by severity.

### 🔴 Critical Failures (Blockers)
- **Test Case:** `test_login_flow`
- **Error:** `AssertionError: Expected 200 OK, got 500 Internal Error`
- **Location:** `src/auth_service.py:45`
- **Root Cause Analysis:** Database connection string is missing in `.env`.

### 🟡 Minor/Edge Case Failures
- **Test Case:** `test_invalid_email_format`
- **Observation:** The validation regex allows "user@com" (missing TLD).

## Test Scope Breakdown
### Unit Level
- [Description of coverage, e.g., "Covered all methods in TaskManager class"]
### Integration Level
- [e.g., "Verified interaction between CLI parser and Storage module"]
### E2E Level (if applicable)
- [e.g., "Simulated full user flow: Add -> List -> Complete"]

## Risks & Recommendations
- **Risk:** [e.g., "The JSON storage write operation is not atomic; data corruption possible on crash."]
- **Recommendation:** [e.g., "Implement a safe-write utility using temporary files."]

## Instruction for Developer / Architect (if neccecary)
- **Priority:** Fix the `ZeroDivisionError` in `calc.py` immediately.
- **Suggestion:** Add a guard clause `if y == 0: raise ValueError(...)`.
- **Suggestion:** Change the architecture of...

## Artifacts
- [Link to coverage HTML report]
- [Link to full log file]