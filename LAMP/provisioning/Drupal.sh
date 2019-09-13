#! /usr/bin/bash
#
# Drupal script for LinuxServer1

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

# Location of provisioning scripts and files
export readonly PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"

#------------------------------------------------------------------------------
# "Imports"
#------------------------------------------------------------------------------

# Utility functions
source ${PROVISIONING_SCRIPTS}/util.sh
# Actions/settings common to all servers
source ${PROVISIONING_SCRIPTS}/common.sh

#------------------------------------------------------------------------------
# "Drupal script"
#------------------------------------------------------------------------------

# Create DB
info "================> Creation Drupal database <================"
mysql --user=root --password=root<<_EOF_
CREATE DATABASE drupalDB;
CREATE USER drupaluser@localhost IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON drupalDB. * TO drupaluser@localhost;
FLUSH PRIVILEGES;
_EOF_

info "================> Restarting services and allowing through firewall <================"
systemctl restart httpd.service
systemctl restart mariadb.service
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

#
## Installatie Drupal
#

# Aanmaak temp dir om drupal te installeren
info "================> Creating temp dir for installation <================"
mkdir temp
cd temp

info "================> Unzip packages <================"
yum -y install wget unzip
wget http://ftp.drupal.org/files/projects/drupal-7.33.zip

info "================> Installing Drupal <================"
# installatie bijkomende drupal packages
yum -y install php-mbstring php-gd php-xml

# unzip durpal file
unzip -q drupal-7.33.zip -d /var/www/html/

# renaming folder
mv /var/www/html/drupal-7.33/ /var/www/html/drupal

info "================> Changing Drupal permissions <================"
# toevoeging juiste permissies
chown -R apache:apache /var/www/html/drupal

info "================> Creating config file <================"
# creatie settings file
cd /var/www/html/drupal/sites/default/
cp -p default.settings.php settings.php

chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/sites/

info "================> Update all packages <================"
# Update all packages
yum -y update

info "================> Installation Drupal complete <================"