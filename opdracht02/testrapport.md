# Testrapport taak 2: LAMP stack

## Test 1

- Uitvoerder(s) test: Sean Vancompernolle
- Uitgevoerd op: 24/03/2019
- Github commit: 2057f1c5da5bc193bd043a7369fd1ca2a0c6ba35


# Testplan LAMP-stack
## Doel
- [x] Er is een versie van Linux geïnstalleerd op de VM
- [x] Apache is geïnstalleerd op de VM
- [x] MariaDB is geïnstalleerd op de VM
- [x] Php is geïnstalleerd op de VM
- [x] De firewall laat het juiste netwerkverkeer door
- [x] We kunnen via onze hostmachine Drupal configureren op de VM

## Vooraf
De VM werd geconfigureerd met sudo wachtwoord 'root'

## Te testen
### Is er een versie van Linux geïnstalleerd op de VM?
1. Op de virtuele machine, gebruik command `uname -or` om de naam van de OS en de kernel version weer te geven
2. Er werd een versie van Linux geïnstalleerd op de VM als dit commando volgende output levert
```
[vagrant@LinuxServer1 ~]$ uname -or
3.10.0-862.11.6.el7.x86_64 GNU/Linux
```

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ uname -or
3.10.0-862.11.6.el7.x86_64 GNU/Linux
```

### Is Apache geïnstalleerd en runt de service?
1. Op de virtuele machine, gebruik command `yum list installed | grep http` om de geïnstalleerde packages waarin 'http' voorkomt weer te geven
2. Apache werd geïnstalleerd als dit commando volgende output levert
```
[vagrant@LinuxServer1 ~]$ yum list installed | grep http
httpd.x86_64                         2.4.6-88.el7.centos             @base
httpd-tools.x86_64                   2.4.6-88.el7.centos             @base
```

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ yum list installed | grep http
httpd.x86_64                         2.4.6-88.el7.centos             @base
httpd-tools.x86_64                   2.4.6-88.el7.centos             @base
```

3. Op de virtuele machine, gebruik command `service httpd status` om de status van de service weer te geven
4. Apache runt als dit commando volgende output levert
```
[vagrant@LinuxServer1 ~]$ service httpd status
Redirecting to /bin/systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-03-20 08:14:36 UTC; 15min ago
```

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ service httpd status
Redirecting to /bin/systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2019-03-24 20:42:17 UTC; 8min ago
```

### Is MariaDB geïnstalleerd en runt de service?
1. Op de virtuele machine, gebruik command `yum list installed | grep mariadb` om de geïnstalleerde packages waarin 'mariadb' voorkomt weer te geven
2. MariaDB werd geïnstalleerd als dit commando volgende output levert
```
[vagrant@LinuxServer1 ~]$ yum list installed | grep mariadb
mariadb.x86_64                       1:5.5.60-1.el7_5                @base
mariadb-libs.x86_64                  1:5.5.60-1.el7_5                @updates
mariadb-server.x86_64                1:5.5.60-1.el7_5                @base
```

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ yum list installed | grep mariadb
mariadb.x86_64                       1:5.5.60-1.el7_5                @base
mariadb-libs.x86_64                  1:5.5.60-1.el7_5                @updates
mariadb-server.x86_64                1:5.5.60-1.el7_5                @base
```

