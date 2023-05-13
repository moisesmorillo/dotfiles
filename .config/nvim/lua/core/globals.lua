local globals = {
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
}

for k, v in pairs(globals) do
  vim.g[k] = v
end
