---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json5", "latex" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~/.markdownlint-cli2.jsonc"), "-" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "markdownlint-cli2" },
      },
      formatters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~/.markdownlint-cli2.jsonc"), "--fix", "$FILENAME" },
        },
      },
    },
  },
}
