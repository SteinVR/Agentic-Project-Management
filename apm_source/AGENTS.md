# Framework sources

This directory owns the assets shipped to generated projects and agent
environments. [APM_ARCHITECTURE.md](../APM_ARCHITECTURE.md) defines their boundaries;
the [README catalog](../README.md#skills) describes the available skills.

## Local map

```text
apm_source/
├── base/     — project scaffold and Memory Bank templates
├── skills/   — shared SKILL.md procedures and their bundled resources
├── packs/    — environment-specific role and configuration envelopes
└── _legacy/  — frozen Cursor payload and retired shared workflows
```

## Asset boundaries

- For scaffold changes, inspect `base/` and the configurator's copy behavior.
  The root and `src/` instruction templates currently have the literal name
  `AGENTS-*.md`; `*` is part of the filename. They are not live repository rules.
- For a skill change, read that skill's `SKILL.md` and only the supporting
  resources needed for the change. The `Workflow skill` mark in its description
  identifies a workflow skill; the name alone does not.
- For role or environment behavior, inspect the relevant pack. Shared role
  contracts have separate environment representations; check their consistency
  without copying environment settings into shared skills or project rules.
- Instructions inside `base/` and skill references govern their eventual
  generated workflows, not framework development. Edit them as deliverables.
- `packs/` contains OpenCode, Codex, and Claude Code payloads. `_legacy/` contains
  compatibility assets; they do not govern new framework design.
