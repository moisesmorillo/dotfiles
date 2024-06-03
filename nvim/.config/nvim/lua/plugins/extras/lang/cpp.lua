return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "clang-format",
        "cpplint",
      })
    end,
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
  {
    "danymat/neogen",
    opts = {
      languages = {
        c = {
          template = {
            annotation_convention = "doxygen",
          },
        },
        cpp = {
          template = {
            annotation_convention = "doxygen",
          },
        },
      },
    },
  },
}
