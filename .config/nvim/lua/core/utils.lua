local M = {}

function M.nnoremap(shorcut, command)
  vim.api.nvim_set_keymap("n", shorcut, command, { noremap = true, silent = true })
end

return M
