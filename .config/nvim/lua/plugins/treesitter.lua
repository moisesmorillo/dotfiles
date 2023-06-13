local opts = {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "dockerfile",
    "go",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "json5",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "mermaid",
    "python",
    "regex",
    "rust",
    "sql",
    "terraform",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  highlight = { enable = true },
  indent = { enable = true },
  auto_install = true,
}

return { 
  "nvim-treesitter/nvim-treesitter", 
  build = ":TSUpdate",
  opts = opts,
  event = { "BufReadPost", "BufNewFile" },
  config = function(_, plugin_opts)
    require("nvim-treesitter.configs").setup(plugin_opts)
  end,
}
