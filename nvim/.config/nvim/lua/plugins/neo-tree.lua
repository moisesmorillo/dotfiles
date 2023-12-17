local get_buff_cwd = function()
	local buffer_id = vim.api.nvim_get_current_buf()
	local buffer_path = vim.api.nvim_buf_get_name(buffer_id)
	local buffer_directory = vim.fn.fnamemodify(buffer_path, ":h:h")
	return buffer_directory
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	keys = function()
		return {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ dir = vim.fn.getcwd(), reveal = true, toggle = true })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ dir = get_buff_cwd(), reveal = true, toggle = true })
				end,
				desc = "Explorer NeoTree (buffer cwd)",
			},
		}
	end,
	opts = {
		filesystem = {
			filtered_items = {
				hide_by_name = {
					"node_modules",
				},
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		},
		window = {
			position = "float",
		},
	},
}
