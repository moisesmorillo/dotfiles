return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    sources = { "filesystem" },
    filesystem = {
      filtered_items = {
        hide_by_name = {
          "node_modules",
          ".git",
        },
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
