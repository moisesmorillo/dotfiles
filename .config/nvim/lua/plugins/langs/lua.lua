return {
  event = { "BufReadPre", "BufNewFile" },
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lua_ls = {
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
      },
    },
  },
}
