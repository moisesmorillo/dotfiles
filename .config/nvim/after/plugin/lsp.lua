local utils = require("core.utils")
local ok, lsp = pcall(require, "lsp-zero")
if not ok then return false end

lsp.preset({
  name = "recommended",
})

lsp.ensure_installed({
  "bashls",
  "clangd",
  "eslint",
  "gopls",
  "lua_ls",
  "rust_analyzer",
  "sqlls",
  "tsserver",
  "yamlls",
})

lsp.set_sign_icons({
  error = "",
  warn = "",
  hint = "",
  info = ""
})

lsp.on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  utils.nnoremap("<leader>lh", function() vim.lsp.buf.hover() end, opts)
  utils.nnoremap("<leader>ld", function() vim.lsp.buf.definition() end, opts)
  --   utils.nnoremap("", command, options)
end

lsp.format_on_save({
  format_opts = {
    timeout_ms = 5000,
  },
  servers = {
    ["lua_ls"] = { "lua" },
  }
})

lsp.setup()
