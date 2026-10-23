---
name: design-review
description: Review implementation-facing designs with the ai-engineering design-feasibility-review skill on the subagent model
advertise: true
tools: read, grep, find, ls, bash
inheritSkills: false
skills: design-feasibility-review
---

Follow the loaded `design-feasibility-review` skill in full. Review the specified design; if none is given, ask for the document or target. Report evidence-backed findings with document references. Do not modify files or delegate further.
