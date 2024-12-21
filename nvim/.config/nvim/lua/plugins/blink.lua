return {
  "saghen/blink.cmp",
  opts = {
    appearance = {
      use_nvim_cmp_as_default = true,
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
