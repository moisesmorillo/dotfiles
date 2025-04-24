---@type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
  },
  version = false,
  opts = {
    provider = "gemini",
    gemini = {
      model = "gemini-2.5-flash-preview-04-17", --"gemini-2.5-pro-exp-03-25",
    },
    ollama = {
      endpoint = "http://127.0.0.1:11434",
      model = "qwen2.5-coder",
      disable_tools = true,
    },
    file_selector = {
      provider = "snacks",
    },
    selector = {
      provider = "snacks",
    },
    rag_service = {
      enabled = true,
      provider = "ollama",
      endpoint = "http://127.0.0.1:11434",
      host_mount = "~/projects/",
      llm_model = "qwen2.5-coder",
      embed_model = "nomic-embed-text",
    },
  },
}
