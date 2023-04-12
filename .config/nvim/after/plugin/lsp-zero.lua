local ok, lsp = pcall(require, "lsp-zero")

if ok then
  lsp.preset("recommended")

  lsp.ensure_installed({
    "sqlls",
    "tsserver",
    "eslint",
    "gopls",
    "lua_ls",
    "rust_analyzer",
    "yamlls",
    "clangd",
    "bashls"
  })

  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

  lsp.on_attach = function (client, bufnr)
    
  end

  lsp.nvim_workspace()
  lsp.setup()

  -- TODO review this config
  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = false,
    underline = true,
    update_in_insert = false,
    float = {
      source = "always", -- Or "if_many"
    },
  })
else
  print("Module lsp-zero not found")
end
