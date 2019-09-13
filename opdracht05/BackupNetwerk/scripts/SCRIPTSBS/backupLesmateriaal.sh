#!/bin/sh
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail
#Backup server toevoegen aan known hosts
echo "$(date +"%Y-%m-%d %T") STARTING BACKUP SCRIPT"
echo "$(date +"%Y-%m-%d %T") ADDING WEBSERVER TO KNOWN HOSTS"
ssh-keyscan -H 192.168.12.12 >> ~/.ssh/known_hosts
echo "$(date +"%Y-%m-%d %T") STARTING BACKUP"
sshpass -p "vagrant" rsync -av --omit-dir-times /home/LESMATERIAAL/ vagrant@192.168.12.12:/var/www/html/LESMATERIAAL/
echo "$(date +"%Y-%m-%d %T") SUCCESS >> DATA SENT TO BACKUPSERVER @192.168.12.24"
echo "$(date +"%Y-%m-%d %T") ENDING BACKUP SCRIPT "
