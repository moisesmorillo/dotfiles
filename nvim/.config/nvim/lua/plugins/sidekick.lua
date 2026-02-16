---@type LazySpec
return {
  "folke/sidekick.nvim",
  opts = function(_, opts)
    ---@type sidekick.Config
    local options = {
      nes = { enabled = false },
      copilot = {
        status = { enabled = false },
      },
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    }
    return vim.tbl_extend("force", opts, options)
  end,
}
