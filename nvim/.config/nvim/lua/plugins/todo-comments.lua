---@type LazySpec
return {
  "folke/todo-comments.nvim",
  opts = {
    search = {
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
    },
  },
}
