#!/bin/bash

# check kernel type
if [[ $(uname) == "Darwin" ]]; then
    continue
elif [[ $(uname) == "Linux" ]]; then
    echo "It seems you're running Linux. Unfortunately it is not supported, yet. Stay tuned!"
    echo "Exiting..."
    exit 1
else
    echo "No supported OS detected! Aborting..."
    exit 1
fi

echo "Uninstalling todabu..."

# Deleting backups...
rm -rf $HOME/.todabu

# Deleting user config...
rm -rf $HOME/.config/todabu

# Deleting exec...
sudo rm -rf /usr/local/bin/todabu

# Unloading and deleting plist...
launchctl unload $HOME/Library/LaunchAgents/com.fpira.todabu.plist
rm $HOME/Library/LaunchAgents/com.fpira.todabu.plist

echo "$(tput setaf 2)Uninstall complete!$(tput sgr 0)" # green
echo "Bye!"
