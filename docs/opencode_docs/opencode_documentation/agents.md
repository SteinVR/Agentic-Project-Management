# Agents

Configure and use specialized agents.

Source: https://opencode.ai/docs/agents/

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.

**Tip:** Use the plan agent to analyze code and review suggestions without making any code changes.

You can switch between agents during a session or invoke them with the `@` mention.

## Types

There are two types of agents in OpenCode: primary agents and subagents.

### Primary agents

Primary agents are the main assistants you interact with directly. You can cycle through them using the **Tab** key, or your configured `switch_agent` keybind. These agents handle your main conversation. Tool access is configured via permissions — for example, Build has all tools enabled while Plan is restricted.

**Tip:** You can use the **Tab** key to switch between primary agents during a session.

OpenCode comes with two built-in primary agents, **Build** and **Plan**. We'll look at these below.

### Subagents

Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by **@ mentioning** them in your messages.

OpenCode comes with two built-in subagents, **General** and **Explore**. We'll look at this below.

## Built-in

OpenCode comes with two built-in primary agents and two built-in subagents.

### Build

*Mode:* `primary`

Build is the **default** primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.

### Plan

*Mode:* `primary`

A restricted agent designed for planning and analysis. We use a permission system to give you more control and prevent unintended changes.

By default, all of the following are set to `ask`:

- `file edits`: All writes, patches, and edits
- `bash`: All bash commands

This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.

### General

*Mode:* `subagent`

A general-purpose agent for researching complex questions and executing multi-step tasks. Has full tool access (except todo), so it can make file changes when needed. Use this to run multiple units of work in parallel.

### Explore

*Mode:* `subagent`

A fast, read-only agent for exploring codebases. Cannot modify files. Use this when you need to quickly find files by patterns, search code for keywords, or answer questions about the codebase.

## Usage

1. For primary agents, use the **Tab** key to cycle through them during a session. You can also use your configured `switch_agent` keybind.
2. Subagents can be invoked:
   - **Automatically** by primary agents for specialized tasks based on their descriptions.
   - Manually by **@ mentioning** a subagent in your message. For example: `@general help me search for this function`
   - **Navigation between sessions**: When subagents create their own child sessions, you can navigate between the parent session and all child sessions using:
     - **Leader+Right** (or your configured `session_child_cycle` keybind) to cycle forward through parent -> child1 -> child2 -> ... -> parent
     - **Leader+Left** (or your configured `session_child_cycle_reverse` keybind) to cycle backward through parent <- child1 <- child2 <- ... <- parent

This allows you to seamlessly switch between the main conversation and specialized subagent work.

## Configure

You can customize the built-in agents or create your own through configuration. Agents can be configured in two ways:

### JSON

Configure agents in your `opencode.json` config file:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "{file:./prompts/build.txt}",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "plan": {
      "mode": "primary",
      "model": "anthropic/claude-haiku-4-20250514",
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "tools": {
        "write": false,
        "edit": false
      }
    }
  }
}
```

### Markdown

You can also define agents using markdown files. Place them in:

- Global: `~/.config/opencode/agents/`
- Per-project: `.opencode/agents/`

Example `~/.config/opencode/agents/review.md`:

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
---
You are in code review mode. Focus on:
- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations
Provide constructive feedback without making direct changes.
```

The markdown file name becomes the agent name. For example, `review.md` creates a `review` agent.

## Options

### Description

Use the `description` option to provide a brief description of what the agent does and when to use it. This is a **required** config option.

### Temperature

Control the randomness and creativity of the LLM's responses with the `temperature` config. Lower values make responses more focused and deterministic, while higher values increase creativity and variability.

Temperature values typically range from 0.0 to 1.0:

- **0.0-0.2**: Very focused and deterministic responses, ideal for code analysis and planning
- **0.3-0.5**: Balanced responses with some creativity, good for general development tasks
- **0.6-1.0**: More creative and varied responses, useful for brainstorming and exploration

