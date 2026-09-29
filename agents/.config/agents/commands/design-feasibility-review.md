---
description: Review a design using the ai-engineering design-feasibility-review skill
agent: design-review-sol
subtask: true
---

Load and follow the `design-feasibility-review` skill using the skill tool before reviewing. Use this command's `design-review-sol` subagent (openai/gpt-6-sol, medium reasoning); do not delegate the review to another agent.

Design document or review scope and any additional instructions: $ARGUMENTS

If no document or scope is supplied, ask which design to review. Report findings with references; do not edit files.
