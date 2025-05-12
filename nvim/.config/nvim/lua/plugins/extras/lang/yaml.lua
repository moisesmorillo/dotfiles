---@type LazySpec[]
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "yamlfmt", "yamllint" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        yamlfmt = {
          prepend_args = function()
            local args = {}
            local local_config_file = vim.fn.getcwd() .. "/.yamlfmt"
            if vim.fn.filereadable(local_config_file) == 1 then
              args = { "-conf", local_config_file }
            end

            return args
          end,
        },
      },
      formatters_by_ft = {
        yaml = { "yamlfmt" },
      },
    },
  },
}
