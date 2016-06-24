#!/bin/bash

# check root
#if [[ $EUID -ne 0 ]]; then
#    echo -e >&2 "$(tput setaf 1)Error: you need to run this script with root priviledges.$(tput sgr 0)\n" # red
#    exit 1
#fi

# check internet connection
echo "Checking internet connection..."
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Connection is ok..."
else
    echo -e >&2 "$(tput setaf 1)Error: No internet connection.$(tput sgr 0)\n" # red
    exit 1
fi

# check kernel type
echo ""
echo "Detecting OS..."
if [[ $(uname) == "Darwin" ]]; then
    echo "macOS detected"
    OS_TYPE="Darwin"
elif [[ $(uname) == "Linux" ]]; then
    echo "It seems you're running Linux. Unfortunately it is not supported, yet. Stay tuned!"
    echo "Exiting..."
    exit 1
else
    echo "No supported OS detected! Aborting..."
    exit 1
fi

# curl proper main script for the platform
echo ""
echo "Fetching data..."
mkdir /tmp/todabu
curl -o /tmp/todabu/todabu -sS "https://raw.githubusercontent.com/pirafrank/todabu/master/macOS/todabu.sh"
curl -o /tmp/todabu/com.fpira.todabu.plist -sS "https://raw.githubusercontent.com/pirafrank/todabu/master/macOS/com.fpira.todabu.plist"

echo ""
echo "Installing..."
echo "Warning: Installed script will be overwritten!"
echo ""
echo "Now you'll be prompted for sudo password. Root needed to install in /usr/local/bin"
sleep 1
sudo cp /tmp/todabu/todabu /usr/local/bin/todabu
sudo chmod +x /usr/local/bin/todabu
sudo cp /tmp/todabu/com.fpira.todabu.plist $HOME/Library/LaunchAgents/com.fpira.todabu.plist
launchctl load $HOME/Library/LaunchAgents/com.fpira.todabu.plist
rm -rf /tmp/todabu

# inititalisation
CONFIG_FILE="$HOME/.config/todabu/config"
COMPUTER_NAME=""
REMOTE=""

echo ""
echo "Starting setup..."

mkdir -p "$HOME/.config/todabu"
touch "$HOME/.config/todabu/config"

echo ""
echo -n "Insert choosen name for this computer and press [enter]: "
read COMPUTER_NAME

while [[ $COMPUTER_NAME == "" ]]; do
    echo -n "Insert choosen name for this computer and press [enter]: "
    read COMPUTER_NAME
done

echo -n "Insert git remote, then press [enter]: "
read REMOTE

while [[ $REMOTE == "" ]]; do
    echo -n "Insert git remote (ONLY url), then press [enter]: "
    read REMOTE
done

echo "BACKUP_DIR=\"$HOME/.todabu\"" > $CONFIG_FILE
echo "CONFIG_DIR=\"$HOME/.config/todabu\"" >> $CONFIG_FILE
echo "COMPUTER_NAME=\"$COMPUTER_NAME\"" >> $CONFIG_FILE
echo "REMOTE=\"$REMOTE\"" >> $CONFIG_FILE

echo ""
echo "Configuration saved"
echo "Done. Script will run soon."
