#!/bin/bash

# This scripts disables, deletes, and/or archives users on the local system.

ARCHIVE_DIR='/archive'

# Display the usage and exit.
usage() {
    echo "Usage: ${0} [-dra] USER [USERN]..." >&2
    echo 'Disables a local linux account.' >&2
    echo '   -d  Deletes account instead of disabling them.' >&2
    echo '   -r  Removes the home directory associated with the account(s).' >&2
    echo '   -a  Creates a archive of the home directory associated with the account(s).' >&2
    exit 1
}

# Make sure the script is being executed with superuser privileges and if not provide the message through standard error.
if [[ "${UID}" -ne 0 ]]
then
 echo "Please execute the script with sudo or as root" >&2
 exit 1
fi

# Parse the options.
while getopts dra OPTION
do 
 case ${OPTIONS} in
   d) DELETE_USER='true' ;;
   r) REMOVE_OPTION='-r' ;;
   a) ARCHIVE='true' ;;
   ?) usage ;;
 esac
done

# Remove the options while leaving the remianing arguments.
shift  "$(( OPTIND - 1 ))"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then 
 usage
fi

# Loop through all the usernames supplied as arguments.
for USERNAME in "${@}"
do
  echo "Processing user: ${USERNAME}"

  # Make sure the uid of the account is atleast 1000.
  USER_ID=$(id -u ${USERNAME})
  if [[ "${USER_ID}" -lt 1000 ]]
  then 
    echo "Refusing to remove the ${USERNAME} associated with the ${USER_ID}" >&2
    exit 1
  fi

  # Create an archive if the user requested to do so.
  if [[ "${ARCHIVE}" = 'true' ]]
  then
    # Make sure the archive directory exists.
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory."
      mkdir -p ${ARCHIVE_DIR}
      if [[ "${?}" -ne 0 ]]
      then
        echo "The archive directory ${ARCHIVE_DIR} could not be created." >&2
        exit 1
      fi
    fi

    # Archives the user's home directory and move it into the ARCHIVE_DIR.
    HOME_DIR="/home/${USERNAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"

    if [[ -d "${HOME_DIR}" ]]
    then 
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
      if [[ "${?}" -ne 0 ]]
      then
        echo "Could not create ${ARCHIVE_FILE}." >&2
        exit 1
      fi
    else
     echo "${HOME_DIR} does not exists or it is not a directory." >&2
     exit 1
    fi
  fi

  if [[ "${DELETE_USER}" = 'true' ]]
  then
    # Delete the user
    userdel ${REMOVE_OPTION} ${USERNAME}

    # check to see if the userdel command succeeded.
    # We don't want to tell the user that an account was deleted when it hasn't been.
    if [[ "${?}" -ne 0 ]]
    then
     echo "The account ${USERNAME} was NOT deleted." >&2
     exit 1
    fi
    echo "The account ${USERNAME} was deleted."
    else
     chage -E 0 ${USERNAME}

     # check to see the if the chage command succeeded.
     # We dont want to tell the user that an account has been disabled when it hasn't been.
     if [[ "${?}" -ne 0 ]]
     then 
      echo "The account ${USERNAME} was not disabled." >&2
      exit 1
     fi
    echo "The account ${USERNAME} was disabled."
  fi
done


exit 0
