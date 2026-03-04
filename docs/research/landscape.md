# Research Landscape

**Date:** 2026-03-04
**Status:** Living document — add new references as research continues
**Purpose:** Intellectual context for dave's design decisions. Organized by cluster, not chronologically.

## Cluster 1: The Known-Unknowns Gap

The positioning argument. Current agentic tools optimize known-known execution. dave occupies the known-unknowns space.

### Key Findings

Anthropic's 2026 Agentic Coding Trends Report confirms engineers delegate "easily verifiable, well-defined, or repetitive" tasks while retaining "high-level design decisions and anything requiring organizational context or taste." Teams with high AI adoption merged 98% more PRs but review times increased 91% — the bottleneck moved from execution to judgment.

The U2F framework (2025) attempts to push agents into unknown-unknowns territory but remains experimental. Production systems don't operate there reliably.

### Implication for dave

dave is not a productivity tool. It does not make deliberation faster. It makes deliberation *possible* when human capacity is constrained — holding the structure so the practitioner can focus cognitive resources on the thinking itself.

### References

- Anthropic. "2026 Agentic Coding Trends Report." resources.anthropic.com
- Osmani, Addy. "The 80% Problem in Agentic Coding." addyo.substack.com
- U2F framework. arxiv.org/pdf/2511.03517.pdf

## Cluster 2: Interaction Design Philosophy

The deepest cluster. Five intellectual threads that inform how the Facilitator should behave.

### Linus Lee: Instrumental vs. Engaged Interfaces

Distinction between interfaces where you want the result (instrumental) and interfaces where the process IS the value (engaged). Musical instruments, board games, strategic exercises are engaged. Most current AI work is stuck in instrumental mode. Lee warns that "agents feel very sexy right now" and problems better solved through engaged interfaces get shoehorned into automation.

**dave application:** The Facilitator is an engaged interface. It must never offer to shortcut the deliberation process. The "skip button" test applies to every feature.

**References:**
- Lee, Linus. Talk and writing on engaged interfaces. antoinebuteau.com/lessons-from-linus-lee/
- Dialectic interview. jacksondahl.com/dialectic/linus-lee

### Collaborative Causal Sensemaking (CCS)

January 2026 paper proposing agents that track the human's evolving world model and surface discrepancies. Core argument: current agents are "answer engines, not partners in collaborative sensemaking." CCS agents initiate sensemaking loops: detect discrepancy → jointly hypothesize → test → revise shared model → act. Trained for collaborative friction (disagreement, clarification, reframing), not output quality.

**dave application:** The tension_noted event type is a lightweight implementation of discrepancy detection. The Facilitator should surface contradictions between the practitioner's current position and earlier evidence — not to correct, but to prompt deliberation.

**References:**
- "Collaborative Causal Sensemaking." arxiv.org/pdf/2512.07801v4.pdf

### Giuseppe Riva: Cognitive Scaffolding and the Comfort-Growth Paradox

AI that's too frictionless induces cognitive complacency. "Enhanced Cognitive Scaffolding" framework based on Vygotskian learning theory proposes three dimensions: Progressive Autonomy (support fades as competence increases), Adaptive Personalization (tailored to trajectories), Cognitive Load Optimization (balance effort to maximize growth without overwhelming).

**dave application:** The Facilitator calibrates friction — not just by lifecycle stage but by detected cognitive capacity. Depletion signals (narrowing responses, repetition, disengagement) should reduce intensity. High engagement signals should increase challenge.

**References:**
- Riva, Giuseppe. "Enhanced Cognitive Scaffolding." arxiv.org/abs/2507.19483

### Ought/Elicit: Process Supervision

Built on the principle of "supervising reasoning processes, not outcomes." For open-ended work, outcomes are unknowable — you can't evaluate a 10-year forecast by its result. System decomposes reasoning into independently meaningful cognitive steps and lets the human compose them.

**dave application:** The JSONL event log is process supervision. It captures the reasoning trajectory, making it inspectable and resumable. The quality measure is the process, not the conclusion.

