---@type MappingsTable
local M = {}
local opts = {
	nowait = true,
	noremap = true,
	silent = true,
}

M.disabled = {
	n = {
		["<C-n>"] = "",
	},
}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = opts },
		["<leader>q"] = { ":q<cr>", "Quit", opts = opts },
		["<leader>pm"] = { "<cmd> Lazy <CR>", "Open Lazy Plugin Manager", opts = opts },
	},
}

M.telescope = {
	plugin = true,
	n = {
		["<leader>fd"] = {
			function()
				require("telescope.builtin").git_files({
					prompt_title = "<Dotfiles>",
					cwd = "~/projects/dotfiles/",
				})
			end,
			"Open dotfiles",
			opts = opts,
		},
		["<leader>fs"] = {
			function()
				require("telescope.builtin").symbols({
					sources = { "emoji", "kaomoji", "gitmoji" },
				})
			end,
			"Open emojis",
		},
	},
}

M.nvimtree = {
	n = {
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
	},
}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint" },
		["<leader>du"] = {
			function()
				require("dapui").toggle()
			end,
			"Toggle UI",
		},
		["<leader>dsb"] = {
			function()
				require("dap").step_back()
			end,
			"Step Back",
		},
		["<leader>ds"] = {
			function()
				require("dap").continue()
			end,
			"Start/Continue",
		},
		["<leader>dsi"] = {
			function()
				require("dap").step_into()
			end,
			"Step Into",
		},
		["<leader>dso"] = {
			function()
				require("dap").step_over()
			end,
			"Step Over",
		},
		["<leader>dsx"] = {
			function()
				require("dap").step_out()
			end,
			"Step Out",
		},

		-- TODO add more debug methods for go
		["<leader>dgt"] = {
			function()
				require("dap-go").debug_test()
			end,
			"Debug go test",
		},
		-- TODO add more debug methods for python
		["<leader>dpt"] = {
			function()
				require("dap-python").test_method()
			end,
			"Debung python test",
		},
	},
}

M.rust = {
	plugin = true,
	n = {
		["<leader>rcu"] = {
			function()
				require("crates").upgrade_all_crates()
			end,
			"Update crates",
		},
	},
}

M.lazygit = {
	plugin = true,
	n = {
		["<leader>lg"] = { "<cmd> LazyGit<CR>", "Open LazyGit" },
	},
}

return M
