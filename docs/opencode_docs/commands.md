# Commands

Create custom commands for repetitive tasks.

Source: https://opencode.ai/docs/commands/

Custom commands let you specify a prompt you want to run when that command is executed in the TUI:

```
/my-command
```

Custom commands are in addition to the built-in commands like `/init`, `/undo`, `/redo`, `/share`, `/help`. [Learn more](https://opencode.ai/docs/tui#commands).

## Create command files

Create markdown files in the `commands/` directory to define custom commands.

Example `.opencode/commands/test.md`:

```markdown
---
description: Run tests with coverage
agent: build
model: anthropic/claude-3-5-sonnet-20241022
---
Run the full test suite with coverage report and show any failures.
Focus on the failing tests and suggest fixes.
```

The frontmatter defines command properties. The content becomes the template. Use the command by typing `/` followed by the command name: `/test`.

## Configure

You can add custom commands through the OpenCode config or by creating markdown files in the `commands/` directory.

### JSON

Use the `command` option in your OpenCode [config](https://opencode.ai/docs/config):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "command": {
    "test": {
      "template": "Run the full test suite with coverage report and show any failures.\\nFocus on the failing tests and suggest fixes.",
      "description": "Run tests with coverage",
      "agent": "build",
      "model": "anthropic/claude-3-5-sonnet-20241022"
    }
  }
}
```

Now you can run this command in the TUI: `/test`.

### Markdown

You can also define commands using markdown files. Place them in:

- Global: `~/.config/opencode/commands/`
- Per-project: `.opencode/commands/`

The markdown file name becomes the command name. For example, `test.md` lets you run `/test`.

## Prompt config

The prompts for the custom commands support several special placeholders and syntax.

### Arguments

Pass arguments to commands using the `$ARGUMENTS` placeholder.

Example `.opencode/commands/component.md`:

```markdown
---
description: Create a new component
---
Create a new React component named $ARGUMENTS with TypeScript support.
Include proper typing and basic structure.
```

Run the command with arguments: `/component Button` — and `$ARGUMENTS` will be replaced with `Button`.

You can also access individual arguments using positional parameters:

- `$1` — First argument
- `$2` — Second argument
- `$3` — Third argument
- And so on...

Example `.opencode/commands/create-file.md`:

```markdown
---
description: Create a new file with content
---
Create a file named $1 in the directory $2
with the following content: $3
```

Run: `/create-file config.json src "{ \"key\": \"value\" }"` — replaces `$1` with `config.json`, `$2` with `src`, `$3` with `{ "key": "value" }`.

### Shell output

Use the form `!`\`your-command\`` to inject [bash command](https://opencode.ai/docs/tui#bash-commands) output into your prompt.

Example — analyze test coverage:

```markdown
---
description: Analyze test coverage
---
Here are the current test results:
!`npm test`
Based on these results, suggest improvements to increase coverage.
```

Example — review recent changes:

```markdown
---
description: Review recent changes
---
Recent git commits:
!`git log --oneline -10`
Review these changes and suggest any improvements.
```

Commands run in your project's root directory and their output becomes part of the prompt.

### File references

Include files in your command using `@` followed by the filename.

Example `.opencode/commands/review-component.md`:

```markdown
---
description: Review component
---
Review the component in @src/components/Button.tsx.
Check for performance issues and suggest improvements.
```

The file content gets included in the prompt automatically.

## Options

### Template

The `template` option defines the prompt that will be sent to the LLM when the command is executed. This is a **required** config option.

### Description

Use the `description` option to provide a brief description of what the command does. This is shown as the description in the TUI when you type in the command.

### Agent

Use the `agent` config to optionally specify which [agent](https://opencode.ai/docs/agents) should execute this command. If this is a [subagent](https://opencode.ai/docs/agents/#subagents) the command will trigger a subagent invocation by default. To disable this behavior, set `subtask` to `false`. This is an **optional** config option. If not specified, defaults to your current agent.

### Subtask

Use the `subtask` boolean to force the command to trigger a [subagent](https://opencode.ai/docs/agents/#subagents) invocation. This is useful if you want the command to not pollute your primary context and will **force** the agent to act as a subagent, even if `mode` is set to `primary` on the [agent](https://opencode.ai/docs/agents) configuration. This is an **optional** config option.

### Model

Use the `model` config to override the default model for this command. This is an **optional** config option.

## Built-in

OpenCode includes several built-in commands like `/init`, `/undo`, `/redo`, `/share`, `/help`; [learn more](https://opencode.ai/docs/tui#commands).

**Note:** Custom commands can override built-in commands. If you define a custom command with the same name, it will override the built-in command.
