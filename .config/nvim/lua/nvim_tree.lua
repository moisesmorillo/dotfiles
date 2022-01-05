--  not migrated options must be set before running the setup function
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_group_empty = 1 
vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
}

require'nvim-tree'.setup {
  git = {
    enable = true,
    ignore = true,
    timeout = 300,
  },
  view = {
    hide_root_folder = false,
    width = 25,
    side = "left",
  }
}