**References:**
- Ought theory of change. forum.effectivealtruism.org/posts/raFAKyw7ofSo9mRQ3/
- Elicit plan. ought.org/updates/2022-04-08-elicit-plan

### GESIS/Nokia Bell Labs: Agent-Supported Foresight

2026 study testing agent-assisted Futures Wheel method. Agents generated 86-110 consequences (condensed to 27-47 unique risks) vs. fewer from humans. But humans contributed what agents couldn't: contextual grounding, emotional salience, lived experience. Proposed hybrid: agents expand the search space, humans own sensemaking.

**dave application:** Direct validation of the Explorer/Facilitator split. Explorer expands the search space (material-agnostic, high-volume). Facilitator holds the sensemaking container. Human owns the judgment.

**References:**
- GESIS/Nokia Bell Labs Futures Wheel study. arxiv.org/html/2602.08565v1

## Cluster 3: Analysis Methodology

Methods for evaluating how the Facilitator's interventions work. Future implementation — the coaching diary idea.

### Conversation Analysis (CA)

Turn-by-turn analysis of how interactions unfold. Key concept: "next-turn proof procedure" — infer how a turn was understood from how the next turn responds. For dave: "When the Facilitator used move X (steelman, inversion), how did the practitioner's next turn display shift, resistance, or deepening?"

Adjacency pairs (question-answer, challenge-defence, suggestion-acceptance) provide vocabulary for tagging Facilitator-practitioner exchanges.

### Epistemic Network Analysis (ENA)

Graphs co-occurrence of epistemic move types across discourse. Reveals patterns of metacognition and expertise development. For dave: map which categories of moves (evidence, justification, alternative, evaluation) co-occur across sessions.

### Process Mining

Reconstructs typical paths from event logs. Identifies bottlenecks and effective vs. ineffective trajectories. Directly applicable to the JSONL event log: what sequences of events correlate with crystallization vs. stagnation?

### Knowledge Building (Scardamalia & Bereiter)

Defines "good moves" in collaborative inquiry: problem raising, explanation, theory improvement, integrating others' ideas. Provides a coding scheme for deliberation quality independent of outcome.

### Practical Stack for Future Implementation

1. **Instrumentation:** Each Facilitator move logged with method tag + practitioner's next turn
2. **Micro analysis:** CA next-turn proof for individual move effectiveness
3. **Meso analysis:** Process mining on event sequences for trajectory patterns
4. **Macro analysis:** ENA across sessions for reasoning development arcs

### References

- Simply Psychology. "Conversation Analysis." simplypsychology.org/conversation-analysis.html
- Epistemic Network Analysis. opus.lib.uts.edu.au/handle/10453/184156
- Process Mining in Learning Analytics. ceur-ws.org/Vol-4032/paper-30.pdf
- Knowledge Building. meshguides.org/guides/node/2226
- Interaction Analysis. files.eric.ed.gov/fulltext/EJ1152647.pdf

## Cluster 4: Existing Skills Landscape

Claude Code skills that occupy adjacent space. None fills the gap dave targets.

| Skill | Approach | Limitation |
|-------|----------|-----------|
| Critical Thinking Partner (McGregor) | Socratic challenge, progressive intensity, devil's advocate / pre-mortem / synthesis modes | Reactive (activates on detection). No persistent state. No process structure. |
| Strategic Thinking Coach (MCP Market) | 5-phase protocol (Sense-Making → Expertise → Gap Analysis → Coaching → Pressure Testing). Has a "Coaching Diary." | Less methodologically grounded. Phases are rigid. |
| Socratic Teaching Scaffolds | Vygotskian ZPD, progressive fading, Feynman explanations | Education-focused. Assumes a knowledge gap, not a deliberative one. |
| Futurist Analyst | Three Horizons, STEEP, scenario planning as scaffolds | Does foresight *for* the user. Instrumental, not engaged. |
| Socratic Thinking Partner (sc-think) | Dialectical operations for architectural doubt / stuck states | Single-session. No persistence. No methodology beyond Socratic questioning. |
| Facilitation Patterns | Workshop methodologies as interaction protocols | Group facilitation focus. No individual deliberation support. |

