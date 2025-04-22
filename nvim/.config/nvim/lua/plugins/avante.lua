---@type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  version = "*",
  opts = {
    provider = "ollama",
    vendors = {
      ollama = {
        __inherited_from = "openai",
        api_key_name = "",
        endpoint = "http://127.0.0.1:11434/v1",
        model = "qwen2.5-coder",
      },
    },
    file_selector = {
      profider = "snacks",
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
  build = "make",
}