If no temperature is specified, OpenCode uses model-specific defaults; typically 0 for most models, 0.55 for Qwen models.

### Max steps

Control the maximum number of agentic iterations an agent can perform before being forced to respond with text only. This allows users who wish to control costs to set a limit on agentic actions.

If this is not set, the agent will continue to iterate until the model chooses to stop or the user interrupts the session.

When the limit is reached, the agent receives a special system prompt instructing it to respond with a summarization of its work and recommended remaining tasks.

### Disable

Set to `true` to disable the agent.

### Prompt

Specify a custom system prompt file for this agent with the `prompt` config. The prompt file should contain instructions specific to the agent's purpose. This path is relative to where the config file is located.

### Model

Use the `model` config to override the model for this agent. Useful for using different models optimized for different tasks.

**Tip:** If you don't specify a model, primary agents use the model globally configured while subagents will use the model of the primary agent that invoked the subagent.

The model ID in your OpenCode config uses the format `provider/model-id`.

### Tools

Control which tools are available in this agent with the `tools` config. You can enable or disable specific tools by setting them to `true` or `false`.

**Note:** The agent-specific config overrides the global config.

You can also use wildcards to control multiple tools at once (e.g. `mymcp_*`: false).

### Permissions

You can configure permissions to manage what actions an agent can take. Currently, the permissions for the `edit`, `bash`, and `webfetch` tools can be configured to:

- `"ask"` — Prompt for approval before running the tool
- `"allow"` — Allow all operations without approval
- `"deny"` — Disable the tool

You can override these permissions per agent. You can also set permissions for specific bash commands using glob patterns. Since the last matching rule takes precedence, put the `*` wildcard first and specific rules after.

### Mode

Control the agent's mode with the `mode` config. The `mode` option can be set to `primary`, `subagent`, or `all`. If no `mode` is specified, it defaults to `all`.

### Hidden

Hide a subagent from the `@` autocomplete menu with `hidden: true`. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool. Only applies to `mode: subagent` agents.

### Task permissions

Control which subagents an agent can invoke via the Task tool with `permission.task`. Uses glob patterns for flexible matching. When set to `deny`, the subagent is removed from the Task tool description entirely.

**Tip:** Rules are evaluated in order, and the **last matching rule wins**. Users can always invoke any subagent directly via the `@` autocomplete menu, even if the agent's task permissions would deny it.

### Additional

Any other options you specify in your agent configuration will be **passed through directly** to the provider as model options. This allows you to use provider-specific features and parameters (e.g. `reasoningEffort`, `textVerbosity` for OpenAI).

**Tip:** Run `opencode models` to see a list of the available models.

## Create agents

You can create new agents using the following command:

```bash
opencode agent create
```

This interactive command will:

1. Ask where to save the agent; global or project-specific.
2. Description of what the agent should do.
3. Generate an appropriate system prompt and identifier.
4. Let you select which tools the agent can access.
5. Finally, create a markdown file with the agent configuration.

## Use cases

- **Build agent**: Full development work with all tools enabled
- **Plan agent**: Analysis and planning without making changes
- **Review agent**: Code review with read-only access plus documentation tools
- **Debug agent**: Focused on investigation with bash and read tools enabled
- **Docs agent**: Documentation writing with file operations but no system commands

## Examples

### Documentation agent

`~/.config/opencode/agents/docs-writer.md`:

```markdown
---
description: Writes and maintains project documentation
mode: subagent
tools:
  bash: false
---
You are a technical writer. Create clear, comprehensive documentation.
Focus on:
- Clear explanations
- Proper structure
- Code examples
- User-friendly language
```

### Security auditor

`~/.config/opencode/agents/security-auditor.md`:

```markdown
---
description: Performs security audits and identifies vulnerabilities
mode: subagent
tools:
  write: false
  edit: false
---
You are a security expert. Focus on identifying potential security issues.
Look for:
- Input validation vulnerabilities
- Authentication and authorization flaws
- Data exposure risks
- Dependency vulnerabilities
- Configuration security issues
```
