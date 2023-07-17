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
defaults write -globalDomain InitialKeyRepeat -float 25
defaults write -globalDomain KeyRepeat -float 2

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
defaults write com.apple.dock autohide-time-modifier -float 0.5
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
# System Preferences > Desktop & Dock
################################################################################
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1

# Restart affected apps
for app in "Dock" "Finder" "SystemUIServer"; do
	killall "${app}" >/dev/null 2>&1
done
