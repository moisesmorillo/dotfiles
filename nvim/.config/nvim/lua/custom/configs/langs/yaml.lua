local ft = { "yaml", "yaml.docker-compose" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "yaml-language-server", "yamlfmt", "yamllint" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "yaml" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = ft,
    opts = {
      servers = {
        yamlls = {
          filetypes = ft,
          settings = {
            redhat = { telemetry = { enabled = true } },
            yaml = {
              validate = true,
              completion = true,
              hover = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemas = {
                kubernetes = "kubernetes/*.{yml,yaml}",
                 -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/actions/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                ["https://json.schemastore.org/golangci-lint"] = ".golangci.{yml,yaml}",
                ["https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json"] = "serverless.{yml,yaml}",
              },
            },
          },
        },
      },
    },
  },

  {
    ft = ft,
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.diagnostics.yamllint,
        b.formatting.yamlfmt,
      })
    end,
  },
}

return plugins
