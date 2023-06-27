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
	},
}

M.nvimtree = {
	plugin = true,
	n = {
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
	},
}

M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint" },
		["<leader>ds"] = {
			function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.toggle() -- TODO fix this, is only opening new sidebars
			end,
			"Toggle debugging sidebar",
		},
	},
}

M.dap_go = {
	plugin = true,
	n = {
		["<leader>dgt"] = {
			function()
				require("dap-go").debug_test()
			end,
			"Debug go test",
		},
	},
}

M.dap_python = {
	plugin = true,
	n = {
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
