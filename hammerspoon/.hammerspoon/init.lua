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

-----------------------------------------
-- 2. Global Mic Mute Toggle
-----------------------------------------
local MIC_ICON = hs.image.imageFromName("NSTouchBarAudioInputTemplate")
local MUTED_ICON = hs.image.imageFromName("NSTouchBarAudioInputMuteTemplate")

local micMenu = hs.menubar.new()

local function getDefaultInputDevice()
	return hs.audiodevice.defaultInputDevice()
end

local function isMicMuted()
	local device = getDefaultInputDevice()
	if not device then
		return false
	end
	return device:inputMuted()
end

local function updateMicMenu()
	if not micMenu then
		return
	end

	local muted = isMicMuted()
	if muted then
		micMenu:setIcon(MUTED_ICON)
		micMenu:setTooltip("🎤 Mic MUTED (click or Hyper+E to unmute)")
	else
		micMenu:setIcon(MIC_ICON)
		micMenu:setTooltip("🎤 Mic LIVE (click or Hyper+E to mute)")
	end
end

local function toggleMicMute()
	local device = getDefaultInputDevice()
	if not device then
		hs.alert.show("🎤 No input device found")
		return
	end

	local muted = device:inputMuted()
	device:setInputMuted(not muted)

	hs.timer.doAfter(0.1, function()
		local newState = isMicMuted()
		if newState then
			hs.alert.show("🎤 Mic MUTED")
		else
			hs.alert.show("🎤 Mic LIVE")
		end
		updateMicMenu()
	end)
end

if micMenu then
	micMenu:setClickCallback(toggleMicMute)
	hs.timer.doEvery(2, updateMicMenu)
	updateMicMenu()
end

-- Hyper+E: toggle global mic mute
hs.hotkey.bind({ "cmd", "alt", "ctrl", "shift" }, "e", toggleMicMute)
