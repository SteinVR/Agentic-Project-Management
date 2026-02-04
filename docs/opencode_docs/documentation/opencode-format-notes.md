# OpenCode format notes

Summary of key OpenCode file formats and locations based on docs in `docs/opencode_docs/`.

## Agents (profiles)

- **Format:** Markdown with YAML frontmatter and a prompt body.
- **Locations:**
  - Global: `~/.config/opencode/agents/`
  - Project: `.opencode/agents/`
- **Name:** filename becomes the agent name (e.g., `apm-architect.md` -> `@apm-architect`).
- **Frontmatter fields (common):**
  - `description` (required)
  - `mode` (`primary` | `subagent` | `all`)
  - `model`, `temperature`, `tools`, `permission` (optional)
- **Notes:** Subagents are invoked via `@mention` or by commands that set `agent:`.

## Commands (playbooks)

- **Format:** Markdown with YAML frontmatter and a prompt body.
- **Locations:**
  - Global: `~/.config/opencode/commands/`
  - Project: `.opencode/commands/`
- **Name:** filename becomes the command (e.g., `apm-start.md` -> `/apm-start`).
- **Frontmatter fields:**
  - `description` (recommended)
  - `agent` (optional, can be a subagent)
  - `subtask` (optional; force subagent execution)
  - `model` (optional)
- **Prompt features:**
  - `$ARGUMENTS` or positional `$1`, `$2`, ...
  - `@path/to/file` to include file contents
  - ``!`command` `` to inject shell output

## Skills

- **Format:** `SKILL.md` inside a folder named exactly as the skill.
- **Locations:**
  - Global: `~/.config/opencode/skills/<name>/SKILL.md`
  - Project: `.opencode/skills/<name>/SKILL.md`
- **Frontmatter (required):** `name`, `description`.
- **Name rules:** lowercase alphanumeric + single hyphens, 1-64 chars.
- **Optional folders:** `references/`, `scripts/`, `assets/`.
- **Loading:** agents use the `skill` tool to load skill content on demand.

## Custom tools

- **Format:** TypeScript/JavaScript file exporting a tool definition.
- **Locations:**
  - Global: `~/.config/opencode/tools/`
  - Project: `.opencode/tools/`
- **Name:** filename becomes tool name.
- **Helper:** `tool()` from `@opencode-ai/plugin` (Zod schemas for args).
- **Context:** `context.directory` (session working dir), `context.worktree` (git root).

