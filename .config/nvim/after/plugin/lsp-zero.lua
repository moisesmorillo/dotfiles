local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  "sqlls",
  "tsserver",
  "eslint",
  "gopls",
  "sumneko_lua",
  "rust_analyzer",
  "yamlls",
  "clangd",
})

lsp.nvim_workspace()
lsp.setup()
