# Bash Scripts
This repository contains 3 different types of scripts to automate 3 different program in linux/unix system.

- **Create Local User (Scripts 1 - 3)** : 
This script prompts user to enter a username, Name of the Individual person and a password. In the second script the system automatically generates a secure password for the user. The third scripts accepts username, Individual name as optional and system generates password for the user and at the end it displays the username, Comment and password to the user.

- **Disable Local User (Script - 4)** : This script disables, deletes, removes or archives an user account on the local system as the option choosen by the user.

- **Run Everywhere (Script - 5)** : This script helps to execute commands on a remote server.

- **Show Attackers (Script - 6)** : This script checks the log file and fetches the details of the IP and its country if there is multiple number of failed logins on an account on a system.


## Instruction to execute scripts.
- Go to the directory where the script is located.
    ```
    cd /{Your Bash Directory}/
    ```

- Change your script permission to make it executable.
    ```
    chmod u+x filename.sh
    ```
    or 
    ```
    chmod 755 filename.sh
    ```
- Execute the bash script.
    ```
    ./filename.sh
    ```