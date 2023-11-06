local ft = { "sh", "zsh" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "bash-language-server", "shfmt", "shellcheck" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "bash" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = ft,
    opts = {
      servers = {
        bashls = {},
      },
    },
  },

  {
    ft = ft,
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.shfmt,
        b.formatting.shellharden,
        b.diagnostics.shellcheck,
        b.diagnostics.zsh,
        b.code_actions.shellcheck,
      })
    end,
  },
}

return plugins
