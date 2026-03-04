# Deliberation Graph (dave) — Design Document

**Date:** 2026-03-01
**Status:** Draft
**Context:** Emerged from analysis of workgraph (graphwork.github.io) and its relationship to known-unknown knowledge work. Workgraph orchestrates execution of known knowns. dave orchestrates deliberation of known unknowns.

## Problem

Strategic practitioners hold open questions across projects and contexts for weeks or months. These questions accumulate evidence, develop tensions with other positions, and eventually crystallize into resolved positions — or dissolve entirely. No tool manages this lifecycle.

Existing tools cover adjacent spaces but miss the active orchestration:
- **IBIS/Compendium** — best primitives (Issue/Idea/Argument) but manual graph construction, no active surfacing
- **InfraNodus** — structural gap detection in text-to-graph networks, but designed for text analysis not long-running question portfolios
- **PAKT** — perspectivized argument graphs, but built for analyzing existing debates not managing evolving understanding
- **kt** — captures knowledge and manages lifecycle (active → stale → compacted), but treats all nodes identically. Questions have a fundamentally different lifecycle than facts.
- **superpowers:brainstorming** — single-session design tool. Assumes you know what you're designing. Doesn't persist across sessions, detect tensions across contexts, or help articulate what you don't yet know.

## Core Concept

A deliberation system analogous to workgraph but with different primitives:

| Workgraph (known knowns) | dave (known unknowns) |
|---|---|
| **Task** — do X, get result | **Question** — hold X, accumulate understanding |
| **Dependency** — A before B | **Tension** — A and B pull opposite directions |
| **Dispatch** — assign agent, execute | **Perspective** — bring a lens, see what emerges |
| **Completion** — output produced, downstream unblocked | **Crystallization** — enough accumulates that a position resolves |
| **Evolution** — mutate roles based on performance | **Reframing** — the question itself changes shape |

## Architecture

### Stack

```
Material layer:  whatever's there (folder of docs, kt namespace, codebase, URLs)
Question layer:  .dave/questions.jsonl — portable, directory-local
Process layer:   Claude Code skills + Explorer subagent
```

No dedicated CLI tool. No database. A Claude Code skill (`/dave`) with a companion Explorer subagent, plus a session-start hook for active surfacing.

### Decision: Why skills, not a CLI tool

Three approaches were evaluated across technical, UX, and maintenance dimensions:

**A: Graph-First (workgraph analog)** — Full CLI with JSONL graph. Most structurally complete but heaviest to build and maintain. Forces explicit question declaration, which fights how questions actually emerge.

**B: Pure Skills + state file** — Lightest. Skills handle all intelligence, thin JSONL file persists state. Closest to how people actually work (invoke in any directory, no context-switching). Fastest to iterate on since skills are markdown files. Chosen approach.

**C: Thin graph + skill agents** — Clean separation of concerns but creates gravitational pull toward explicit question management (`dave add`, `dave list`). The real work happens in conversation with facilitator agents, making the CLI an unused middleman.

**Why B wins:** The decisive factor is question emergence. Questions in the known-unknown space are often not yet articulated — the Facilitator helps you articulate them. A tool that requires "type your question" as the entry point fights the fundamental nature of the work. Skills allow questions to emerge from conversation and get captured, like `/kapture` does for knowledge.

## Components

### 1. Facilitator Skill (`/dave`)

The main skill. Guides the practitioner through deliberation. Stays in the main conversation context.

**Invocation:** `/dave` in any directory.

**Flow:**
1. Reads `.dave/questions.jsonl` (or creates `.dave/` directory)
2. If open questions exist: asks whether to revisit one or open new
3. If new: guides framing — "What are you trying to figure out? What makes this hard?"
4. Dispatches Explorer subagent(s) to load relevant material
5. Works through deliberation — no rigid phase gates, but natural flow between framing, evidence-weighing, tension-checking, crystallizing
6. Writes events to questions.jsonl

**Interaction style adapts to question lifecycle:**
- Early (just opened): open-ended framing, exploratory
- Middle (evidence accumulating): tension-spotting, cross-referencing, pointed questions
- Late (potentially ripe): direct — "is this resolved? do you have enough to commit?"

**Future: agent role decomposition.** The single Facilitator may decompose into specialized roles (Framer, Tension Spotter, Weigher, Closer, Reframer) based on usage patterns. Wait for signal from practice before splitting.

### 2. Explorer Subagent

Dispatched by the Facilitator to go deep into material without filling the main context window. Uses the Agent tool with subagent_type `Explore` or `general-purpose`.

**When dispatched:**
- Session start — "go understand what's in this directory"
- Specific reference — "find everything related to Protocol OS positioning"
- Tension investigation — "check the user's position on X across namespaces"
- Multiple Explorers can run in parallel

