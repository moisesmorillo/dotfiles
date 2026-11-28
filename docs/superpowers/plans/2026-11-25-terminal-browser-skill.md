# Terminal Browser Skill Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans. Check each step against the approved design in the session.

**Goal:** Make the Terminal Browser skill available from the dotfiles across agent tools.

**Architecture:** Stow installs the canonical skill under `~/.config/agents/skills`. A small installer links it from the shared agent directory and Claude Code. The installer removes only known Homebrew links that duplicate this skill.

**Tech stack:** Bash, Agent Skills, GNU Stow, and Homebrew Bundle.

## Constraints

- Include the existing `cask "terminal-browser"` change in `brew/Brewfile.base`.
- Keep one skill file. Preserve unrelated skills, real files, and custom links.
- Do not run the full macOS installer on the current machine. It reinstalls Homebrew and can remove local settings.
- Use the shared agent path for Pi, Codex, Gemini CLI, Amp, and OpenCode. Support the native Claude Code path.
- Ask before changing browser tools. Keep the browser open unless the user asks to close it.

## Review Focus

Cover fresh installs, existing Homebrew links, folded skill directories, unrelated entries, and repeat runs. Check broken Homebrew links without dereferencing their targets.

## Task: Install and verify the shared skill

- [ ] Add a temporary-home test for discovery paths and safe migration. Run it before adding the installer.
- [ ] Write `agents/.config/agents/skills/terminal-browser/SKILL.md`. Use the split syntax from the installed CLI help.
- [ ] Add `scripts/link-terminal-browser-skill.sh` and call it after Stow in `scripts/install-mac.sh`.
- [ ] Apply only the existing `brew/Brewfile.base` patch from the main checkout to this worktree.
- [ ] Run the link test, shell checks, and a browser smoke test. State which agent discovery checks use paths only.
- [ ] Review the diff, push the branch, and open the pull request. Give the local activation command for use after merge.
