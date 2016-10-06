#!/bin/bash
#
# #############################################################################
# Create new SSH user
# I use this script whenever I need to add a new SSH user to a remote machine.
#
# With thanks to https://gist.github.com/raw/4223476
#
# Usage: 
# sh createNewSSHUser.sh
# #############################################################################
#

# Get ssh login credentials, new user name, and ssh key locations
read -p "Enter the ssh login for the remote server you wish to create the user on (e.g  user@server.com): " ssh_credentials
ssh_credentials='root@184.173.120.23'
read -p "Enter the new user name: " user_name
read -p "Enter the new user password: " password

ssh_pub_default="$HOME/.ssh/id_rsa.pub"
read -p "Enter the path to the ssh public key [$ssh_pub_default]: " ssh_pub_path

ssh_priv_default="$HOME/.ssh/id_rsa"
echo "Please note: You don't need to upload your private key.  In fact, you probably shouldn't."
echo "For more information: https://www.gnupg.org/gph/en/manual/c481.html#AEN506"
echo "Enter 'no' to ignore the private key."
read -p "Enter the path to the ssh *private* key [$ssh_priv_default]: " ssh_priv_path

#Read in public key
ssh_pub_path="${ssh_pub_path:-$ssh_pub_default}"
ssh_pub_file=$(<$ssh_pub_path)

#If provided, read in private key
if [ "$ssh_priv_path" != "no" ]; 
then
  ssh_priv_path="${ssh_priv_path:-$ssh_priv_default}"
  ssh_priv_file=$(<$ssh_priv_path)
fi

#Begin SSH session
echo "Please authenticate for $ssh_credentials: "
ssh -t -t $ssh_credentials /bin/bash << EOF

  #Create user
  useradd -m -G sudo,www-data ${user_name}
  echo -e "$password\n$password\n" | passwd $user_name 
  chsh -s /bin/bash ${user_name}

  #Create SSH directory
  mkdir /home/${user_name}/.ssh
  cd /home/${user_name}/.ssh

  #Copy over private key
  if [ "$ssh_priv_path" != "no" ]; 
  then
    touch id_rsa
    echo "${ssh_priv_file}" > id_rsa 
  fi

  #Copy over public key
  touch authorized_keys
  echo "${ssh_pub_file}" > authorized_keys

  #Set SSH key permissions
  chmod 700 /home/${user_name}/.ssh

  #Change file/folder ownership to new user
  chown -R ${user_name}:${user_name} /home/${user_name}
  exit
EOF

exit
