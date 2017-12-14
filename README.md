# createnewuser
Bash script to log in to a Linux server and set up a new user

## What is this?

This is a devops tool to create accounts with sane defaults on remote servers.  It's useful for people who need to manage a lot of servers, eg. AWS, and need to grant access to other people.

## What can I do with it?

This script does several things in a row:

1. Create a new user account on a target machine
1. Add a public ssh key to the new account
1. Add a private ssh key too (so you can ssh *from* the new machine *to* additional machines, eg. rsync between environments)
1. Add the new user to `sudo` and `www-user` groups - useful for sysadmins on a web server

## What do I need?

For best results, you'll need the following:

- Bash terminal emulator (eg. "Terminal" on Mac OS X)
- Existing super user credentials for your target server
- *Optional:* SSH key for your new user.  You can upload both a public key and a private key if you want.

## How do I use it?

Follow these simple steps:
1. Gather all the necessary information (see "What do I need?" above)
1. Run the script: `sh createNewSSHUser.sh`
1. The wizard will ask you a few questions.  Then you can sit back and watch the magic happen!

Are you wishing for more?  Feel free to contribute with a [pull request](https://github.com/Exygy/createnewuser/compare)!
