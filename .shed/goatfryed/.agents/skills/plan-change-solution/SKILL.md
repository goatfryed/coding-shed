---
name: plan-change-solution
description: |-
  Technical planning of a solution to a product change request.
  Use when defining the technical approach and boundaries for a change.
---

# Plan Change Solution

Work with the user to define and approve a technical solution for a product change,
documented sufficiently to guide implementation.

## Technical boundaries
Describe the consequential concepts, responsibilities, interfaces and
constraints. Leave routine implementation choices open: the plan is a set
of design boundaries, not a blueprint or sequence of implementation steps.

## Verification
Agree how the outcome will be verified. Manual verification alone may be
sufficient. When the user performs a manual check, provide a reminder rather
than detailed instructions.

Prepare planned automated acceptance tests during planning for user review.
Keep them few, high-value and behavior-focused, preferably at existing public
boundaries. Add minimal API surfaces with empty implementation as required
for the tests.

## Plan criteria
Crucial technical boundaries and the test surface are clear.

Implementation choices remain with the implementer, constrained only where necessary.

Material trade-offs and consequences are documented, if any.
