# Claude Code: Environment Documentation for APM

## 1. Overview

Claude Code is Anthropic's CLI-based agentic coding tool. It operates in the terminal as an interactive REPL or in headless mode (`-p` flag) for automation and CI/CD. Claude Code uses its own instruction format (`CLAUDE.md`) instead of the cross-tool `AGENTS.md` standard, has a rich subagent system, skills following the `agentskills.io` spec, and an experimental Agent Teams feature for multi-session coordination.

Key traits relevant to APM integration:
- Instruction layer: `CLAUDE.md` (not `AGENTS.md`; AGENTS.md support is pending).
- Subagent definitions: `.claude/agents/` (Markdown + YAML frontmatter).
- Skills: `.claude/skills/` following `agentskills.io` spec (shared with Cursor).
- Settings and permissions: `.claude/settings.json` (JSON, scoped).
- Headless / SDK mode: `claude -p` for non-interactive execution.
- Agent Teams: experimental multi-session orchestration (separate from subagents).

---

## 2. CLAUDE.md -- Instruction Layer

### 2.1. Role

`CLAUDE.md` is Claude Code's equivalent of `AGENTS.md`. It provides persistent project memory loaded into every conversation at startup. Claude treats its contents as context and behavioral guidance (not hard enforcement). The more specific and concise the instructions, the more reliably Claude follows them.

### 2.2. File Locations and Hierarchy

CLAUDE.md files load from multiple locations with cascading priority. More specific scopes override broader ones.

| Scope | Location | Priority | Shared |
|-------|----------|----------|--------|
| Managed policy | `/etc/claude-code/CLAUDE.md` (Linux/WSL) | Highest (cannot be excluded) | All users on machine |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Medium | Team (via VCS) |
| User | `~/.claude/CLAUDE.md` | Lowest | Personal, all projects |

**Subdirectory CLAUDE.md files** are discovered on demand. When Claude reads files in a subdirectory, it also loads any `CLAUDE.md` found there. This enables monorepo and per-package instructions.

**Directory walk-up**: Claude Code walks up the directory tree from the current working directory, loading `CLAUDE.md` from each ancestor. Running Claude in `foo/bar/` loads both `foo/bar/CLAUDE.md` and `foo/CLAUDE.md`.

### 2.3. Modular Rules: `.claude/rules/`

For larger projects, instructions can be split into topic-specific `.md` files inside `.claude/rules/`. Each file covers one topic (e.g., `testing.md`, `api-design.md`).

**Path-scoped rules** use YAML frontmatter with `paths:` to activate only when Claude works with matching files:

```yaml
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules
- All API endpoints must include input validation
- Use the standard error response format
```

Rules without a `paths` field load unconditionally at session start.

### 2.4. Imports

`CLAUDE.md` supports importing additional files with `@path/to/file` syntax. Imported files expand at launch. Relative paths resolve from the importing file. Max depth: 5 hops.

