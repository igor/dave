# Reasoning Trace: How the Principles Emerged

**Date:** 2026-03-04
**Purpose:** Document the thinking process, not just the conclusions. This is a deliberation about deliberation — and practicing what we preach means making the reasoning visible.

## Starting Point: The Design Document

The design doc (2026-03-01) established the architectural skeleton: skills over CLI, JSONL state, Explorer subagent, session-start hook. The decisive move was choosing skills because "questions emerge from conversation, not from being typed in." This was already a philosophical commitment disguised as a technical decision.

What the design doc didn't yet have: a methodological backbone for the Facilitator. It described *what* the Facilitator does (guides framing → evidence → tension → crystallization) but not *how it thinks* — what moves it makes, how it calibrates, what it watches for.

## The Research Changed the Frame

Four Perplexity research threads were conducted. Reading them as a corpus rather than individually revealed something the individual threads didn't state:

### Thread 1: "Would it be fair to say agentic work is focused on known knowns?"

This established the **positioning**: dg sits in the known-unknowns quadrant. Most agentic tools optimize execution speed for well-defined tasks. dg doesn't make deliberation faster — it makes it possible when capacity is constrained. This reframed the value proposition from "better deliberation tool" to "infrastructure for a cognitive mode that has no tooling."

### Thread 2: "How can agentic work guide process when the outcome isn't clear?"

This was the pivotal thread. Five independent intellectual lines converged:

- **Linus Lee** gave the vocabulary: instrumental vs. engaged. This named what the design doc was already doing but hadn't articulated. The Facilitator is an engaged interface.
- **CCS** gave the mechanism: track the human's evolving world model, surface discrepancies. This operationalized how the Facilitator should use tension_noted events — not as a record, but as an active detection system.
- **Riva** gave the calibration principle: the comfort-growth paradox. This added a dimension the design doc missed entirely — the Facilitator should adapt not just to question lifecycle but to the human's current cognitive state.
- **Ought/Elicit** gave the evaluation philosophy: supervise process, not outcomes. This validated the JSONL event log as more than storage — it's a process supervision mechanism.
- **GESIS/Nokia** gave empirical validation: agents expand search space, humans own sensemaking. This confirmed the Explorer/Facilitator split as architecturally sound.

### Thread 3: "Anyone built Claude Code skills around this?"

This mapped the existing landscape and revealed the gap: no skill combines persistent state + methodological backbone + capacity awareness + engaged interface philosophy. Each existing skill has one or two of these. dg needs all of them.

### Thread 4: "Coaching diary — analysis methods for agent interactions"

This introduced the meta-layer: the event log could eventually support analysis of which Facilitator moves actually work. CA, ENA, process mining — established methods that haven't been applied to agent-human deliberation. This is a future capability but it shaped a design decision now: if we want to analyze moves later, we need to log them as first-class events.

## The Synthesis Moment: "The Human Is the Cognitive Agent"

This phrase emerged from the collision of three ideas:

1. **Lee's engaged interface test**: If the user would press "skip," you've built the wrong thing. Therefore the human's cognitive engagement is not a cost — it's the product.

2. **CCS's epistemic agency concept**: Current agents are trained to resolve uncertainty. Deliberation requires *holding* uncertainty. The agent should scaffold, not replace.

3. **The design doc's skill-over-CLI decision**: Questions emerge from conversation. The architecture already presumes human cognitive engagement at every step — it just hadn't named this commitment.

The phrase "the human is the cognitive agent" is not a feature requirement. It's a philosophical position that generates design constraints. Every feature can be tested against it: does this let the user disengage from thinking? If yes, it violates the principle.

This is also what distinguishes dg from every existing skill in the landscape. The Critical Thinking Partner challenges your thinking (reactive). The Futurist Analyst does foresight for you (instrumental). The Facilitator holds the methodological container while you do the thinking (engaged). The distinction is in who holds cognitive agency.

## What the Research Added to the Design

| Design Doc Had | Research Added |
|----------------|---------------|
| Lifecycle-stage adaptation (early/middle/late) | Capacity-aware calibration (comfort-growth paradox) |
| Tension as event type | Tension as active detection mechanism (CCS discrepancy surfacing) |
| JSONL as state persistence | JSONL as process supervision (Ought) and future analysis substrate (CA/ENA) |
| Explorer returns compressed briefs | Explorer expands search space; Facilitator holds sensemaking (GESIS validation) |
| "No rigid phase gates" | Named principle: engaged interface, never offer to skip |
| Implicit: human thinks, agent holds structure | Explicit: "the human is the cognitive agent" |

## Open Tensions in the Thinking

Documenting these honestly because they're unresolved:

**Automation boundary for tension detection.** The design doc asks: can the session-start hook detect tensions automatically? The CCS paper suggests agents *should* surface discrepancies. But the "human as cognitive agent" principle suggests the human should notice tensions. Resolution might be: the agent *surfaces* (makes visible), the human *interprets* (makes meaning). But where exactly that line falls is an empirical question.

**Domain-specific methods.** The current methodology (steelmanning, competing hypotheses, assumption surfacing) is domain-agnostic epistemology. Should foresight-specific methods (Three Horizons, scenario planning, causal layered analysis) be part of the Facilitator? Or should they be loadable modules? The purist answer is: the Facilitator holds epistemic process, domain methods are the practitioner's job. The pragmatic answer is: sometimes you need the agent to say "have you considered running a pre-mortem on this position?" The tension is between methodological purity and practical utility.

**Capacity detection.** Riva's framework describes what cognitive scaffolding should do. It does not describe how a text-based agent detects cognitive depletion in practice. What are the actual signals? Shorter responses? Repetitive language? Convergence without evidence? This needs empirical work.

**The coaching diary as evaluation loop.** The CA/ENA research suggests we could analyze which Facilitator moves correlate with productive shifts. But this requires a definition of "productive shift" that doesn't reduce to "reached a conclusion" — because dissolution is also a valid outcome. What's the quality metric for a process that doesn't optimize for any particular output?
