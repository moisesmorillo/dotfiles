return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-jest",
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
}
