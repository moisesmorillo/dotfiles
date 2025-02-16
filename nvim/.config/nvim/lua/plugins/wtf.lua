---@type LazySpec
return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    openai_model_id = "gpt-4o",
    popup_type = "vertical",
  },
  keys = {
    {
      "gw",
      function()
        require("wtf").ai()
      end,
      desc = "Search diagnostic with AI",
    },
    {
      "gW",
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Google",
    },
  },
}
