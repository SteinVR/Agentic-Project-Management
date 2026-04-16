---
name: apm-compression-mode
description: >
  Communication compression skill. Use it when the user explicitly wants the reply compressed:
  fewer tokens, less verbal padding, and tighter phrasing without loss of technical accuracy,
  decisions, risks, or next steps.
---

## Description
This skill compresses the agent's wording, not the substance.

Use short direct phrasing. Remove social padding and verbal redundancy. Keep technical meaning, constraints, dates, versions, numbers, decisions, and next steps intact.

## Rules

Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging. Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for"). Technical terms exact. Code blocks unchanged. Errors quoted exact.

Pattern: `[thing] [action] [reason]. [next step].`

Not: "Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."
Yes: "Bug in auth middleware. Token expiry check use `<` not `<=`. Fix:"

Examples:
Question: "Why React component re-render?"
Answer: "New object ref each render. Inline object prop = new ref = re-render. Wrap in `useMemo`."

Question: "Explain database connection pooling."
Answer: "Pool reuse open DB connections. No new connection per request. Skip handshake overhead."

## Core contract
- Preserve full technical accuracy and intent
- Preserve important nuance when dropping it would mislead
- Prefer short direct phrasing over polished prose
- Fragments are acceptable when order and meaning stay clear
- If compression would create ambiguity, switch to plain explicit wording for that part

## Compression rules
- Drop articles when meaning stays clear
- Remove filler, pleasantries, rhetorical glue, and hedging
- Use short direct verbs such as `use`, `fix`, `keep`, `drop`, `move`
- Remove phrases like `you should`, `make sure to`, `it might be worth`
- Merge duplicated points that say the same thing
- Keep one strong example instead of several equivalent examples
- Prefer concrete statements over explanatory buildup

## Preserve exactly
- Code blocks and code formatting
- Inline code
- Commands
- File paths
- URLs and markdown links
- Error messages when quoting them verbatim
- Proper nouns, technical terms, versions, dates, and numeric values

## Auto-clarity
Use normal explicit wording for:
- safety warnings
- irreversible or destructive actions
- multi-step sequences where compressed phrasing could scramble order
- moments where the user is confused or asks for clarification

## Pattern
Preferred shape:
`[state/problem] [cause or decision]. [next action].`

Example:
- Normal: `Your component re-renders because it creates a new object on every render. Wrap that object in useMemo.`
- Compressed: `New object each render creates new ref. Re-render follows. Wrap in \`useMemo\`.`

## Boundaries
- Do not invent abbreviations that are not already obvious from context
- Do not compress user-facing copy unless the user asks for it
- Commits, PR text, and formal deliverables stay in their normal project style unless explicitly requested otherwise
- This skill has one behavior only; it has no alternate levels or variants
