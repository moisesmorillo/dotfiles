local opts = {
    ensure_installed = {
        "bash",
        "cpp",
        "dockerfile",
        "go",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "mermaid",
        "ninja",
        "python",
        "rust",
        "sql",
        "terraform",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      }
}

return { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    opts = opts,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
}