-- Start of Jenkinsfile (groovy) filetype --
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.Jenkinsfile",
	callback = function()
		vim.bo.filetype = "groovy"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "groovy",
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
	end,
})
-- End of Jenkinsfile (groovy) filetype --
