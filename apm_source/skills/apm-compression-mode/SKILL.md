---
name: apm-compression-mode
description: >
  Communication compression skill. Use it when the user explicitly wants.
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

## Preserve exactly

Do not alter code blocks, inline code, commands, file paths, URLs, markdown links, quoted error text, proper nouns, technical terms, versions, dates, or numeric values.

## Clarity override

Use normal explicit wording for safety warnings, irreversible actions, multi-step sequences where fragments could scramble order, or moments where the user is confused and needs clarity first.

## Boundaries

Do not invent abbreviations that are not already obvious from context. Do not compress user-facing copy. Commits, PR text, and formal deliverables stay in their normal project style unless explicitly requested otherwise.
