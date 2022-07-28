#!/bin/bash

# This script creates an account just like the previous script.
# You will have to provide the username and account name as commandline argument.
# The password will be randomly generated unique for each account.


# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then 
 echo -e "Please execute the script with superuser privilges.\nError status 1"
 exit 1
fi

# If the user doesn't supply atleast one argument, then give them help.
if [[ "${#}" -lt 1 ]]
then 
 echo "Usage: ${0} USER_NAME [COMMENT]..."
 echo 'Create an account on the local system with the name of the USER_NAME and a comments field of comment.'
 exit 1
fi

# The first parameter is the username.
USER_NAME=${1}

# The rest of the parameter are for the account comments.
shift
COMMENT=${*}

# Generate a password
PASSWORD=$(date +%s%N | sha256sum | head -c12)

# Create the user with password.
useradd -c "${COMMENT}" -m ${USER_NAME}

# check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
 echo -e "The account could not be created.\nError status 1"
 exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
 echo -e "The password for the account could not be set.\nError status 1"
 exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.

# Display username.
echo -e "\nusername:\n${USER_NAME}"

# Display password.
echo -e "\npassword:\n${PASSWORD}"

# Display current host name.
echo -e "\nhost:"
echo "${HOSTNAME}"

exit 0
