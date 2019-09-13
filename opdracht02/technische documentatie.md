# Setup en automatisering van LAMP-stack installatie

## Vooraf

In dit stappenplan maak ik telkens gebruik van Notepad++ voor het wijzigen van .yml, .yaml, .sql en bestanden zonder extensie.

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

## Stap 1: Vagrant

Vagrant is a tool for building and managing virtual machine environments in a single workflow. With an easy-to-use workflow and focus on automation, Vagrant lowers development environment setup time, increases production parity, and makes the "works on my machine" excuse a relic of the past.

**Concreet:** Vagrant zorgt ervoor dat we VMs kunnen aanmaken en exact reproduceren. We gebruiken dit om een automatische installatie van een vooraf geconfigureerde machine uit te voeren, in ons geval dus een LAMP-stack waarop Drupal is geïnstalleerd.

### Stap 1.1: Vagrantfile

In bestand **"Vagrantfile"** passen we enkel de `DEFAULT_BASE_BOX` aan. Hier selecteren we het systeem waarop onze webserver zal runnen. Een ruime keuze aan dit soort boxen is te verkrijgen via de **"Vagrant cloud"** (https://app.vagrantup.com/boxes/search).

Wij kozen voor 'bento/centos-7.5'. 

Het gewijzigde bestand **"Vagrantfile"** ziet er zo uit: 

```
...
...
# Set your default base box here
DEFAULT_BASE_BOX = 'bento/centos-7.5'
...
...
```
Op het einde van **Vagrantfile** passen we ook het volgende aan:
```
# Run configuration script for the VM
      node.vm.provision 'shell', path: 'provisioning/' + host['name'] + '.sh'
      node.vm.provision 'shell', path: 'provisioning/drupal.sh'
```
We doen dit om het installatiescript voor drupal uit te voeren tijdens de installatie van de VM.

### Stap 1.2: Vagrant-hosts.yml

In bestand **"vagrant-hosts.yml"** stellen we de basisinstellingen voor onze nieuwe VM in. Voorlopig heb ik enkel een `name` en een `ip` gespecifiëerd, maar hier kunnen heel wat basisinstellingen geconfigureerd worden.

Het gewijzigde bestand **"vagrant-hosts.yml"** ziet er zo uit:

```
# vagrant_hosts.yml
#
# List of hosts to be created by Vagrant. This file controls the Vagrant
# settings, specifically host name and network settings. You should at least
# have a `name:`.  Other optional settings that can be specified:
#
# * `box`: choose another base box instead of the default one specified in
#          Vagrantfile. A box name in the form `USER/BOX` (e.g.
#          `bertvv/centos72`) is fetched from Atlas.
# * `box_url`: Download the box from the specified URL instead of from Atlas.
# * `ip`: by default, an IP will be assigned by DHCP. If you want a fixed
#         addres, specify it.
# * `netmask`: by default, the network mask is `255.255.255.0`. If you want
#              another one, it should be specified.
# * `mac`: The MAC address to be assigned to the NIC. Several notations are
#          accepted, including "Linux-style" (`00:11:22:33:44:55`) and
#          "Windows-style" (`00-11-22-33-44-55`). The separator characters can
#          be omitted altogether (`001122334455`).
# * `intnet`: If set to `true`, the network interface will be attached to an
#             internal network rather than a host-only adapter.
# * `auto_config`: If set to `false`, Vagrant will not attempt to configure
#                  the network interface.
# * `synced_folders`: A list of dicts that specify synced folders. `src` and
#   `dest` are mandatory, `options:` are optional. For the possible options,
#   see the Vagrant documentation[1]. Keys of options should be prefixed with
#   a colon, e.g. `:owner:`.
#
# To enable *provisioning*, add these hosts to site.yml and assign some roles.
#
# [1] http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
---

- name: LinuxServer1
  ip: 192.168.56.31

```

### Stap 1.3: /provisioning

In de map provisioning vinden we het script **"LinuxServer1.sh"**. Hier komt onze code voor de automatische installatie van gewenste software, in ons geval dus Apache, MariaDB en PHP voor Apache. Om deze CLI instructies door te geven, plaatsen we deze in volgorde in het pas aangemaakte script.

Het gewijzigde bestand **"LinuxServer1.sh"** ziet er zo uit:

```
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
```

In deze eerste stap werd **Apache** geïnstalleerd en startten we de service.

```
#
## Installatie MariaDB
#
info "================> Installing mariadb <================"
yum -y -q install mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb
```
In deze tweede stap werd **mariadb** geïnstalleerd en werd de service gestart.

```
# Change firewall rules
info "================> Enabling firewall <================"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload
```

In deze derde stap werd de **firewall** gestart en hebben we regels toegevoegd om http en https traffic door te laten.

```
#Install php
info "================> Installing php <================"
yum install -y -q epel-release yum-utils
yum -y -q install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
yum-config-manager --enable remi-php73
yum -y -q install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
```

In deze vierde stap werd **php** geïnstalleerd, en ook alle nodige packages om correct met mysql te kunnen werken.

```
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

info "================> LAMP installation complete <================"
```

In deze vijfde en laatste stap werd een initiële configuratie van **mariadb** uitgevoerd en werd de gehele LAMP-stack correct geïnstalleerd en geconfigureerd.

### Stap 1.4: VM genereren

Open de **command prompt** en navigeer naar de correcte directory, in mijn geval dus `C:\Users\Milan\Desktop\Project Systeembeheer\p2ops-g12\opdracht02\LAMP`
en gebruik command `vagrant up` om de VM te genereren.

Dit commando levert volgende output: 

```
C:\Users\Milan\Desktop\Project Systeembeheer\p2ops-g12\opdracht02\LAMP>vagrant up
Bringing machine 'LinuxServer1' up with 'virtualbox' provider...
==> LinuxServer1: Importing base box 'bento/centos-7.5'...
==> LinuxServer1: Matching MAC address for NAT networking...
==> LinuxServer1: Checking if box 'bento/centos-7.5' version '201808.24.0' is up to date...
==> LinuxServer1: Setting the name of the VM: LAMP_LinuxServer1_1552920958598_87746
==> LinuxServer1: Clearing any previously set network interfaces...
==> LinuxServer1: Preparing network interfaces based on configuration...
    LinuxServer1: Adapter 1: nat
    LinuxServer1: Adapter 2: hostonly
==> LinuxServer1: Forwarding ports...
    LinuxServer1: 22 (guest) => 2222 (host) (adapter 1)
==> LinuxServer1: Running 'pre-boot' VM customizations...
==> LinuxServer1: Booting VM...
==> LinuxServer1: Waiting for machine to boot. This may take a few minutes...
    LinuxServer1: SSH address: 127.0.0.1:2222
    LinuxServer1: SSH username: vagrant
    LinuxServer1: SSH auth method: private key
    LinuxServer1: Warning: Connection reset. Retrying...
    LinuxServer1: Warning: Connection aborted. Retrying...
    LinuxServer1: Warning: Remote connection disconnect. Retrying...
    LinuxServer1: Warning: Connection aborted. Retrying...
    LinuxServer1: Warning: Connection reset. Retrying...
    LinuxServer1: Warning: Connection aborted. Retrying...
    LinuxServer1:
    LinuxServer1: Vagrant insecure key detected. Vagrant will automatically replace
    LinuxServer1: this with a newly generated keypair for better security.
    LinuxServer1:
    LinuxServer1: Inserting generated public key within guest...
==> LinuxServer1: Machine booted and ready!
==> LinuxServer1: Checking for guest additions in VM...
==> LinuxServer1: Setting hostname...
==> LinuxServer1: Configuring and enabling network interfaces...
==> LinuxServer1: Mounting shared folders...
    LinuxServer1: /vagrant => C:/Users/Milan/Desktop/Project Systeembeheer/p2ops-g12/opdracht02/LAMP
==> LinuxServer1: Running provisioner: shell...
    LinuxServer1: Running: C:/Users/Milan/AppData/Local/Temp/vagrant-shell20190318-14252-1wxuya8.sh
    LinuxServer1: >>> Starting common provisioning tasks
    LinuxServer1: >>> Starting server specific provisioning tasks on LinuxServer1
    LinuxServer1: Changing password for user root.
    LinuxServer1: passwd: all authentication tokens updated successfully.
    LinuxServer1: >>> ================> Installing httpd <================
    LinuxServer1: >>> ================> Starting httpd <================
    LinuxServer1: Created symlink from /etc/systemd/system/multi-user.target.wants/httpd.service to /usr/lib/systemd/system/httpd.service.
    LinuxServer1: >>> ================> Restarting httpd <================
    LinuxServer1: >>> ================> Installing mariadb <================
    LinuxServer1: Created symlink from /etc/systemd/system/multi-user.target.wants/mariadb.service to /usr/lib/systemd/system/mariadb.service.
    LinuxServer1: >>> ================> Enabling firewall <================
    LinuxServer1: Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd/system/firewalld.service.
    LinuxServer1: Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd/system/firewalld.service.
    LinuxServer1: success
    LinuxServer1: success
    LinuxServer1: success
    LinuxServer1: >>> ================> Installing php <================
    LinuxServer1: No Presto metadata available for base
    LinuxServer1: Loaded plugins: fastestmirror
    LinuxServer1: =============================== repo: remi-php73 ===============================
    LinuxServer1: [remi-php73]
    LinuxServer1: async = True
    LinuxServer1: bandwidth = 0
    LinuxServer1: base_persistdir = /var/lib/yum/repos/x86_64/7
    LinuxServer1: baseurl =
    LinuxServer1: cache = 0
    LinuxServer1: cachedir = /var/cache/yum/x86_64/7/remi-php73
    LinuxServer1: check_config_file_age = True
    LinuxServer1: compare_providers_priority = 80
    LinuxServer1: cost = 1000
    LinuxServer1: deltarpm_metadata_percentage = 100
    LinuxServer1: deltarpm_percentage =
    LinuxServer1: enabled = 1
    LinuxServer1: enablegroups = True
    LinuxServer1: exclude =
    LinuxServer1: failovermethod = priority
    LinuxServer1: ftp_disable_epsv = False
    LinuxServer1: gpgcadir = /var/lib/yum/repos/x86_64/7/remi-php73/gpgcadir
    LinuxServer1: gpgcakey =
    LinuxServer1: gpgcheck = True
    LinuxServer1: gpgdir = /var/lib/yum/repos/x86_64/7/remi-php73/gpgdir
    LinuxServer1: gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    LinuxServer1: hdrdir = /var/cache/yum/x86_64/7/remi-php73/headers
    LinuxServer1: http_caching = all
    LinuxServer1: includepkgs =
    LinuxServer1: ip_resolve =
    LinuxServer1: keepalive = True
    LinuxServer1: keepcache = False
    LinuxServer1: mddownloadpolicy = sqlite
    LinuxServer1: mdpolicy = group:small
    LinuxServer1: mediaid =
    LinuxServer1: metadata_expire = 21600
    LinuxServer1: metadata_expire_filter = read-only:present
    LinuxServer1: metalink =
    LinuxServer1: minrate = 0
    LinuxServer1: mirrorlist = http://cdn.remirepo.net/enterprise/7/php73/mirror
    LinuxServer1: mirrorlist_expire = 86400
    LinuxServer1: name = Remi's PHP 7.3 RPM repository for Enterprise Linux 7 - x86_64
    LinuxServer1: old_base_cache_dir =
    LinuxServer1: password =
    LinuxServer1: persistdir = /var/lib/yum/repos/x86_64/7/remi-php73
    LinuxServer1: pkgdir = /var/cache/yum/x86_64/7/remi-php73/packages
    LinuxServer1: proxy = False
    LinuxServer1: proxy_dict =
    LinuxServer1: proxy_password =
    LinuxServer1: proxy_username =
    LinuxServer1: repo_gpgcheck = False
    LinuxServer1: retries = 10
    LinuxServer1: skip_if_unavailable = False
    LinuxServer1: ssl_check_cert_permissions = True
    LinuxServer1: sslcacert =
    LinuxServer1: sslclientcert =
    LinuxServer1: sslclientkey =
    LinuxServer1: sslverify = True
    LinuxServer1: throttle = 0
    LinuxServer1: timeout = 30.0
    LinuxServer1: ui_id = remi-php73
    LinuxServer1: ui_repoid_vars = releasever,
    LinuxServer1:    basearch
    LinuxServer1: username =
    LinuxServer1: Package php-mcrypt is obsoleted by php-pecl-mcrypt, trying to install php-pecl-mcrypt-1.0.2-2.el7.remi.7.3.x86_64 instead
    LinuxServer1: No Presto metadata available for base
    LinuxServer1: Delta RPMs reduced 3.7 M of updates to 1.0 M (72% saved)
    LinuxServer1: /usr/share/doc/glibc-2.17/BUGS: No such file or directory
    LinuxServer1: cannot reconstruct rpm from disk files
    LinuxServer1: Public key for gd-last-2.2.5-8.el7.remi.x86_64.rpm is not installed
    LinuxServer1: warning: /var/cache/yum/x86_64/7/remi-safe/packages/gd-last-2.2.5-8.el7.remi.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 00f97f56: NOKEY
    LinuxServer1: Public key for libargon2-20161029-2.el7.x86_64.rpm is not installed
    LinuxServer1: warning: /var/cache/yum/x86_64/7/epel/packages/libargon2-20161029-2.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
    LinuxServer1: Public key for php-bcmath-7.3.3-1.el7.remi.x86_64.rpm is not installed
    LinuxServer1: Some delta RPMs failed to download or rebuild. Retrying..
    LinuxServer1: Importing GPG key 0x00F97F56:
    LinuxServer1:  Userid     : "Remi Collet <RPMS@FamilleCollet.com>"
    LinuxServer1:  Fingerprint: 1ee0 4cce 88a4 ae4a a29a 5df5 004e 6f47 00f9 7f56
    LinuxServer1:  Package    : remi-release-7.6-2.el7.remi.noarch (installed)
    LinuxServer1:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    LinuxServer1: Importing GPG key 0x352C64E5:
    LinuxServer1:  Userid     : "Fedora EPEL (7) <epel@fedoraproject.org>"
    LinuxServer1:  Fingerprint: 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5
    LinuxServer1:  Package    : epel-release-7-11.noarch (@extras)
    LinuxServer1:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
    LinuxServer1: >>> ================> Configuring mariadb <================
    LinuxServer1: >>> ================> LAMP installation complete <================
```
Hierna wordt ook **Drupal** automatisch geïnstalleerd.

## Stap 2: Cloud hosting
Voor het hosten van onze Linux server hebben we gebruik gemaakt van Azure. Het is een cloud computing-platform van Microsoft waarmee internetdiensten aangeboden worden. Het gebruikt een aangepast besturingssysteem Microsoft Azure om een cluster van servers te beheren die in het datacenter van Microsoft staan.

### Stap 2.1 Aanmaken van een VM op Azure
Eens aangekomen op het[portaal van Azure](https://portal.azure.com) krijg je een overweldigende reeks aan keuze mogelijkheden. Wij kiezen voor het aanmaken van een Virtual Machine. 

Ga naar 'All resources' en klink linksboven op 'Add'. Gebruik de zoekbar om naar een OS te zoeken. Wij gebruiken CentOS 7.5. Klink onderaan op 'Create'.

![](Screenshots/Azure-Create-VM.png?raw=true "Create VM")

De configuratie van de OS kan u zelf kiezen. Waar je wel moet op letten is dat je de HTTP poort toe laat op je server. Deze optie vind je onderaan de eerste pagina. Volgende instellingen mag u zelf kiezen.

![](Screenshots/Azure-AllowHTTP.png?raw=true "Allow HTTP")

### Stap 2.2 Configuratie VM op Azure
Eens de installatie van de VM complete is kan je de serial console gebruiken om de configuratie te doen. De serial console optie vindt u onderaan het scroll menu links.

Vervolgens clonen we de Git Repository waar de installatie scripts staan.

Eerst installeren we **Git**, dit doen we met het `sudo yum install git-all` commando.

Vervolgens maken we een map `vagrant/provisioning` aan onder root, hierin clonen we de installatie scripts.
```
cd /
mkdir vagrant/provisioning
git clone https://github.com/HoGentTIN/p2ops-g12/tree/master/opdracht02/LAMP/provisioning
```
We geven de scripts de juiste permissies met het `chmod +x LinuxServer1.sh` commando. Herhaal dit voor alle installatie scritpts.

### Stap 2.3 Web pagina controlleren
Om te testen of de web pagina bereikbaar is surft u naar het publieke IP-adres van de server. Dit is te vinden op de 'overview' pagina van de virtuele machine. Bij het surfen naar dit IP-adres komt u op de test pagina terecht. voeg `/drupal` achteraan toe aan het IP-adres om op de drupal installatie pagina te geraken.


# Setup en automatisering van WISA-stack installatie

## Stap 1: Vagrant

Deze stack vereist het [Vagrant platform](https://www.vagrantup.com/) voor het beheren en hosten van de virtuele machine waarin de WISA-stack draait. Download de laatste versie van Vagrant voor het vereiste platform [hier](https://www.vagrantup.com/downloads.html) en volg de installatie-instructies.

## Stap 2: Virtualbox

Een andere vereiste is [Virtualbox,](https://www.virtualbox.org/) nodig voor de gebruikte Windows Server 2016 box. Download de laatste versie van Virtualbox voor het vereiste platform [hier](https://www.virtualbox.org/wiki/Downloads) en volg de installatie-instructies.

## Stap 3: Ingegeven variabelen

### Stap 3.1: vagrant-hosts.yml

In de hoofdmap van de WISA-stack vindt men het bestand `vagrant-hosts.yml`. In dit bestand kan men het lokale IP-adres en het subnetmasker van de virtuele machine instellen, na de opties `ip:` en `netmask:`. Standaard staan deze op `192.168.3.24` en `255.255.255.0` ingesteld.

Men kan ook de naam van de virtuele machine, die standaard `Windows01` is, aanpassen na de optie `name:`. **Indien deze naam veranderd wordt moet ook het bestand `Windows01.ps1` in de map `provision` worden hernoemt naar de nieuwe naam!**

### Stap 3.2: Windows01.ps1

In de map `provision`, te vinden in de hoofdmap van de WISA-stack, vindt men het bestand `Windows01.ps1`, tenzij men dit heeft hernoemt in stap 3.1. In dit bestand kan men de instellingen van IIS en SQL-Server aanpassen. Al deze variabelen staan bovenaan aan het script, en er zou dus geen aanpassingen aan de rest van het script moeten plaatsvinden. Men kan de naam van de site in IIS aanpassen door de variabele `$siteName` te veranderen. Deze staat standaard op `Testsite`.

Om de Databank aan te maken in SQLSERVER maken we ook gebruik van een aantal variabelen.
```
$instanceName = ".\SQLEXPRESS"
$loginName = de gebruikersnaam 
$password = het wachtwoord
$database = de naam van de databank die aangemaakt moet worden
```

## Stap 4: Opstarten WISA Stack

Navigeer naar de hoofdfolder van de WISA stack (waar het `Vagrantfile` bestand aanwezig is), start een commandoprompt op, en voer het command `vagrant up` uit. Dit zal de volledige WISA stack downloaden, installeren, en instellen.

**Opmerking:** Indien men Windows gebruikt als host environment is het best om deze commandos in een Powershell consoleprompt die als Administrator is opgestart uit te voeren. Anders is het mogelijk dat Vagrant blijft hangen bij de installatie. [Dit is een vaak voorkomende fout in Vagrant zelf.](https://www.vagrantup.com/docs/virtualbox/common-issues.html)

Indien men de virtuele machine opnieuw wenst af te sluiten gebruik hier het commando `vagrant halt` voor. Indien provisioning opnieuw moet worden uitgevoerd, voer het commando `vagrant provision` uit indien de virtuele machine al actief is, of `vagrant up --provision` indien de virtuele machine was afgesloten.

**Opmerking:** Indien er een fout voorkomt bij het provisionen van de WISA stack probeer dan de provisioning opnieuw uit te voeren via de hierboven gegeven commandos. Dit lost de meeste provision-fouten op.

Voor meer Vagrant commandos gelieve [de officiële Vagrant documentatie](https://www.vagrantup.com/docs/cli/) raad te plegen.

Voor het installeren van een ASP.NET applicatie op de WISA stack gelieve [de gebruikershandleiding](gebruikersdocumentatie.md) raad te plegen.

**Opmerking:** Indien men een ASP.NET applicatie wilt installeren die gebruik maakt van `.NET 4.7.2` **moet** de virtuele machine na provisioning eerst herladen worden via het commando `vagrant reload`, of `vagrant halt` gevolgt door `vagrant up`. Dit is vereist omdat de installatie van `.NET 4.7.2` slechts volledig is na een herstart.
