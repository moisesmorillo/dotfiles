-- Fix cursor block when exiting from neovim
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		vim.cmd([[set guicursor=a:ver100]])
	end,
})