```text
See @README for project overview and @package.json for available commands.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

### 2.5. Key Differences from AGENTS.md

| Aspect | AGENTS.md | CLAUDE.md |
|--------|-----------|-----------|
| Supported tools | Codex, Cursor, Copilot, Windsurf, Devin, others | Claude Code only (AGENTS.md support pending) |
| Format | Pure Markdown | Pure Markdown |
| Subdirectory loading | Immediate (all levels) | On-demand (when Claude reads files in that directory) |
| Modular rules | Not supported | `.claude/rules/` with optional path scoping |
| File imports | Not supported | `@path/to/file` syntax |
| Managed tier | Not applicable | `/etc/claude-code/CLAUDE.md` (IT-deployed) |

### 2.6. Auto Memory

Claude Code has an auto memory system separate from `CLAUDE.md`. Claude writes notes for itself as it works (build commands, debugging insights, architecture patterns). Auto memory is stored per-project at `~/.claude/projects/<project>/memory/` and the first 200 lines of `MEMORY.md` load at session start.

This is complementary to (not a replacement for) explicit `CLAUDE.md` instructions.

---

## 3. Subagents

### 3.1. Concept

Subagents are specialized AI instances that handle specific tasks within a single Claude Code session. Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions. The parent agent delegates tasks and receives results back.

Key constraint: **subagents cannot spawn other subagents** (max depth 1).

### 3.2. Built-in Subagents

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| Explore | Haiku (fast) | Read-only | File discovery, code search, codebase exploration |
| Plan | Inherits | Read-only | Codebase research for plan mode |
| General-purpose | Inherits | All | Complex multi-step tasks requiring both exploration and modification |
| Bash | Inherits | Bash | Terminal commands in a separate context |

Explore supports thoroughness levels: `quick`, `medium`, `very thorough`.

### 3.3. Custom Subagent Configuration

Custom subagents are Markdown files with YAML frontmatter stored in:

| Location | Scope | Priority |
|----------|-------|----------|
| `--agents` CLI flag (JSON) | Current session only | 1 (highest) |
| `.claude/agents/` | Current project | 2 |
| `~/.claude/agents/` | All projects (personal) | 3 |
| Plugin `agents/` directory | Where plugin is enabled | 4 (lowest) |

Project subagents (`.claude/agents/`) are intended for version control.

### 3.4. Subagent File Format

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices. Use proactively after code changes.
tools: Read, Glob, Grep, Bash
model: sonnet
---

You are a senior code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

The frontmatter defines metadata and configuration. The body becomes the system prompt.

### 3.5. Supported Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase letters and hyphens) |
| `description` | Yes | When Claude should delegate to this subagent |
| `tools` | No | Allowed tools (allowlist). Inherits all if omitted |
| `disallowedTools` | No | Tools to deny (denylist), removed from inherited/specified list |
| `model` | No | `sonnet`, `opus`, `haiku`, full model ID, or `inherit` (default) |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Maximum agentic turns before the subagent stops |
| `skills` | No | Skills to preload into subagent context at startup |
| `mcpServers` | No | MCP servers available to this subagent |
| `hooks` | No | Lifecycle hooks scoped to this subagent |
| `memory` | No | Persistent memory scope: `user`, `project`, or `local` |
| `background` | No | `true` to always run as background task (default: `false`) |
| `effort` | No | `low`, `medium`, `high`, `max` (Opus 4.6 only) |
| `isolation` | No | `worktree` to run in a temporary git worktree |

### 3.6. Tool Control

Subagent tools can be restricted via `tools` (allowlist) or `disallowedTools` (denylist):

```yaml
# Allowlist: only these tools available
tools: Read, Grep, Glob, Bash

# Denylist: inherit everything except these
disallowedTools: Write, Edit
```

If both are set, `disallowedTools` is applied first, then `tools` resolves against the remaining pool.

To restrict which subagents an agent can spawn (when running as main thread with `--agent`):

```yaml
tools: Agent(worker, researcher), Read, Bash
```

### 3.7. Permission Modes

| Mode | Behavior |
|------|----------|
| `default` | Standard permission checking with prompts |
| `acceptEdits` | Auto-accept file edits |
| `dontAsk` | Auto-deny permission prompts (explicitly allowed tools still work) |
| `bypassPermissions` | Skip permission prompts (use with caution) |
| `plan` | Plan mode (read-only exploration) |

### 3.8. Foreground vs Background Execution

- **Foreground**: blocks the main conversation until complete. Permission prompts pass through.
- **Background**: runs concurrently. Permissions are pre-approved at launch; anything not pre-approved is auto-denied. Clarifying questions fail but the subagent continues.

Claude decides automatically, or the user can request "run this in the background" or press `Ctrl+B`.

### 3.9. Subagent Invocation Methods

1. **Automatic delegation**: Claude delegates based on `description` match.
2. **Natural language**: "Use the code-reviewer subagent to review my changes."
3. **@-mention**: `@"code-reviewer (agent)" review the auth changes` -- guarantees invocation.
4. **Session-wide**: `claude --agent code-reviewer` -- the entire session uses that subagent's config.

### 3.10. Resume and Context

Each subagent invocation is fresh. To continue existing work, ask Claude to resume (uses `SendMessage` tool with the agent's ID). Subagent transcripts persist at `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`.

Subagents support auto-compaction at ~95% capacity.

### 3.11. Persistent Memory for Subagents

The `memory` field gives subagents a persistent directory across conversations:

| Scope | Location | Use when |
|-------|----------|----------|
| `user` | `~/.claude/agent-memory/<name>/` | Learnings across all projects |
| `project` | `.claude/agent-memory/<name>/` | Project-specific, shareable via VCS |
| `local` | `.claude/agent-memory-local/<name>/` | Project-specific, not committed |

When enabled, the subagent's system prompt includes memory management instructions and the first 200 lines of `MEMORY.md`.

### 3.12. Lifecycle Hooks

Subagents support hooks in frontmatter (`PreToolUse`, `PostToolUse`, `Stop`) and in `settings.json` for project-level lifecycle events (`SubagentStart`, `SubagentStop`):

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
```

