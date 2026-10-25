# Agentic Project Management

**A framework for agentic development across OpenCode, Codex, and Claude Code.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

APM connects two responsibilities:

- **Flow management** — planning, execution, delegation, and verification.
- **Context management** — shared instructions, skills, role contracts, and
  durable project artifacts loaded at the right scope.

It provides a project scaffold, reusable workflows, environment-specific roles,
and a Bash configurator with Bash/PowerShell pack installers. The host environment
runs the agents and enforces permissions.

**Current delivery status:** scaffold instruction filenames and Codex skill
installation need finalization.
Read the [compatibility review](docs/framework-status.md) before adopting the
current generator output. The review separates confirmed behavior from pending
changes and records the failing E2E checks.

For framework responsibilities and invariants, see
[APM_ARCHITECTURE.md](APM_ARCHITECTURE.md). For development of APM itself, start
with [AGENTS.md](AGENTS.md).

## Quick start

The commands below are the existing delivery entry points. They do not resolve
the known compatibility gaps above.

Run the configurator on Linux/macOS or Windows via WSL/Git Bash:

```bash
bash ./apm_project/apm.sh
```

For a non-interactive project with local OpenCode assets:

```bash
bash ./apm_project/apm.sh --opencode --project-name "my-app" \
  --project-path "/projects" --local --non-interactive
```

Inside an existing project directory:

```bash
bash /path/to/Agentic-Project-Management/apm_project/apm.sh \
  --opencode --local --non-interactive
```

Environment shorthands are `--opencode`, `--codex`, and `--claude`; several
can be selected for one project. Installation scope is `--local`, `--global`,
or `--none` (the default). In non-interactive mode, project path and name default
to the current directory and its name. Legacy methodology flags do not select
different templates; workflows extend the common scaffold.

## Pack installation

Install packs without regenerating a project:

| Environment | Global installation | Project-local installation |
| --- | --- | --- |
| OpenCode | `bash apm_project/scripts/opencode_install.sh --global` | `bash apm_project/scripts/opencode_install.sh --local /path/to/project` |
| Codex | `bash apm_project/scripts/codex_install.sh --global` | `bash apm_project/scripts/codex_install.sh --local /path/to/project` |
| Claude Code | `bash apm_project/scripts/claude_install.sh --global` | `bash apm_project/scripts/claude_install.sh --local /path/to/project` |

PowerShell equivalents use the matching `*_install.ps1` script with `-Global`
or `-Local -Path <project>`.

Current installer destinations:

| Environment | Skills | Roles |
| --- | --- | --- |
| OpenCode | `.opencode/skills/` or `~/.config/opencode/skills/` | `agents/` under the same config directory |
| Codex | `.codex/skills/` or `~/.codex/skills/` — legacy destination, see review | `.codex/agents/` or `~/.codex/agents/` |
| Claude Code | `.claude/skills/` or `~/.claude/skills/` | `agents/` under the same config directory |

Codex installation also merges APM settings into `config.toml` at the chosen
scope. File installation and runtime discovery are separate: current Codex skill
discovery uses `.agents/skills/`, and shared project-instruction loading in
Claude Code depends on version and settings.
[Compatibility details and official sources](docs/framework-status.md).

Cursor remains a legacy compatibility target, with its payload under
`apm_source/_legacy/cursor_pack/`. It does not drive new framework design.

Optional shell aliases:

```bash
alias apm='bash /path/to/Agentic-Project-Management/apm_project/apm.sh'
alias apm-cd='cd /path/to/Agentic-Project-Management'
```

## How it works

The configurator copies a minimal scaffold and optionally installs packs.
Project initialization then runs through `apm-start`: capture your original
formulation verbatim, clarify the intended project, obtain confirmation, select
the appropriate architecture template, and initialize the Memory Bank.

For a new generated repository, `apm-start` prescribes independent clean
`main` and working `dev` histories. The configurator's copy step does not create
them. Existing history is not reshaped without explicit approval. These are
generated-project conventions, not instructions to rename this repository's
branches.

Invoke `apm` explicitly when you want its main-session coordination layer.
It selects relevant workflows, binds the task to its source-of-truth artifacts,
plans the work, and finishes with self-review. It asks whether to create formal
task artifacts or work ad hoc when no task/spec is established.

Workflow selection follows skill descriptions. A skill carrying the literal
`Workflow skill` mark in its description defines a workflow; supporting skills
have their own invocation conditions. Domain workflows create directories such
as `eda/`, `experiments/`, and `models/` when needed.

The main session performs work by default. Specialist delegation uses bounded
tasks, relevant context pointers, and an expected result, subject to the host's
delegation rules. If a frozen task spec exists, it binds both main and delegated
execution.

