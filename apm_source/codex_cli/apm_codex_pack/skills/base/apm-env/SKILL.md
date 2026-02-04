---
name: apm-env
description: Set up DS environment from ARCHITECTURE.md (pyproject + setup steps).
compatibility: codex
---
## What I do
- Analyze the Technology Stack section in `memory-bank/ARCHITECTURE.md`.
- Propose or create a compatible `pyproject.toml`.
- Provide setup commands and update `memory-bank/STATE.md`.

## Required reads
- `memory-bank/ARCHITECTURE.md`
- `memory-bank/STATE.md`

## Workflow
1. Read the Technology Stack section.
2. Propose the environment setup (dependencies, tooling, Python version).
3. If approved, create or update `pyproject.toml`.
4. Provide setup commands and record the environment in `STATE.md`.

## Required outputs
- `pyproject.toml` (if approved)
- `memory-bank/STATE.md` (updated)