### 3.13. CLI-Defined Subagents (Ephemeral)

Subagents can be passed as JSON via `--agents` for single-session use:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer.",
    "prompt": "You are a senior code reviewer.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

---

## 4. Agent Teams (Experimental)

### 4.1. Concept

Agent Teams coordinate multiple independent Claude Code instances (separate sessions, not subagents). One session acts as team lead; teammates are fully independent Claude Code instances with their own context windows and full tool access.

Unlike subagents (hierarchical, single-session), Agent Teams support peer-to-peer messaging, shared task lists, and self-coordination.

### 4.2. Requirements

- Claude Code v2.1.32+
- Opus 4.6 model
- Experimental flag: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

### 4.3. Architecture

| Component | Role |
|-----------|------|
| Team lead | Main session that creates team, spawns teammates, coordinates work |
| Teammates | Separate Claude Code instances working on assigned tasks |
| Task list | Shared work items with `pending`, `in progress`, `completed` states and dependencies |
| Mailbox | Messaging system for inter-agent communication |

Storage: `~/.claude/teams/{team-name}/config.json` and `~/.claude/tasks/{team-name}/`.

### 4.4. Comparison with Subagents

| | Subagents | Agent Teams |
|---|-----------|-------------|
| Context | Own context; results return to caller | Own context; fully independent |
| Communication | Report back to main agent only | Peer-to-peer messaging |
| Coordination | Main agent manages all work | Shared task list with self-coordination |
| Best for | Focused tasks where only result matters | Complex work requiring discussion |
| Token cost | Lower (summarized results) | Higher (each teammate is a separate instance) |
| Depth | Cannot spawn sub-subagents | Teammates cannot spawn teams |

### 4.5. Display Modes

- **In-process**: all teammates run inside the main terminal. `Shift+Down` cycles through teammates.
- **Split panes**: each teammate in its own pane (requires tmux or iTerm2).

### 4.6. Limitations

- No session resumption for in-process teammates.
- One team per session.
- No nested teams.
- Lead is fixed (cannot transfer leadership).
- Permissions set at spawn (inherited from lead).
- Split panes not supported in VS Code terminal, Windows Terminal, or Ghostty.

---

## 5. Skills

### 5.1. Format

Claude Code skills follow the `agentskills.io` open standard (shared with Cursor). Skills are directories containing a `SKILL.md` file with YAML frontmatter and Markdown instructions.

```text
my-skill/
├── SKILL.md           # Required: metadata + instructions
├── scripts/           # Optional: executable code
├── references/        # Optional: documentation
└── assets/            # Optional: templates, configs
```

### 5.2. Skill Locations

| Location | Scope |
|----------|-------|
| `.claude/skills/<name>/SKILL.md` | Project |
| `~/.claude/skills/<name>/SKILL.md` | Personal (all projects) |
| Plugin `skills/` directory | Where plugin is enabled |
| `.claude/commands/<name>.md` | Legacy (still works, skills take precedence) |

Automatic discovery: when editing files in subdirectories, Claude Code also looks for skills in nested `.claude/skills/` directories (monorepo support).

### 5.3. Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Identifier (defaults to directory name). Lowercase, hyphens, max 64 chars. |
| `description` | Recommended | What the skill does and when to use it. |
| `argument-hint` | No | Hint for autocomplete (e.g., `[issue-number]`). |
| `disable-model-invocation` | No | `true` = only manual `/name` invocation. Default: `false`. |
| `user-invocable` | No | `false` = hidden from `/` menu, Claude-only. Default: `true`. |
| `allowed-tools` | No | Tools Claude can use without asking when skill is active. |
| `model` | No | Model override for this skill. |
| `effort` | No | Effort level: `low`, `medium`, `high`, `max`. |
| `context` | No | `fork` to run in a subagent context. |
| `agent` | No | Subagent type when `context: fork` (`Explore`, `Plan`, `general-purpose`, or custom). |
| `hooks` | No | Hooks scoped to this skill's lifecycle. |

