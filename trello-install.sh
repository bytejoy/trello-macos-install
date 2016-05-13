#!/bin/sh

# This script will install Homebrew, Node and Nativefier and then create an "app" for Trello.

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
      
    export PATH="/usr/local/bin:$PATH"
fi

fancy_echo "Updating Homebrew formulae ..."
brew update

fancy_echo "Installing Node ..."
brew install node

fancy_echo "Installing Nativefier ..."
npm install nativefier -g

fance_echo "Downloading card-id hack ..."
curl --remote-name https://raw.githubusercontent.com/annaminton/trello-osx-install/master/display-card-ids.css

fancy_echo "Creating Trello app ..."
nativefier --name "Trello" "http://trello.com" --inject display-card-ids.css

fancy_echo "Moving to Applications ..."
rsync -a ~/Trello-darwin-x64/Trello.app/ /Applications/Trello.app/

fancy_echo "Creating Dock icon"
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Trello.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
killall Dock