3. Op de virtuele machine, gebruik command `service mariadb status` om de status van de service weer te geven
4. MariaDB runt als dit commando volgende output levert
```
[vagrant@LinuxServer1 ~]$ service mariadb status
Redirecting to /bin/systemctl status mariadb.service
● mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-03-20 08:14:41 UTC; 23min ago
```

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ service mariadb status
Redirecting to /bin/systemctl status mariadb.service
● mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2019-03-24 20:42:23 UTC; 11min ago
```

### Is Php geïnstalleerd?
1. Op de virtuele machine, gebruik command `yum list installed | grep php` om de geïnstalleerde packages waarin 'php' voorkomt weer te geven
2. Php packages werden geïnstalleerd als dit commando volgende output levert
```
[vagrant@LinuxServer1 ~]$ yum list installed | grep php
php.x86_64                           7.3.3-1.el7.remi                @remi-php73
php-bcmath.x86_64                    7.3.3-1.el7.remi                @remi-php73
php-cli.x86_64                       7.3.3-1.el7.remi                @remi-php73
php-common.x86_64                    7.3.3-1.el7.remi                @remi-php73
php-devel.x86_64                     7.3.3-1.el7.remi                @remi-php73
php-fedora-autoloader.noarch         1.0.0-1.el7                     @epel
php-fpm.x86_64                       7.3.3-1.el7.remi                @remi-php73
php-gd.x86_64                        7.3.3-1.el7.remi                @remi-php73
php-json.x86_64                      7.3.3-1.el7.remi                @remi-php73
php-mbstring.x86_64                  7.3.3-1.el7.remi                @remi-php73
php-mysqlnd.x86_64                   7.3.3-1.el7.remi                @remi-php73
php-pdo.x86_64                       7.3.3-1.el7.remi                @remi-php73
php-pear.noarch                      1:1.10.9-1.el7.remi             @remi-php73
php-pecl-mcrypt.x86_64               1.0.2-2.el7.remi.7.3            @remi-php73
php-pecl-zip.x86_64                  1.15.4-1.el7.remi.7.3           @remi-php73
php-process.x86_64                   7.3.3-1.el7.remi                @remi-php73
php-xml.x86_64                       7.3.3-1.el7.remi                @remi-php73
```

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ yum list installed | grep php
php.x86_64                           7.3.3-1.el7.remi                @remi-php73
php-bcmath.x86_64                    7.3.3-1.el7.remi                @remi-php73
php-cli.x86_64                       7.3.3-1.el7.remi                @remi-php73
php-common.x86_64                    7.3.3-1.el7.remi                @remi-php73
php-devel.x86_64                     7.3.3-1.el7.remi                @remi-php73
php-fedora-autoloader.noarch         1.0.0-1.el7                     @epel
php-fpm.x86_64                       7.3.3-1.el7.remi                @remi-php73
php-gd.x86_64                        7.3.3-1.el7.remi                @remi-php73
php-json.x86_64                      7.3.3-1.el7.remi                @remi-php73
php-mbstring.x86_64                  7.3.3-1.el7.remi                @remi-php73
php-mysqlnd.x86_64                   7.3.3-1.el7.remi                @remi-php73
php-pdo.x86_64                       7.3.3-1.el7.remi                @remi-php73
php-pear.noarch                      1:1.10.9-1.el7.remi             @remi-php73
php-pecl-mcrypt.x86_64               1.0.2-2.el7.remi.7.3            @remi-php73
php-pecl-zip.x86_64                  1.15.4-1.el7.remi.7.3           @remi-php73
php-process.x86_64                   7.3.3-1.el7.remi                @remi-php73
php-xml.x86_64                       7.3.3-1.el7.remi                @remi-php73
```

### Laat de firewall het juiste netwerkverkeer door?
1. Op de virtuele machine, gebruik command `sudo firewall-cmd --list-services` om de services weer te geven die de firewall doorlaat
2. De firewall werd correct geconfigureerd als http en https in deze lijst staan

**Voldaan:** We verkregen volgende output:

```
[vagrant@LinuxServer1 ~]$ sudo firewall-cmd --list-services
ssh dhcpv6-client http https
```

### Kunnen we via onze hostmachine Drupal configureren op de VM?
1. Op het hostsysteem, open de browser en surf naar http://192.168.56.31/drupal/
2. Drupal werd correct geïnstalleerd als we op deze webpagina de configuratiepagina van Drupal te zien krijgen

**Voldaan:** De configuratiepagina is correct bereikbaar.

# Testrapport taak 2: WISA stack

## Test 1

Tester: Milan Dewilde

