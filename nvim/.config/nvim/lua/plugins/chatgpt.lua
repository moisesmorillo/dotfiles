return {
	"jackMort/ChatGPT.nvim",
	cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		openai_params = {
			model = "gpt-4-1106-preview",
		},
		openai_edit_params = {
			model = "gpt-4-1106-preview",
		},
	},
}
