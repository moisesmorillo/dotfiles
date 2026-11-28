#!/bin/bash

# Close System Preferences to avoid overriding settings
osascript -e 'tell application "System Preferences" to quit'

################################################################################
# System Preferences > General > Language & Region
################################################################################
defaults write ".GlobalPreferences_m" AppleLanguages -array en-CO en-US
defaults write ".GlobalPreferences_m" AppleLocale -string "en_CO"
defaults write -globalDomain AppleLanguages -array en-CO en-US
defaults write -globalDomain AppleFirstWeekday -dict gregorian -int 2

################################################################################
# System Preferences > Keyboard
################################################################################
defaults write -globalDomain AppleKeyboardUIMode -int 0
# Fast key repeat for Neovim and terminal work. Takes effect after you log out and in.
defaults write -globalDomain InitialKeyRepeat -int 15
defaults write -globalDomain KeyRepeat -int 2

################################################################################
# Finder
################################################################################
defaults write com.apple.finder QuitMenuItem -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

################################################################################
# System Preferences > Desktop & Dock
################################################################################
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock largesize -float 85
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -float 50
defaults write com.apple.dock "show-recents" -bool False
defaults write com.apple.dock region -string "CO"

################################################################################
# System Preferences > Control Center
################################################################################
defaults write "com.apple.controlcenter" "NSStatusItem Visible Bluetooth" -bool true
defaults write "com.apple.controlcenter" "NSStatusItem Visible Battery" -bool true
defaults write "com.apple.controlcenter" "NSStatusItem Visible Sound" -bool true
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

################################################################################
# System Preferences > Accessibility
################################################################################
# Keep motion on: Rex turns its animations off when Reduce Motion is on.
defaults write com.apple.Accessibility ReduceMotionEnabled -int 0

###############################################################################
# AeroSpace & Tiling Window Management                                        #
###############################################################################

# Disable Mission Control shortcuts that conflict with AeroSpace (Alt + Numbers/Arrows)
# This releases the keys so AeroSpace can capture them.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{enabled = 0;}"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{enabled = 0;}"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{enabled = 0;}"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "{enabled = 0;}"

# Group windows by application (Crucial for AeroSpace stability with Mission Control)
defaults write com.apple.dock expose-group-apps -bool true

# Disable automatic Space rearranging based on most recent use
defaults write com.apple.dock "mru-spaces" -bool false

# Keep transparency on: Rex Glass needs it.
defaults write com.apple.Accessibility ReduceTransparencyEnabled -int 0

# Accelerate window resizing animation
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable Press and Hold only in editors/terminals (keep accent popup globally)
# Remove any global override so macOS uses its default (press-and-hold enabled)
defaults delete NSGlobalDomain ApplePressAndHoldEnabled 2>/dev/null || true
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.superlogical.rex ApplePressAndHoldEnabled -bool false

################################################################################
# Rex
################################################################################
# Rex keeps its appearance in this preferences domain, not in ~/.config/rex/init.lua.
# Quit Rex before you run this section, or Rex writes its old values back when it quits.
REX_THEMES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/rex/.config/rex/themes/custom-themes.json"
if [ -f "$REX_THEMES" ]; then
	# Rex stores its custom themes as a JSON array in a data value.
	defaults write com.superlogical.rex Workspace.customThemes -data "$(xxd -p "$REX_THEMES" | tr -d '\n')"
	defaults write com.superlogical.rex Workspace.darkThemeID -string "custom-8AABDBA9-F09D-4F43-97BB-968B906E5372"
fi
defaults write com.superlogical.rex Workspace.appearance -string "dark"
defaults write com.superlogical.rex Workspace.lightThemeID -string "merino-light"
defaults write com.superlogical.rex Workspace.interfaceStyle -string "useTheme"
defaults write com.superlogical.rex Workspace.usesPaneGlass -bool true
defaults write com.superlogical.rex Workspace.terminalFontName -string "JetBrainsMono Nerd Font Mono"
defaults write com.superlogical.rex Workspace.terminalFontPointSize -string "17.5"
defaults write com.superlogical.rex Workspace.paneDensity -string "comfortable"
defaults write com.superlogical.rex Workspace.showsPaneHeaders -bool true
defaults write com.superlogical.rex Workspace.inactivePaneFadeMode -string "both"
defaults write com.superlogical.rex Workspace.tabIconTintMode -string "off"
# Vertical tabs in a sidebar on the left.
defaults write com.superlogical.rex Workspace.tabStyle -string "vertical"
defaults write com.superlogical.rex Workspace.sidebarPosition -string "left"
defaults write com.superlogical.rex Workspace.sidebarTextPointSize -float 15
defaults write com.superlogical.rex rex.agents.names-sessions -bool true

# Restart affected apps
for app in "Dock" "Finder" "SystemUIServer"; do
	killall "${app}" >/dev/null 2>&1
done
