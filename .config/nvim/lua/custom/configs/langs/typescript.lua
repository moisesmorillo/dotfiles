local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local util = require "lspconfig.util"

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript-language-server", "prettier", "deno" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript", "javascript" })

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      servers = {
        tsserver = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          root_dir = util.root_pattern("package.json", "yarn.lock", "package-lock.json", ".git"),
        },
      },
    },
  },

  {
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } },
        b.formatting.deno_fmt.with {
          extra_args = { "--single-quote" },
        }, -- choosed deno for ts/js files cuz its very fast!
      })

      return opts
    end,
  },
}

return plugins
