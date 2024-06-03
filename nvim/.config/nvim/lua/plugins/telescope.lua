return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
      find_files = {
        hidden = true,
      },
    })
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      vimgrep_arguments = {
        "rg",
        "-L",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
      file_ignore_patterns = {
        "%.git/",
      },
    })
  end,
}
