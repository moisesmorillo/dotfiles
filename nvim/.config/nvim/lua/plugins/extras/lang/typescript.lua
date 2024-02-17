return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "typescript-language-server", "js-debug-adapter" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		-- disable tsserver from LazyVim
		opts = {
			setup = {
				tsserver = function(_, _)
					return true
				end,
			},
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = function()
			return {
				settings = {
					expose_as_code_action = "all",
					complete_function_calls = true,
				},
			}
		end,
	},
	{
		"nvim-neotest/neotest",
		-- TODO: remove commit version after this PR is merged https://github.com/nvim-neotest/neotest-jest/pull/100
		dependencies = {
			{ "nvim-neotest/neotest-jest", commit = "6ea51a1b9fd65c36f58729267b4a9abd992d05a4" },
		},
		opts = {
			adapters = {
				["neotest-jest"] = {
					jestCommand = "npx jest --coverage --ci",
					env = { NODE_OPTIONS = "--experimental-vm-modules" },
				},
			},
		},
	},
	{
		"danymat/neogen",
		opts = {
			languages = {
				javscript = {
					template = {
						annotation_convention = "jsdoc",
					},
				},

				typescript = {
					template = {
						annotation_convention = "tsdoc",
					},
				},
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		opts = function(_, _)
			local dap = require("dap")
			if not dap.adapters["pwa-node"] then
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "127.0.0.1",
					port = "${port}",
					executable = {
						command = "node",
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			for _, language in ipairs({ "typescript", "javascript" }) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
				end
			end
		end,
	},
}
