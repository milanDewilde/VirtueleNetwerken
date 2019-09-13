# Installatie en configuratie van Drupal op de LAMP-stack

## Vooraf

In dit stappenplan maak ik telkens gebruik van Notepad++ voor het wijzigen van .yml, .yaml, .sql en bestanden zonder extensie.
Tijdens de setup van deze LAMP-stack werd Drupal al geïnstalleerd. In dit document wordt verder toegelicht op welke manier deze installatie verloopt.

**Ter referentie**

De mappenstructuur van de gebruikte map ziet eruit als volgt:
```
C:\Users\Milan\Desktop\Project Systeembeheer\p2ops-g12\opdracht02\LAMP>tree /F
Folder PATH listing for volume Windows
Volume serial number is 305C-A96E
C:.
│   LICENSE.md
│   README.md
│   vagrant-hosts.yml
│   Vagrantfile
│
└───provisioning
        common.sh
        Drupal.sh
        LinuxServer1.sh
        util.sh
```

## Installatiescript Drupal.sh

In de map `/provisioning` vinden we het script **Drupal.sh**. In dit script worden de CLI instructies voor de installatie van Drupal stap voor stap beschreven. Om dit script aan te roepen hebben we in de **Vagrantfile** een regel toegevoegd.

Het script **Drupal.sh** ziet er zo uit: 

```
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

```

In de stap **Create DB** wordt de database die we gebruiken met Drupal gemaakt en geïnitialiseerd.
 
```
info "================> Restarting services and allowing through firewall <================"
systemctl restart httpd.service
systemctl restart mariadb.service
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
```

In deze stap werden de httpd en mariadb services herstart en werden regels aan de firewall toegevoegd die http en https traffic doorlaten.

```
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

```

In deze stap werd **Drupal** geïnstalleerd en werden de nodige resources naar de juiste directory verplaatst.

```
info "================> Changing Drupal permissions <================"
# toevoeging juiste permissies
chown -R apache:apache /var/www/html/drupal

info "================> Creating config file <================"
# creatie settings file
cd /var/www/html/drupal/sites/default/
cp -p default.settings.php settings.php

chcon -R -t httpd_sys_content_rw_t /var/www/html/drupal/sites/
```

In deze stap werden de nodige permissies voor het wijzigen van bestanden toegekend. Dit staat ons toe om bepaalde settings te wijzigen.

```
info "================> Update all packages <================"
# Update all packages
yum -y update

info "================> Installation Drupal complete <================"
```

In deze laatste stap werden **alle** packages geüpdatet, zowel de packages van Drupal als de algemene packages zoals Apache, Mariadb, enz.

## Verficatie van de correcte installatie

Drupal is correct geïnstalleerd en geconfigureerd op de server als we via http://192.168.56.31/drupal/ vanop het hostsysteem de online configuratiepagina van Drupal kunnen bereiken.

# Installatie van een ASP.NET app op de WISA-stack

1. Plaats de bestanden van de ASP.NET applicatie in de `application` map, te vinden in de hoofdmap van de WISA-stack.
2. Voer het commando `vagrant up --provision` uit of, indien de VM al actief is, `vagrant provision`.
3. Wacht tot de provision volledig uitgevoerd is.
4. Nagiveer naar het IP-adres van de VM (ingegeven in het `vagrant-hosts.yml` bestand) om de installatie van de ASP.NET te vervolledigen, afhankelijk van de gebruike app. Hier zal men waarschijnlijk de verbinding met de SQL Server moeten instellen. De gegevens hiervoor bevinden zich in het bestand `Windows01.ps1` in de map `provision` (tenzij dit bestand tijdens installatie van de WISA stack werd hernoemd).

**Opmerking:** Indien men `provision` opnieuw uitvoert, om bijvoorbeeld de ASP.NET app up te daten, zullen alle applicatie gegevens worden gewist op de VM en opnieuw worden gekopieerd van de `application` map. **Indien er niet gebruikt wordt gemaakt van SQL Server om gegevens op te slaan hou hier rekening mee, en neem een back-up van de nodige applicatie bestanden op de VM!** De applicatiebestanden kan men na inloggen vinden in de VM in de map `C:\Application`. Kopieer de benodigde bestanden in de map `C:\applicationsource`, waarna ze in de map `application` van de WISA-stack zullen verschijnen.

## Inloggen op de VM

Men kan inloggen op de account `Vagrant User` met het wachtwoord `vagrant`.

**Opmerking:** Standaard staat de VM ingesteld op de QWERTY toetsenbord-indeling. Hou hier rekening mee bij het ingeven van tekst.
