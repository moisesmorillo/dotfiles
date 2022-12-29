local baseFolder = "mmorillo"
-- Neovim options settings
require(baseFolder..".options")
-- Neovim global settins
require(baseFolder..".globals")
-- Keymaps
require(baseFolder..".keymaps")
-- Plugin package manager settings
require(baseFolder..".packer")
-- Golang specific settings
require(baseFolder..".langs.go")
