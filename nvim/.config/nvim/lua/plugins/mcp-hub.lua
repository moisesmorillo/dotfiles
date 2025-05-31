---@type LazySpec
return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
  opts = {
    auto_approve = true,
    extensions = {
      avante = {
        make_slash_commands = true, -- make /slash commands from MCP server prompts
      },
    },
    use_bundled_binary = true,
  },
}
