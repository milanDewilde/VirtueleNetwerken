#!/bin/sh
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail
#Backup server toevoegen aan known hosts

echo "$(date +"%Y-%m-%d %T") STARTING MAINTENANCE SCRIPT "
rm -f /home/DATABANK/leden.csv
echo "$(date +"%Y-%m-%d %T") SUCCESS >> Old file deleted"
ssh-keyscan -H 192.168.12.24 >> ~/.ssh/known_hosts
echo "$(date +"%Y-%m-%d %T") ADDING WEBSERVER TO KNOWN HOSTS"
mysql --user=root --password=root db_leden --execute="CALL backupToCSV();"
echo "$(date +"%Y-%m-%d %T") SUCCESS >> New file created"
sshpass -p "vagrant" rsync -av --omit-dir-times /home/DATABANK/ vagrant@192.168.12.24:/home/DATABANK/
echo "$(date +"%Y-%m-%d %T") SUCCESS >> DATA SENT TO BACKUPSERVER @192.168.12.24"
echo "$(date +"%Y-%m-%d %T") ENDING MAINTENANCE SCRIPT "
