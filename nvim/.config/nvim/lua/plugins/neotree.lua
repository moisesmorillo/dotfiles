return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {
				"node_modules",
			},
		},
		window = {
			position = "float",
		},
	},
}
