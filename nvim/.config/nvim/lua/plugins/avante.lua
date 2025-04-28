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
    cursor_applying_provider = "groq",
    behaviour = {
      auto_apply_diff_after_generation = true,
      enable_cursor_planning_mode = true,
      use_cwd_as_project_root = true,
    },
    provider = "openrouter",
    vendors = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "openai/gpt-4.1-mini",
      },
      groq = {
        __inherited_from = "openai",
        api_key_name = "GROQ_API_KEY",
        endpoint = "https://api.groq.com/openai/v1/",
        model = "llama-3.3-70b-versatile",
        max_completion_tokens = 32768,
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
    web_search_engine = {
      provider = "brave",
    },
  },
}
