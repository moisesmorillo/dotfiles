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
-- Open new buffer
utils.nnoremap("<leader>n", ":enew<cr>")
