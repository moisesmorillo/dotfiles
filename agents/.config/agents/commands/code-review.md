---
description: Review code using the ai-engineering code-review skill
agent: code-review-sol
subtask: true
---

Load and follow the `code-review` skill using the skill tool before reviewing. Use this command's `code-review-sol` subagent (openai/gpt-6-sol, medium reasoning); do not delegate the review to another agent.

Review scope and any additional instructions: $ARGUMENTS

If no scope is supplied, review the current uncommitted changes. Report findings with file and line references; do not edit files.
