local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
			-- lsp code actions with telescope
			{
				"aznhe21/actions-preview.nvim",
				dependencies = {
					"nvim-telescope/telescope.nvim",
				},
				opts = {
					backend = { "telescope" },
					telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
				},
				config = function(_, opts)
					require("actions-preview").setup(opts)
					require("core.utils").load_mappings("actions_preview")
				end,
			},
			-- lsp progress visualizer
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				config = function(_, _)
					require("fidget").setup({})
				end,
			},
			-- cmp (auto complete)
			{
				"hrsh7th/nvim-cmp",
				opts = function()
					local M = require("plugins.configs.cmp")
					table.insert(M.sources, { name = "crates" })
					return M
				end,
			},
			-- DAP support
			{
				"mfussenegger/nvim-dap",
				dependencies = {
					"rcarriga/nvim-dap-ui",
					{
						"leoluz/nvim-dap-go", -- "dreamsofcode-io/nvim-dap-go"
						ft = "go",
					},
					{
						"mfussenegger/nvim-dap-python",
						ft = "python",
					},
				},
				init = function()
					require("custom.configs.dap").setup()
					require("core.utils").load_mappings("dap")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.langs.lua")
			require("custom.configs.langs.cpp")
			require("custom.configs.langs.go")
			require("custom.configs.langs.python")
			require("custom.configs.langs.typescript")
		end,
	},
	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
		init = function()
			require("core.utils").load_mappings("nvimtree")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = overrides.telescope,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = overrides.gitsigns,
	},

	-- my plugins
	{
		"wakatime/vim-wakatime",
		event = "VeryLazy",
	},

	{
		"jackMort/ChatGPT.nvim",
		enabled = false,
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "op read op://Work/OpenAI_API_Key/api_key_cmd --no-newline",
				openai_params = {
					model = "gpt-4",
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	{
		"github/copilot.vim",
		enabled = false,
		event = "VeryLazy",
	},

	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		dependencies = "neovim/nvim-lspconfig",
		opts = function()
			require("custom.configs.langs.rust")
		end,
		config = function(_, opts)
			require("rust-tools").setup(opts)
		end,
	},

	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			crates.show()
			require("core.utils").load_mappings("rust")
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		init = function()
			vim.g.lazygit_use_custom_config_file_path = 1
			vim.g.lazygit_config_file_path = "~/.config/lazygit/config.yml"
			require("core.utils").load_mappings("lazygit")
		end,
	},

	{
		"andythigpen/nvim-coverage",
		branch = "main",
		commit = "8fcc71e",
		cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageSummary" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			commands = true,
			load_coverage_cb = function(ftype)
				vim.notify("Loaded " .. ftype .. " coverage") -- TODO change this by nvim notify
			end,
			lang = {
				python = {
					coverage_file = "project/.coverage",
				},
			},
		},
		config = function(_, opts)
			require("coverage").setup(opts)
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},
}

return plugins
