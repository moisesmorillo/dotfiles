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
-- 2. MetalVoice control
-----------------------------------------
local METALVOICE = "MetalVoice"

local function isMetalVoiceRunning()
	return hs.application.get(METALVOICE) ~= nil
end

-- Open the popup by clicking the MetalVoice menubar item
local function openMetalVoicePopup()
	local mv = hs.application.get(METALVOICE)
	if not mv then
		return false
	end

	local axApp = hs.axuielement.applicationElement(mv)
	if not axApp then
		return false
	end

	local extras = axApp:attributeValue("AXExtrasMenuBar")
	if not extras then
		return false
	end

	local children = extras:attributeValue("AXChildren")
	if not children or #children == 0 then
		return false
	end

	children[1]:performAction("AXPress")
	return true
end

-- Toggle DeepFilterNet AI on via Accessibility
local function enableDeepFilterNet()
	local mv = hs.application.get(METALVOICE)
	if not mv then
		return
	end

	local app = hs.axuielement.applicationElement(mv)
	if not app then
		return
	end

	app:allDescendantElements(function(_msg, results, count)
		for i = 1, count do
			local el = results[i]
			local role = el:attributeValue("AXRole") or ""
			local value = el:attributeValue("AXValue")
			if role == "AXCheckBox" and value == 0 then
				el:performAction("AXPress")
				print("✅ DeepFilterNet AI activated")
				-- Close the popup by clicking outside (second press on the menubar item)
				hs.timer.doAfter(0.3, function()
					openMetalVoicePopup()
				end)
				return
			end
		end
		print("⚠️ DeepFilterNet checkbox not found or already on")
	end)
end

local function startMetalVoice()
	if not isMetalVoiceRunning() then
		hs.application.launchOrFocus(METALVOICE)
		-- Wait for it to start, open popup, enable DeepFilterNet, close popup
		hs.timer.doAfter(2, function()
			openMetalVoicePopup()
			hs.timer.doAfter(0.5, enableDeepFilterNet)
		end)
	end
end

local function stopMetalVoice()
	local app = hs.application.get(METALVOICE)
	if app then
		app:kill()
	end
end

_G.enableDeepFilterNet = enableDeepFilterNet
_G.openMetalVoicePopup = openMetalVoicePopup

-----------------------------------------
-- 3. Mic indicator in menubar + toggle hotkey
-----------------------------------------
local MIC_ICON = hs.image.imageFromName("NSTouchBarAudioInputTemplate")
local MUTED_ICON = hs.image.imageFromName("NSTouchBarAudioInputMuteTemplate")

local micMenu = hs.menubar.new()

local function updateMicStatus()
	if not micMenu then
		return
	end
	if isMetalVoiceRunning() then
		micMenu:setIcon(MIC_ICON)
		micMenu:setTooltip("MetalVoice: ON · mic live to meetings")
	else
		micMenu:setIcon(MUTED_ICON)
		micMenu:setTooltip("MetalVoice: OFF · no audio to meetings")
	end
end

local function toggleMetalVoice()
	if isMetalVoiceRunning() then
		stopMetalVoice()
		hs.alert.show("MetalVoice OFF · meetings receive silence")
	else
		startMetalVoice()
		hs.alert.show("MetalVoice ON · mic live")
	end
	hs.timer.doAfter(0.5, updateMicStatus)
end

if micMenu then
	micMenu:setClickCallback(toggleMetalVoice)
	hs.timer.doEvery(2, updateMicStatus)
	updateMicStatus()
end

-- Hyper+V: toggle MetalVoice
hs.hotkey.bind({ "cmd", "alt", "ctrl", "shift" }, "v", toggleMetalVoice)

-----------------------------------------
-- 4. Safety net: close MetalVoice when no meeting apps remain
-----------------------------------------
local meetingApps = {
	"zoom.us",
	"Slack",
	"Microsoft Teams",
	"Discord",
	"FaceTime",
}

local function anyMeetingAppRunning()
	for _, name in ipairs(meetingApps) do
		if hs.application.get(name) then
			return true
		end
	end
	return false
end

local appWatcher = hs.application.watcher.new(function(name, event, _app)
	if event == hs.application.watcher.terminated then
		for _, meetingApp in ipairs(meetingApps) do
			if name == meetingApp then
				hs.timer.doAfter(2, function()
					if not anyMeetingAppRunning() and isMetalVoiceRunning() then
						stopMetalVoice()
						hs.alert.show("Meeting ended · MetalVoice OFF")
						updateMicStatus()
					end
				end)
				break
			end
		end
	end
end)
appWatcher:start()
