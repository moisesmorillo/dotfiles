local opts = {
    disable_filetype = { "TelescopePrompt" , "vim" },
}

return { 
    "windwp/nvim-autopairs",
    opts = opts,
    event = "InsertEnter",
    config = function(_, opts)
        require("nvim-autopairs").setup(opts)
        -- setup cmp for autopairs
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}