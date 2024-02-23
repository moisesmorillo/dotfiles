-- This also has an autocmd in nvim/.config/nvim/lua/config/autocmds.lua which set Jenkinsfile to groovy filetype.
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "groovy" })
		end,
	},
}
