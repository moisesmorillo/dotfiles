# OpenCode Configuration

This directory contains the OpenCode agent configuration for the dotfiles repository.

## Directory Structure

```
.config/opencode/
├── AGENTS.md                 # Agent behavior and protocol guidelines
├── opencode.json            # Main OpenCode configuration
└── commands/
    └── gh-sync.md            # Custom command: sync changes to GitHub with PR creation
```

## Configuration

### Models
- **Default**: `zai/glm-4.7`
- **Small**: `zai/glm-4.7-flash`
- **Default agent**: `plan`

### Agent Models
- **plan**: `zai/glm-4.7`
- **build**: `zai/glm-4.7`

## MCP Servers

Three Model Context Protocol (MCP) servers are configured:

### Context7
Provides access to library documentation for any programming framework.

**Command**: `npx -y @upstash/context7-mcp --api-key {env:CONTEX7_API_KEY}`

### Playwright
Browser automation and web interaction capabilities.

**Command**: `npx @playwright/mcp@latest`

### SonarQube
Code quality and analysis integration with SonarCloud.

**Command**: `npx -y sonarqube-mcp-server@latest`

**Environment**:
- `SONARQUBE_TOKEN`: API token for authentication
- `SONARQUBE_URL`: `https://sonarcloud.io`
- `SONARQUBE_ORG`: `platzidev`

## Agent Guidelines

### Shell Command Best Practices
- **Directory navigation**: Always use `\cd` instead of `cd` (agentic tools cannot access the `cd` alias)
- **Shell selection**: Use `zsh` and always run `source ~/.zshrc` to avoid conflicts with tool operations

### English Development Protocol

When writing in English, agents provide language learning support:

**Core principles:**
- Always respond in English by default when the user writes in English
- Adapt difficulty to the user's current level with concise, example-driven explanations
- Offer both everyday and technical vocabulary alternatives

**Mandatory corrections:**
- Always include an "English Improvements" section at the end of responses
- Point out specific errors directly without hedging language
- Show clear before → after pairs for each fix
- Highlight recurring error patterns (tense consistency, prepositions, articles, subject-verb agreement, punctuation, register)
- Cover both mechanics (grammar, spelling, punctuation) and style (clarity, flow, tone, word choice)

**Vocabulary enrichment:**
- Provide everyday synonyms and technical/industry alternatives for key words
- Suggest 2–4 alternatives with short usage notes or examples
- Mark false friends or overused words and suggest better replacements

**Fluency micro-coaching:**
- Offer one "Upgrade Tip" per message (stronger verb, native-like connector, cleaner sentence pattern)
- Provide 1–2 minute micro-drills when requested (gap-fill, minimal pairs, paraphrase challenges)

**Optional modes:**
- **Concise Mode**: Only top 3 fixes + one Upgrade Tip
- **Exam Mode**: Formal register, no fillers, no contractions
- **Tech Mode**: Precise technical terminology with domain notes
- **Casual Mode**: Natural conversational phrasing with idiomatic alternatives

**Safety and tone:**
- Professional and encouraging, never mocking or overpraising
- Clarify or rephrase intended meaning without inventing content

### Problem-Solving Approach

**Never assume — Always ask for clarification**

When multiple valid solutions exist, agents:
1. Recognize the ambiguity
2. Ask clarifying questions to understand constraints, goals, and preferences
3. Present different approaches with tradeoffs
4. Let the user decide
5. Implement their preferred solution

**When it's okay to assume:**
- User explicitly states their constraint or preference
- Single obvious "best practice" with no meaningful tradeoffs
- Building on something already discussed and confirmed
- Context makes the intent unmistakably clear

## Custom Commands

### `gh-sync`

Sync local changes to GitHub with automated PR creation.

**Workflow:**
1. Check current branch; create new branch using Git Flow conventions if on main/master
2. Run project-specific linting and tests (JS/TS, Go, Python detected automatically)
3. Stage all changes with `git add .`
4. Create conventional commit message (feat:/fix:/refactor:/docs:/test:)
5. Push to origin and create PR with detailed description

## Environment Variables

Required environment variables:

- `CONTEX7_API_KEY`: API key for Context7 MCP server
- `SONARQUBE_TOKEN`: Authentication token for SonarCloud

## Available Models

The configuration includes multiple Google/Antigravity models with varying capabilities:

- **Gemini 3 Pro/Flash**: Up to 1M context, supports text/image/PDF input
- **Claude Sonnet 4.5**: 200K context, optional thinking mode
- **Claude Opus 4.5**: 200K context, optional thinking mode
- **Gemini 2.5 Pro/Flash**: High context with multi-modal support
- **Gemini 3 Preview**: Latest preview versions with enhanced features
