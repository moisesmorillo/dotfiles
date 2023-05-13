local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then return false end

treesitter.setup({
  ensure_installed = {
    "bash",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "luadoc",
    "mermaid",
    "ninja",
    "python",
    "rust",
    "sql",
    "terraform",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
})
