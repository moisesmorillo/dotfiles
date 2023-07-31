---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = "lua",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "marksman" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "lua",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline", "mermaid" })

      return opts
    end,
  },

  {
    ft = "lua",
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  {
    ft = "lua",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, { b.formatting.stylua })

      return opts
    end,
  },
}

return plugins
