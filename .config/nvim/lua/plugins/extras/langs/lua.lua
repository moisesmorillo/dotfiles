local opts = {
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      completion = {
        autoRequire = true,
        enable = true,
        callSnippet = "Both",
        displayContext = true,
        showParams = true,
      },
      diagnostics = {
        enable = true,
        globals = { "vim" },
        workspaceDelay = 500,
      },
      hint = {
        enable = true,
        paramName = "all",
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua/core",
          vim.api.nvim_get_runtime_file("", true),
        },
        checkThirdParty = false,
      }
    },
  },
}

return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls" },
    },
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = { "stylua" },
      automatic_installation = false,
    },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    --[[ config = function()
      --require("your.null-ls.config") -- require your null-ls config here (example below)
    end, ]]
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    opts = opts,
    config = function(_, plugin_opts)
      require("lspconfig").lua_ls.setup(plugin_opts)
    end,
  }
}
