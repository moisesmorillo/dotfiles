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

-- ToggleTerm
map("t", "<esc>", "<cmd>ToggleTerm<cr>", { desc = "Exit Terminal", noremap = true, silent = true })
map("t", "<c-h", "<cmd>wincmd h", { desc = "Go To Left Terminal", noremap = true, silent = true })
map("t", "<c-j", "<cmd>wincmd j", { desc = "Go To Down Terminal", noremap = true, silent = true })
map("t", "<c-k", "<cmd>wincmd k", { desc = "Go To Above Terminal", noremap = true, silent = true })
map("t", "<c-l", "<cmd>wincmd l", { desc = "Go To Right Terminal", noremap = true, silent = true })
