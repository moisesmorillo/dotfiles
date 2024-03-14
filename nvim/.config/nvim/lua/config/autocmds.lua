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

vim.api.nvim_create_user_command("UpdateTM", function()
	vim.cmd("TSUpdate")
	local mason_registry = require("mason-registry")
	local installed_packages = mason_registry.get_installed_package_names()
	vim.cmd("MasonInstall " .. table.concat(installed_packages, " "))
end, { desc = "Install/Update treesitter and mason packages" })
