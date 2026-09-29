---
description: Review code with the code-review skill on GPT-6 Sol medium
argument-hint: "[scope]"
subagent: code-review-sol
fresh: true
---
Review ${@:-the current uncommitted changes} using the loaded `code-review` skill. Report evidence-backed findings with file and line references. Do not modify files.
