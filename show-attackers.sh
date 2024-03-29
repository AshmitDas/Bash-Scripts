#!/bin/bash

# Count the number of failed logins by IP address.
# If there are any IP with over LIMIT failures, display the count, IP and location.

LIMIT='10'
LOG_FILE="${1}"

# Make sure the file was supplied as an argument.
if [[ ! -e "${LOG_FILE}" ]]
then
 echo "Cannot open log file: ${LOG_FILE}" >&2
 exit 1
fi

# Display the CSV header.
echo 'Count, IP, Location'

# Loop through the list of failed attempts and corresponding IP addresses.
grep Failed "${1}" | awk -F '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
 # If the number of failed attempts is greater than the limit display count, IP and Locations.
 if [[ "${COUNT}" -gt "${LIMIT}" ]]
 then 
   LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
   echo "${COUNT}, ${IP}, ${LOCATION}"
 fi
done

exit 0
