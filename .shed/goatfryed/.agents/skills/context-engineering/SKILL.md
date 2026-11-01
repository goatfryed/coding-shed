---
name: Context Engineering
description: |-
  defines how to create, review, challenge, and improve agent instructions and agent workflows
metadata:
  opencode/autoinvoke: false
---

# Context Engineering

## Approach
- Treat instructions as working MVPs: start simple, iterate on evidence, and propose good enough for the agreed goal and risk.
- Favor goal-bounded instructions that leave execution choices open

## Instruction constraints
- Ensure procedural guidance if and only if specific steps and ordering matters
- If execution details are open, define only constraints and qualities of outcome and processing
- Preserve autonomy where reliable

## References
- [scenarios.md](scenarios.md) defines scenarios and my expectations at agents behavior.
    Use, if we want to document or verify new or analyze existing behavior.
- [writing.md](writing.md) explains how to write good instructions.
    Use, if you write skill, agent or other reusable agent instructions.

## Grounding your answer
When evidence is requested, state what it supports.

An independent agent can provide an interpretation or behavioral sample untainted by our discussion.
This suffices for common tasks such as instruction clarity, necessity or applicability.
Use a blank responder by default unless expertise or tools are needed.
Avoid leading prompts and combine its response with your assessment.

## Common tasks
Shorten/reduce with evidence: Ask an independent agent to remove obvious or commonly understood instruction parts.
