# Decision Log: [Project Name]

> Note: This document records architectural and technical decisions using ADR (Architecture Decision Record) format. Add new decisions at the top.

---

## Template

```markdown
## DEC-XXX: [Decision Title]

- **Date:** YYYY-MM-DD
- **Status:** [Proposed / Accepted / Deprecated / Superseded by DEC-XXX]
- **Context:** [What is the issue or situation that requires a decision?]
- **Decision:** [What was decided?]
- **Rationale:** [Why was this decision made?]
- **Consequences:** [What are the implications - both positive and negative?]
- **Affects:** [Which blocks/components are impacted?]
```

---

## Decisions

<!-- Add new decisions here, above the line -->

---

## DEC-001: [Example - Database Choice]

- **Date:** YYYY-MM-DD
- **Status:** Accepted
- **Context:** Need to choose a database for the project.
- **Decision:** Use SQLite for data persistence.
- **Rationale:** Simple deployment, no external dependencies, sufficient for MVP scope.
- **Consequences:** Limited concurrency, may need migration for scaling.
- **Affects:** All blocks requiring data persistence.

