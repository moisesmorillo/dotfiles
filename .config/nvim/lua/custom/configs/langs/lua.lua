---@type NvPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    ft = "lua",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua-language-server", "stylua" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "lua",
    opts = function(_, opts)
      -- lua is part of nvchad defaults so we don't add it to this list
      vim.list_extend(opts.ensure_installed, { "luadoc", "luap", "vim", "vimdoc" })

      return opts
    end,
  },

  {
    ft = "lua",
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      local server_opts = {
        lua_ls = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "lua" },

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
                globals = { "vim" },
                workspaceDelay = 500,
              },
              hint = {
                enable = true,
                paramName = "all",
              },
              workspace = {
                library = {
                  [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                  [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                  [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
                  [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                checkThirdParty = false,
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
            },
          },
        },
      }

      return vim.tbl_extend("force", opts, server_opts)
    end,
  },
  {
    ft = "lua",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts, { b.formatting.stylua })

      return opts
    end,
  },
}
