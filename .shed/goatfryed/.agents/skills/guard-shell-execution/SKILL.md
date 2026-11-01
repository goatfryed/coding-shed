---
name: guard-shell-execution
description: Use before any terminal or shell execution, including commands run through delegated agents or other tools. Keeps executions purpose-bounded and readable.
---

# Shell execution

## Bounded purpose

- Each execution answers one concrete question or performs one coherent operation. Broad labels such as “environment checks” do not make unrelated checks one purpose.
- Include only commands needed for that purpose.

## Approval boundaries

- Submit independently reviewable operations as separate terminal tool calls so the user can approve each individually. Separate lines within one call are not separate approval boundaries.
- A shared goal such as “validate the changes” does not justify bundling independent checks into one call.
- Keep pipelines and dependent command sequences together when they form one coupled operation. One operation does not mean one process.

## Readability

- Keep commands easy to inspect before execution and relate to their output afterward.
- Format multi-command executions across lines, with one logical step per line and visible control flow, rather than dense semicolon chains.

## Proportionate discovery

Reasonable environment assumptions are acceptable. Discover or correct details when needed, including after a failure; routine execution does not require verifying every assumption first.
