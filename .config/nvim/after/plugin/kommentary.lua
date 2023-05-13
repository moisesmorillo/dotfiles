local ok, kommentary = pcall(require, "kommentary.config")
if not ok then return false end

kommentary.configure_language("go", {
  single_line_commnet_string = "//",
  multi_line_comment_string = { "/*", "*/" },
})
