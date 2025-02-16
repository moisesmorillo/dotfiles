---@type LazySpec[]
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "clang-format", "cpplint" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        c = { "cpplint" },
        cpp = { "cpplint" },
      },
    },
  },
}