### 5.4. Bundled Skills

| Skill | Purpose |
|-------|---------|
| `/batch <task>` | Parallel large-scale changes across codebase (worktree-per-unit, PR-per-unit). |
| `/claude-api` | Claude API reference for current project language. |
| `/debug [description]` | Session debug log troubleshooting. |
| `/loop [interval] <prompt>` | Repeated prompt execution on schedule. |
| `/simplify [focus]` | Three-agent parallel code quality review + fixes. |

### 5.5. String Substitutions

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed at invocation |
| `$ARGUMENTS[N]` / `$N` | Specific argument by 0-based index |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Directory containing the skill's SKILL.md |

### 5.6. Dynamic Context Injection

The `` !`command` `` syntax runs shell commands before skill content reaches Claude:

```yaml
---
name: pr-summary
context: fork
agent: Explore
---

PR diff: !`gh pr diff`
PR comments: !`gh pr view --comments`
```

### 5.7. Running Skills in Subagents

Add `context: fork` and optionally `agent: <type>` to run a skill in isolation:

```yaml
---
name: deep-research
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly...
```

---

## 6. Settings and Permissions

### 6.1. Configuration Scopes

| Scope | Location | Priority | Shared |
|-------|----------|----------|--------|
| Managed | `/etc/claude-code/managed-settings.json` (Linux) | Highest | IT-deployed |
| CLI args | `--settings`, `--allowedTools`, etc. | High | Session only |
| Local | `.claude/settings.local.json` | Medium-high | Personal, per-project (gitignored) |
| Project | `.claude/settings.json` | Medium | Team (via VCS) |
| User | `~/.claude/settings.json` | Lowest | Personal, all projects |

Array settings (like `permissions.allow`) merge (concatenate + deduplicate) across scopes rather than override.

### 6.2. Permission System

Permission rules use `allow`, `ask`, and `deny` arrays. Evaluation order: deny first, then ask, then allow. First match wins.

Rule syntax: `Tool` or `Tool(specifier)`.

```json
{
  "permissions": {
    "allow": ["Bash(npm run lint)", "Bash(npm run test *)"],
    "deny": ["Bash(curl *)", "Read(./.env)", "Read(./secrets/**)"]
  }
}
```

### 6.3. Key Settings

| Key | Description |
|-----|-------------|
| `model` | Override default model |
| `agent` | Run main thread as named subagent |
| `effortLevel` | `low`, `medium`, `high` |
| `permissions` | Allow/ask/deny rules |
| `hooks` | Lifecycle hook configuration |
| `sandbox` | Bash sandboxing (filesystem + network isolation) |
| `env` | Environment variables for all sessions |
| `language` | Response language preference |
| `includeGitInstructions` | Include built-in git workflow instructions (default: `true`) |

### 6.4. Sandbox

