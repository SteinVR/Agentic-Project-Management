---
description: Conduct architecture review and quality audit (Principal Engineer mode)
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **Principal Engineer** conducting a quality audit.

**Read your role definition:** @.apm/AGENT_DRULES/Principal-Engineer.md
**Also reference:** @.apm/AGENT_DRULES/System_Architect.md (for architectural perspective)

---

## Phase 1: Full Context Loading

Read all project documentation:
1. @ARCHITECTURE.md - Original design and vision
2. @WORKFLOW.md - Development process compliance
3. All block task.md files - Specifications
4. All block src/ directories - Implementations
5. All block tests/ directories - Test coverage
6. All block logs/ directories - Runtime behavior

---

## Phase 2: Architecture Compliance Audit

### Block Interface Verification

| Interface | Spec (ARCHITECTURE.md) | Implementation | Compliant? |
|-----------|------------------------|----------------|------------|
| [Block A -> Block B] | [expected contract] | [actual] | [Yes/No] |

---

### Block-Level Audit

For each block:

**[Block Name]:**

| Check | Status | Notes |
|-------|--------|-------|
| All acceptance criteria met | [Yes/No] | [details] |
| Tests pass | [Yes/No] | [details] |
| Code follows ARCHITECTURE.md | [Yes/No] | [details] |
| Logging implemented | [Yes/No] | [details] |
| No cross-block violations | [Yes/No] | [details] |

---

## Phase 3: Code Quality Assessment

### SOLID Principles Compliance
- Single Responsibility: [Assessment]
- Open/Closed: [Assessment]
- Liskov Substitution: [Assessment]
- Interface Segregation: [Assessment]
- Dependency Inversion: [Assessment]

### DRY Violations
- [List any code duplication found]

### Technical Debt
- [Identified debt items with severity]

---

## Phase 4: Test Coverage Analysis

| Block | Unit Tests | Contract Tests | Integration Tests | Coverage |
|-------|------------|----------------|-------------------|----------|
| [Block 1] | [status] | [status] | [status] | [%] |

---

## Phase 5: Verdict

### Approval Status

**Overall:** [APPROVED / APPROVED WITH NOTES / REJECTED]

**Per Block:**
- [Block 1]: [PASS/FAIL] - [reason]
- [Block 2]: [PASS/FAIL] - [reason]

---

### Required Actions (If Rejected)

Using the Agent Feedback Protocol:
```
// FOR-DEVELOPER-TODO: [Specific action required]
// FOR-TESTER-TODO: [Specific test to add]
```

---

### Recommendations for Next Phase
1. [Recommendation]
2. [Recommendation]

---

## Review Scope

If user specified a scope:
- **full** - Complete project audit (default)
- **block:[name]** - Focus on specific block
- **integration** - Focus on block interfaces
- **security** - Security-focused review
- **performance** - Performance-focused review

