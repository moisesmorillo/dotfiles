local options = {
  go_highlight_build_constraints = 1,
  go_highlight_extra_types = 1,
  go_highlight_fields = 1,
  go_highlight_functions = 1,
  go_highlight_methods = 1,
  go_highlight_operators = 1,
  go_highlight_structs = 1,
  go_highlight_types = 1,
  go_auto_sameids = 1,
  go_fmt_command = "goimports",
  go_auto_type_info = 1,
  go_textobj_include_function_doc = 0,
  go_highlight_function_calls = 1,
  go_highlight_generate_tag = 1,
}


for k, v in pairs(options) do
  vim.g[k] = v
end
