# Scenarios

## Scenario 1 - Implement new ability fireball into existing fighting game
I have a concrete, but not materialized requirement to implement a new ability.
I ask my agent to implement it. I want a normal, structured change.
My agent works with me through a materialized change requirement.
Since the change is of moderate complexity and seems to fit existing technology,
my agent also proposes to use a `developer/standard` for a technical planning next.
I approve the plan and wish to proceed. My agent commits it and starts technical planning.
The subagent assesses the requirement and identifies important technical constraints.
They list crucial high level concepts and components and defines the crucial test surface and contract.
They confirm the moderate complexity.
My agent reviews the technical plan and proposes to use a `developer/standard` for implementation as well.
I review the technical sanity and, if the plan shows proper understanding of my requirement.
I approve the technical proposal and wish to proceed.
My agent commits it and starts implementation.
A fresh subagent updates the code, implements the change, adds test and passes build and test.
A review agent checks the updated code.
My agent deems the implementation succeeded and asks me for my final review.
I approve, commit and end the session.

## Scenario 2 - Plan new feature player mounts
I have a product idea. I ask my agent to refine and prepare it.
My agent and I write and refine a draft until my product change requirement is well-defined. 
The outcome is this documented material.
One or more sessions and outside discussions might create the final material.

## Scenario 3 - Plan the implementation of the new feature global chat
I have a materialized product change requirement. I ask my agent to plan it.
We iterate on a draft until the technical requirements
are sufficiently defined to start implementation.
the outcome is this documented material of architectural and design railguards
no blueprint, process, step instruction. boundaries instead.
Since the new feature starts discussion about a new chat server, an adr is created and processed
by a system architect.
As a follow-up this introduces a new question about testing the distributed chat. I decide that
we test chat manual.
The planner minimal, high-value test set of automated tests added to the client.
They also document a verification reminder for manual chat test. Since this addresses me,
details are left out.
Since the planning included an automated test that fits the existing concepts,
the technical planner includes the test code and minimal api surfaces.
This process involved one or more sessions and outside discussions.

## Scenario 4 - Implement a fully planned change
I have a materialized product change requirement, including a technical plan.
A fresh subagent updates the code, implements the change, adds test and passes build and test.
A review agent checks the updated code.

expect to implement themself and self-review through delegation

## Scenario 5 - Implement a product change requirement
i have a materialized product change.
a primary agent i asked to plan and implement.

