local opts = {
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  defaults = {
    file_ignore_patterns = {
      "%.git/",
    },
  },
}

local keys = {
  {"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope: Find Files", silent = true, noremap = true},
  {"<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Telescope: Live Search", silent = true, noremap = true},
  {"<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope: Show Buffers", silent = true, noremap = true},
  {"<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Telescope: Help Tags", silent = true, noremap = true},
}

return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.1",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = opts,
  keys = keys,
}
