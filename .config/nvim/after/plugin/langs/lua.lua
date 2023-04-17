local ok, lspconfig = pcall(require, "lspconfig")
local _, lsp = pcall(require, "lsp-zero")

if ok then
  lspconfig.lua_ls.setup(
    lsp.nvim_lua_ls({
      settings = {
        Lua = {
          completion = {
            autoRequire = true,
            enable = true,
          },
          hint = {
            enable = true,
            paramName = "all",
          },
          workspace = {
            library = {
              -- Make the server aware of Neovim runtime files
              vim.fn.expand("$VIMRUNTIME/lua"),
              vim.fn.stdpath("config") .. "/lua",
              vim.api.nvim_get_runtime_file("", true),
            }
          }
        },
      },
    })
  )
else
  print("Could not configure lua language support")
end
