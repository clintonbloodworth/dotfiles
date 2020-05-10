#!/usr/bin/env zsh

###################################################################
# Start
###################################################################

# Ask for sudo up front and keep alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###################################################################
# Install Tools
###################################################################

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew analytics off
brew install fzf && /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
brew bundle --file=~/.homebrew

# Mackup
ln -s ~/iCloud/Work/Mackup/.mackup.cfg ~
ln -s ~/iCloud/Work/Mackup/.mackup ~
mackup restore --force

# Fish
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fisher

# Node.js and NPM
n lts
npm i -g caniuse-cli
npm i -g cpy-cli
npm i -g emma-cli
npm i -g fkill-cli
npm i -g fx
npm i -g gzip-size-cli
npm i -g http-server
npm i -g npm-check
npm i -g is-online-cli
npm i -g trash-cli

# Rust
cargo install tokei

# Shell
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish

###################################################################
# Install Applications
###################################################################

echo Installing XCode
sudo xcodebuild -license accept && xcode-select --install
ln -s /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app /Applications/

###################################################################
# Change Application Settings
###################################################################

# Brave
defaults write com.brave.Browser AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.brave.Browser AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.brave.Browser PMPrintingExpandedStateForPrint2 -bool false

# Mail
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail PlayMailSounds -bool false
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Safari
defaults write -g AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
defaults write com.apple.Safari HistoryAgeInDaysLimit -int 31
defaults write com.apple.Safari HomePage -string 'about:blank'
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari NewTabBehavior -int 1
defaults write com.apple.Safari NewWindowBehavior -int 1
defaults write com.apple.Safari ProxiesInBookmarksBar '()'
defaults write com.apple.Safari ReadingListSaveArticlesOfflineAutomatically -bool true
defaults write com.apple.Safari ShowFavoritesBar -bool false
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari ShowStatusBar -boolean true
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true #  Tab to highlight each item on a web page
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true #  Tab to highlight each item on a web page
defaults write com.apple.finder NewWindowTarget -string 'PfHm' # New windows open at $HOME

# xScope
defaults write com.iconfactory.mac.xScope generalShowDockIcon 0
defaults write com.iconfactory.xScope generalShowDockIcon 0

###################################################################
# Change System Settings
###################################################################

# Dock
defaults write -g AppleWindowTabbingMode -string 'always'
defaults write com.apple.dock expose-animation-duration -int 0.1
defaults write com.apple.dock mineffect -string 'scale'
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock persistent-apps -array # Remove default apps from the Dock
defaults write com.apple.dock show-process-indicators -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock showAppExposeGestureEnabled -bool false
defaults write com.apple.dock showDesktopGestureEnabled -bool false
defaults write com.apple.dock showMissionControlGestureEnabled -bool false
defaults write com.apple.dock tilesize -int 75

# Finder
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder NewWindowTarget -string 'PfHm' # Open new windows open at $HOME
defaults write com.apple.finder DisableAllAnimations -bool true # Disable animations
defaults write com.apple.finder QLEnableTextSelection -bool true # Allow text selection in Quick Look
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder FXPreferredGroupBy -string 'None' # Default "Arrange By"
defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf' # When performing a search, search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXInfoPanesExpanded -dict OpenWith -bool true Privileges -bool true
defaults write com.apple.finder FXPreferredViewStyle -string 'clmv' # Use list view in all Finder windows by default (`icnv`, `clmv`, `Flwv`);
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowRecentTags -bool false

# Keyboard
defaults write -g AppleKeyboardUIMode -int 3 # Enable full keyboard access (e.g. tab in modal dialogs)
defaults write -g ApplePressAndHoldEnabled -bool false # Disable press-and-hold accent menu
defaults write -g InitialKeyRepeat -int 15 # 225 ms
defaults write -g KeyRepeat -int 2 # 30 ms
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Miscellaneous
defaults write com.apple.CrashReporter DialogType -string 'none'
defaults write com.apple.Siri HotkeyTag -int 1
defaults write com.apple.bird optimize-storage -bool true
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
sudo dscl . delete "$HOME" jpegphoto
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs ~/iCloud

# Security & Updates
defaults write com.apple.LaunchServices LSQuarantine -bool false # Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo fdesetup enable -user "$(id -un)"

# Sound
defaults write -g com.apple.sound.beep.feedback -int 0
defaults write -g com.apple.sound.uiaudio.enabled -int 0
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true && killall PowerChime # Prevent chime on power plug in
defaults write com.apple.systemsound com.apple.sound.beep.volume -float 0

# Trackpad
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true

# User Interface 
defaults write -g CGDisableCursorLocationMagnification -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g NSQuitAlwaysKeepsWindows -bool true # Disable "Close windows when quitting an app" dialog
defaults write -g PMPrintingExpandedStateForPrint -bool true # Expand print dialog by default
defaults write -g PMPrintingExpandedStateForPrint2 -bool true # Expand print dialog by default
defaults write com.apple.Accessibility ReduceMotionEnabled -float 1
sudo launchctl stop com.apple.AmbientDisplayAgent
sudo launchctl remove com.apple.AmbientDisplayAgent

###################################################################
# Install Fonts
###################################################################

find "$HOME/iCloud/Work/Fonts" -iname '*.*' -exec cp \{\} "$HOME/Library/Fonts" \;

###################################################################
# Finish
###################################################################

mkdir ~/Sites && chmod 700 "$_"
