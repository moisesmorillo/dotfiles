local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "eslint",
  "gopls",
  "sumneko_lua",
  "rust_analyzer",
  "yamlls",
})

lsp.nvim_workspace()
lsp.setup()
