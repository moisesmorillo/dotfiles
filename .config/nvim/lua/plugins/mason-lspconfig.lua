local opts = {
  ensure_installed = {
    "bashls",
    "clangd",
    "eslint",
    "gopls",
    "lua_ls",
    "rust_analyzer",
    "sqlls",
    "tsserver",
    "yamlls",
  },
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  dependencies = {
    {
      "williamboman/mason.nvim",
      cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonUninstallAll" },
      opts = {
        max_concurrent_installers = 10,
        ui = {
          icons = {
            package_installed = "󰞑",
            package_pending = "",
            package_uninstalled = "",
          },
        },
      },
    },
    "neovim/nvim-lspconfig",
  },
  event = "VimEnter",
}
