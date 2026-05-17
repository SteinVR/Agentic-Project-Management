---
name: apm-start
description: "Project kickoff: initialize directory structure, bootstrap the dual-branch git layout, run Vision Alignment, and set up Memory Bank. Use when starting a new project or resetting architecture from scratch."
---
## Skill Description
Project initialization workflow that aligns goals, establishes project structure, bootstraps the repository's dual-branch layout, and creates the initial Memory Bank as the working source of truth.

## Required outputs
- Clean `main` branch with independent history and without APM working artifacts.
- `dev` branch with independent history, full APM working artifacts, and ready as the default working branch.
- `memory_bank/ARCHITECTURE.md`
- `memory_bank/TASKS.md`
- `memory_bank/STATE.md`
- Initial task spec in `memory_bank/specs/` and working journal in `memory_bank/tasks/`

## Step 1: Initialize structure
Only when the project directory is missing required directories. Create:
`src/`, `tests/`, `logs/`, `external/`, `memory_bank/`, `memory_bank/design/`, `memory_bank/specs/`, `memory_bank/tasks/`

## Step 2: Vision Alignment
Run a structured session to produce a clear project definition. Approach this as turning an ambiguous idea into precise, actionable architecture.

First capture the user's original project formulation verbatim. Preserve wording, scope, examples, and rough edges. Do not clean it up, summarize it, translate it, or merge it with later interpretation. This quote becomes the Original Intent anchor in `memory_bank/ARCHITECTURE.md`.

Then run a detailed clarification pass. Be deliberately thorough: ask about details the user may have left implicit, assumptions that are still only in their head, and places where a future agent could reinterpret the project incorrectly. Do not proceed from vague answers when the ambiguity affects architecture, scope, workflow, data, quality criteria, or delivery.

Adapt questions to the project domain. Cover these areas (order and depth may vary):

1. **Project Idea** -- what the project is, what problem it solves
2. **Scope & Form Factor** -- type (CLI, web service, ML pipeline, library, etc.), core functionality, delivery boundaries
3. **User/Execution Workflow** -- how users interact with the product, or how the pipeline executes
4. **Success Criteria** -- concrete metrics or acceptance criteria (for ML: targets, evaluation metrics; for product: user-facing requirements)
5. **Constraints** -- budget, time, infra, data access, latency, interpretability -- whatever applies
6. **Non-goals and Boundaries** -- what must not be built, optimized, automated, or abstracted
7. **Examples and Counterexamples** -- concrete cases that should work, cases that should fail, and cases outside scope
8. **Terminology** -- project-specific words that must keep their intended meaning
9. **User Preferences** -- UX, code style, operational behavior, risk tolerance, and other preferences not obvious from the brief

Then provide:
- **Suggested Details** (proposals the user may not have considered)
- **Tech Stack Proposal** (options with trade-offs)
- **Ambiguity Check** (remaining unclear points and the risk of each)

Wait for user confirmation before proceeding.

## Step 3: Bootstrap git layout
- Initialize git if the project is not yet a repository.
- Create two separate branches with independent history:
  - `main` -- clean branch, reserved for artifact-free project state. Do not keep working artifacts here (`AGENTS.md`, `memory_bank/`, `external/`, `docs/`, and similar operating assets).
  - `dev` -- primary development branch. Keep the full APM working layer here, including all operating artifacts required for agentic development.
- Treat `dev` as the default branch for day-to-day work, task branches, and worktrees.
- Finish initialization on `dev`.

## Step 4: Create Memory Bank
- Determine the appropriate architecture template from this skill's `references/`:
  - `ARCHITECTURE_PRODUCT_TMP.md` -- for product/application projects
  - `ARCHITECTURE_DS_TMP.md` -- for ML/DL/experiment-driven projects
  Choose based on the project domain established in Step 2. If the project mixes both, start with the one closer to the primary deliverable and extend as needed.
- Fill `memory_bank/ARCHITECTURE.md` using the chosen template. Include the Original Intent verbatim quote, approved decisions, tech stack, architecture, and constraints.
- Initialize `memory_bank/TASKS.md`, initial spec and task files, and `memory_bank/STATE.md`.

## Step 5: Environment setup
- Read Technology Stack and Deployment sections in the newly created `memory_bank/ARCHITECTURE.md`.
- Propose the environment (runtime versions, package manager, core deps).
- If approved, create or update config files (pyproject.toml, package.json, etc.) and provide setup commands.

## Guardrails
- Do not rewrite or replace an existing user git history without explicit approval. If the repository already has meaningful history, align with the user before reshaping branches into the dual-branch layout.
- Do not implement application code unless explicitly requested.
- Do not update Memory Bank files outside the initialization steps above unless the user explicitly asks.