**What it explores (material-agnostic):**
- Files in the current directory (markdown, PDFs, code, whatever's there)
- kt namespaces (if available — detected via `command -v kt && kt stats --format json`)
- Chroma/RAG collections (if MCP tools available)
- URLs (when provided by user)

**What it returns:** Compressed brief, not raw content. Organized by theme, noting tensions and gaps. Example:

```
Found 14 relevant files across 3 themes:
- EPA positioning (5 files): Current claim is "infrastructure for orgs
  that don't know what they want." Supported by McChrystal, pi.dev
  comparison. Tension: sales deck leads with Palantir comparison
  despite decision to reduce it.
- Protocol OS architecture (6 files): L0-L4 stack, two readings.
  No contradiction detected.
- Competitive signals (3 files): workgraph, pi.dev, Palantir. All
  positioned as downstream/adjacent, not direct competitors.
```

**Detection logic:**
```
kt available?     → command -v kt && kt stats --format json
Chroma available? → MCP tool list for chroma
Current directory → always: Glob + Read patterns
URLs              → only when user provides them
```

### 3. State File (`.dave/questions.jsonl`)

Append-only, one event per line. Git-friendly, human-readable.

**Event types:**

| Event | Fields | Meaning |
|---|---|---|
| `question_opened` | id, text, context | New question framed |
| `evidence_added` | question, source, summary | Signal or material linked to question |
| `tension_noted` | between (question IDs), description | Contradiction or pull between positions |
| `position_taken` | question, position | Preliminary stance (not yet crystallized) |
| `question_reframed` | id, old_text, new_text, reason | The question itself changed shape |
| `question_crystallized` | id, position | Resolved — enough evidence, commitment made |
| `question_dissolved` | id, reason | No longer a question — dissolved by reframing or irrelevance |

**Example:**

```jsonl
{"type":"question_opened","id":"q-1a2b","text":"What's EPA's actual differentiator vs tool providers?","context":"ep-advisory work","ts":"2026-03-01T21:00:00Z"}
{"type":"evidence_added","question":"q-1a2b","source":"file:ep/foundations/canon/intellectual-origins.md","summary":"Articulation gap is the product, not the tool","ts":"2026-03-01T21:05:00Z"}
{"type":"tension_noted","between":["q-1a2b","q-3c4d"],"description":"Positioning claims advisory but architecture looks like a tool","ts":"2026-03-01T21:10:00Z"}
{"type":"question_crystallized","id":"q-1a2b","position":"EPA sells the process of knowing what to encode, not the encoding itself","ts":"2026-03-15T14:00:00Z"}
```

The Facilitator reconstructs current state by replaying events. No separate "current state" file — the event log IS the state.

### 4. Session-Start Hook

Lightweight check at session start. Scans for `.dave/` in working directory (or walks up directory tree).

If found, reads JSONL and computes:
- Open questions count
- Questions with recent evidence accumulation
- Stale questions (no activity in configurable number of days)

Injects a short nudge, not a full briefing:

```
DELIBERATION: 3 open questions in this directory.
"EPA differentiator" has 2 new evidence items since last session.
```

Does not auto-invoke `/dave` — just surfaces state. The practitioner decides whether to engage.

## Open Questions / Future Iterations

### Methodological framework for Explorers
The Explorer currently returns "what's there." It should eventually apply analytical lenses — how to assess what's *important*, not just what's *present*. What heuristics guide a good research assistant vs a keyword searcher? This needs its own design work.

### Agent role decomposition
The single Facilitator may need to split into specialized roles. Candidate roles from the original analysis:
- **Framer** — structured articulation of what the question actually is
- **Tension Spotter** — provocative, surfaces contradictions across contexts
- **Weigher** — assesses evidence sufficiency
- **Closer** — detects crystallization readiness, prompts commitment
- **Reframer** — offers alternative framings when a question is stuck

Wait for usage patterns before splitting. The interaction styles are described; whether they need separate agents or work as modes of one agent is an empirical question.

### Cross-directory deliberation
Questions that span multiple projects. A question opened in the EP vault that has evidence in the OIO project folder. Current design is directory-local. Cross-directory linking would require either a global index or a convention for referencing other `.dave/` stores.

### kt integration depth
Should crystallized positions auto-capture as kt nodes? Should kt nodes auto-surface as evidence for open questions? The boundary between knowledge storage (kt) and question management (dave) needs to stay clean, but the handoff points matter.

### Tension detection automation
Can the session-start hook or Explorer detect tensions automatically — not just count questions? This would require comparing positions across questions, which is a semantic operation. Might use embeddings if the question set is large enough to warrant it.

### Evidence quality assessment
Not all evidence is equal. A primary source vs a second-hand summary vs a hunch. Should the state file track evidence quality? Should the Facilitator weigh evidence differently based on source type?

## Relationship to Existing Systems

```
Rumsfeld Matrix        Tool
─────────────────────  ──────────────────────
Unknown unknowns   →   Signals library, foresight work
Known unknowns     →   dave (this tool) + kt
Known knowns       →   workgraph, task management
```

dave sits between signals work (surfacing what isn't yet a question) and execution tools (doing what you've decided). It's the infrastructure for the phase where you know there's something to figure out but haven't resolved it yet.

EP connection: dave applied to the individual practitioner is EPA's value proposition applied reflexively — "infrastructure for organizations that need help knowing what they want" becomes "infrastructure for practitioners who need help knowing what they think."
