local opts = {
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 100,
    },
}

return { 
    "lewis6991/gitsigns.nvim",
    opts = opts,
    event = "InsertEnter",
}