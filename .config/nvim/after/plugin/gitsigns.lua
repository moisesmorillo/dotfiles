local ok, gitsigns = pcall(require, "gitsigns")

if ok then
  gitsigns.setup({
    current_line_blame = true
 })
else
  print("Module gitsigns not found")
end
