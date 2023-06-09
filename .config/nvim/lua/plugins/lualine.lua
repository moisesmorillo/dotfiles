local opts = {
    options = {
        theme = "catppuccin",
        disabled_filetypes = { "NvimTree" },
    },
    globalstatus = true,
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {'diagnostics'},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress',},
        lualine_z = {'location'}
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 
        "nvim-tree/nvim-web-devicons",
        "catppuccin",
    },
    opts = opts,
    event = "VeryLazy",
    config = function(_, opts)
        require("lualine").setup(opts)
    end,
}
