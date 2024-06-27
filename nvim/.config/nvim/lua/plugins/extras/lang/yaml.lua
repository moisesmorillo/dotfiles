return {
  {
    "williamboman/mason.nvim",
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
          args = function()
            local local_config_file = vim.fn.getcwd() .. "/.yamlfmt"
            if vim.fn.filereadable(local_config_file) == 1 then
              return { "-conf", local_config_file, "$FILENAME" }
            end

            return { "-global_conf", "$FILENAME" }
          end,
        },
      },
      formatters_by_ft = {
        yaml = { "yamlfmt" },
      },
    },
  },
}
