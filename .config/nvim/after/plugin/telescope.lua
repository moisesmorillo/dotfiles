local utils = require("core.utils")
local ok, builtin = pcall(require, "telescope.builtin")
if not ok then return false end

utils.nnoremap("<leader>ff", function() builtin.find_files({ hidden = true }) end)
utils.nnoremap("<leader>fg", builtin.live_grep)
utils.nnoremap("<leader>fb", builtin.buffers)
utils.nnoremap("<leader>fh", builtin.help_tags)
