local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local util = require "lspconfig.util"

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = "go",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "gopls", "golines", "gofumpt", "goimports-reviser", "delve" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "go",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "go" })

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = "go",
    opts = {
      servers = {
        gopls = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = util.root_pattern("go.work", "go.mod", ".git"),
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                fieldalignment = true,
                unusedparams = true,
                unusedvariable = true,
              },
            },
          },
        },
      },
    },
  },

  {
    ft = "go",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.gofumpt,
        b.formatting.goimports_reviser.with { extra_args = { "-set-alias", "-rm-unused" } },
        b.formatting.golines.with { extra_args = { "-m", "120" } },
      })

      return opts
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("custom.configs.dap").set_go_debugger()
      require("core.utils").load_mappings "go"
    end,
  },
}

return plugins
