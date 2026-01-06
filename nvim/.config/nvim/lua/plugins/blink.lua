---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "*",
  enabled = function()
    return not vim.tbl_contains({ "typr" }, vim.bo.filetype)
  end,
  dependencies = {
    { "saghen/blink.compat", version = "*" },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      completion = {
        list = {
          selection = "auto_insert",
        },
      },
    },
  },
}
