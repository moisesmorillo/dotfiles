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
  },
  auto_install = true,
})
