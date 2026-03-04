# `/dave` Skill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the `/dave` Claude Code skill — a Facilitator for structured deliberation on open questions, with Explorer subagent, JSONL state, and session-start hook.

**Architecture:** Layered progressive disclosure. 4 markdown files in `~/.claude/skills/dave/` (SKILL.md, METHODS.md, EXPLORER.md, STATE.md) plus a shell script hook at `~/.claude/hooks/deliberation-context.sh`. The skill is pure markdown instruction — no runtime code except the jq-based hook script.

**Tech Stack:** Markdown (Claude Code skills), Bash/jq (session-start hook), JSONL (state format)

---

### Task 1: Create STATE.md (JSONL Event Schema)

**Why first:** Every other component references the event schema. Define it once, reference everywhere.

**Files:**
- Create: `~/.claude/skills/dave/STATE.md`

**Step 1: Create the skill directory**

```bash
mkdir -p ~/.claude/skills/dave
```

**Step 2: Write STATE.md**

Write `~/.claude/skills/dave/STATE.md` with the complete JSONL event schema from the design doc (Component 4). Include:

- Common fields section (type, ts, session)
- All 8 event type tables: question_opened, evidence_added, tension_noted, position_taken, question_reframed, question_crystallized, question_dissolved, facilitator_move
- ID format specification: `q-` + 4-char hex
- State reconstruction rules (how to compute current state from event replay)
- The full example event sequence from the design doc

Reference: Design doc lines 269-356.

Target: ~100 lines. No YAML frontmatter (this is a reference file, not a skill).

**Step 3: Verify**

Read the file back. Confirm all 8 event types are present with correct fields.

**Step 4: Commit**

```bash
cd ~/Github/dg && git add ~/.claude/skills/dave/STATE.md
git commit -m "feat(skill): add STATE.md — JSONL event schema for deliberation"
```

---

### Task 2: Create EXPLORER.md (Subagent Dispatch Guidance)

**Why second:** Self-contained component referenced by SKILL.md but not dependent on other skill files.

**Files:**
- Create: `~/.claude/skills/dave/EXPLORER.md`

**Step 1: Write EXPLORER.md**

Write `~/.claude/skills/dave/EXPLORER.md` with the subagent dispatch guidance from the design doc (Component 3). Include:

- When to dispatch (session start survey, specific thread, tension investigation, parallel dispatch)
- Source detection logic (kt check via `command -v kt`, cwd always, URLs from user)
- The full prompt template with `{question_text}`, `{what_to_look_for}`, `{detected_sources_with_commands}` placeholders
- Context isolation rules: Explorers never read JSONL, SKILL.md, or METHODS.md. Return compressed briefs only, under 500 words.

Reference: Design doc lines 217-267.

Target: ~80 lines. No YAML frontmatter.

**Step 2: Verify**

Read the file back. Confirm the prompt template has all three placeholders and the return format specification.

**Step 3: Commit**

```bash
cd ~/Github/dg && git add ~/.claude/skills/dave/EXPLORER.md
git commit -m "feat(skill): add EXPLORER.md — subagent dispatch guidance"
```

---

### Task 3: Create METHODS.md (Epistemic Moves + Calibration)

**Why third:** The methodological backbone. Must be complete before SKILL.md can reference it.

**Files:**
- Create: `~/.claude/skills/dave/METHODS.md`

**Step 1: Write METHODS.md**

Write `~/.claude/skills/dave/METHODS.md` with the full epistemic moves palette and calibration system from the design doc (Component 2). Include all four sections:

**Section 1 — Epistemic Moves** organized by direction:
- Expansion moves (4): steelmanning, perspective multiplication, absence probe, competing hypotheses
- Compression moves (4): assumption surfacing, tension naming, evidence quality check, commitment test
- Reframing moves (4): inversion, scope shift, time shift, dissolve test
- Each move has a name and an example prompt phrase in quotes

**Section 2 — Implicit Behavioral Shifts** by lifecycle stage:
- Early stage: emphasis on expansion, exploratory tone, dispatch Explorers
- Middle stage: emphasis on compression, provocative, cross-reference evidence
- Late stage: emphasis on commitment/dissolve tests, direct, name regression

**Section 3 — Calibration Signals:**
- Depletion signals (5 bullet points) with response guidance
- Engagement signals (5 bullet points) with response guidance
- Mixed signals handling
- The principle stated once: "calibrate friction to cognitive capacity"

**Section 4 — Anti-Patterns** (5):
- Premature closure, infinite regression, confirmation bias, question drift, comfort-seeking
- Each with observable signal description

Reference: Design doc lines 136-215.

Target: ~200 lines. No YAML frontmatter. The tone is instructional but not prescriptive — these are moves to draw from, not rules to execute.

**Step 2: Verify**

Read the file back. Confirm:
- All 12 epistemic moves present (4 expansion + 4 compression + 4 reframing)
- All 3 lifecycle stages described
- Both signal sets (depletion + engagement) have 5 items each
- All 5 anti-patterns named with signals

**Step 3: Commit**

