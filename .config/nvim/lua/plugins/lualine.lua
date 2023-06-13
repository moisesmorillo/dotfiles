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
        --lualine_x = {'encoding', 'filetype'}, // TODO update this to show lazy status
        lualine_x = {
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff0000" },
          },
        },
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
