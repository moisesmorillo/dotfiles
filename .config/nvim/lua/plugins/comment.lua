local keys = {
    {"<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle comments in normal mode", silent = true, noremap = true},
    {"<leader>/", "<Plug>(comment_toggle_blockwise_visual)", desc = "Toggle comments in visual mode", mode="v", silent = true, noremap = true},
}

return {
    "numToStr/Comment.nvim",
    keys = keys,
}
