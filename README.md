# `~/.dotfiles`

<p align="center">
  <img src="screenshots/terminal.png" alt="Terminal Screenshot" width="800">
</p>

My personal dotfiles for macOS and GitHub Codespaces environments.

## ✨ Features

- 🔄 Cross-platform setup (macOS & GitHub Codespaces)
- 🧪 GitHub Actions for automated testing
- 🔧 Easy installation with environment detection
- 🛠️ Modular configuration with GNU Stow
- 🎨 Beautiful git diffs with Delta and Rose Pine theme
- 🤖 AI-powered development tools (Claude, Gemini, OpenCode)
- 📊 Modern CLI tools (bat, eza, yazi, btop)

## 🛠️ Tools & Configurations

### 🐚 ZSH

- Custom `.zshrc` configuration
- Various useful aliases and functions
- Integration with tools like `fzf`, `ripgrep`, and more

### 🔮 Neovim

- Full-featured development environment
- LSP integration with autocompletion
- Syntax highlighting and treesitter support
- Snacks for fuzzy finding
- Custom keybindings and plugins
- AI integration with Sidekick
- Cursor like features

### 📊 Tmux

- Custom key bindings
- Status bar customization
- Session management
- Integration with tmux plugins via TPM

### 👻 Ghostty

- Modern terminal emulator configuration
- Custom color schemes and fonts
- Performance optimizations

### 🚀 Starship

- Cross-shell customizable prompt
- Git status integration
- Runtime information

### 🍺 Homebrew

- Package management for macOS
- Customized Brewfile with essential software
- Automated installation of development tools

### 🐳 Docker & Lazydocker

- Custom Docker configuration
- Lazydocker for container management
- OrbStack as the container runtime on macOS
- OrbStack VM settings (CPU/RAM limits) versioned in `orbstack/` and linked to `~/.orbstack/vmconfig.json`
  - Note: OrbStack rewrites this file atomically, so any change made via the GUI or
    `orb config set` replaces the symlink with a regular file. To change a setting,
    edit `orbstack/.orbstack/vmconfig.json` in the repo, run `stow -R orbstack`, and
    restart OrbStack. If you did change it via GUI/CLI, copy the new value into the
    repo and re-run `stow -R orbstack` (delete the regular file first).

### 🗂️ Lazygit

- Terminal UI for Git commands
- Custom keybindings and themes
- Seamless Git workflow
- Integrated with delta for beautiful diffs

### 🎨 Delta

- Enhanced git diff viewer
- Side-by-side diffs with syntax highlighting
- Rose Pine theme integration
- Optimized for lazygit

### 🔄 Mise

- Runtime version manager
- Configuration for multiple languages
- Automatic version switching

### 🦇 Bat

- Modern `cat` replacement with syntax highlighting
- Line numbers and git integration
- Multiple theme support

### 📊 Btop

- Beautiful resource monitor
- System resource visualization
- Process management

### 📁 Eza

- Modern `ls` replacement with colors
- Tree view support
- Git integration

### 🗄️ Yazi

- Terminal file manager
- Fast and efficient navigation
- Preview support for multiple file types

### ⌨️ Karabiner

- Keyboard customization for macOS
- Complex key mappings
- Application-specific shortcuts

### 🤖 AI Tools

- **Claude CLI** - Claude AI integration
- **Gemini CLI** - Google Gemini integration
- **OpenCode** - AI coding assistant with Neovim integration (Toggle sidebar: `Ctrl+x` + `b`)
- **Pi** - AI coding assistant configured to use `openai/gpt-6-luna` with medium reasoning (`gpt-6.1-sol` is also configured for review subagents)

Reusable skills are owned by the separate `ai-engineering` repository. Pi and OpenCode register
`~/workspace/moisesmorillo/ai-engineering/skills` globally, so updating that repository updates both tools.

| Review | OpenCode | Pi |
| --- | --- | --- |
| Code | `/code-review [scope]` | `/prompt-workflow code-review [scope]` |
| Design | `/design-feasibility-review <document>` | `/prompt-workflow design-feasibility-review <document>` |

These commands launch dedicated subagents on GPT-6.1 Sol with medium reasoning (`openai/gpt-6.1-sol` in
OpenCode, `openai/gpt-6.1-sol` in Pi). Pi's `/skill:...` commands instead load a skill in the
current agent without switching models.

Pi package references in `pi/.pi/agent/settings.json` are intentionally unpinned so Pi can resolve current
releases when packages are installed or updated. The installers merge the repository's Pi settings into
`~/.pi/agent/settings.json`, preserving unrelated settings. Run `scripts/pi-status.sh` to compare declared
package sources for missing or extra entries. Since refs are unpinned, it does not detect whether installed
package versions are current or inspect the package manager's cache.

We keep the Pi setup lean and do not currently add these optional integrations:

- `pi-interactive-shell`: useful for interactive long-running commands, but not needed in the current workflow.
- `@plannotator/pi-extension`: offers visual diff annotation; the existing review workflow does not require it.
- `pi-ask-user`: interactive prompting is not currently needed for these agent workflows.
- `@tmustier/pi-usage-extension`: adds usage analytics, which are not required here.
- MCP: use Pi's native MCP support rather than adding `pi-mcp-adapter`.
- `pi-claude-cli`: not applicable because Pi uses the `openai` provider.

`@juanibiapina/pi-extension-settings` is not installed, so no special package load order is required.

### 🔧 Development Tools

- **Git** - Global git configuration
- **Yamlfmt** - YAML formatter
- **Yamllint** - YAML linter
- **Network Utils** - Network debugging utilities

## 📥 Installation

### macOS

```bash
# Clone the repository
git clone https://github.com/moisesmorillo/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the install script
chmod +x install.sh
./install.sh
```

### GitHub Codespaces

The dotfiles will be automatically installed when creating a new Codespace.

## 🧪 Testing

This repository includes GitHub Actions workflows to test the configuration:

- Shell script linting with ShellCheck
- YAML validation
- Cross-platform installation tests
- Lua type checking for Neovim configuration

## 📂 Structure

```
.
├── aerospace/    # Window Manager
├── agents/       # AI Agents
├── bat/          # Bat (cat replacement) config
├── borders/      # Borders Config
├── brew/         # Homebrew bundle files
├── btop/         # Btop resource monitor config
├── claude/       # Claude CLI config
├── delta/        # Delta git diff viewer config
├── eza/          # Eza (ls replacement) config
├── gemini/       # Gemini CLI config
├── ghostty/      # Ghostty terminal config
├── karabiner/    # Karabiner keyboard config
├── lazydocker/   # Lazydocker configuration
├── lazygit/      # Lazygit configuration
├── markdownlint/ # Markdown Linting
├── mise/         # Mise runtime manager config
├── network_utils/# Network utilities
├── nvim/         # Neovim configuration
├── opencode/     # OpenCode CLI config
├── scripts/      # Installation scripts
├── starship/     # Starship prompt config
├── tmux/         # Tmux configuration
├── yamlfmt/      # YAML formatter config
├── yamllint/     # YAML linter config
├── yazi/         # Yazi file manager config
└── zsh/          # ZSH configuration
```

## ⚖️ License

MIT 