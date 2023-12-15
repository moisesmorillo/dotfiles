local map = vim.keymap.set

-- LSP
map("n", "<leader>cli", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>cld", "<cmd>Neoconf lsp<cr>", { desc = "LSP Debug" })
