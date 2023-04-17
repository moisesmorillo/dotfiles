local ok, lsp = pcall(require, "lsp-zero")

if ok then
  lsp.preset({
    name = "recommended",
  })

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

  lsp.set_sign_icons({
    error = "",
    warn = "",
    hint = "",
    info = ""
  })

  lsp.on_attach = function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
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
else
  print("Module lsp-zero not found")
end
