#!/bin/bash
#
# #############################################################################
# Create new SSH user
# I use this script whenever I need to add a new SSH user to a remote machine.
#
# With thanks to https://gist.github.com/raw/4223476
#
# Usage: 
# @TODO: rewrite instructions
# #############################################################################
#

read -p "Enter the ssh login for the remote server you wish to create the user on (e.g  user@server.com): "  ssh_uname
ssh_credentials="$ssh_uname"
echo $ssh_credentials

read -p "Enter the new user name: " user_name
ssh $ssh_credentials "cd /home; mkdir $user_name"

read -p "enter the new user password: " password

exit

export A_NEW_USER=$1
export NEW_USER_PWD=$1
#
echo New User is $A_NEW_USER identified by $NEW_USER_PWD
#
echo "Get ${A_NEW_USER} home directory .. . . . . . . . "
export A_NEW_USER_HOME=$( grep "${A_NEW_USER}" /etc/passwd | awk -F: '{print $6}' )
echo "New user's home directory is ${A_NEW_USER_HOME}"
#
if [ "XX${A_NEW_USER_HOME}" == "XX" ]; then
#
echo "Create admin group ............................................"
addgroup admin
#
echo "Create a full privileges admin user ..........................."
export PASS_HASH=$(perl -e 'print crypt($ARGV[0], "password")' "$NEW_USER_PWD")
echo ${PASS_HASH}
# addgroup sudo
useradd -Ds /bin/bash
useradd -m -G sudo,www-data -p ${PASS_HASH} ${A_NEW_USER}
passwd -e ${A_NEW_USER}
#
A_NEW_USER_HOME=/home/${A_NEW_USER}
chown -r ${A_NEW_USER} ${A_NEW_USER_HOME}
chsh -s /bin/bash ${A_NEW_USER}
cp /home/koppie/.bash_profile ${A_NEW_USER_HOME}
chmod 666 ${A_NEW_USER_HOME}/.bash_profile
else
echo "The ${A_NEW_USER} user account is already configured in ${A_NEW_USER_HOME} . . . "
fi
#
echo "................................................................"
echo "Prepare for SSH tasks"
echo "................................................................"
#
apt-get install -y openssh-server
#
export A_NEW_USER_SSH_DIR=${A_NEW_USER_HOME}/.ssh
mkdir -p ${A_NEW_USER_SSH_DIR}
chmod 700 ${A_NEW_USER_SSH_DIR}
#
pushd ${A_NEW_USER_SSH_DIR}
#
 #
 echo "................................................................"
 echo "Generate SSH key pair for ${A_NEW_USER}"
 echo "................................................................"
 rm -f id_rsa*
 ssh-keygen -f id_rsa -t rsa -N '' -C "${A_NEW_USER}@${A_NEW_USER}.me"
 #
#
popd
#
echo "................................................................"
echo "Assign correct ownership ......................................"
echo "................................................................"
chown -R ${A_NEW_USER}:${A_NEW_USER} /home/${A_NEW_USER}
#
#
echo "................................................................"
echo "Here is ${A_NEW_USER}'s public key"
echo "................................................................"
echo " "
cat ${A_NEW_USER_SSH_DIR}/id_rsa.pub
echo " "
echo " "
echo " "
echo Done creating new user ${A_NEW_USER}
echo   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit 0;
