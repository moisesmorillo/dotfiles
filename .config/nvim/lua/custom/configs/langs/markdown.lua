---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = "markdown",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "marksman" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline", "mermaid" })

      return opts
    end,
  },

  {
    ft = "markdown",
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      require("core.utils").load_mappings "markdown"
    end,
  },
}

return plugins
