return {
	-- This will extend the extra go LazyVim setting https://www.lazyvim.org/extras/lang/go
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				go = { "golangcilint" },
			},
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-go",
		},
		keys = {
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.fn.getcwd())
				end,
				desc = "Run All Test Files",
			},
		},
		opts = {
			adapters = {
				["neotest-go"] = {
					experimental = {
						test_table = true,
					},
					recursive_run = true,
				},
			},
		},
	},
	{
		"danymat/neogen",
		opts = function(_, opts)
			opts = vim.tbl_deep_extend("force", opts or {}, {
				languages = {
					go = {
						template = {
							annotation_convention = "godoc",
						},
					},
				},
			})
			return opts
		end,
	},
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		dependencies = {
			"ray-x/guihua.lua",
		},
		opts = {},
		event = { "CmdlineEnter" },
		build = ":lua require(\"go.install\").update_all_sync()",
	},
}
