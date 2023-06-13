return {
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
}
