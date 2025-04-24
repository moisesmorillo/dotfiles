---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "*",
  enabled = function()
    return not vim.tbl_contains({ "AvanteInput" }, vim.bo.filetype)
  end,
  dependencies = {
    { "saghen/blink.compat", version = "*" },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      compat = {
        "avante_commands",
        "avante_mentions",
        "avante_files",
      },
      providers = {
        avante_commands = {
          name = "avante_commands",
          module = "blink.compat.source",
          score_offset = 90, -- show at a higher priority than lsp
          opts = {},
        },
        avante_files = {
          name = "avante_files",
          module = "blink.compat.source",
          score_offset = 100, -- show at a higher priority than lsp
          opts = {},
        },
        avante_mentions = {
          name = "avante_mentions",
          module = "blink.compat.source",
          score_offset = 1000, -- show at a higher priority than lsp
          opts = {},
        },
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
