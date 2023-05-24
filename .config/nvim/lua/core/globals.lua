local globals = {
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  mapleader = " ",
}

for k, v in pairs(globals) do
  vim.g[k] = v
end
