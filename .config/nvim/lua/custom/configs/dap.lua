local M = {}

local set_dap_breakpoint_signs = function()
	local breakpoint_signs = {
		error = {
			text = "🔴",
			texthl = "LspDiagnosticsSignError",
			linehl = "",
			numhl = "",
		},
		rejected = {
			text = "",
			texthl = "LspDiagnosticsSignHint",
			linehl = "",
			numhl = "",
		},
		stopped = {
			text = "⭐️",
			texthl = "LspDiagnosticsSignInformation",
			linehl = "DiagnosticUnderlineInfo",
			numhl = "LspDiagnosticsSignInformation",
		},
	}

	vim.fn.sign_define("DapBreakpoint", breakpoint_signs.error)
	vim.fn.sign_define("DapStopped", breakpoint_signs.stopped)
	vim.fn.sign_define("DapBreakpointRejected", breakpoint_signs.rejected)
end

local set_dap_ui = function()
	local dap, dapui = require("dap"), require("dapui")
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
end

local set_debuggers = function()
	require("dap-go").setup()
	local debugpy_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
	require("dap-python").setup(debugpy_path)
end

M.setup = function()
	set_dap_breakpoint_signs()
	set_dap_ui()
	require("core.utils").load_mappings("dap")
	set_debuggers()
end

return M
