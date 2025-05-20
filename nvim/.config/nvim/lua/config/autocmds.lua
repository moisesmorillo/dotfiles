vim.api.nvim_create_user_command("UpdateTM", function()
  vim.cmd("TSUpdate")
  local mason_registry = require("mason-registry")
  local installed_packages = mason_registry.get_installed_package_names()
  vim.cmd("MasonInstall " .. table.concat(installed_packages, " "))
end, { desc = "Install/Update treesitter and mason packages" })

-- start TMUX improvements
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  callback = function()
    vim.opt.guicursor = table.concat({
      "n-v-c:block", -- block in normal, visual and command modes
      "i-ci-ve:ver5", -- thin vertical bar in insert mode
      "r-cr:hor20", -- horizontal cursor for replace
      "o:hor50", -- horizontal cursor for operator-pending
      "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- blink style
      "sm:block-blinkwait175-blinkoff150-blinkon175", -- select mode
    }, ",")
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  callback = function()
    -- return to block cursor without blinking when exiting Neovim
    vim.opt.guicursor = "a:ver5-blinkon250-blinkoff400-blinkwait700"
  end,
})
-- end TMUX improvements
