---
name: any-decision-records
description: >
  Turn ANY significant decisions into persistent project knowledge
  and respect decisions as challengeable constraints
  Keywords: adr, decision, record
metadata:
    opencode/slash: false
---

# Any Decision Records
We track decisions as any decision records (ADRs)
Decisions
- document requirements towards implementations
- explain requirement context
- allow challenging requirements due to changing context

Documenting a decision is more important than making a good decision.


## Form
Every decision record has an id as a short slug. Ideally this matches title.
Naming convention `domain/orientend/path/<id>`  
Frontmatter: id, title, short-summary, created  
Body:
```md
# Topic
## Issue
## Decision
## Consequences
## Assumptions
## Context
```

## Context
Context describes surrounding information. It includes constraints, supporting data,
and hints. This does not mean and should not include the conversation to the decision.
Context entries should include evidence, if possible.
Constraints are marked in a leading subsection.

## Challenging decisions
A decision `we use foo because we want like it and it claims to do bar` is great,
because decisions without basis allow us to challenge them.

A decision is not to be challenged for the sake of it, but should be challenged,
if evidence suggests issues with that decision.

## Proposing new or changed decisions

- Record proposals as new ADRs with `status: draft` in frontmatter.
- Preserve existing ADRs when proposing changes. Use a new draft addendum to extend a decision, or a new draft superseding ADR to replace it.
- Reference the affected ADR and explain the proposed change, supporting evidence, and consequences.
- A draft is a proposal, not an adopted decision. It does not itself authorize a change; authority to act comes from applicable project rules and the decision's context.
