#!/bin/bash

#
# NOTES
#
# Please setup a remote for your repository. If you want privacy, bitbucket
# offers unlimited private repo. But remember, sharing is caring!
#
# Be aware that if you do not want some files to sync (e.g. you're
# worried about privacy of ssh folder and keys) you can comment those ones out
# in the proper section.
# SSH keys are not backed up by the way, as they should never leave your computer.
#
# You can use the same repo for multiple computers. Each computer will have it's
# own sub-directory.
#

###################################################################################

# Script header - Do NOT touch this!

if [[ ! -f $HOME/.config/todabu/config ]]; then
    /usr/bin/osascript -e 'display notification "Error: Configuration not found!." with title "Todabu Backup"'
    exit 1
else
    source $HOME/.config/todabu/config
fi

if [[ ! -d ${BACKUP_DIR} ]]; then
     mkdir -p ${BACKUP_DIR}
     cd ${BACKUP_DIR}
     git init
     git remote add origin $REMOTE
else
    cd ${BACKUP_DIR}
fi

if [[ ! -d ${COMPUTER_NAME} ]]; then
     mkdir -p ${COMPUTER_NAME}
     cd ${COMPUTER_NAME}
else
    cd ${COMPUTER_NAME}
fi

if [[ ! -d $USER ]]; then
     mkdir -p $USER
fi

###################################################################################
# Backup section - comment out only what you don't need!

# save app list
echo "saving app list..."
ls -l /Applications/ > installed_apps.txt

# save user-installed software
echo "saving list of user-installed software in /usr/local/bin"
ls -l /usr/local/bin/ > installed_usr_local_bin.txt

# save installed port list (Macports)
echo "saving installed ports..."
port installed > installed_ports.txt

# save installed pip modules list
echo "saving globally installed pip modules..."
echo "Python version is:" > pip_installed.txt
sleep 1
python --version >> pip_installed.txt
sleep 1
pip list >> pip_installed.txt

# save list of node versions (nvm)
echo "saving list of nvm-installed node version..."
echo "### io.js versions ###" > nvm_installed.txt
sleep 1
ls -l ~/.nvm/versions/io.js/ >> nvm_installed.txt
sleep 1
echo "### node versions ###" >> nvm_installed.txt
sleep 1
ls -l ~/.nvm/versions/node/ >> nvm_installed.txt

# save list of globally installed npm packages for default node release
echo "saving list of globally installed npm packages..."
npm list -g --depth=0 > npm_globally_installed.txt

# save list of ruby versions (rvm)
echo "saving list of rvm-installed ruby versions..."
rvm list > rvm_installed.txt

# save list of installed gems for default ruby release
echo "saving list of installed gems for default ruby release..."
gem list > gem_installed.txt

# backing up user configuration files
echo "backing up bash user config files..."
cp ${HOME}/.bash_profile ./$USER/.bash_profile
cp ${HOME}/.bashrc ./$USER/.bashrc
cp ${HOME}/.profile ./$USER/.profile
echo "backing up zsh user config files..."
cp ${HOME}/.zshrc ./$USER/.zshrc
cp ${HOME}/.zshenv ./$USER/.zshenv
cp ${HOME}/.zlogin ./$USER/.zlogin

# backing up vim files and config
echo "backing up vim config..."
# cp -r ${HOME}/.vim ./USER/vim
cp ${HOME}/.vimrc ./$USER/.vimrc

# backing up ssh configuration
echo "backing up ssh configuration..."
mkdir "$USER/ssh"
cp ${HOME}/.ssh/config ./$USER/ssh/
cp ${HOME}/.ssh/known_hosts ./$USER/ssh/known_hosts

# backing up user global git configuration files
echo "backing up global git configuration..."
cp ${HOME}/.gitconfig ./$USER/.gitconfig
cp ${HOME}/.gitignore_global ./$USER/.gitignore_global

# backup user settings ~/.config
echo "backing up user default config..."
rm -rf ./$USER/.config
cp -r ~/.config ./$USER/.config

# backing up /etc/hosts
echo "backing up /etc/hosts file..."
mkdir ./etc
cp /etc/hosts ./etc/hosts

# backing up sublime text 3 preferences and plugins settings
echo "backing up sublime text 3 preferences and plugins settings..."
# rm -rf ./sublime-text-user-installed-packages
cp -rf "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/" ./sublime-text-user-installed-packages

# list of installed quicklook plugins
echo "saving list of QuickLook plugins..."
ls -l ${HOME}/Library/QuickLook > user_installed_quicklook_plugins.txt

# list of fonts installed by the user
echo "saving list of fonts installed by the user..."
ls -l ${HOME}/Library/fonts > user_installed_fonts.txt

# list of installed screen savers
echo "saving list of installed screensavers..."
ls -l "${HOME}/Library/Screen Savers" > user_installed_screensavers.txt

###################################################################################
# Script footer - Do NOT touch this!

# cleaning up
echo "cleaning up..."
rm -rf ./"sublime-text-user-installed-packages/Color Highlighter"
rm -rf ./"sublime-text-user-installed-packages/Package Control.cache"
rm ./"sublime-text-user-installed-packages/Package Control.last-run"
rm ./"sublime-text-user-installed-packages/Package Control.merged-ca-bundle"
rm ./"sublime-text-user-installed-packages/Package Control.system-ca-bundle"
rm ./"sublime-text-user-installed-packages/Package Control.user-ca-bundle"

sleep 1
cd ${BACKUP_DIR}

# commit
echo ""
echo "about to commit everything to git..."
git add .
git commit -m 'commit'

# push to remote
echo ""
echo "ready to push to remote... checking connection..."
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    git push origin master
    sleep 1
    /usr/bin/osascript -e 'display notification "Backup completed." with title "Todabu Backup"'
else
    echo ""
    echo "error: no internet connection. I'll try on next backup!"
    /usr/bin/osascript -e 'display notification "Backup completed." with title "Todabu Backup"'
    /usr/bin/osascript -e 'display notification "No connection: I will upload later..." with title "Todabu Backup"'
    exit 1
fi
