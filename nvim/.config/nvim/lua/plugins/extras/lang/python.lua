return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-python",
		},
		opts = {
			adapters = {
				["neotest-python"] = {
					dap = { justMyCode = false },
					runner = "pytest",
					is_test_file = function(file_path)
						return string.match(file_path, ".py$") ~= nil and string.match(file_path, "test?") ~= nil
					end,
				},
			},
		},
	},
	{
		"danymat/neogen",
		opts = {
			languages = {
				python = {
					template = {
						annotation_convention = "numpydoc",
					},
				},
			},
		},
	},
}
