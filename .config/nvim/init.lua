local baseFolder = "mmorillo"
-- Neovim options settings
require(baseFolder..".options")
-- Neovim global settins
require(baseFolder..".globals")
-- Keymaps
require(baseFolder..".keymaps")
-- Plugin package manager settings
require(baseFolder..".packer")
-- Theme, colorscheme settings
require(baseFolder..".theme")
-- Golang specific settings
require(baseFolder..".langs.go")
-- NvimTree settings
require(baseFolder..".nvim-tree")
-- Lualine settings
require(baseFolder..".lualine")
-- Bufferline settings
require(baseFolder..".bufferline")
-- Nvim Treesitter settings
require(baseFolder..".nvim-treesitter")
