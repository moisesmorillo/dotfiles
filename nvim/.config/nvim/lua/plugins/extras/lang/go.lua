---@type LazySpec[]
return {
  -- This will extend the extra go LazyVim setting https://www.lazyvim.org/extras/lang/go
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "golangci-lint" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },
  {
    "ray-x/go.nvim",
    enabled = false,
    ft = { "go", "gomod" },
    dependencies = {
      "ray-x/guihua.lua",
    },
    opts = {},
    event = { "CmdlineEnter" },
    build = ":lua require(\"go.install\").update_all_sync()",
  },
}
