local M = {}

local on_attach = function(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end
end

M.setup = function(sources)
  local reset_sources = require("null-ls").reset_sources
  local setup = require("null-ls").setup

  reset_sources()

  setup {
    debug = true,
    on_attach = on_attach,
    sources = sources,
  }
end

return M
