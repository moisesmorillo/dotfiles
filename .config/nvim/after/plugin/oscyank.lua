vim.api.nvim_command(
  [[
  autocmd TextYankPost * if v:event.operator is 'y' | execute 'OSCYankRegister' | endif
  ]]
)
