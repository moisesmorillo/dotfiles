local ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript-language-server", "prettier", "deno" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript", "javascript" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = ft,
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
    ft = ft,
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } },
        b.formatting.deno_fmt.with {
          extra_args = { "--single-quote" },
        }, -- choosed deno for ts/js files cuz its very fast!
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    ft = ft,
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
    end,
  },

  {
    "danymat/neogen",
    ft = ft,
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

  -- TODO: add https://github.com/pmizio/typescript-tools.nvim
}

return plugins
