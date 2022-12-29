require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "cpp", 
    "lua", 
    "rust", 
    "python", 
    "javascript", 
    "go",
    "json",
    "jsonc",
    "help",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})
