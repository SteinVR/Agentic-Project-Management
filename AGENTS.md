# Agentic Project Management

APM is a framework for agentic development. It connects flow management
(planning, execution, delegation, verification) with context management
(shared instructions, skills, role configs, and durable project artifacts).
This repository contains the framework sources and delivery tools.

At the start of a new chat, read [README.md](README.md) for usage and
[APM_ARCHITECTURE.md](APM_ARCHITECTURE.md) for component boundaries and contracts.
Align with both before structural or methodological changes.

## Project map

```text
APM/
├── README.md              — usage, installation, skill and role catalog
├── APM_ARCHITECTURE.md    — framework architecture and invariants
├── apm_source/            — project templates, shared skills, environment packs
├── apm_project/           — configurator, installers, validation
├── docs/                  — supporting documentation and compatibility review
├── external/              — third-party reference material and skill sources
├── my-notes/              — design notes and proposals
├── git-branch-sync.sh     — selective tracked-file synchronization
└── .gitbranchignore       — branch-local exclusions for synchronization
```

- Framework assets: [apm_source/AGENTS.md](apm_source/AGENTS.md) explains source ownership and template scope.
- Delivery and validation: [apm_project/AGENTS.md](apm_project/AGENTS.md) maps the entry points and checks.
- Supporting material: [docs/AGENTS.md](docs/AGENTS.md) distinguishes current guidance from historical environment notes and routes branch-sync work.

## Shared contracts

- Use environment names `OpenCode`, `Codex`, `Claude Code`, and `Cursor (legacy)`.
  Environments are delivery targets; skills define workflows.
- Keep `AGENTS.md` to shared context, navigation, and rules applicable to every
  role in its scope. Put procedures in skills and role-specific behavior in
  agent configs. Keep each rule in its owning layer.
- Use progressive disclosure: describe the current level, link to local
  context, and load details for the task. Do not reproduce child-area contents
  in the root or create instruction files mechanically in every directory.
- Framework templates and reference instructions are deliverables, not
  governing instructions for work on this repository. Design notes and vendored
  material do not establish current framework contracts.
- When changing framework methodology, skills, roles, packs, or contracts,
  settle the logic and instruction flow first. Change implementation scripts
  only after the user explicitly requests finalization.
- Keep rules and skills concise: state intent, constraints, decisions, and
  expected outcomes without repetition or filler.
- Update `README.md` when usage, structure, skills, roles, or environment behavior
  changes. Update `APM_ARCHITECTURE.md` when core boundaries or invariants change.
