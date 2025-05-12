---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "groovy" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "npm-groovy-lint" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        groovyls = {},
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        groovy = { "npm-groovy-lint" },
      },
      linters = {
        ["npm-groovy-lint"] = {
          args = { "--failon", "error" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        groovy = { "npm_groovy_lint" },
      },
      formatters = {
        npm_groovy_lint = {
          command = "npm-groovy-lint",
          args = { "--failon", "error", "--format", "$FILENAME" },
          cwd = require("conform.util").root_file({ ".git" }),
          stdin = false,
        },
      },
    },
  },
}
