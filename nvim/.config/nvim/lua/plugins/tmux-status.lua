---@type LazySpec
return {
  "christopher-francisco/tmux-status.nvim",
  event = "VeryLazy",
  cond = function()
    return vim.env.TMUX ~= nil
  end,
  opts = {},
}
