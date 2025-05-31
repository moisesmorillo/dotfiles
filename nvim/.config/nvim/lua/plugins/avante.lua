---@type LazySpec
return {
  "yetone/avante.nvim",
  build = "make",
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "avante: ask" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
    "ravitemer/mcphub.nvim",
    "zbirenbaum/copilot.lua",
  },
  version = false,
  opts = {
    cursor_applying_provider = "copilot",
    behaviour = {
      auto_apply_diff_after_generation = true,
      enable_cursor_planning_mode = true,
      use_cwd_as_project_root = true,
    },
    provider = "copilot",
    copilot = {
      model = "claude-3.7-sonnet-thought",
    },
    vendors = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "google/gemini-2.5-flash-preview",
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
    web_search_engine = {
      provider = "brave",
    },
    windows = {
      position = "left",
    },
    -- system_prompt as function ensures LLM always has latest MCP server state
    -- This is evaluated for every message, even in existing chats
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    -- Using function prevents requiring mcphub before it's loaded
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
    -- disabled_tools to avoid conflicts with mcphub
    disabled_tools = {
      "list_files", -- Built-in file operations
      "search_files",
      "read_file",
      "create_file",
      "rename_file",
      "delete_file",
      "create_dir",
      "rename_dir",
      "delete_dir",
      "bash", -- Built-in terminal access
    },
  },
}
