# Configuring and Interacting with Agents in Cursor: The Complete Guide

## Overview

As of **Cursor 2.5 (February 2026)**, the IDE provides a robust, multi-layered ecosystem for extending and customizing AI agents. The architecture relies on four key mechanisms: **AGENTS.md** for static project instructions, **Skills (SKILL.md)** for dynamic capabilities, **Subagents** for parallel and asynchronous execution of subtasks, and the new **Plugins** system for bundling these features. All these mechanisms complement each other and work in tandem with project rules (`.cursor/rules/`).

***

## 1. AGENTS.md — Global & Project Instructions

### What is AGENTS.md?

AGENTS.md is a plain Markdown file (no YAML frontmatter, no glob patterns) that Cursor automatically reads when opening a project. It establishes the foundational context and behavioral rules for the agent: tech stack, architectural decisions, build commands, and coding style.

### Location and Hierarchy

AGENTS.md supports a three-tier hierarchy with cascading priorities:

| Level | Location | Priority | Purpose |
|-------|----------|----------|---------|
| Global | `~/.codex/agents.md` (or `~/.cursor/`) | Lowest | Personal coding preferences applied across all projects. |
| Project | `AGENTS.md` in repository root | Medium | Tech stack, architecture, and conventions for the specific project. |
| Folder | `AGENTS.md` in a subdirectory (e.g., `src/components/`) | Highest | Specific rules for certain components/modules. |

In case of conflicting rules, the file with the highest priority wins: Folder → Project → Global.

### Format and Content

The file is pure Markdown. A typical structure looks like this:

```markdown
# Project: My App

## Tech Stack
- Framework: Next.js 15
- Language: TypeScript
- Database: PostgreSQL + Prisma

## Build Commands
- `npm run dev`: start dev server
- `npm run build`: build for production
- `npm run test`: run test suite

## Code Conventions
- Use ES modules (import/export)
- Destructure imports
- Components should follow `components/Button.tsx` as the canonical example

## Architecture
- API routes belong in `app/api/`
- Always run a typecheck after a series of modifications
```

### Tips

Cursor also supports project rules in `.cursor/rules/` (`.md` or `.mdc` files with frontmatter), which have four application modes (Always Apply, Apply Intelligently, Apply to Specific Files, Apply Manually). AGENTS.md is a simpler, cross-compatible alternative (supported by agentsmd.io standards, Claude Code, etc.) for those who want a single file without extra configuration. Both approaches can be combined.

***

## 2. Agent Skills (SKILL.md) — Dynamic Capabilities

### What are Agent Skills?

Agent Skills is an open standard (`agentskills.io`) adopted by Cursor and Claude Code to extend the agent with domain knowledge and specific workflows. Unlike static rules (which are always active), skills are loaded **dynamically** only when the agent deems them relevant to the current conversation.

### File Locations

| Directory | Scope |
|-----------|-------|
| `.cursor/skills/<skill-name>/` | Project |
| `.claude/skills/<skill-name>/` | Project (Claude Code compatibility) |
| `~/.cursor/skills/<skill-name>/` | Global (User) |
| `~/.claude/skills/<skill-name>/` | Global (Claude Code compatibility) |

> **Warning:** Do not create skills in `~/.cursor/skills-cursor/` — this directory is reserved for Cursor's built-in skills (like `create-skill`, `create-rule`, etc.).

### Skill Directory Structure

```text
my-skill/
├── SKILL.md          # Required file — entry point
├── scripts/          # Optional — executable scripts
│   ├── deploy.sh
│   └── validate.py
├── references/       # Optional — supplementary documentation
│   └── REFERENCE.md
└── assets/           # Optional — templates, configs
    └── config-template.json
```

The directory name **must exactly match** the `name` field in the frontmatter.

### SKILL.md Format

The file consists of two parts: a YAML frontmatter block and a Markdown body.

#### Required Frontmatter Fields

| Field | Constraints | Purpose |
|-------|-------------|---------|
| `name` | 1–64 chars; lowercase alphanumeric and hyphens; must match folder name | Unique identifier for the skill. |
| `description` | 1–1024 chars; no angle brackets | Description of what the skill does and when to use it. |

#### Optional Frontmatter Fields

| Field | Purpose |
|-------|---------|
| `license` | License of the skill. |
| `disable-model-invocation` | If `true`, the skill can only be invoked manually via `/skill-name`. |
| `allowed-tools` | List of allowed tools (experimental). |
| `compatibility` | Environment requirements. |
| `metadata` | Arbitrary key-value data. |

#### Example SKILL.md

```markdown
---
name: deploy-staging
description: Handles deployment to the staging environment. Use when the user asks to deploy, release, or push to staging.
---

# Deploy to Staging

## When to Use
- User requests deployment to staging
- After a successful test run before production

## Instructions

1. Verify all tests pass: `npm run test`
2. Build the project: `npm run build`
3. Run the deploy script: `scripts/deploy.sh staging`
4. Validate deployment: `scripts/validate.py --env staging`

## Edge Cases
- If deploy fails, check `references/REFERENCE.md` for common issues
```

### Progressive Disclosure

Skills use a three-tier loading system to conserve the context window:

| Level | What is loaded | When |
|-------|----------------|------|
| **Level 1: Metadata** | YAML frontmatter (~100 tokens) | Always on startup — the agent sees the list of available skills. |
| **Level 2: Instructions** | SKILL.md body (<5000 tokens recommended) | When the skill is activated. |
| **Level 3: Resources** | `references/`, `scripts/`, `assets/` | Only when explicitly requested/read by the agent from SKILL.md. |

