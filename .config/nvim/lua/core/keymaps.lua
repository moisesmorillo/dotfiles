vim.g.mapleader = " "

local nnoremap = function(shorcut, command) 
  vim.api.nvim_set_keymap("n", shorcut, command, { noremap = true, silent = true })
end
local builtin = require("telescope.builtin")

-- Save file
nnoremap("<leader>w", ":w<cr>")

-- Quit from current mode
nnoremap("<leader>q", ":q<cr>")

-- Turn off highlighting until next search using ctr+l
nnoremap("<c-l>", ":noh<cr>")

-- Open/Quit NvimTree
nnoremap("<s-tab>", ":NvimTreeFocus<cr>")

-- Telescope
nnoremap("<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")
nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Clear search highlight
nnoremap("<esc>", ":noh<CR>")