Self-review is part of execution. `apm-quality-gate` adds independent
simplification and review only when explicitly requested. `apm-sync` updates
continuity and affected project-owned READMEs on explicit request; its
architecture changes require approval.

Example flows (invoke optional steps when needed):

- Product: `apm-start` → `apm-dev` → `apm-test` → optional `apm-quality-gate` → requested `apm-sync`.
- DS/ML: `apm-start` → `apm-eda` → `apm-deep-feature-engineering` → `apm-exp` → requested `apm-sync`.
- Mixed projects combine the relevant skills within the same scaffold.

## Project context and artifacts

Generated projects use `memory_bank/`:

- `ARCHITECTURE.md` preserves Original Intent and approved architecture.
- `STATE.md` holds operational continuity; `TASKS.md` holds the high-level board.
  Keep each under 120 lines.
- `design/SPEC-{module}.md` defines module contracts; changes require approval.
- `specs/SPEC_{id}.md` is a frozen task spec, read-only during execution.
- `tasks/{id}.md` is the working journal and outcome.

Root and nested `AGENTS.md` provide shared context and local rules; skills provide
procedures; role configs define specialist behavior. Detailed generated-project
code conventions belong in the `src/` instruction layer rather than being
repeated in every skill. The source instruction templates currently use the
literal filename `AGENTS-*.md`; producing active `AGENTS.md` output is a pending
delivery fix.

Runtime logs belong in `logs/runtime/`; generated test, review, and model reports
belong in `logs/project/reports/`.

For isolated execution streams, `apm-git-taskflow` manages `dev`-based task
branches and worktrees with shared heavy resources. `apm-autoresearch` provides
an isolated research stream with keep/discard decisions and selective promotion.
The separate root `git-branch-sync.sh` helper synchronizes selected tracked files
between branches; see [Git workflow notes](docs/git-workflow.md).

## Skills

| Skill | Purpose |
| --- | --- |
| `apm` | Explicit main-session coordination: task framing, context binding, workflow selection, self-review |
| `apm-start` | Project kickoff, Original Intent, clarification, Git bootstrap, Memory Bank initialization |
| `apm-dev` | Workflow skill for iterative development and verification |
| `apm-test` | Workflow skill for module smoke and smoke E2E checks, with narrow integration tests when needed |
| `apm-eda` | Workflow skill for exploratory data analysis and leakage checks |
| `apm-deep-feature-engineering` | Workflow skill for ranked, testable feature candidates after EDA |
| `apm-exp` | Workflow skill for baselines and hypothesis-driven ML/DS experiments |
| `apm-quality-gate` | Explicitly requested simplification, verification, independent review, and fix loop |
| `apm-git-taskflow` | Task branch/worktree isolation and shared runtime management |
| `apm-sync` | Workflow skill for requested Memory Bank and project README reconciliation |
| `apm-subagent` | Specialist delegation contract with relevant SSOT and frozen-spec pointers |
| `apm-logs` | Runtime logging conventions |
| `apm-autoresearch` | Workflow skill for isolated autonomous research with reporting and selective promotion |
| `apm-compression-mode` | Explicitly requested terse communication without loss of technical meaning |

Sources live in [apm_source/skills/](apm_source/skills/). Skill descriptions and
their instructions determine invocation conditions.

## Agent roles

| Role | Responsibility |
| --- | --- |
| `apm-worker` | Bounded execution and self-review |
| `apm-code-simplifier` | Behavior-preserving cleanup |
| `apm-reviewer` | Independent verification |
| `apm-memory-bank-sync` | Memory Bank and affected project README continuity |
| `apm-web-explorer` | Focused external research with sources |
| `apm-co-founder` | Primary partner for project vision, architecture, and direction |

The five specialist roles are present in all three active packs.
`apm-co-founder` is provided by OpenCode and Claude Code; the Codex pack has no
co-founder role file. Role settings and runtime capabilities vary by environment.

## Framework sources and validation

- [apm_source/](apm_source/) contains the scaffold, shared skills, and packs.
- [apm_project/](apm_project/) contains the configurator, installers, and checks.
- [docs/](docs/) contains supporting references; older environment research is
  labeled as historical.
- `external/` holds third-party skill sources; `my-notes/` holds design notes
  and proposals rather than active framework contracts.

Run `bash apm_project/tests/e2e_tests.sh` for delivery E2E checks.
`bash apm_project/tests/validate_all.sh` adds syntax, interactive, and installer
matrix checks. These do not prove live host/model compatibility.
See the [review](docs/framework-status.md#verification-evidence) for the current
baseline and unverified paths.
