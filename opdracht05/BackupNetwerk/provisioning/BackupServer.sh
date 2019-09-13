#! /usr/bin/bash
#
# Provisioning script for LinuxServer1

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

readonly rootpasswd="root"
readonly sqlpasswd="root"

# Location of provisioning scripts and files
export readonly PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"

#------------------------------------------------------------------------------
# "Imports"
#------------------------------------------------------------------------------

# Utility functions
source ${PROVISIONING_SCRIPTS}/util.sh

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------

info "Starting server specific provisioning tasks on ${HOSTNAME}"

# TODO: insert code here, e.g. install Apache, add users (see the provided
# functions in utils.sh), etc.

echo "$rootpasswd" | sudo passwd root --stdin

#
## Installatie Apache
#
info "================> Installing httpd <================"
yum -y -q install httpd

# Start and enable httpd
info "================> Starting httpd <================"
systemctl start httpd
systemctl enable httpd

info "================> Restarting httpd <================"
systemctl restart httpd

#
## Installatie MariaDB
#
info "================> Installing mariadb <================"
yum -y -q install mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb

# Change firewall rules
info "================> Enabling firewall <================"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

#Install php
info "================> Installing php <================"
yum install -y -q epel-release yum-utils
yum -y -q install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
yum-config-manager --enable remi-php73
yum -y -q install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json

#
## Automatisatie mysql
#
info "================> Configuring mariadb <================"
mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('${sqlpasswd}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

info "================> Creating database <================"

mysql --user=root --password=root <<_EOF_
CREATE DATABASE IF NOT EXISTS db_leden;
USE db_leden;
CREATE TABLE leden ( 
	lid_id INT NOT NULL, 
	lid_voornaam VARCHAR(20) NOT NULL, 
	lid_achternaam VARCHAR(30) NOT NULL, 
	lid_geboortejaar INT NOT NULL, 
	lid_graad VARCHAR(20) NOT NULL,
	username VARCHAR(30) NOT NULL,
	password VARCHAR(30) NOT NULL,
	PRIMARY KEY (lid_id));
_EOF_

info "================> Configuring ssh <================"
sudo yum -y install sshpass

info "================> Installing rsync <================"
sudo yum install -y rsync

info "================> Installing cronjob <================"
sudo yum install -y cronie

info "================> Creating directories <================"

sudo mkdir /home/DATABANK
sudo mkdir -p /home/LESMATERIAAL/{wit,geel,oranje,groen,blauw,bruin,zwart,rood}
sudo chmod -R 777 /home/LESMATERIAAL
sudo chmod -R 777 /home/DATABANK
sudo chmod -R 777 /home/SCRIPTS

info "================> Installing usefull software <================"
sudo yum install tree -y
sudo yum install vim -y

info "================> BackupServer installation complete <================"