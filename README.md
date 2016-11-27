# todabu

A simple way to automatically backup user configuration files, info and installation status in a git repository.

## Requirements

todabu is currently available for macOS.

Linux version coming soon.

## Installation and setup

1. Create an **empty** remote repository on your server of choice (github, bitbucket, gitlab, personal, ecc.)
2. Run `\curl -sSL "https://raw.githubusercontent.com/pirafrank/todabu/master/install.sh" | bash`
3. Follow on-screen instructions

## How it works

The script automatically runs backup everyday at late evening.

Script is scheduled via native `launchd` utility built-in in macOS.

If script can't be run at that time (e.g. computer is sleeping), launchd will run it as soon as it can (e.g. on wake up).

## Uninstall

This **will** delete everything: data, config, executeable and local repository and directories).

This will **not** delete your remote repository you configured during installation.

`\curl -sSL "https://raw.githubusercontent.com/pirafrank/todabu/master/uninstall.sh" | bash`

## To-do list

- [x] bundle install and setup scripts
- [ ] restore option: user should be able to restore config file from backup repository
- [ ] auto-updater
- [ ] Linux porting

Note: order is not important!

## Contributions

Contributions are always welcome and respect the GitHub spirit.

Sharing is caring, so feel free to send me a PR with your improments.

## License

The software in this repository are released under the GNU GPLv3 License by Francesco Pira (dev[at]fpira[dot]com, fpira.com). You can read the terms of the license [here](http://www.gnu.org/licenses/gpl-3.0.html).
