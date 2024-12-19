return {
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>tcs",
        function()
          require("coverage").summary()
        end,
        desc = "Show Coverage Summary",
      },
      {
        "<leader>tct",
        function()
          require("coverage").toggle()
        end,
        desc = "Toggle Coverage",
      },
      {
        "<leader>tcl",
        function()
          require("coverage").load(true)
        end,
        desc = "Load Coverage",
      },
    },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>tc", group = "+coverage" },
      },
    },
  },
}
