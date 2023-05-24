-- Disable tmux status bar when starting neovim
vim.cmd [[
    autocmd VimEnter,VimLeave * silent !tmux set status
]]

local baseFolder = "core"
-- Neovim diagnostic settings
require(baseFolder .. ".diagnostic")
-- Neovim options settings
require(baseFolder .. ".options")
-- Neovim global settins
require(baseFolder .. ".globals")
-- Keymaps
require(baseFolder .. ".keymaps")
-- Lazy Plugin Manager
require(baseFolder .. ".lazy")