```bash
cd ~/Github/dg && git add ~/.claude/skills/dave/METHODS.md
git commit -m "feat(skill): add METHODS.md — epistemic moves palette and calibration"
```

---

### Task 4: Create SKILL.md (Facilitator Core)

**Why fourth:** The main skill file. References all three other files. Must be written last so references are accurate.

**Files:**
- Create: `~/.claude/skills/dave/SKILL.md`

**Step 1: Write SKILL.md**

Write `~/.claude/skills/dave/SKILL.md` — the Facilitator core. This is the only file with YAML frontmatter.

**Header (exact):**
```yaml
---
name: dave
description: >
  Facilitate deliberation on open questions across sessions.
  Use when holding known unknowns, working through strategic questions,
  weighing evidence across contexts, or needing structured thinking
  on unresolved problems. Not for tasks with clear answers.
user-invocable: true
---
```

**Body must include in this order:**

1. **Title and one-line overview** — "Guide structured deliberation on open questions. The human does the thinking; the Facilitator holds the process."

2. **Process flow** — The numbered sequence (steps 1-9 from design doc lines 99-108). Include "Load STATE.md", "Load METHODS.md", "Load EXPLORER.md" at the appropriate points so Claude knows when to read each file.

3. **Iron Law** — Exact text from design doc line 112. Use blockquote formatting.

4. **Rationalization Table** — All 7 rows from design doc lines 116-124. Markdown table.

5. **Rules** — All 7 bullet points from design doc lines 128-134.

6. **File loading guide** — Explicit section telling Claude:
   - "For event schema, read STATE.md in this directory"
   - "For epistemic moves and calibration, read METHODS.md in this directory"
   - "For Explorer dispatch, read EXPLORER.md in this directory"

Reference: Design doc lines 46-134.

Target: ~150-200 lines. Every line matters — this is always loaded on invocation.

**Step 2: Verify the skill is discoverable**

Check that the YAML frontmatter parses correctly:
```bash
head -10 ~/.claude/skills/dave/SKILL.md
```

Confirm: name is `dave`, description starts with "Facilitate deliberation", `user-invocable: true` is present.

**Step 3: Verify file references**

Read SKILL.md and confirm it references STATE.md, METHODS.md, and EXPLORER.md by name with clear "when to load" guidance.

**Step 4: Commit**

```bash
cd ~/Github/dg && git add ~/.claude/skills/dave/SKILL.md
git commit -m "feat(skill): add SKILL.md — Facilitator core with iron law and process flow"
```

---

### Task 5: Create deliberation-context.sh (Session-Start Hook)

**Why fifth:** Independent of the skill files. Uses jq to parse JSONL deterministically.

**Files:**
- Create: `~/.claude/hooks/deliberation-context.sh`

**Step 1: Write the hook script**

Write `~/.claude/hooks/deliberation-context.sh`. The script must:

1. Read hook input from stdin (same pattern as `kt-context.sh` line 7):
   ```bash
   INPUT=$(cat)
   CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)
   ```

2. Walk up directory tree from `$CWD` looking for `.deliberation/questions.jsonl`:
   ```bash
   DIR="$CWD"
   while [ "$DIR" != "/" ]; do
     if [ -f "$DIR/.deliberation/questions.jsonl" ]; then
       JSONL="$DIR/.deliberation/questions.jsonl"
       break
     fi
     DIR=$(dirname "$DIR")
   done
   ```

3. If not found, exit 0 silently (no output).

4. If found, use `jq` to compute stats. The logic:
   - Parse each line as a JSON object
   - Track open questions: `question_opened` where id has no subsequent `question_crystallized` or `question_dissolved`
   - For each open question, count events in the last 7 days
   - Flag stale questions (no events in 14+ days)
   - Extract question text from the `question_opened` event (or most recent `question_reframed` text)

5. Output the nudge in plain text format:
   ```
   DELIBERATION: N open questions in this directory.
   "Question text" has M new evidence items since last session.
   "Other question" is stale (N days, no activity).
   ```

6. Exit 0.

**Important:** The script must handle edge cases:
- Empty JSONL file (newly created)
- Malformed lines (skip with jq error handling)
- No open questions (output nothing)
- `jq` not installed (exit silently — `command -v jq` check)

Make the script executable:
```bash
chmod +x ~/.claude/hooks/deliberation-context.sh
```

**Step 2: Test with empty state**

```bash
mkdir -p /tmp/test-dg/.deliberation
touch /tmp/test-dg/.deliberation/questions.jsonl
echo '{"cwd":"/tmp/test-dg"}' | ~/.claude/hooks/deliberation-context.sh
```

Expected: No output (no open questions).

**Step 3: Test with sample data**

```bash
cat > /tmp/test-dg/.deliberation/questions.jsonl << 'JSONL'
{"type":"question_opened","id":"q-1a2b","text":"What is EPA's differentiator?","context":"ep-advisory","ts":"2026-03-01T21:00:00Z"}
{"type":"evidence_added","question":"q-1a2b","source":"conversation","summary":"Articulation gap is the product","ts":"2026-03-04T10:00:00Z"}
{"type":"question_opened","id":"q-3c4d","text":"Protocol OS architecture scope","context":"ep-advisory","ts":"2026-02-10T10:00:00Z"}
JSONL
echo '{"cwd":"/tmp/test-dg"}' | ~/.claude/hooks/deliberation-context.sh
```

