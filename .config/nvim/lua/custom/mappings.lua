---@type MappingsTable
local M = {}
local opts = {
  nowait = true,
  noremap = true,
  silent = true,
}

M.disabled = {
  n = {
      ["<C-n>"] = ""
  }
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = opts, },
    ["<C-q>"] = { ":q<cr>", "Quit", opts = opts, },

    --Tree
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },
}

return M
