---@type NvPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    ft = "rust",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust-analyzer" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "rust",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust" })

      return opts
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    ft = "rust",
    opts = function()
      local M = require "plugins.configs.cmp"
      vim.list_extend(M.sources, { name = "crates" })

      return M
    end,
  },

  {
    ft = "rust",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts, {
        b.formatting.clang_format,
      })

      return opts
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function(_, _)
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities
      local util = require "lspconfig.util"

      return {
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "rust" },
          root_dir = util.root_pattern("Cargo.toml", "Cargo.lock", ".git"),
        },
      }
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      crates.show()
      require("core.utils").load_mappings "rust"
    end,
  },

  -- TODO add support for DAP
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   ft = "rust",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "mfussenegger/nvim-dap",
  --   },
  --   opts = {
  --     handlers = {},
  --   },
  -- },
}
