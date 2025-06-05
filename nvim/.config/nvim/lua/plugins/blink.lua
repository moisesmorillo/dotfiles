---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    { "saghen/blink.compat", version = "*" },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      per_filetype = {
        codecompanion = { "codecompanion" },
      },
    },
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
