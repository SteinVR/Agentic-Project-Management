# APM Architecture

APM connects **flow management** (how work is planned, executed, delegated, and
verified) with **context management** (which instructions and artifacts govern
that work). It targets OpenCode, Codex, and Claude Code.

This document defines framework responsibilities and contracts.
[README.md](README.md) owns usage and the skill catalog;
[docs/framework-status.md](docs/framework-status.md) records dated implementation
gaps and compatibility evidence. A documented contract does not imply that every
delivery path currently implements it.

## 1. Framework boundary

APM ships project templates, reusable skills, role definitions, and delivery
scripts. The host environment runs the agent, loads instructions and skills,
enforces tool permissions, and schedules subagents. APM is an instruction and
delivery framework; it does not implement its own agent runtime.

Flow and context constrain each other. A frozen task specification determines
what execution must satisfy; a workflow determines when the agent reads that
specification, verifies the result, and records an outcome.

The stable principles are:

- Preserve the user's original formulation verbatim and separate it from later
  clarification and approved design decisions.
- Keep durable context small enough to maintain across sessions.
- Load local instructions and skill resources when the task needs them.
- Keep shared project context, procedures, and role behavior in separate layers.
- Match verification to the work and finish execution with self-review.

Instruction-level contracts, including a frozen spec, are behavioral
constraints. Filesystem protection and permission enforcement belong to the host;
prose alone does not provide them.

## 2. Sources and delivery

| Source | Owns |
| --- | --- |
| [apm_source/base/](apm_source/base/) | Minimal project scaffold, shared project instructions, Memory Bank templates |
| [apm_source/skills/](apm_source/skills/) | Shared workflows, supporting procedures, and bundled references |
| [apm_source/packs/](apm_source/packs/) | Environment-specific role definitions and configuration |
| [apm_source/_legacy/](apm_source/_legacy/) | Frozen compatibility assets, including the Cursor payload |
| [apm_project/](apm_project/) | Configurator, installers, and delivery validation |

The configurator copies the base scaffold and can install several environment
packs into the same project. Pack installation is optional: project-local,
user-global, or skipped. Legacy methodology flags are compatibility no-ops;
domain workflows extend the scaffold when needed.

Current installer output is:

| Environment | Skills | Roles and configuration |
| --- | --- | --- |
| OpenCode | `.opencode/skills/` or `~/.config/opencode/skills/` | Markdown roles in the corresponding `agents/` directory |
| Codex | `.codex/skills/` or `~/.codex/skills/` (legacy destination; see compatibility review) | TOML roles in `.codex/agents/`; settings merged into `.codex/config.toml` at the selected scope |
| Claude Code | `.claude/skills/` or `~/.claude/skills/` | Markdown roles in the corresponding `agents/` directory |

