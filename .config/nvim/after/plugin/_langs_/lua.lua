local ok, lspconfig = pcall(require, "lspconfig")
local _, lsp = pcall(require, "lsp-zero")

if ok then
  local config = {
    settings = {
      Lua = {
        codeLens = {
          enable = true,
        },
        completion = {
          autoRequire = true,
          enable = true,
          callSnippet = "Both",
          displayContext = true,
          showParams = true,
        },
        diagnostics = {
          enable = true,
          workspaceDelay = 500,
        },
        hint = {
          enable = true,
          paramName = "all",
        },
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.stdpath("config") .. "/lua/core",
            vim.api.nvim_get_runtime_file("", true),
          },
          checkThirdParty = false,
        }
      },
    },
  }
  lspconfig.lua_ls.setup(lsp.nvim_lua_ls(config))
else
  print("Could not configure lua language support")
end
