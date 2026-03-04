# Explorer Subagent Dispatch

Guidance for dispatching Explorer subagents during deliberation sessions.

## When to Dispatch

- **Session start survey** — scan available material in cwd for relevance to open questions
- **Specific thread** — "find everything related to [topic]" in a particular source
- **Tension investigation** — "check for contradictions on [X] across sources"
- **Parallel dispatch** — multiple Explorers for different angles simultaneously

## Source Detection

Before dispatching, detect what sources are available:

```
kt available?     → command -v kt && kt stats --format json
Current directory  → always available: Glob + Read patterns
URLs               → only when user provides them in conversation
```

When kt is available, use `kt search --query "{topic}" --limit 5` in the Explorer prompt for actual searching.

Build the `detected_sources_with_commands` block from what's present. Only include sources that actually exist.

## Prompt Template

Inject full context into the Explorer prompt. The Explorer receives exactly what it needs and nothing more.

```
You are an Explorer investigating material for a deliberation session.

QUESTION: {question_text}
INVESTIGATION: {what_to_look_for}

Available sources:
{detected_sources_with_commands}

RETURN FORMAT:
Return a compressed brief (not raw content). Organize by theme.
For each theme:
- What you found (specific, with sources)
- Any tensions or contradictions within the material
- Any gaps — what you'd expect to find but didn't

Keep it under 500 words. The Facilitator needs themes and tensions,
not exhaustive detail.
```

### Placeholder Reference

| Placeholder | Source |
|-------------|--------|
| `{question_text}` | The current question text (from `question_opened` or most recent `question_reframed`) |
| `{what_to_look_for}` | Specific investigation angle the Facilitator determines |
| `{detected_sources_with_commands}` | Built from source detection above — kt commands, Glob patterns, URLs |

## Context Isolation Rules

- Each Explorer gets exactly: the question, the investigation angle, the available source commands
- Explorers **never** read the JSONL state, SKILL.md, or METHODS.md
- Return format is compressed brief only — no raw content dumps
- Explorer subagent type: use `subagent_type: "Explore"` or `subagent_type: "general-purpose"` depending on scope
- This protects the main conversation's context window from material overload

## Dispatch Pattern

```
Use the Agent tool:
  subagent_type: "general-purpose" (for kt + file searches)
  or "Explore" (for codebase-only searches)
  prompt: [filled template above]
  description: "Explore [topic] for [question]"
```
