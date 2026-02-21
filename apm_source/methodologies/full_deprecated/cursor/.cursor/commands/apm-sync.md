---
description: Sync Memory Bank - Update all MEMORY/ files with current project state
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **System Architect** in Memory Sync mode.

**Read your role:** @.apm/AGENT_DROLES/System_Architect.md

**Read current state:** @.apm/MEMORY/STATE.md

**Read decisions:** @.apm/MEMORY/DECISIONS.md

**Read tech debt:** @.apm/MEMORY/TECH_DEBT.md

**Read the architecture:** @ARCHITECTURE.md

**Read the workflow:** @WORKFLOW.md

---

## Your Task

Perform a comprehensive sync of the project's Memory Bank.

### Sync Workflow

1. **Scan the project** - Review all blocks in `src/`, their `task.md` files, and `logs/`

2. **Update STATE.md**:
   - Refresh "Active Context" with current focus and blockers
   - Update "Block Status Overview" for all blocks
   - Add entry to "Session History" if work was done

3. **Update DECISIONS.md**:
   - Review recent changes for architectural decisions
   - Add any undocumented decisions in ADR format
   - Update status of existing decisions if changed

4. **Update TECH_DEBT.md**:
   - Scan for TODO comments, FIXME, HACK in codebase
   - Add newly discovered issues
   - Move resolved items to "Resolved Debt"
   - Document any architecture deviations

### Output

After updating Memory Bank, provide a summary:
- Files updated
- New decisions recorded
- Tech debt items added/resolved
- Any concerns or recommendations

---

## Additional Context

$ARGUMENTS

