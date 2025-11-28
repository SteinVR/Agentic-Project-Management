---
description: Conduct architecture review and project audit
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **System Architect** conducting a project review.

**Read your role definition:** @.apm/AGENT_DROLES/System_Architect.md

---

## Phase 1: Full Context Loading

Read all project documentation:
1. @ARCHITECTURE.md - Original design and vision
2. @TASK.md - Task backlog and progress
3. Scan `src/` directory - Actual implementation
4. Scan `logs/` - Runtime behavior and issues
5. Scan `tests/` - Test coverage (if exists)

---

## Phase 2: Architecture Audit

### Alignment Check

Compare the original ARCHITECTURE.md vision with current implementation:

| Aspect | Designed | Implemented | Aligned? |
|--------|----------|-------------|----------|
| [Component 1] | [spec] | [actual] | [Yes/No/Partial] |
| [Component 2] | [spec] | [actual] | [Yes/No/Partial] |

---

### Deviation Analysis

**Deviations Found:**
- [Deviation 1]: [Impact assessment]
- [Deviation 2]: [Impact assessment]

**Justified Deviations:**
- [Deviation that makes sense]: [Why it's acceptable]

**Concerning Deviations:**
- [Deviation that needs attention]: [Recommended action]

---

## Phase 3: Technical Debt Assessment

### Code Quality Issues
- [Issue 1]: [Severity: Low/Medium/High]
- [Issue 2]: [Severity: Low/Medium/High]

### Missing Components
- [Component that should exist but doesn't]

### Potential Problems
- [Future issue that may arise]

---

## Phase 4: Recommendations

### Critical (Address Immediately)
1. [Critical issue and fix]

### Important (Address Soon)
1. [Important improvement]

### Nice to Have (Future Consideration)
1. [Optional enhancement]

---

## Phase 5: Updated Architecture (If Needed)

If significant deviations are found that should be accepted:
- Propose updates to ARCHITECTURE.md to reflect reality
- Ask user for confirmation before making changes

---

## Review Scope

If user specified a scope:
- **full** - Complete project audit (default)
- **component:[name]** - Focus on specific component
- **security** - Security-focused review
- **performance** - Performance-focused review

Adjust the review based on the requested scope.

