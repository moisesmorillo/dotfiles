return {
  "folke/edgy.nvim",
  opts = function(_, opts)
    local left = opts.left or {}
    local right = opts.right or {}

    for i, v in ipairs(right) do
      if v.ft == "copilot-chat" then
        vim.print("Removing Copilot Chat from the right side")
        table.remove(right, i)
        break
      end
    end

    vim.list_extend(left, {
      {
        ft = "copilot-chat",
        title = "Copilot Chat",
        pinned = true,
        open = function()
          vim.cmd("Neotree close")
          vim.cmd("CopilotChat toggle")
        end,
      },
    })

    -- Swap the left and right sides, and leave the right side empty for NeoTree
    opts.left = right
    opts.right = left
    opts.options = {
      right = {
        size = 50,
      },
    }
    opts.animate = {
      enabled = false,
    }

    return opts
  end,
}
