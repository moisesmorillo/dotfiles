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
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          root_dir = { "package.json", "yarn.lock", "package-lock.json", ".git" },
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

  {
    "nvim-neotest/neotest",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-jest" {
          jestCommand = "npx jest --bail --verbose --ci --outputFile=lcov.info --",
          env = { NODE_OPTIONS = "--experimental-vm-modules" },
          jestConfigFile = "jest.config.js",
        },
      })

      return opts
    end,
  },

  {
    "danymat/neogen",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      languages = {
        javscript = {
          template = {
            annotation_convention = "jsdoc",
          },
        },

        typescript = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
      },
    },
  },
}

return plugins
