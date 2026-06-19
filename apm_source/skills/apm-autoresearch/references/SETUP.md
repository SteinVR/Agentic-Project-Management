# Setup

## Setup steps
1. Create or reuse `autoresearch/<tag>` from `dev` (or the project's active integration branch if `dev` does not exist). Use a dedicated worktree when the environment supports it.
2. Bootstrap the branch-local research context. Use these example artifacts from `references/`:
   - `AGENTS.md`
   - `memory_bank/ARCHITECTURE.md`
   - `memory_bank/specs/SPEC_TASK-AR.md`
   - `memory_bank/tasks/TASK-AR.md`
   - `run-id.md`
3. Read all in-scope and read-only files for full context.
4. Create `results.tsv` with header row.
5. Run the baseline without modifications and record it in `results.tsv`.
6. Once setup is complete, start the autoresearch loop.

## Expected project map

The autoresearch branch should keep the main implementation tree plus a branch-local research context:

```text
.
├── src/
├── AGENTS.md
├── results.tsv
├── memory_bank/
│   ├── ARCHITECTURE.md
│   ├── specs/
│   │   └── SPEC_TASK-AR.md
│   └── tasks/
│       └── TASK-AR.md
├── analysis/
│   └── ... project-specific analysis and run reports
├── artifacts/
│   └── ... project-specific research artifacts
└── ... runner-specific configs, scripts, and logs
```

Keep this map minimal. Add only the research-local artifacts needed for the loop, artifact inspection, and keep/discard continuity.

## Branch-local research context

Inside `autoresearch/<tag>`, keep an independent research context. Typical branch-local artifacts:
- `AGENTS.md`
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/specs/`
- `memory_bank/tasks/`
- `results.tsv`
- analysis and report artifacts
- keep-state artifacts

This context is local to the autoresearch stream. It is not promoted back by default.
