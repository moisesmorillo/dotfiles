local map = vim.keymap.set

-- LSP
map("n", "<leader>cli", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>cld", "<cmd>Neoconf lsp<cr>", { desc = "LSP Debug" })

-- Telescope
map("n", "<leader>fd", function()
	require("telescope.builtin").git_files({
		prompt_title = "<Dotfiles>",
		cwd = "~/projects/dotfiles/",
	})
end, { desc = "Find Dotfiles" })
