vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.Jenkinsfile",
	callback = function()
		vim.bo.filetype = "groovy"
	end,
})