### The Gap

No existing skill combines:
- Persistent state across sessions (JSONL event log)
- Methodological backbone (epistemic moves, not just Socratic questioning)
- Capacity-aware calibration (comfort-growth balance)
- Material-agnostic exploration (Explorer subagent pattern)
- Process-as-product philosophy (engaged, not instrumental)

dave's Facilitator is designed to fill this gap.

## Cluster 5: Calibration Architecture

Research conducted during skill design (2026-03-04) to answer: where should adaptation logic live in an LLM-based facilitator?

### Intelligent Tutoring Systems (ITS) Architecture

ITS literature uses a modular four-component architecture: domain model (content), learner model (student state), pedagogical model (strategy), communication model (interface). For an LLM skill, this translates to layered instruction: principles in the core skill, adaptation signals in a reference document, detection emergent from the vocabulary.

Key distinction: **macro-adaptive** (pre-session assessment) vs. **micro-adaptive** (moment-to-moment). The Facilitator uses both: lifecycle stage is macro, capacity calibration is micro.

**References:**
- ITS Architecture Survey. arxiv.org/html/2503.09748v1
- Stanford CS229 ITS Design. cs229.stanford.edu/proj2008/Whiteley-ModernIntelligentTutoringSystem.pdf
- Design Recommendations for ITS Vol 3. intellimedia.ncsu.edu

### Text-Based Cognitive Load Signals

Validated signals for detecting cognitive load in text-based human-AI interaction:
- Shorter responses → depletion (reduced output capacity under load)
- Increased hedging ("maybe," "I think") → uncertainty and mental effort
- Reduced vocabulary diversity / repetition → cognitive fatigue
- Topic drift → disengagement
- Rephrasing/replanning → elevated load from interaction burden

These stem from Theory of Mind mismatches in human-AI interaction where absent multimodal cues amplify text-based demands.

**References:**
- Cognitive Load in Human-AI Interaction. arxiv.org/abs/2111.01400
- Human-AI Interaction Patterns. emergentmind.com/topics/human-ai-interaction-card

### Prescriptive Rules vs. Principle-Based Guidance for LLMs

Prompt engineering research (2025-2026) consistently shows principles + examples beat exhaustive if-then rules:
- Principles generalize to novel situations; rules fail on edge cases
- Rules are token-inefficient; principles are compact
- LLMs excel at applying high-level guidance contextually, not following decision trees
- Even principle-based systems need explicit scaffolding — the principles must be operationally clear

**Application to dave:** METHODS.md provides a signal vocabulary and example responses, not a decision tree. The Facilitator operationalizes from principles, not from prescriptive rules.

**References:**
- Lakera Prompt Engineering Guide. lakera.ai/blog/prompt-engineering-guide
- Addy Osmani LLM Coding Workflow. addyo.substack.com/p/my-llm-coding-workflow-going-into
- Prompting Guide. promptingguide.ai/techniques

## Open Research Questions

These are areas where further investigation could strengthen the design:

1. **Capacity detection signals** — What observable patterns in text indicate cognitive depletion vs. productive struggle? The scaffolding literature describes this theoretically but lacks operational heuristics for text-based interaction.

2. **Move effectiveness metrics** — Beyond next-turn analysis, how do you measure whether a steelman move or an inversion actually deepened the practitioner's understanding? Crystallization is a lagging indicator.

3. **Cross-session trajectory analysis** — What does a "healthy" deliberation trajectory look like across weeks? The process mining literature has methods but hasn't been applied to this kind of data.

4. **Methodological repertoire expansion** — The current move vocabulary (steelman, inversion, competing hypotheses, assumption surfacing) is drawn from epistemology and intelligence analysis. Domain-specific methods (Three Horizons, STEEP, scenario planning, causal layered analysis) could be added as loadable modules.

5. **The automation boundary** — Explorer agents expand the search space. Could they also detect tensions automatically using embeddings? Where does automated analysis stop and human sensemaking begin? The design doc flags this; the CCS paper suggests the boundary should be drawn at "discrepancy surfacing" — the agent can detect, but the human interprets.
