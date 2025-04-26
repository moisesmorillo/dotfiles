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
    provider = "openrouter",
    vendors = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "google/gemini-2.5-flash-preview",
        disable_tools = true,
      },
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