*Note: As of Cursor 2.5, you can also define **Sandbox network access controls** to isolate the network domains your skills and scripts are allowed to reach.*

### Invocation Methods

1. **Automatic** — Cursor shows the agent a list of skills and their descriptions. The agent decides when a skill is relevant based on the conversation context.
2. **Manual** — Type `/` in the Agent Mode chat and select the desired skill (e.g., `/deploy-staging`).

To view detected skills: **Cursor Settings** (Ctrl+Shift+J) → **Rules** → **Agent Decides** section.

### Migrating Rules to Skills

Cursor includes a `/migrate-to-skills` flow that converts dynamic rules ("Apply Intelligently") into standard skills, and slash commands into skills with `disable-model-invocation: true`.

***

## 3. Subagents — Asynchronous Task Delegation

### What are Subagents?

Subagents are specialized, independent agents spawned by the parent agent to handle discrete subtasks. **As of Cursor 2.5**, subagents are **fully asynchronous**. They run in the background, meaning the parent agent is no longer blocked and can continue chatting and writing code while the subagent works in parallel. They maintain their own isolated context, prompts, tools, and models.

### New in Cursor 2.5: Agent Trees

Subagents can now **spawn their own subagents** (Sub-subagents). This creates an "Agent Tree," allowing for highly coordinated, hierarchical task execution—perfect for massive codebase refactoring or complex research tasks.

### Built-in Subagents

Cursor includes default subagents for:
- Codebase research (`explore`)
- Executing terminal commands (`terminal`)
- Parallel workflows

### Creating Custom Subagents

Custom subagents are defined as Markdown files in the `.cursor/agents/` directory (or globally in `~/.cursor/agents/`).

#### Subagent File Format

A subagent file is a Markdown file with YAML frontmatter:

```markdown
---
name: code-reviewer
description: Expert code review specialist. Reviews code for quality, security, and maintainability.
model: inherit
---

# Code Reviewer

You are a specialized code review agent.

## Responsibilities
- Review code for bugs, security issues, and style violations
- Suggest improvements with concrete examples
- Follow the project's coding standards

## Output Format
- List issues by severity (critical, warning, info)
- Include file path and line number
- Provide fix suggestions
```

#### Subagent Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Subagent identifier (must match the filename). |
| `description` | Yes | Specialization description and trigger conditions. |
| `model` | No | LLM model; use `inherit` to inherit the parent agent's model. |
| `readonly` | No | If `true`, the subagent can only read, not edit files. |

*(Note: The `is_background` flag from version 2.4 is now largely superseded by 2.5's native asynchronous behavior).*

### Invoking Subagents

Subagents can be invoked in several ways:
1. **Automatically** — The parent agent delegates tasks via the Task tool when it determines a subagent is suited for a subtask.
2. **Via Prompt** — E.g., *"Use the task tool to invoke the code-reviewer subagent."*
3. **Via Slash Command** — `/agent-name` in the chat.

### Known Limitations & Fixes (Update 2.5)

- **Latency & Streaming:** Cursor 2.5 significantly improved streaming feedback and reduced latency when subagents return data to the parent agent.
- **Model Inheritance Bug:** Occasionally, the `model: inherit` setting might still default to a fallback model (like `composer-1`) instead of the exact parent model.
- **Task Tool Recognition:** Sometimes the Task tool struggles to recognize custom agents from `.cursor/agents/`, requiring explicit prompting.

***

## 4. Cursor Marketplace & Plugins (New in 2.5)

Introduced in February 2026, **Cursor Plugins** (available via `cursor.com/marketplace` or the `/add-plugin` command) allow developers to bundle various extension mechanisms into a single package. 

Instead of manually setting up Rules, Skills, Subagents, and MCP (Model Context Protocol) servers, you can install a single Plugin that provisions all of them simultaneously for a specific framework or workflow (e.g., a complete "Next.js + Supabase Expert" plugin).

***

## Comparative Table: Rules vs. Skills vs. Subagents vs. Plugins

| Aspect | Rules (`.cursor/rules/`) | Skills (`SKILL.md`) | Subagents (`.cursor/agents/`) | Plugins (Marketplace) |
|--------|--------------------------|---------------------|-------------------------------|-----------------------|
| **Purpose** | Static project instructions | Dynamic workflows & capabilities | Parallel/Async subtask execution | Bundling of all tools |
| **When Applied** | Always / Intelligently / By Glob / Manually | When agent decides it's relevant, or manually | When delegated by parent or spawned in an Agent Tree | Installs capabilities globally or per-project |
| **Format** | Markdown + Frontmatter | YAML Frontmatter + Markdown | YAML Frontmatter + Markdown | Distributed Package |
| **Context** | Shared with main agent | Loaded on demand (Progressive) | Isolated background context | Varies by bundled tools |
| **Portability**| Project-specific | Open standard (Cursor & Claude) | Standardized format | Cursor ecosystem |

***

## Practical Recommendations: When to Use What

1. **AGENTS.md** is best when you need a single, simple context file accessible to multiple tools (Cursor, Claude Code, GitHub Copilot). It's the minimal-friction option.
2. **Rules (`.cursor/rules/`)** are best for strict project standards that must *always* apply or target specific file types (via globs). Think of rules as "Laws".
3. **Skills (`SKILL.md`)** are optimal for reusable workflows, procedural instructions, and domain expertise that the agent only needs occasionally. Think of skills as "Expertise".
4. **Subagents** are essential for complex, multi-step tasks. Use them when you need parallel execution, deep codebase research without cluttering the main chat, or when breaking down massive refactoring plans into asynchronous background threads.
5. **Plugins** are your go-to when you want to share a complete AI configuration with your team or community, bundling skills, agents, and rules together.