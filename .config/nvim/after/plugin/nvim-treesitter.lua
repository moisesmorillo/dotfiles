local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if ok then
  treesitter.setup({
    ensure_installed = {
      "cpp",
      "lua",
      "rust",
      "python",
      "javascript",
      "go",
      "json",
      "jsonc",
      "jsdoc",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
  })
else
  print("Module nvim-treesitter not found")
end
