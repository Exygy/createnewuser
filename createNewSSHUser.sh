#!/bin/bash
#
# #############################################################################
# Create new SSH user (Ubuntu)
# I use this script whenever I need to add a new SSH user to an Ubuntu machine.
# Usage: 
# 1)  Download the "raw" with -  wget -O createNewSSHUser.sh  https://gist.github.com/raw/4223476
# 2)  Make it executable with -  chmod a+x createNewSSHUser.sh
# 3)  Uncomment the last line and edit the user & pwd values
# 4)  Execute it with : sudo ./createNewSSHUser.sh
# 5)  Immediately set a new password by logging in once with -
#          su newUsrName
# #############################################################################
#
function createSSHUser {
   #
   touch /root/trash 2> /dev/null
   if [  $? -ne  0  ]
   then 
      echo "Must execute as root user . . . "
      echo "sudo ./createNewSSHUser.sh"
      exit 0;
   fi
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

}
#
# Example call :
 createSSHUser Fred10 okokokok
exit 0;
##########  Quick start  ###########
rm -f createNewSSHUser.sh
wget -O createNewSSHUser.sh  https://gist.github.com/raw/4223476/
chmod a+x createNewSSHUser.sh
nano createNewSSHUser.sh
#
