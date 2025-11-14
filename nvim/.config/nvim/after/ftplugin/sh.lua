local filename = vim.fn.expand("%:t")

if filename:match("^%.env") or filename:match("%.env$") then
  vim.diagnostic.enable(false, { bufnr = 0 })
end
