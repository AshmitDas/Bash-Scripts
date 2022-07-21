#!/bin/bash

# This scripts creates an account.
# You will be prompted for the account name.


# Make sure the the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo -e "Run with superuser privileges.\nexit 1"
 exit 1
fi


# Ask for the username.
read -p 'Enter the username to create: ' USER_NAME

# Ask for the real name(contents for the description field).
read -p 'Enter the name of the person or application that will be using this account: ' COMMENT

# Get the password.
read -p 'Enter the password to use for the account: ' PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME} 

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
 echo 'The account could not be created.'
 exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
 echo 'The password for the account could not be set.'
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
echo -e "\nhost:\n"
echo "${HOSTNAME}"

exit 0
