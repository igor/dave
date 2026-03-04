# JSONL Event Schema

Reference for `.dave/questions.jsonl` format. Append-only event log.

## ID Format

Question IDs: `q-` + 4-char hex (e.g., `q-1a2b`). Generated when a question is opened.

## Common Fields (all events)

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Event type |
| `ts` | string | ISO 8601 timestamp |
| `session` | string (optional) | Session identifier for grouping |

## Event Types

### `question_opened`

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | `q-` + 4-char hex |
| `text` | string | The question as framed |
| `context` | string | Where/why this question arose |

### `evidence_added`

| Field | Type | Description |
|-------|------|-------------|
| `question` | string | Question ID |
| `source` | string | Where the evidence came from (file path, kt node, URL, "conversation") |
| `summary` | string | What the evidence says (1-2 sentences) |

### `tension_noted`

| Field | Type | Description |
|-------|------|-------------|
| `between` | array[string] | Question IDs or position descriptions |
| `description` | string | What the tension is |

### `position_taken`

| Field | Type | Description |
|-------|------|-------------|
| `question` | string | Question ID |
| `position` | string | The preliminary stance |

### `question_reframed`

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Question ID |
| `old_text` | string | Previous framing |
| `new_text` | string | New framing |
| `reason` | string | Why the question changed shape |

### `question_crystallized`

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Question ID |
| `position` | string | The resolved position |

### `question_dissolved`

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Question ID |
| `reason` | string | Why it's no longer a question |

### `facilitator_move`

| Field | Type | Description |
|-------|------|-------------|
| `question` | string | Question ID |
| `move` | string | Move name from METHODS.md vocabulary |
| `context` | string | What triggered the move and what it targeted |

## Writing Events

**Create directory (first run only):**
```bash
mkdir -p .dave
```

**Append events using Bash** (never use the Write tool — it overwrites):
```bash
echo '{"type":"question_opened","id":"q-1a2b","text":"...","context":"...","ts":"2026-03-04T19:00:00Z"}' >> .dave/questions.jsonl
```

One JSON object per line. Never edit or delete existing lines.

## State Reconstruction

Current state is computed by replaying all events in order:

- **Open questions:** `question_opened` where id has no subsequent `question_crystallized` or `question_dissolved`
- **Evidence per question:** count of `evidence_added` events and their sources
- **Active tensions:** `tension_noted` events between open questions/positions
- **Positions:** most recent `position_taken` per question
- **Last activity:** most recent event timestamp per question
- **Facilitator moves:** sequence of moves per question (for future coaching diary analysis)

## Example Event Sequence

```jsonl
{"type":"question_opened","id":"q-1a2b","text":"What's EPA's actual differentiator vs tool providers?","context":"ep-advisory work","ts":"2026-03-01T21:00:00Z"}
{"type":"facilitator_move","question":"q-1a2b","move":"perspective_multiplication","context":"Asked who the buyer actually is and what they're comparing against","ts":"2026-03-01T21:02:00Z"}
{"type":"evidence_added","question":"q-1a2b","source":"file:ep/foundations/canon/intellectual-origins.md","summary":"Articulation gap is the product, not the tool","ts":"2026-03-01T21:05:00Z"}
{"type":"tension_noted","between":["q-1a2b","q-3c4d"],"description":"Positioning claims advisory but architecture looks like a tool","ts":"2026-03-01T21:10:00Z"}
{"type":"facilitator_move","question":"q-1a2b","move":"steelman","context":"User dismissing tool comparison; steelmanned the case that EPA IS a tool","ts":"2026-03-01T21:12:00Z"}
{"type":"position_taken","question":"q-1a2b","position":"EPA sells the process of knowing what to encode, not the encoding itself","ts":"2026-03-01T21:20:00Z"}
{"type":"question_crystallized","id":"q-1a2b","position":"EPA sells the process of knowing what to encode, not the encoding itself","ts":"2026-03-15T14:00:00Z"}
```
