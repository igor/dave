# Dave

A deliberation facilitator for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Named after the human in the movie, not the machine.

Dave is a skill that guides structured thinking on open questions across sessions. It sits in the known-unknowns quadrant: questions you know you're carrying but can't yet resolve. Evidence accumulating from different contexts. Tensions forming between candidate positions. The question itself still shifting shape.

Most AI tools want to answer your question or execute your task. Dave does neither. It holds the process while you do the thinking.

## How It Works

Dave facilitates deliberation through epistemic moves: some widen the space, some compress it toward resolution, some reframe the question entirely. It tracks questions, evidence, tensions, and positions in a persistent event log (`.dave/questions.jsonl`), so you can pick up a question after weeks and see exactly where you left off.

One rule: **the human is the cognitive agent.** Dave holds methodological structure. It never resolves the question for you.

## Structure

```
skills/dave/
  SKILL.md        # Core facilitator process and iron law
  METHODS.md      # Epistemic moves, lifecycle shifts, calibration signals
  EXPLORER.md     # Subagent guidance for deep material exploration
  STATE.md        # Event schema and field definitions

hooks/
  deliberation-context.sh   # Session-start hook, surfaces open questions

docs/
  philosophy/     # Core principles, design reasoning
  research/       # Research landscape and references
  plans/          # Design and implementation plans
```

## Installation

Copy the `skills/dave/` directory into your Claude Code skills path and the hook into your hooks configuration. See the [Claude Code docs](https://docs.anthropic.com/en/docs/claude-code) for skill and hook setup.

## Research

The design draws on five research threads:

- **Linus Lee** on [instrumental vs. engaged interfaces](https://www.youtube.com/watch?v=OeKEXnNP2yA): deliberation is engaged, the process is the value ([summary](https://antoinebuteau.com/lessons-from-linus-lee/), [interview](https://jacksondahl.com/dialectic/linus-lee))
- **Collaborative Causal Sensemaking** ([arxiv](https://arxiv.org/pdf/2512.07801v4.pdf)): agents should track the human's evolving world model, not resolve uncertainty on their behalf
- **Giuseppe Riva** on [cognitive scaffolding](https://arxiv.org/abs/2507.19483): frictionless AI induces complacency, thinking tools need calibrated challenge
- **Ought/Elicit** on [process supervision](https://forum.effectivealtruism.org/posts/raFAKyw7ofSo9mRQ3/): supervise reasoning processes, not outcomes ([plan](https://ought.org/updates/2022-04-08-elicit-plan))
- **GESIS/Nokia Bell Labs** on [agent-assisted foresight](https://arxiv.org/html/2602.08565v1): agents expand the search space, humans own the sensemaking

Full research notes in [`docs/research/landscape.md`](docs/research/landscape.md).

## Status

Working prototype. Built for one user, one practice. Not packaged, not polished, not generalized.
## License

MIT
