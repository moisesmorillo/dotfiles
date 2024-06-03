return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {},
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
