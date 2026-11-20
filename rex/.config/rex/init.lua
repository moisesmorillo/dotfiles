-- Rex configuration: key bindings and custom actions.
-- Appearance (theme, font, tab layout) is not read from this file. Rex keeps it in the
-- macOS preferences domain com.superlogical.rex, which scripts/macos-settings.sh writes.
-- The Rex server reads this file and sends the bindings to every client (Mac, iPhone, iPad).
-- Run `rex config reload` (or press cmd+shift+r) after you change this file.

local TERMINAL = "com.superlogical.terminal"

-- Prefix for the tmux-style bindings. It works on every client:
--   Mac:    tap Caps Lock (Karabiner sends ctrl+space; hold stays Hyper for AeroSpace).
--   iPhone: a ctrl+space key in the Key Bar (Settings > Keyboard > Shortcut Groups).
--   iPad:   ctrl+space on the hardware keyboard.
local PREFIX = "ctrl+space"

local function prefixed(key, action, args)
	rex.bind(PREFIX .. ">" .. key, action, args)
end

-- Return the directory of the focused terminal. The shell does not report its directory
-- (no OSC 7), so read it from the foreground process first.
local function focused_cwd()
	local proc = rex.block.call(TERMINAL, "process", {})
	if proc then
		if proc.foreground and proc.foreground.cwd then
			return proc.foreground.cwd
		end
		for _, ancestor in ipairs(proc.ancestors or {}) do
			if ancestor.cwd then
				return ancestor.cwd
			end
		end
	end
	local reported = rex.block.call(TERMINAL, "pwd", {})
	return reported and reported.pwd or nil
end

-- lazygit in a floating pane that covers the window, in the focused pane's directory.
-- The pane closes when lazygit exits.
rex.action({
	name = "lazygit_float",
	title = "lazygit (floating)",
	category = "Tools",
	keywords = "git lazygit popup",
	run = function(ctx)
		local _, err = rex.session.new_layer({
			window_id = nil,
			bounds = { 0, 0, 1, 1 },
			focus = true,
			layout = rex.layout.block({
				flavor = TERMINAL .. ".shell",
				options = {
					command = { "mise", "exec", "--", "lazygit" },
					cwd = focused_cwd(),
				},
			}),
		})
		if err then
			rex.log("error", "lazygit_float: " .. tostring(err) .. " (session " .. tostring(ctx.session_id) .. ")")
		end
	end,
})

-- Reload this file.
rex.bind("cmd+shift+r", "client.config.reload")

-- Panes: focus (h j k l), resize (shift+h j k l), split, zoom, close.
prefixed("h", "pane.focus.left")
prefixed("j", "pane.focus.down")
prefixed("k", "pane.focus.up")
prefixed("l", "pane.focus.right")
prefixed("shift+h", "pane.resize", { direction = "left" })
prefixed("shift+j", "pane.resize", { direction = "down" })
prefixed("shift+k", "pane.resize", { direction = "up" })
prefixed("shift+l", "pane.resize", { direction = "right" })
prefixed("-", "pane.split.down")
prefixed("shift+\\", "pane.split.right") -- | on a US layout
prefixed("z", "pane.zoom")
prefixed("x", "pane.close")

-- Tabs: new, next, previous, go to 1-9.
prefixed("c", "client.tab.new")
prefixed("n", "client.tab.next")
prefixed("p", "client.tab.previous")
for i = 1, 9 do
	prefixed(tostring(i), "client.tab.goto", { index = i })
end

-- Sessions.
prefixed("w", "session.switch")
prefixed("shift+s", "session.new")

-- Tools.
prefixed("g", "lazygit_float")
prefixed("[", "pane.copy_mode.enter") -- Mac only
prefixed("r", "client.config.reload") -- Mac only

-- Press the prefix twice to send one ctrl+space to the program (Neovim completion menu).
prefixed(PREFIX, "pane.send_key", { key = PREFIX })
