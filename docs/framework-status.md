# Framework status and compatibility review

Reviewed on **2026-10-25** against the checked-out sources and current official
environment documentation. This is an evidence snapshot and finalization plan;
it does not claim that the pending source or installer changes have been made.
[APM_ARCHITECTURE.md](../APM_ARCHITECTURE.md) owns the framework contracts.

## Scaffold instruction delivery

**Confirmed:** the base instruction templates are literally named
`apm_source/base/AGENTS-*.md` and `apm_source/base/src/AGENTS-*.md`.
Commit `6d613a0` renamed them from `AGENTS.md`. The
[configurator](../apm_project/apm.sh) copies the base without translating those
names. The [development skill](../apm_source/skills/apm-dev/SKILL.md) still expects
`src/AGENTS.md`, and the E2E suite expects a generated root `AGENTS.md`.

**Consequence:** generated projects receive the template filenames instead of
the instruction entry points expected by the workflows. This is a delivery
failure, not an argument for making source templates live repository rules.

**Finalization needed:** materialize the root and `src/` templates as
`AGENTS.md` in generated projects while keeping the source filenames deliberate.
Verify both output paths, template content, and in-place refresh behavior.
The source filenames and template contents were preserved during this review.

## Codex delivery

**Confirmed:** both Codex installers copy skills into `.codex/skills/` and role
TOML files into `.codex/agents/` at the selected local/global scope. The current
skill discovery contract documents repository and user skills under
`.agents/skills/`. The installer destination therefore needs alignment or an
explicit, tested legacy compatibility policy. This review did not establish
whether a particular installed Codex build also accepts the old path.
[Official skill locations](https://learn.chatgpt.com/docs/build-skills#where-codex-loads-local-skills).

The pack and Bash installer also write `multi_agent = true`, `max_threads = 6`,
and `max_depth = 1`. Current documentation says multi-agent support is enabled by
default and retains `max_threads` as an alias for
`max_concurrent_threads_per_session`. Those two older settings alone do not prove
a failure. `agents.max_depth` is absent from the current configuration reference;
its behavior needs verification against the chosen supported runtime.
[Official configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference).

**Finalization needed:** settle supported runtime versions, align skill delivery
in Bash and PowerShell, and verify real discovery and role invocation. Check the
existing model/effort pins against the user's available models; no model
migration or account availability check was performed here.

## Environment boundaries and role availability

**Confirmed:** OpenCode and Claude Code each ship six role files, including
`apm-co-founder`. Codex ships five specialist roles and no co-founder role file.
The shared workflow layer does not imply role parity.

OpenCode's documented `agents/` and `skills/` destinations match the current
installer layout. This is a layout check, not a live role execution test.
[Official agents documentation](https://opencode.ai/docs/agents/),
[official skills documentation](https://opencode.ai/docs/skills/).

Claude Code's instruction loading is version- and settings-dependent. Current
documentation supports direct `AGENTS.md` loading from v2.1.277, subject to its
project-instruction selection rules; existing `CLAUDE.md` files can take
precedence. Where direct loading is unavailable, the documented bridge is an
`@AGENTS.md` import in `CLAUDE.md`. APM currently delivers neither a version
policy nor that bridge. Choose and test the supported loading path before
claiming portable shared instructions.
[Official instruction-loading documentation](https://code.claude.com/docs/en/memory#agentsmd).

The old [Codex](Codex-CLI-Subagents.md) and [Claude Code](claude_docs.md) research
documents remain historical snapshots. Their earlier assumptions are not the
current compatibility contract.

## Cursor legacy path

**Confirmed:** the versioned `apm_source/_legacy/cursor_pack/` contains legacy
agents and commands. The configurator still exposes Cursor, and both the E2E
suite and broader validation runner include that delivery path. The E2E checks
for the Cursor engineer role and start command passed in this review.

Cursor remains frozen compatibility scope rather than an active architecture
target. File-copy checks do not establish current Cursor runtime compatibility;
no new support commitment or legacy migration was introduced.

## Verification evidence

Executed against the unchanged delivery code:

```bash
bash apm_project/tests/e2e_tests.sh
```

Result: **125 passed, 7 failed**, exit code **1**. Every failure is the missing
generated root `AGENTS.md`: OpenCode, Codex, Claude Code, Cursor, multi-environment,
in-place, and force-refresh scenarios. The suite does not assert the missing
`src/AGENTS.md` path, so the failure count understates the instruction-delivery gap.

The full `validate_all.sh` matrix, PowerShell execution, and live host/model
execution were not run. The full runner calls this failing E2E suite before its
installer matrix.

## Scope of this update

Updated repository instructions, framework architecture, usage documentation,
and the distinction between current contracts and historical research. Added
local navigation for framework sources, delivery, and supporting docs.

Implementation scripts, role configs, shared skills, and scaffold templates were
not changed. Their finalization remains a separate implementation step under the
repository's methodology-first rule. The immediate delivery work is template
materialization and Codex discovery alignment, followed by live instruction,
skill, and role-loading checks in the supported environment versions.
