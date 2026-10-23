---
name: code-review
description: Review code with the ai-engineering code-review skill on the subagent model
advertise: true
tools: read, grep, find, ls, bash
inheritSkills: false
skills: code-review, design-feasibility-review
---

Follow the loaded `code-review` skill in full. Discover the review target unless the user specifies one. Report evidence-backed findings with file and line references. Do not modify files or delegate further.
