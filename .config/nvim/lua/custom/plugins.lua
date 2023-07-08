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
			-- lsp progress visualizer
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				config = function(_, _)
					require("fidget").setup({})
				end,
			},
			-- DAP support
			{
				"mfussenegger/nvim-dap",
				init = function()
					vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
					require("core.utils").load_mappings("dap")
				end,
			},
			{
				"rcarriga/nvim-dap-ui",
				dependencies = "mfussenegger/nvim-dap",
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup()
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.langs.lua")
			require("custom.configs.langs.go")
			require("custom.configs.langs.python")
			require("custom.configs.langs.typescript")
		end, -- Override to setup mason-lspconfig
	},

	{
		"hrsh7th/nvim-cmp",
		opts = function()
			local M = require("plugins.configs.cmp")
			table.insert(M.sources, { name = "crates" })
			return M
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
		config = function()
			require("core.utils").load_mappings("dotfiles")
		end,
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
		"leoluz/nvim-dap-go", -- "dreamsofcode-io/nvim-dap-go"
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		init = function()
			require("core.utils").load_mappings("dap_go")
		end,
		config = function(_, opts)
			require("dap-go").setup(opts)
		end,
	},

	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, _)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
			require("core.utils").load_mappings("dap_python")
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function(_, _)
			vim.g.lazygit_use_custom_config_file_path = 1
			vim.g.lazygit_config_file_path = "~/.config/lazygit/config.yml"
			require("core.utils").load_mappings("lazygit")
		end,
	},
}

return plugins
