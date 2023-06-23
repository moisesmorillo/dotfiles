--[[ local opts = {
  ensure_installed = {
    "bashls",
    "clangd",
    "eslint",
    "gopls",
    "rust_analyzer",
    "sqlls",
    "tsserver",
    "yamlls",
  },
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  event = "VimEnter",
} ]]

return {}