Optional bash sandboxing isolates commands from the filesystem and network:

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "filesystem": {
      "allowWrite": ["/tmp/build"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"]
    }
  }
}
```

---

## 7. CLI Reference (Key Commands)

### 7.1. Interactive Mode

```bash
claude                     # Start interactive REPL
claude "query"             # Start with initial prompt
claude -c                  # Continue most recent conversation
claude -r "session-id"     # Resume specific session
claude agents              # List configured subagents
claude mcp                 # Configure MCP servers
```

### 7.2. Headless / SDK Mode

```bash
claude -p "prompt"                        # Non-interactive execution
claude -p "prompt" --output-format json   # Structured JSON output
claude -p "prompt" --output-format stream-json  # Streaming JSONL
claude -p "prompt" --max-turns 10 --max-budget-usd 0.50  # Limits
claude -p "prompt" --allowedTools 'Read' 'Bash(npm *)'    # Pre-approved tools
```

### 7.3. Agent and Subagent Flags

```bash
claude --agent code-reviewer        # Run session as named subagent
claude --agents '{ JSON }'          # Ephemeral session-only subagents
claude --model sonnet               # Override model
claude --append-system-prompt "..."  # Inject system prompt
claude --add-dir ../other-repo      # Additional working directories
claude --allowedTools 'Read' 'Bash(git *)'  # Pre-approve tools
claude --disallowedTools 'Agent(Explore)'   # Block specific tools/agents
```

### 7.4. Worktree Mode

```bash
claude --worktree "task description"   # Run in an isolated git worktree
```

Worktree settings:
- `worktree.symlinkDirectories`: directories to symlink (avoid duplicating `node_modules`).
- `worktree.sparsePaths`: sparse checkout paths for large monorepos.

---

## 8. Hooks System

Hooks run custom commands at lifecycle events. Configured in `settings.json` or subagent/skill frontmatter.

### 8.1. Available Events

| Event | Matcher input | When it fires |
|-------|--------------|---------------|
| `PreToolUse` | Tool name | Before a tool is used |
| `PostToolUse` | Tool name | After a tool is used |
| `Stop` | (none) | When agent finishes |
| `SubagentStart` | Agent type name | When a subagent begins |
| `SubagentStop` | Agent type name | When a subagent completes |
| `InstructionsLoaded` | (none) | When instruction files load |
| `TeammateIdle` | (none) | When a teammate is about to go idle |
| `TaskCompleted` | (none) | When a task is marked complete |

### 8.2. Exit Codes

- `0`: success, continue normally.
- `2`: block the operation and feed error message back to Claude.
- Other non-zero: log error, continue.

---

## 9. MCP (Model Context Protocol)

Claude Code supports MCP servers for extending tool capabilities.

### 9.1. Configuration Locations

| Scope | Location |
|-------|----------|
| User | `~/.claude.json` |
| Project | `.mcp.json` (root of project) |
| Subagent-scoped | `mcpServers` field in subagent frontmatter |

### 9.2. Subagent-Scoped MCP

Inline MCP definitions in subagent frontmatter connect only when the subagent runs:

```yaml
---
name: browser-tester
description: Tests features using Playwright
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github
---
```

---

## 10. Plugins

Plugins bundle skills, agents, hooks, and MCP servers into distributable packages. Installed via marketplaces (`/plugin` command).

Plugin subagents do **not** support `hooks`, `mcpServers`, or `permissionMode` for security reasons.

Configured in `settings.json`:

```json
{
  "enabledPlugins": {
    "formatter@acme-tools": true,
    "deployer@acme-tools": true
  }
}
```

---

## 11. Environment Variables

Key variables for automation and configuration:

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | API authentication |
| `ANTHROPIC_MODEL` | Override model |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Disable background subagent execution |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | Disable auto memory |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Enable Agent Teams |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | Load CLAUDE.md from `--add-dir` dirs |
| `CLAUDE_CODE_NEW_INIT` | Enable interactive multi-phase `/init` |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Trigger compaction earlier (e.g., `50`) |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET` | Override skill description character budget |

---

## 12. Comparison: Claude Code vs Other APM Environments

### 12.1. Instruction Layer

