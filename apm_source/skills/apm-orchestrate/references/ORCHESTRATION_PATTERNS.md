# APM Orchestration Patterns (Codex Subagents)

## 1) Delegation contract templates
Choose the appropriate level when decomposing subtasks.

### Lite — single-file or short tasks
```text
Task ID:
Objective:
Owned paths:
Done criteria:
```

### Full — parallel streams or non-trivial sessions
```text
Task ID:
Objective:
Owned paths:
Disallowed paths:
Inputs:
Output format:
Role-specific detail artifacts:
Done criteria:
Verification:
Activity report path:
```

## 2) Parallelization rules
- Parallelize only independent subtasks with low file overlap.
- Keep one owner per mutable file in a parallel wave.
- Push shared integration changes to a dedicated fan-in stage.

## 3) Fan-out examples
### DS experiments
- Subtask A: baseline variant with feature set A.
- Subtask B: baseline variant with feature set B.
- Subtask C: hyperparameter sweep for the best baseline candidate.

### RAPID delivery
- Subtask A: API endpoint implementation.
- Subtask B: UI integration for the endpoint.
- Subtask C: test suite updates and regression checks.

## 4) Fan-in checklist
- Normalize outputs into the same report structure.
- Compare assumptions and shared dependencies.
- Resolve conflicts before merging into the main stream.
- Re-run validation after each integration step.
- Update Memory Bank with final decisions and follow-ups.

## 5) Git worktree pattern
```bash
# Create independent worktrees for parallel streams
git worktree add ../wt-feature-a -b feat/stream-a
git worktree add ../wt-feature-b -b feat/stream-b

# After each stream is complete, integrate in deterministic order
git checkout main
git merge --no-ff feat/stream-a
git merge --no-ff feat/stream-b
```

## 6) Output normalization pattern
Require each subagent to return:
1. What has been done
2. Files touched
3. Status / Blockers

Detailed metrics, risks, and assumptions should be returned in role-specific artifacts and
activity reports for non-trivial sessions.

This keeps fan-in deterministic and reduces integration ambiguity.