Expected output should show 2 open questions, q-1a2b with recent activity, q-3c4d as stale.

**Step 4: Clean up test fixtures**

```bash
rm -rf /tmp/test-dg
```

**Step 5: Commit**

```bash
cd ~/Github/dg && git add ~/.claude/hooks/deliberation-context.sh
git commit -m "feat(hook): add deliberation-context.sh — session-start JSONL stats"
```

---

### Task 6: Register Hook in settings.json

**Why sixth:** Must happen after the hook script exists and is tested.

**Files:**
- Modify: `~/.claude/settings.json` (the hooks.SessionStart array)

**Step 1: Read current settings.json**

Read `~/.claude/settings.json` and confirm the current SessionStart hooks array structure.

**Step 2: Add the new hook**

Add a third hook entry to the existing SessionStart hooks array, after the kt-context.sh entry:

```json
{
  "type": "command",
  "command": "/Users/zeigor/.claude/hooks/deliberation-context.sh",
  "timeout": 10
}
```

The full hooks section should become:
```json
"hooks": {
  "SessionStart": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "/Users/zeigor/.claude/hooks/session-start.sh",
          "timeout": 10
        },
        {
          "type": "command",
          "command": "/Users/zeigor/.claude/hooks/kt-context.sh",
          "timeout": 15
        },
        {
          "type": "command",
          "command": "/Users/zeigor/.claude/hooks/deliberation-context.sh",
          "timeout": 10
        }
      ]
    }
  ]
}
```

**Step 3: Verify JSON validity**

```bash
python3 -c "import json; json.load(open('/Users/zeigor/.claude/settings.json'))" && echo "Valid JSON"
```

Expected: "Valid JSON"

**Step 4: Commit**

```bash
cd ~/Github/dg && git add ~/.claude/settings.json
git commit -m "feat(config): register deliberation-context.sh in session-start hooks"
```

---

### Task 7: Smoke Test — Full Invocation

**Why last:** End-to-end verification that all components work together.

**Step 1: Create a test deliberation directory**

```bash
mkdir -p /tmp/test-dave/.deliberation
touch /tmp/test-dave/.deliberation/questions.jsonl
```

**Step 2: Test session-start hook**

```bash
echo '{"cwd":"/tmp/test-dave"}' | ~/.claude/hooks/deliberation-context.sh
```

Expected: No output (empty state).

**Step 3: Test skill discovery**

In a Claude Code session, verify the skill appears:
- The description should mention "known unknowns," "strategic questions," "deliberation"
- Invoking `/dave` should load SKILL.md

**Step 4: Test first-run experience**

In `/tmp/test-dave`, invoke `/dave`. Expected behavior:
- Facilitator sees empty `.deliberation/questions.jsonl`
- Asks to open a new question
- Guides framing
- Writes `question_opened` event to JSONL
- Loads METHODS.md for the deliberation session

**Step 5: Verify JSONL output**

```bash
cat /tmp/test-dave/.deliberation/questions.jsonl | jq .
```

Expected: At least one `question_opened` event with valid id, text, context, and ts fields.

**Step 6: Test hook with populated state**

```bash
echo '{"cwd":"/tmp/test-dave"}' | ~/.claude/hooks/deliberation-context.sh
```

Expected: Shows "1 open question" with the question text.

**Step 7: Clean up**

```bash
rm -rf /tmp/test-dave
```

**Step 8: Final commit**

If any adjustments were needed during smoke testing, commit them:
```bash
cd ~/Github/dg && git add -A && git commit -m "fix: adjustments from smoke testing"
```

---

## Task Dependency Graph

```
Task 1 (STATE.md) ──┐
Task 2 (EXPLORER.md)─┼── Task 4 (SKILL.md) ── Task 7 (Smoke Test)
Task 3 (METHODS.md) ─┘         │
                               │
Task 5 (Hook script) ── Task 6 (Register hook) ── Task 7 (Smoke Test)
```

Tasks 1-3 can be done in parallel. Task 4 depends on 1-3. Task 6 depends on 5. Task 7 depends on 4 and 6.

## Notes for Implementer

- **This is a skill, not code.** The "implementation" is writing precise markdown that instructs Claude how to behave. The only actual code is the shell script (Task 5).
- **Every word in SKILL.md matters.** It's always loaded, so token efficiency is critical. Don't pad with explanations — be direct and structural.
- **METHODS.md is a palette, not a rulebook.** The moves are examples to draw from, not a checklist to execute. Write them as a reference, not as instructions.
- **The design doc is the spec.** All content for the skill files comes from `/Users/zeigor/Github/dg/docs/plans/2026-03-04-dave-skill-design.md`. Don't invent beyond what's specified.
- **The philosophy docs inform tone, not content.** Read `docs/philosophy/core-principles.md` for the stance, but don't embed the philosophy into the skill files. The principles should be felt, not stated.