| Feature | Claude Code | Codex CLI | OpenCode | Cursor |
|---------|-------------|-----------|----------|--------|
| Main instruction file | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md` | `AGENTS.md` |
| Subdirectory loading | On-demand | Immediate | Immediate | Immediate (folder priority) |
| Modular rules | `.claude/rules/*.md` | Not native | Not native | `.cursor/rules/*.md` |
| Path-scoped rules | Yes (YAML `paths:`) | No | No | Yes (frontmatter globs) |
| File imports | `@path` syntax | No | No | No |

### 12.2. Agent/Subagent Configuration

| Feature | Claude Code | Codex CLI | OpenCode | Cursor |
|---------|-------------|-----------|----------|--------|
| Agent format | `.md` (YAML frontmatter) | `.toml` | `.md` (YAML frontmatter) | `.md` (YAML frontmatter) |
| Agent directory | `.claude/agents/` | `.codex/agents/` | `.opencode/agent/` | `.cursor/agents/` |
| Global agents | `~/.claude/agents/` | `~/.codex/agents/` | `~/.config/opencode/agent/` | `~/.cursor/agents/` |
| Model selection | `model` field | `model` field | `model` field | `model` field |
| Tool restrictions | `tools` / `disallowedTools` | `sandbox_mode` | Not native | Implicit |
| Permission modes | 5 modes | Sandbox-based | Not native | `readonly` flag |
| Persistent memory | `memory` field (3 scopes) | Not native | Not native | Not native |
| Isolation | `isolation: worktree` | Not native | Not native | Not native |
| Max depth | 1 (subagents cannot spawn) | Configurable (`max_depth`) | 1 | Configurable (Agent Trees) |
| Lifecycle hooks | Frontmatter + settings.json | Not native | Not native | Not native |

### 12.3. Multi-Agent Orchestration

| Feature | Claude Code | Codex CLI | OpenCode | Cursor |
|---------|-------------|-----------|----------|--------|
| Subagent spawning | Agent tool (auto or explicit) | `spawn_agent` tool call | Shift+Tab (cycle) / subtask | Task tool (auto or explicit) |
| Parallel execution | Yes (foreground/background) | Yes (`spawn_agent` + `wait`) | Yes (subtask delegation) | Yes (async, Agent Trees) |
| Inter-agent comms | Agent Teams mailbox | `send_input` / `wait` | Not native | Not native |
| Team orchestration | Agent Teams (experimental) | Multi-agent threading | Primary agent switching | Not native |
| Max concurrent | No hard limit (resource-bound) | `max_threads` (default 6) | Configurable | Not specified |

### 12.4. Skills

| Feature | Claude Code | Codex CLI | OpenCode | Cursor |
|---------|-------------|-----------|----------|--------|
| Skill format | `agentskills.io` spec | `agentskills.io` spec | Custom YAML+MD | `agentskills.io` spec |
| Skill directory | `.claude/skills/` | `.codex/skills/` | `.opencode/skills/` | `.cursor/skills/` |
| Auto-invocation | Yes (description-based) | Yes (description-based) | Yes | Yes (description-based) |
| Manual invocation | `/skill-name` | Via prompt | Via prompt | `/skill-name` |
| Subagent execution | `context: fork` | Not native | Not native | Not native |
| Dynamic injection | `` !`cmd` `` syntax | Not native | Not native | Not native |
| Bundled skills | `/batch`, `/simplify`, `/debug`, `/loop` | None | None | `/migrate-to-skills` |

### 12.5. Configuration and Permissions

| Feature | Claude Code | Codex CLI | OpenCode | Cursor |
|---------|-------------|-----------|----------|--------|
| Settings file | `.claude/settings.json` | `.codex/config.toml` | YAML config | `.cursor/rules/` + Settings UI |
| Permission granularity | Tool-level allow/ask/deny | Sandbox modes + approval policy | Not detailed | Basic rules |
| Sandboxing | OS-level (filesystem + network) | Sandbox modes (3 levels) | Not native | Not native |
| Scopes | Managed > CLI > Local > Project > User | CLI > Profile > Project > User > System | Global / Local | Workspace / User |
| Managed policies | IT-deployed, cannot override | Not native | Not native | Not native |

---

## 13. APM Integration Notes

### 13.1. Pack Structure

A Claude Code pack for APM should follow the pattern:

```text
claude_pack/
├── agents/                    # Subagent role definitions (.md)
│   ├── apm-architect.md
│   ├── apm-code-reviewer.md
│   ├── apm-code-simplifier.md
│   ├── apm-data-scientist.md
│   ├── apm-engineer.md
│   ├── apm-memory-bank-sync.md
│   └── apm-sdet.md
└── (no config.toml -- Claude Code uses settings.json)
```

### 13.2. Mapping APM Concepts to Claude Code

| APM Concept | Claude Code Equivalent |
|-------------|----------------------|
| `AGENTS.md` (project rules) | `CLAUDE.md` or `.claude/CLAUDE.md` |
| Nested `AGENTS.md` | Subdirectory `CLAUDE.md` (loaded on-demand) |
| Skills (`SKILL.md`) | `.claude/skills/<name>/SKILL.md` (same spec) |
| Subagent roles (Codex `.toml`) | `.claude/agents/<name>.md` |
| Commands (`/apm-*`) | Skills with `disable-model-invocation: true` |
| `config.toml` multi-agent settings | Not needed (subagents always available, no feature flag) |
| Primary agents (Co-Founder, Team Lead) | `--agent <name>` flag or `agent` setting in `settings.json` |
| Team Lead WAVE orchestration | Agent Teams (experimental) or main session with subagent delegation |
| Worktree isolation | `isolation: worktree` in subagent frontmatter or `--worktree` flag |

### 13.3. Key Differences for APM

1. **No multi-agent feature flag**: subagents are always available in Claude Code. No equivalent of Codex `features.multi_agent = true`.

2. **No explicit `max_threads` / `max_depth`**: Claude Code does not expose these as configuration. Subagent depth is hard-limited to 1 (no sub-subagents). Concurrent subagent count is resource-bound, not configurable.

3. **CLAUDE.md instead of AGENTS.md**: the pack installer must generate `CLAUDE.md` (or `.claude/CLAUDE.md`) instead of root `AGENTS.md`. Content is equivalent; only the filename differs.

4. **Primary agents via `--agent`**: Claude Code allows running the entire session as a custom subagent via `--agent <name>`. This maps to APM's primary agent modes (Co-Founder, Team Lead). Can be persisted in `.claude/settings.json` with `"agent": "apm-team-lead"`.

5. **Skills as commands**: Claude Code merges the concept of commands and skills. APM `/apm-*` commands map to skills with `disable-model-invocation: true` for user-triggered workflows.

6. **Hooks for quality gates**: Claude Code's hook system enables enforcement of quality gates (`PreToolUse`, `PostToolUse`, `SubagentStop`) that APM currently implements via skill instructions.

7. **Agent Teams for WAVE orchestration**: the experimental Agent Teams feature maps directly to APM's Team Lead WAVE pattern (lead + parallel teammates + shared task list). However, since it is experimental and requires Opus 4.6, the primary orchestration model should remain subagent-based delegation from the main session.

8. **Permissions granularity**: Claude Code offers finer-grained tool permissions than other environments. APM subagent roles can leverage `tools` / `disallowedTools` for explicit capability boundaries (e.g., read-only reviewer, write-capable engineer).

9. **Persistent subagent memory**: Claude Code's `memory` field enables subagents to accumulate knowledge across sessions. This complements APM's Memory Bank for roles that benefit from cross-session continuity (e.g., Code Reviewer learning project patterns).

### 13.4. Installer Considerations

The Claude Code installer should:

1. Copy subagent `.md` files to `.claude/agents/` (project-level) or `~/.claude/agents/` (global).
2. Copy shared skills to `.claude/skills/` or `~/.claude/skills/`.
3. Generate `CLAUDE.md` (or `.claude/CLAUDE.md`) from the methodology template, adapted from `AGENTS.md` format.
4. Optionally create `.claude/settings.json` with permission rules and hooks.
5. Support both `--global` and `--local` install targets, mirroring Codex/OpenCode installers.

### 13.5. CLAUDE.md vs AGENTS.md Portability

Since Claude Code does not yet read `AGENTS.md`, the APM methodology template must be output as `CLAUDE.md`. The content is compatible (both are plain Markdown). The installer can:
- Generate both `AGENTS.md` and `CLAUDE.md` from the same source, or
- Generate `CLAUDE.md` only for Claude Code packs, or
- Symlink `CLAUDE.md` -> `AGENTS.md` if cross-tool compatibility is desired once AGENTS.md support lands.

---

## 14. Reference Links

- [Claude Code documentation](https://code.claude.com/docs/en/)
- [CLAUDE.md and memory](https://code.claude.com/docs/en/memory)
- [Custom subagents](https://docs.anthropic.com/en/docs/claude-code/subagents)
- [Agent Teams](https://code.claude.com/docs/en/agent-teams)
- [Skills](https://code.claude.com/docs/en/skills)
- [Settings](https://docs.anthropic.com/en/docs/claude-code/settings)
- [CLI reference](https://docs.anthropic.com/en/docs/claude-code/cli-usage)
- [Hooks](https://code.claude.com/docs/en/hooks)
- [Permissions](https://code.claude.com/docs/en/permissions)
- [Agent Skills spec](https://agentskills.io/specification)
