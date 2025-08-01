# Agent Guidelines for dotfiles Repository

This document outlines the conventions and commands for agents operating within this dotfiles repository.

## Build/Lint/Test Commands

*   **Lua Linting**: `luacheck .` (used in CI via `.github/workflows/lua.yml`)
*   **Shell Script Linting**: `shellcheck <script_name.sh>` (install `shellcheck` if not available)
*   **YAML Linting**: `yamllint <file_name.yaml>`

There are no traditional build or test commands for this repository as it primarily contains configuration files and scripts.

## Code Style Guidelines

*   **EditorConfig**: Adhere to the rules defined in `.editorconfig` for consistent formatting across various file types. Key rules include:
    *   `indent_style = tab`
    *   `indent_size = 4`
    *   `end_of_line = lf`
    *   `insert_final_newline = true`
    *   `trim_trailing_whitespace = true`
    *   `max_line_length = 120` for Makefiles and shell scripts.
*   **Lua**: Follow `luacheck` recommendations for Lua files.
*   **YAML**: The `yamllint` configuration disables the `document-start` rule. Otherwise, follow default `yamllint` rules.
*   **Naming Conventions**: Follow existing naming conventions within specific directories (e.g., `nvim` for Lua files, `scripts` for shell scripts).
*   **Error Handling**: Implement robust error handling in shell scripts where applicable, following common shell scripting best practices (e.g., `set -e`, `set -u`, `set -o pipefail`).
*   **Imports/Requires**: For Lua, use `require` statements consistently at the top of files. For shell scripts, source other scripts at the beginning if necessary.
*   **Comments**: Add comments to explain complex logic or non-obvious configurations.

## Cursor/Copilot Rules

No specific Cursor or Copilot rule files were found in this repository. Agents should follow the general code style guidelines outlined above.