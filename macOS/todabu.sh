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

if [[ ! -f $HOME/.config/todabu/config ]];then
    /usr/bin/osascript -e 'display notification "Error: Configuration not found!." with title "todabu backup"'
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
date > installed_apps.txt
ls -l /Applications/ >> installed_apps.txt

# save user-installed software
date > installed_usr_local_bin.txt
ls -l /usr/local/bin/ >> installed_usr_local_bin.txt

# save installed port list (Macports)
date > installed_ports.txt
port installed >> installed_ports.txt

# save installed pip package list
date > pip_installed.txt
echo "Python version is:" >> pip_installed.txt
python --version >> pip_installed.txt
pip list >> pip_installed.txt

# save list of node versions (nvm)
date > nvm_installed.txt
echo "### io.js versions ###" >> nvm_installed.txt
ls -l ~/.nvm/versions/io.js/ >> nvm_installed.txt
echo "### node versions ###" >> nvm_installed.txt
ls -l ~/.nvm/versions/node/ >> nvm_installed.txt

# save list of globally installed npm packages for default node release
date > npm_globally_installed.txt
npm list -g --depth=0 >> npm_globally_installed.txt

# save list of ruby versions (rvm)
date > rvm_installed.txt
rvm list >> rvm_installed.txt

# save list of installed gems for default ruby release
date > gem_installed.txt
gem list >> gem_installed.txt

# backing up user configuration files
cp ${HOME}/.bash_profile ./$USER/.bash_profile
cp ${HOME}/.bashrc ./$USER/.bashrc
cp ${HOME}/.profile ./$USER/.profile
cp ${HOME}/.zshrc ./$USER/.zshrc
cp ${HOME}/.zshenv ./$USER/.zshenv
cp ${HOME}/.zlogin ./$USER/.zlogin

# backing up vim files and config
# cp -r ${HOME}/.vim ./USER/vim
cp ${HOME}/.vimrc ./$USER/.vimrc

# backing up ssh keys and configuration
mkdir "$USER/ssh"
cp ${HOME}/.ssh/config ./$USER/ssh/
cp ${HOME}/.ssh/known_hosts ./$USER/ssh/known_hosts

# backing up user global git configuration files
cp ${HOME}/.gitconfig ./$USER/.gitconfig
cp ${HOME}/.gitignore_global ./$USER/.gitignore_global

# backup user settings ~/.config
rm -rf ./$USER/.config
cp -r ~/.config ./$USER/.config

# backing up /etc/hosts
mkdir ./etc
cp /etc/hosts ./etc/hosts

# backing up sublime text 3 preferences and plugins settings
# rm -rf ./sublime-text-user-installed-packages
cp -rf "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/" ./sublime-text-user-installed-packages

# list of installed quicklook plugins
date > user_installed_quicklook_plugins.txt
ls -l ${HOME}/Library/QuickLook >> user_installed_quicklook_plugins.txt

# list of installed fonts
date > user_installed_fonts.txt
ls -l ${HOME}/Library/fonts >> user_installed_fonts.txt

# list of installed screen savers
date > user_installed_screensavers.txt
ls -l "${HOME}/Library/Screen Savers" > user_installed_screensavers.txt

###################################################################################
# Script footer - Do NOT touch this!

# cleaning up
rm -rf ./"sublime-text-user-installed-packages/Color Highlighter"
rm -rf ./"sublime-text-user-installed-packages/Package Control.cache"
rm ./"sublime-text-user-installed-packages/Package Control.last-run"
rm ./"sublime-text-user-installed-packages/Package Control.merged-ca-bundle"
rm ./"sublime-text-user-installed-packages/Package Control.system-ca-bundle"
rm ./"sublime-text-user-installed-packages/Package Control.user-ca-bundle"

sleep 1
cd ${BACKUP_DIR}

# commit
git add .
git commit -m 'commit'
git push origin master

# notify backup complete
/usr/bin/osascript -e 'display notification "Backup completed." with title "todabu backup"'
