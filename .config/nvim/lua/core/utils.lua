local M = {}

function M.nnoremap(shorcut, command, options)
  local opts = vim.tbl_extend("keep", {
    noremap = true,
    silent = true,
  }, options or {})

  vim.keymap.set("n", shorcut, command, opts)
end

return M
