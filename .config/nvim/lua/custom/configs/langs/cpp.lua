---@type NvPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "clangd", "clang-format", "codelldb" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c", "cpp" })

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities
      local util = require "lspconfig.util"

      local server_opts = {
        clangd = {
          on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelpProvider = false
            on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          filetypes = { "c", "cpp" },
          root_dir = util.root_pattern("main.cpp", ".git"),
        },
      }

      return vim.tbl_extend("force", opts, server_opts)
    end,
  },

  {
    ft = { "c", "cpp" },
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts, {
        b.formatting.clang_format,
      })

      return opts
    end,
  },
}
