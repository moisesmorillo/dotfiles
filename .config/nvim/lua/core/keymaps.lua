vim.g.mapleader = " "

local utils = require("core.utils")

-- Save file
utils.nnoremap("<leader>w", ":w<cr>")

-- Quit
utils.nnoremap("<leader>q", ":q<cr>")

-- Close Buffer
utils.nnoremap("<leader>bd", ":bd<cr>")
-- Next Buffer
utils.nnoremap("<leader>bn", ":bn<cr>")
-- Previous Buffer (before)
utils.nnoremap("<leader>bb", ":bp<cr>")

-- Turn off highlighting until next search using ctr+l
utils.nnoremap("<c-l>", ":noh<cr>")

-- Open/Quit NvimTree
utils.nnoremap("<s-tab>", ":NvimTreeToggle<cr>")

-- Open new buffer
utils.nnoremap("<leader>n", ":enew<cr>")

-- Telescope
local ok, _ = pcall(require, "telescope.builtin")

if ok then
  utils.nnoremap("<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
  utils.nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
  utils.nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")
  utils.nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")
end

-- Clear search highlight
utils.nnoremap("<esc>", ":noh<CR>")

-- Golang specific mappings
vim.cmd [[
  autocmd FileType go nnoremap <leader>gb <plug>(go-build)
  autocmd FileType go nnoremap <leader>gr <plug>(go-run)
  autocmd FileType go nnoremap <leader>gt :GoTest ./...<cr>
  autocmd FileType go nnoremap <leader>gtf <plug>(go-test-func)
  autocmd FileType go nnoremap <leader>gc <plug>(go-coverage-toggle)
  autocmd FileType go nnoremap <c-n> :cnext<cr>
  autocmd FileType go nnoremap <c-p> :cprevious<cr>
  autocmd FileType go nnoremap <c-a> :cclose<cr>
]]

-- Github Copitlot mappings
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-H>", 'copilot#Previous()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Next()', { silent = true, expr = true })
