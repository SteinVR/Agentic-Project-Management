# Supporting documentation

This area explains framework operations and holds environment research.
[APM_ARCHITECTURE.md](../APM_ARCHITECTURE.md) owns framework contracts;
[framework-status.md](framework-status.md) records the dated compatibility review,
verification evidence, and work still needed.

## Local map

```text
docs/
├── framework-status.md       — current findings and deferred finalization
├── git-workflow.md           — selective branch sync and historical Git notes
├── about_skills/             — skill format and authoring references
├── opencode_docs/            — OpenCode reference material
├── Codex-CLI-Subagents.md    — historical Codex research snapshot
├── claude_docs.md            — historical Claude Code integration snapshot
├── cursor_docs.md            — legacy Cursor reference
└── _legacy/                 — archived orchestration research
```

For branch synchronization, read [git-workflow.md](git-workflow.md) before using
the root helper. For environment integration, start with
[framework-status.md](framework-status.md) and its official sources. Older local
snapshots explain prior choices; verify version-sensitive claims before reuse.
