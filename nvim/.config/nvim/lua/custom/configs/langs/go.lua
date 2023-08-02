local ft = { "go", "gomod" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "delve",
        "gofumpt",
        "goimports-reviser",
        "golangci-lint",
        "golangci-lint-langserver",
        "golangci-lint-langserver",
        "golines",
        "gopls",
        "gotestsum",
        "iferr",
        "impl",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "go", "gomod" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = ft,
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
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              staticcheck = true,
              semanticTokens = true,
            },
          },
        },
        golangci_lint_ls = {},
      },
    },
  },

  {
    ft = ft,
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
    ft = ft,
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
    ft = ft,
    dependencies = {
      { "nvim-neotest/neotest-go" },
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, { require "neotest-go" })
    end,
  },

  {
    "danymat/neogen",
    ft = ft,
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

  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    event = { "CmdlineEnter" },
    ft = ft,
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}

return plugins
