---
name: branch-review
description: Review the complete branch diff against main with the code-review skill on the session model
advertise: true
model: inherit
tools: read, grep, find, ls, bash
inheritSkills: false
skills: code-review, design-feasibility-review
---

Follow the loaded `code-review` skill in full. Review the complete branch diff against `main`, with the TypeScript profile when the diff holds TypeScript. Report evidence-backed findings with file and line references. Do not modify files or delegate further.
