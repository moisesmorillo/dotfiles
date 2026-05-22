-- Hammerspoon configuration
-- https://www.hammerspoon.org/

-----------------------------------------
-- 1. Auto-reload configuration
-----------------------------------------
local function reloadConfig(paths)
	local doReload = false
	for _, file in pairs(paths) do
		if file:sub(-4) == ".lua" then
			doReload = true
			break
		end
	end
	if doReload then
		hs.reload()
	end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded", 2)
