# SPEC: W1A — [Title]

**Wave:** 1 | **Depends on:** — | **Blocks:** —

## Goal

[1-2 sentences: what to build and why. Concrete — no "may", "optional", or deferred decisions.]

## Pipeline

[How the feature/module functions: sequence, data flow, processing order. Not an implementation plan — describes the runtime behavior.]

1. [Step with exact module, e.g. `src/core/auth.py` — validate session token]
2. ...

## Contracts

| Interface | Location | Owner |
|-----------|----------|-------|
| [e.g. SessionStore] | [e.g. src/contracts/auth.py] | [Owner TASK_ID] |

> Cross-task contract definitions. Point to concrete interface artifacts such as Protocols, ABCs, TypedDicts, dataclasses, schemas, or other typed contract files. If no cross-task contracts exist, leave empty.

## Ready Interfaces

[Concrete interface definitions or exact signatures the implementation builds against.]

```python
# Example
from typing import Protocol

class SessionStore(Protocol):
    def get(self, session_id: str) -> Session | None: ...
    def put(self, session: Session) -> None: ...
```

## Typecheck Automation

- **Command:** [e.g. `pyright src tests` or `mypy src tests`]
- **Scope:** [e.g. `src/contracts/auth.py`, `src/core/auth.py`, `tests/test_auth.py`]
- **Gate:** [e.g. Must pass before handoff / quality gate / merge]

## Frozen Decisions

| Decision | Value |
|----------|-------|
| [e.g. Auth mechanism] | [e.g. JWT with RS256] |

## Output

- [Expected artifact paths, e.g. `src/core/auth.py`, `tests/test_auth.py`]

## Definition of Done

- [ ] [Concrete, verifiable criterion]
- [ ] All declared contract interfaces implemented
- [ ] Declared typecheck automation passes
- [ ] Verification passing


---

> This template contains core sections. Task-specific sections (e.g., VRAM Budget, Metrics, External Integration) may be added as needed.
