---@type NvPluginSpec[]
local plugins = {
  {
    "Exafunction/codeium.vim",
    event = "BufReadPost",
    enabled = false,
    build = ":Codeium Auth",
    config = function()
      vim.g.codeium_disable_bindings = 1
      require("core.utils").load_mappings "codeium"
    end,
  },

  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      openai_params = {
        model = "gpt-4-32k",
      },
      openai_edit_params = {
        model = "gpt-4-32k",
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = true,
    event = "BufReadPost",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<A-CR>",
          dismiss = "<Esc>",
          next = "<C-]>",
          prev = "<C-[>",
        },
      },
    },
  },
}

return plugins
