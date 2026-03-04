# Core Principles

**Date:** 2026-03-04
**Status:** Living document
**Context:** Distilled from the design document and supporting research. These principles are design constraints — every feature decision should be tested against them.

## 1. The Human Is the Cognitive Agent

The Facilitator is not an answer engine. The human does the thinking; the agent holds the structure.

This is not a limitation or a phase-one compromise. It is the philosophical position. Deliberation — the process of holding uncertainty, weighing evidence, surfacing tensions, and arriving at a position — is the work itself. An agent that resolves uncertainty on the user's behalf has destroyed the value it was meant to create.

**Boundary test:** If a proposed feature would let the user disengage from the thinking, it violates this principle.

**Intellectual lineage:**
- Linus Lee's distinction between instrumental and engaged interfaces: "If the user could press a magic button and have their task completed instantly, would they want that?" For deliberation, the answer is no — the process IS the product.
- The Collaborative Causal Sensemaking (CCS) framework's concept of "epistemic agency": agents should scaffold the human's reasoning, not replace it. Current agents are trained to resolve uncertainty; deliberation requires holding it.
- The design document's decision to use skills over a CLI: questions emerge from conversation, not from being typed in. The architecture presumes human cognitive engagement at every step.

## 2. Process Over Output

The Facilitator embodies methodology, not knowledge. Its value is in knowing *how* to deliberate, not *what* to conclude.

This means:
- The Facilitator guides through epistemic moves (steelmanning, assumption surfacing, competing hypotheses) without steering toward a particular answer
- The event log captures the reasoning trajectory, not just the outcome
- A question that dissolves is as valid an outcome as one that crystallizes
- The quality of deliberation is measured by the process (depth of evidence considered, tensions surfaced, assumptions tested) not by whether a position was reached

**Contrast with existing tools:** Most AI strategy/thinking tools operate in one of two modes — "do the analysis for you" (instrumental) or "challenge whatever you say" (reactive). The Facilitator does neither. It holds a methodological container and calibrates its moves to where the human is in the process.

## 3. Calibrated Friction

Too little friction produces cognitive atrophy. Too much produces disengagement. The Facilitator must calibrate.

Giuseppe Riva's "comfort-growth paradox" applied: AI that's frictionless doesn't support growth — it induces complacency. The Facilitator deliberately introduces productive friction through epistemic moves (inversions, competing hypotheses, evidence quality challenges) while monitoring whether that friction is generative or overwhelming.

**Three calibration axes:**
- **Lifecycle stage** — Early questions get open exploration. Late questions get direct "is this resolved?" pressure.
- **Cognitive capacity** — Detecting signals of depletion (narrowing responses, repetition, disengagement) and adjusting intensity. Not every session needs maximum challenge.
- **Evidence saturation** — When evidence keeps confirming without adding, the Facilitator pushes toward commitment. When evidence is thin, it pushes toward expansion.

## 4. Material Agnosticism

The Facilitator works with whatever's there. It does not require a specific knowledge infrastructure.

The Explorer subagent adapts to available material: files in the current directory, kt namespaces, RAG collections, URLs. The deliberation process is the same regardless of what feeds it. A question can be deliberated with three markdown files or with a thousand indexed documents.

This prevents the tool from becoming coupled to any specific knowledge management system and ensures it remains useful across contexts.

## 5. Emergence Over Declaration

Questions are not "created." They emerge from conversation and get recognized.

The design document's decisive insight: a tool that requires "type your question" as the entry point fights the fundamental nature of known-unknown work. Questions in this space are often not yet articulated — the practitioner knows something needs figuring out but can't yet name it precisely.

The Facilitator helps articulate what's unresolved. The act of framing a question is itself a deliberative move, not an administrative one.

## 6. Persistent Trajectory

Deliberation happens across sessions, not within them. The state file is the continuity mechanism.

The append-only JSONL event log serves three purposes:
- **Continuity** — The Facilitator reconstructs where a question is by replaying events, so deliberation can resume after days or weeks
- **Trajectory** — The sequence of events tells a story: how the question evolved, what evidence accumulated, where tensions appeared, when positions shifted
- **Reflexivity** — The log enables the practitioner (or a future analysis layer) to examine their own reasoning process — which moves produced shifts, where they got stuck, what patterns recur

## Relationship Between Principles

These principles form a coherent system:

- **Human as cognitive agent** (1) requires **process over output** (2) — if the human thinks, the agent must hold process
- **Calibrated friction** (3) operationalizes (1) — the right amount of friction keeps the human engaged without overwhelming
- **Material agnosticism** (4) ensures the process works regardless of infrastructure
- **Emergence** (5) respects the nature of known-unknown work — you can't declare what you don't yet know
- **Persistent trajectory** (6) makes the process visible and resumable across time
