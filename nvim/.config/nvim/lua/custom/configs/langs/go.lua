---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = "go",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "gopls", "golines", "gofumpt", "goimports-reviser", "delve" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "go",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "go" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = "go",
    opts = {
      servers = {
        gopls = {
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = { "go.work", "go.mod", ".git" },
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

  {
    "nvim-neotest/neotest",
    ft = "go",
    dependencies = {
      { "nvim-neotest/neotest-go" },
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, { require "neotest-go" })
    end,
  },

  {
    "danymat/neogen",
    ft = "go",
    opts = {
      languages = {
        go = {
          template = {
            annotation_convention = "godoc",
          },
        },
      },
    },
  },
}

return plugins