## Doel
### Installatie Windows Server 2016
- Verifieer dat Windows Server 2016 is geïnstalleerd
### Installatie IIS
- Verifieer dat IIS is geïnstalleerd
### Installatie SQL Server
- Verifieer dat SQL Server is geïnstalleerd
### Installatie .NET 4.7.2
- Verifieer dat .NET 4.7.2 is geïnstalleerd
### Installatie ASP.NET
- Verifieer dat ASP.NET is geïnstalleerd
### Configureren IIS Site
- Verifieer dat de site naam correct is ingesteld
- Verifieer dat de IP-adressen, poorten, en hostnaam correct zijn ingesteld
### Configureren SQL Server
- Verifieer dat gebruikersnaam en wachtwoord van SQL Server correct zijn ingegesteld
### ASP.NET Web app hosten
- Verifieer dat de site gestart is
- Verifieer dat de app gehost wordt en bereikbaar is van binnen de VM
- Verifieer dat de app gehost wordt en bereikbaar is van buiten de VM

## Te testen
### Is Windows Server 2016 geïnstalleerd?
1. Start de VM met het commando `vagrant up` in de folder met de Vagrantfile.
2. Wacht tot Virtualbox opstart.
3. Log in op de VM als gebruiker `Vagrant User` met wachtwoord `vagrant`.

**Voldaan**: Inloggen lukt en rechtsonder staat er te lezen dat Windows Server 2016 is geïnstalleerd.

### Is IIS geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op de startknop en open Server Manager.
3. Klik op de knop `Tools` en selecteer de optie `Internet Information Services (IIS) Manager`.

**Voldaan**: IIS is geïnstalleerd

### Is SQL Server geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Open de zoekbalk of druk op de Windows knop.
3. Typ "ssms" en open Microsoft SQL Server Management Studio 17.

**Voldaan**: SSMS is geïnstalleerd

### Is .NET 4.7.2 geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.

**Opmerking:** Indien de VM na installatie nog nooit herstart is herstart het nu via `vagrant reload`, anders is de installatie van `.NET 4.7.2` niet volledig.

2. Open een Powershell venster.

**Opmerking:** Open een standaard `powershell` venster, niet een `powershell (x86)` venster, anders zullen de volgende commandos niet correct werken.

3. Geef het commando ` Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' |  Get-ItemPropertyValue -Name Release | Foreach-Object { $_ -ge 461808 }` in.

**Voldaan**: Dit commando levert 'true'

### Is ASP.NET geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Open een Powershell venster.

**Opmerking:** Net zoals hierboven open een standaard `powershell` venster, niet een `powershell (x86)` venster.

3. Geef het commando `Import-Module servermanager` in gevolgd door het commando `Get-WindowsFeature web-asp-net`.

**Voldaan**: Install state is 'available'

### Is de IIS Site correct geconfigureerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op de startknop en open Server Manager.
3. Klik op de knop `Tools` en selecteer de optie `Internet Information Services (IIS) Manager`.
4. Navigeer in het `Connections` venster links naar `hostname VM` -> `Sites` -> `Naam Site`.

**Voldaan**: De site bestaat met dezelfde naam als gespecifiëerd in het installatiescript 

5. Klik op het tabblad rechts op `Bindings...`

**Voldaan**: Alle instellingen zijn correct geconfigureerd

### Is SQL Server correct geconfigureerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Open de zoekbalk of druk op de Windows knop.
3. Typ "ssms" en open `Microsoft SQL Server Management Studio 17`.
4. Bij het openen staat er bij de Server Name `WINDOWS01\SQLSERVER`
5. Kies bij Authentication voor `SQL Server Authentication`
6. Vul de `Login` en het `Password` in die als variabele staan in het Windows01.ps1 bestand. (Bvb. `admin` & `test123`)
7. In de Object Explorer, druk op de + naast `Databases`

**Voldaan**: De databank maakt en we kunnen inloggen op de server

### Wordt de ASP.NET app correct gehost?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op de startknop en open Server Manager.
3. Klik op de knop `Tools` en selecteer de optie `Internet Information Services (IIS) Manager`.
4. Navigeer in het `Connections` venster links naar `hostname VM` -> `Sites` -> `Naam Site`.
5. Klik op de link onder `Browse Website` in het tabblad rechts.
6. Open op de host computer een browser en navigeer naar het IP-adres dat is ingegeven in het `vagrant-hosts.yml` bestand.

**Voldaan**: De ASP.NET app kan bereikt worden vanuit de browser
