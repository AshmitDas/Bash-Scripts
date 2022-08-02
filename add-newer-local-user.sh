#!/bin/bash

# This script creates a new user on the local system.
# You must supply a username as an argument to the script.
# Optionally, you can also provide a comment for the account as an argument.
# A password will be automatically generated for the account.
# The username, password, and host for the account will be displayed.

# Make sure the script is being executed with superuser privileges and if not provide the message through standard error.
if [[ "${UID}" -ne 0 ]]
then 
 echo -e "Please execute the script with superuser privilges.\nError status 1" >&2
 exit 1
fi

# If the user doesn't supply atleast one argument, then give help through standard error message.
if [[ "${#}" -lt 1 ]]
then 
 echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
 echo 'Create an account on the local system with the name of the USER_NAME and a comments field of comment.' >&2
 exit 1
fi

# The first parameter is the username.
USER_NAME=${1}

# The rest of the parameter are for the account comments.
shift
COMMENT=${@}

# Generate a password
PASSWORD=$(date +%s%N | sha256sum | head -c12)

# Create the user with password and send the STDOUT, STDERR to /dev/null .
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# check to see if the useradd command succeeded and if not succeeded provide the message through standard error.
# We don't want to tell the user that an account was created when it hasn't been.
if [[ "${?}" -ne 0 ]]
then
 echo -e "The account could not be created.\nError status 1" >&2
 exit 1
fi

# Set the password and send the output to /dev/null
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check to see if the passwd command succeeded and if not succeeded provide the message through standard error.
if [[ "${?}" -ne 0 ]]
then
 echo -e "The password for the account could not be set.\nError status 1" >&2
 exit 1
fi

# Force password change on first login and send all the STDOUT to /dev/null.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.

# Display username.
echo -e "username:\n${USER_NAME}"

# Display password.
echo -e "\npassword:\n${PASSWORD}"

# Display current host name.
echo -e "\nhost:"
echo "${HOSTNAME}"

exit 0
