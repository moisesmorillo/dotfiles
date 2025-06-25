---@type LazySpec[]
return {
  -- Default LazyVim tresitter config include bash
  -- Default LazyVim conform config include shfmt for sh
  -- Default mason config include shfmt
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "shfmt" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        shellcheck = {
          args = { "-x" },
        },
      },
      linters_by_ft = {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        zsh = { "shellcheck" },
      },
    },
  },
}
