# Dave

A deliberation facilitator for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Named after the human in the movie, not the machine.

Dave is a skill that guides structured thinking on open questions across sessions. It sits in the known-unknowns quadrant: questions you know you're carrying but can't yet resolve. Evidence accumulating from different contexts. Tensions forming between candidate positions. The question itself still shifting shape.

Most AI tools want to answer your question or execute your task. Dave does neither. It holds the process while you do the thinking.

## How It Works

Dave facilitates deliberation through epistemic moves: some widen the space, some compress it toward resolution, some reframe the question entirely. It tracks questions, evidence, tensions, and positions in a persistent event log (`.deliberation/questions.jsonl`), so you can pick up a question after weeks and see exactly where you left off.

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

- **Linus Lee** on [instrumental vs. engaged interfaces](https://www.youtube.com/watch?v=OeKEXnNP2yA): deliberation is engaged, the process is the value
- **Collaborative Causal Sensemaking** ([Buçinca et al.](https://arxiv.org/abs/2502.09946)): agents should track the human's evolving world model, not resolve uncertainty on their behalf
- **Giuseppe Riva** on [cognitive scaffolding](https://doi.org/10.1089/cyber.2023.29296.editorial): frictionless AI induces complacency, thinking tools need calibrated challenge
- **Ought/Elicit** on [process supervision](https://ought.org/research/process): supervise reasoning processes, not outcomes
- **GESIS/Nokia Bell Labs** on [agent-assisted foresight](https://arxiv.org/abs/2501.02789): agents expand the search space, humans own the sensemaking

Full research notes in [`docs/research/landscape.md`](docs/research/landscape.md).

## Status

Working prototype. Built for one user, one practice. Not packaged, not polished, not generalized. Published because the gap it addresses (no infrastructure for known unknowns) seems worth talking about.

## License

MIT