This table describes the scripts in this repository. Current host discovery
rules and installed-runtime acceptance are separate compatibility concerns.
In particular, current Codex documentation uses `.agents/skills/`.
[The compatibility review](docs/framework-status.md#codex-delivery) identifies the
required follow-up.

Cursor is a legacy delivery path with a versioned payload in
`apm_source/_legacy/cursor_pack/`. Installers retain it for compatibility and can
also deliver shared skills. New framework design targets the three active
environments above; legacy delivery checks do not certify current Cursor runtime
compatibility.

## 3. Context ownership and loading

| Layer | Responsibility |
| --- | --- |
| Root `AGENTS.md` | Project purpose, navigation, shared context and rules |
| Nested `AGENTS.md` | Context and rules for the selected area, without repeating parents |
| `SKILL.md` and its resources | An attachable procedure for a specific task or workflow |
| Agent config | A role's behavior, boundaries, tools, and environment controls |
| Memory Bank and specs | Durable project intent, decisions, contracts, and continuity |
| Task or delegation prompt | The concrete scope, expected result, and relevant pointers |

Use progressive disclosure. The root maps major areas; local context explains
the selected area; detailed procedures and references are loaded for the current
action. A directory needs its own instruction file only when it has useful local
context. Shared instructions must remain suitable for every role in their scope;
role-specific orchestration belongs in a role config or main-session procedure.

Source templates and skill reference instructions are framework deliverables,
not instructions for developing APM itself. The framework repository's
`APM_ARCHITECTURE.md` is distinct from a generated project's
`memory_bank/ARCHITECTURE.md`.

Automatic discovery, inheritance, instruction filenames, and skill availability
depend on the host and its version. An adapter must deliver both the files and a
working loading path; copying Markdown does not establish that it reaches an
agent's context.

## 4. Flow and agent responsibilities

The base template is methodology-neutral. Product development, testing, DS/ML,
and research share the scaffold and select procedures by task. A **workflow
skill** is identified by the literal `Workflow skill` mark in its description;
other skills may support a workflow without carrying that classification.

The main session owns the task by default. When explicitly invoked, `apm` adds
main-session coordination: frame the task, select the relevant workflow, bind to
SSOT artifacts, plan concrete work, execute or delegate, and self-review.
It does not automatically activate every APM skill.

Artifact mode is distinct from workflow selection:

- If a task spec exists, read it before planning and use it during execution,
  delegation, and review.
- When `apm` is active and no task/spec is established, it asks whether to create
  formal task artifacts or continue ad hoc.
- Ad-hoc work is allowed; it does not remove applicable architecture constraints
  or the need to verify the requested result.

Typical lifecycle:

1. The configurator copies the scaffold and optionally installs packs.
2. `apm-start` captures Original Intent, clarifies the project, obtains
   confirmation, bootstraps the Git layout, and initializes the Memory Bank.
   It selects a product or DS architecture template for the primary deliverable.
3. The selected workflow performs development, tests, EDA, feature analysis, or
   experiments. Domain directories are created on first use.
4. `apm-quality-gate` adds simplification and independent review **only when
   explicitly requested**. Self-review remains part of ordinary execution.
5. `apm-sync` reconciles continuity artifacts and affected project-owned READMEs
   **on explicit request**, using the memory-bank-sync role.

### Roles and delegation

| Role | Responsibility | Pack availability |
| --- | --- | --- |
| `apm-worker` | Bounded execution with self-review | All three active targets |
| `apm-code-simplifier` | Behavior-preserving cleanup of changed code | All three |
| `apm-reviewer` | Independent verification and ranked findings | All three |
| `apm-memory-bank-sync` | Continuity and project README reconciliation | All three |
| `apm-web-explorer` | Focused external research with sources | All three |
| `apm-co-founder` | Primary project partner for vision and direction | OpenCode and Claude Code; no Codex role file |

Delegate bounded responsibilities with clear ownership, expected output, and
acceptance checks. Use the appropriate available APM role and the
`apm-subagent` delegation contract. Pass paths to architecture, relevant module
and task specs, and task-specific context instead of copying the whole project.
A frozen task spec binds both the main session and delegated work.

Host delegation triggers, tool permissions, and nesting limits still apply.
A useful isolation boundary does not override a host requirement for an explicit
delegation request or applicable instruction. Role availability is not identical
across environments.

## 5. Durable project context

Generated projects keep durable context in `memory_bank/`:

| Artifact | Contract |
| --- | --- |
| `ARCHITECTURE.md` | Project-level source of truth: verbatim Original Intent, clarified intent, stack, architecture, constraints, and approved decisions |
| `STATE.md` | Compact operational status, blockers, and continuity |
| `TASKS.md` | Ordered high-level task board; when waves are used, waves are sequential and tasks within one wave may run in parallel |
| `design/SPEC-{module}.md` | Global module contracts, interfaces, invariants, and data formats; changes require approval |
| `specs/SPEC_{id}.md` | Frozen task goal, contracts, pipeline, and Definition of Done; read-only during execution |
| `tasks/{id}.md` | Working journal, findings, and outcome |

Keep `STATE.md` and `TASKS.md` under 120 lines and compress them when needed.
Original Intent remains verbatim; approved refinements belong outside the quote.
Do not silently change a frozen contract to match an implementation.

Continuity synchronization updates actual state and affected project-owned
READMEs. The sync role proposes architecture changes for explicit approval;
a synchronization request alone does not authorize a redesign.

Generated-project implementation conventions belong in the `src/` instruction
layer: modular typed code, single-role files, minimal fallback logic, runtime
logging, smoke-first verification, and local source documentation. Their source
template is in `apm_source/base/src/`; skills and roles refer to that layer
instead of redefining it.

## 6. Git boundaries

`apm-start` prescribes two independent histories for a **new generated project**:
clean `main` without APM working artifacts, and working `dev` with the full
operating context. Initialization finishes on `dev`. The configurator's file
copy alone does not create this layout.

Existing user history must not be rewritten or reshaped into this layout without
explicit approval. These bootstrap instructions do not prescribe a branch rename
or history migration for the APM framework repository.

For isolated execution, `apm-git-taskflow` creates `task/<identifier>` branches
from `dev` and worktrees under `.apm/worktrees/<identifier>`. Heavy untracked
resources may be shared at repository level; new artifacts are created in the
worktree and integrated deliberately.

`apm-autoresearch` uses an isolated `autoresearch/<tag>` stream with branch-local
context, run reporting, keep/discard decisions, and selective promotion to
`dev`. Its destructive reset behavior is confined to that research stream.

The framework repository also provides `git-branch-sync.sh` for selective
tracked-file synchronization. Its preview/apply behavior and branch-local
exclusions are documented in [docs/git-workflow.md](docs/git-workflow.md).

## 7. Compatibility and verification boundary

Delivery validation checks scaffold and installer output. Runtime verification
must additionally establish that the intended environment loads project
instructions, discovers a skill, accepts a role definition, and can execute the
selected model and tools. Shared Markdown does not guarantee equal behavior.

Keep framework contracts, current installer output, and proposed migrations
distinct. Record unresolved gaps in [docs/framework-status.md](docs/framework-status.md)
until source assets, installers, and verification agree. Methodological changes
settle before script finalization, as required by the repository instructions.
