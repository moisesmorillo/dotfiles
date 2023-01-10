vim.g.mapleader = " "

local utils = require("core.utils")
local builtin = require("telescope.builtin")

-- Save file
utils.nnoremap("<leader>w", ":w<cr>")

-- Quit
utils.nnoremap("<leader>q", ":q<cr>")

-- Turn off highlighting until next search using ctr+l
utils.nnoremap("<c-l>", ":noh<cr>")

-- Open/Quit NvimTree
utils.nnoremap("<s-tab>", ":NvimTreeToggle<cr>")

-- Telescope
utils.nnoremap("<leader>ff", "<cmd>Telescope find_files hidden=true<cr>")
utils.nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
utils.nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")
utils.nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Clear search highlight
utils.nnoremap("<esc>", ":noh<CR>")

-- Golang specific mappings
vim.cmd [[
  autocmd FileType go nnoremap <leader>b <plug>(go-build)
  autocmd FileType go nnoremap <leader>r <plug>(go-run)
  autocmd FileType go nnoremap <leader>t :GoTest ./...<cr>
  autocmd FileType go nnoremap <leader>tf <plug>(go-test-func)
  autocmd FileType go nnoremap <leader>c <plug>(go-coverage-toggle)
  autocmd FileType go nnoremap <c-n> :cnext<cr>
  autocmd FileType go nnoremap <c-p> :cprevious<cr> 
  autocmd FileType go nnoremap <c-a> :cclose<cr> 
]]

