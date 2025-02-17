local map = vim.keymap.set

-- LSP
map("n", "<leader>cli", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>cld", "<cmd>LazyDev lsp<cr>", { desc = "LSP Debug" })

-- Picker
map("n", "<leader>fd", function()
  Snacks.picker.files({
    hidden = true,
    title = "<Dotfiles> ",
    dirs = { "~/projects/dotfiles/" },
  })
end, { desc = "Find Dotfiles" })

-- ToggleTerm
map("t", "<c-h", "<cmd>wincmd h", { desc = "Go To Left Terminal", noremap = true, silent = true })
map("t", "<c-j", "<cmd>wincmd j", { desc = "Go To Down Terminal", noremap = true, silent = true })
map("t", "<c-k", "<cmd>wincmd k", { desc = "Go To Above Terminal", noremap = true, silent = true })
map("t", "<c-l", "<cmd>wincmd l", { desc = "Go To Right Terminal", noremap = true, silent = true })
