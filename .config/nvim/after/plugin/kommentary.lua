local ok, kommentary = pcall(require, "kommentary.config")

if ok then
  kommentary.configure_language("go", {
    single_line_commnet_string = "//",
    multi_line_comment_string = {"/*", "*/"},
  })
else
  print("Module kommentary not found")
end
