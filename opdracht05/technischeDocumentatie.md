# Setup en automatisering van Backup Netwerk installatie

## Vooraf

In dit stappenplan maken we telkens gebruik van Notepad++ voor het wijzigen van .yml, .yaml, .sql en bestanden zonder extensie.

**Ter referentie**

De mappenstructuur van de gebruikte map ziet eruit als volgt:
```
D:\School\Tweede Bachelor TI\Projecten II\p2ops-g12\opdracht05\BackupNetwerk>tree
Folder PATH listing for volume HDD
Volume serial number is 0214-A160
D:.
├───.vagrant
│   ├───machines
│   │   ├───BackupServer
│   │   │   └───virtualbox
│   │   └───WebServer
│   │       └───virtualbox
│   └───rgloader
├───applicatie
│   └───LESMATERIAAL
│       ├───blauw
│       ├───bruin
│       ├───geel
│       ├───groen
│       ├───oranje
│       ├───rood
│       ├───wit
│       └───zwart
├───backuples
│   └───LESMATERIAAL
│       └───geel
├───provisioning
└───scripts
    ├───SCRIPTSBS
    └───SCRIPTSWS
```
## Stap 1: Virtuele machines
Om deze backup structuur waar te maken hebben we gebruikt gemaakt van twee Linux machines. De Web Server is een LAMP stack waar de applicatie op draait en de databank op gehost wordt. De Backup Server is een gewone Linux machine die de NAS simuleert. De twee virtuele machines hebben we gerecupereerd uit opdracht 2. Deze machines zijn volledig geautomatiseerd en eenvoudig op te stellen. Voor de technische en gebruikersdocumentatie van deze machines wijs ik u graag door naar de documentatie van oprdacht 2. `opdracht02 > gebruikersdocumentatie/technische documentatie`.

## Stap 2: Veranderingen aan installatiescript virtuele machines

### Stap 2.1: WebServer
**Concreet:**
 Het is de job van de WebServer om de applicatie en de databank te hosten. Daarnaast is het de bedoeling dat de databank opgeslagen wordt naar de BackupServer. Elke dag om 12 uur 's nachts wordt er een backup gemaakt van de databank op de WebServer naar de BackupServer. Hiervoor maken we gebruik van **r-sync** en **cronjob**. r-sync zorgt voor het synchronisatieproces en cronjob zorgt voor de timing van de synchronisatie. Daarnaast maken we gebruik van PHP om er voor te zorgen dat leden met een bepaalde graad enkel toegang krijgen tot lesmateriaal die voor hen beschikbaar is. Bijvoorbeeld: Een witte gordel kan enkel het lesmateriaal zien voor de graad van witte gordel. Terwijl een groene gordel het lesmateriaal kan zien van wit, geel, oranje en groen. 

**Aanmaak databank:**
In het installatiescript wordt een mock databank opgesteld bij het aanmaken van de virtuele machine. PHP zal deze databank gebruiken om te bepalen wie toegang heeft tot welk les materiaal. De code voor de databank ziet er als volgt uit.
```
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
INSERT INTO leden
    (lid_id, lid_voornaam, lid_achternaam, lid_geboortejaar,lid_graad, username, password)
    VALUES
    (1,"Milan","Dewilde",1996,"zwart","miladewi","test123"),
    (2,"Bernard","Deploige",2055,"zwart","berndepl","test123"),
    (3,"Sean","Vancompernolle",1855,"bruin","seanvanc","test123"),
    (4,"Thibault","Dewitte",1999,"blauw","thibdewi","test123"),
	(5,"Olivier","Rosseel",1999,"wit","oliboss","test123");
CREATE PROCEDURE backupToCSV()
	SELECT lid_id, lid_voornaam, lid_achternaam, lid_geboortejaar, lid_graad, username, password
	FROM leden 
	INTO OUTFILE '/home/DATABANK/leden.csv' 
	FIELDS ENCLOSED BY '"' 
	TERMINATED BY ';' 
	ESCAPED BY '"' 
	LINES TERMINATED BY '\r\n';
_EOF_
```
Om da databank te bezichtigen op de WebServer voer je het commando `mysql -u root -p` uit en vervolgens gebruik je het wachtwoord `root` om in de cli versie van MySQL te werken. Vervolgens gebruik je het commando `select * from leden;` om de tabel te zien te krijgen.

De databank table ziet er als volgt uit
```
+--------+--------------+----------------+------------------+-----------+----------+----------+
| lid_id | lid_voornaam | lid_achternaam | lid_geboortejaar | lid_graad | username | password |
+--------+--------------+----------------+------------------+-----------+----------+----------+
|      1 | Milan        | Dewilde        |             1996 | zwart     | miladewi | test123  |
|      2 | Bernard      | Deploige       |             2055 | zwart     | berndepl | test123  |
|      3 | Sean         | Vancompernolle |             1855 | bruin     | seanvanc | test123  |
|      4 | Thibault     | Dewitte        |             1999 | blauw     | thibdewi | test123  |
|      5 | Olivier      | Rosseel        |             1999 | wit       | oliboss  | test123  |
+--------+--------------+----------------+------------------+-----------+----------+----------+
```
**r-sync en cronjob:**
We gebruiken r-sync voor de synchronisatie naar een remote server, in ons geval word de databank van de Webserver naar BackupServer gesynchroniseerd. Cronjob wordt gebruikt om deze synchronisatie te timen.

De installatie van de software gebeurt tijdens de installatie.
```
info "================> Installing rsync <================"
sudo yum install -y rsync

info "================> Installing cronjob <================"
sudo yum install -y cronie
```
**sshpass:** We gebruiken sshpass om een wachtwoord door te geven tijdens het rsync proces. Voor rsync naar een remote host wordt er een ssh verbinding opgesteld naar de remote host. Om deze te beveiligen wordt er een wachtwoord gebruikt. Om de invoer van dit wachtwoord te automatiseren gebruiken we sshpass.

De installatie van de software gebeurt tijdens de installatie.
```
info "================> Configuring ssh <================"
sudo yum -y install sshpass
```

## Stap 2.2: BackupServer
**Concreet:**
Het is de job van de BackupServer om het les materiaal te hosten. Daarnaast is het de bedoeling dat het les materiaal opgeslagen wordt naar de WebServer zodat de leden aan het materiaal kunnen. Wanneer de lesgever met toegang tot de BackupServer nieuw lesmateriaal wil publiceren, kan hij aan de hand van het script **backupLesmateriaal.sh** het lesmateriaal overzetten naar de WebServer, waar het automatisch wordt aangepast. Hiervoor maken we gebruik van **r-sync**. r-sync zorgt voor het synchronisatieproces. De PHP applicatie op de WebServer regelt wie toegang krijgt tot welk lesmateriaal. 

**Aanmaak lege databank:**
In het installatiescript wordt een lege databank opgesteld bij het aanmaken van de virtuele machine. De backup van de databank op de webserver zal deze lege databank opvullen. De code voor de databank ziet er als volgt uit.

```
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
```
**r-sync en cronjob:**
We gebruiken r-sync voor de synchronisatie naar een remote server, in dit geval word het lesmateriaal van de BackupServer naar WebServer gesynchroniseerd.

De installatie van de software gebeurt tijdens de installatie.
```
info "================> Installing rsync <================"
sudo yum install -y rsync

info "================> Installing cronjob <================"
sudo yum install -y cronie
```
**sshpass:** We gebruiken sshpass om een wachtwoord door te geven tijdens het rsync proces. Voor rsync naar een remote host wordt er een ssh verbinding opgesteld naar de remote host. Om deze te beveiligen wordt er een wachtwoord gebruikt. Om de invoer van dit wachtwoord te automatiseren gebruiken we sshpass.

De installatie van de software gebeurt tijdens de installatie.
```
info "================> Configuring ssh <================"
sudo yum -y install sshpass
```

## Stap 3: Scripts
### Stap 3.1: WebServer
Op de Webserver gebruiken we één script om de backup van de Ledendatabank uit te voeren. Dit script vindt u onder de gedeelde map `scripts > SCRIPTSWS > backupLeden.sh`
Bij het uitvoeren van het script wordt een backup gemaakt van de ledendatabank op de BackupServer. Het script is eenvoudig en ziet er uit als volgt:
```
#!/bin/sh
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail

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
```
De uitvoer van dit script ziet er uit als volgt:
```
[vagrant@WebServer SCRIPTS]$ ./backupLeden.sh
2019-05-11 10:46:58 STARTING MAINTENANCE SCRIPT
2019-05-11 10:46:58 SUCCESS >> Old file deleted
# 192.168.12.24:22 SSH-2.0-OpenSSH_7.4
# 192.168.12.24:22 SSH-2.0-OpenSSH_7.4
# 192.168.12.24:22 SSH-2.0-OpenSSH_7.4
2019-05-11 10:46:58 ADDING WEBSERVER TO KNOWN HOSTS
2019-05-11 10:46:58 SUCCESS >> New file created
sending incremental file list
leden.csv

sent 429 bytes  received 35 bytes  928.00 bytes/sec
total size is 306  speedup is 0.66
2019-05-11 10:46:58 SUCCESS >> DATA SENT TO BACKUPSERVER @192.168.12.24
2019-05-11 10:46:58 ENDING MAINTENANCE SCRIPT
```
Om dit synchornysatie proces te timen gebruiken we `cronjob`. Dit kan niet gescript worden. Om een actie toe te voegen aan cronjob gebruiken we `crontab -e`. Dit opent een document waar je de actie aan kan toevoegen. De syntax om een actie toe te voegen gaat als volgt:
```
* * * * * command to be executed
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)
```

**Bijvoorbeeld:** als we het ledenBackup.sh script elke dag om 12 uur 's nachts willen uitvoeren ziet de syntax er uit als volgt: `0 0 * * * /home/SCRIPTS/backupLeden.sh`.
Om een lijst van cron acties te krijgen gebruiken we het commando `crontab -l`. De uitvoer is als volgt:
```
[vagrant@WebServer SCRIPTS]$ crontab -l
0 0 * * * /home/SCRIPTS/backupLeden.sh
```

### Stap 3.2: BackupServer
Op de BackupServer gebruiken we twee scripts. `backupLesMateriaal.sh` en `ledenToTable.sh`. Deze scripts vindt u onder de gedeelde map `scripts > SCRIPTSWS`.

**ledenToTable.sh:** 
Dit script wordt gebruikt om de backup van de databank om te zetten naar een table. De backup van de databank op WebServer wordt omgezet naar een .csv bestand voor het doorgestuurd wordt naar de BackupServer. In de BackupServer wordt dit bestand ingelezen en omgezet naar een table en in de databank geplaatst op de BackupServer. Het script ziet er uit als volgt:
```
#!/bin/sh
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail
echo "$(date +"%Y-%m-%d %T") STARTING MAINTENANCE SCRIPT "
mysql --user=root --password=root db_leden <<_EOF_
LOAD DATA INFILE '/home/DATABANK/leden.csv' 
	INTO TABLE leden
	FIELDS ENCLOSED BY '"' 
	TERMINATED BY ';' 
	ESCAPED BY '"' 
	LINES TERMINATED BY '\r\n';
_EOF_
echo "$(date +"%Y-%m-%d %T") SUCCESS >> TABLE ALTERED"
echo "$(date +"%Y-%m-%d %T") ENDING MAINTENANCE SCRIPT "
```
De uitvoer is als volgt:
```
[vagrant@BackupServer SCRIPTS]$ ./ledenToTable.sh
2019-05-11 11:02:22 STARTING MAINTENANCE SCRIPT
2019-05-11 11:02:22 SUCCESS >> TABLE ALTERED
2019-05-11 11:02:22 ENDING MAINTENANCE SCRIPT
```
Om da databank te bezichtigen op de BackupServer voer je het commando `mysql -u root -p` uit en vervolgens gebruik je het wachtwoord `root` om in de cli versie van MySQL te werken. Vervolgens gebruik je het commando `select * from leden` om de tabel te zien te krijgen.

De databank table ziet er als volgt uit
```
+--------+--------------+----------------+------------------+-----------+----------+----------+
| lid_id | lid_voornaam | lid_achternaam | lid_geboortejaar | lid_graad | username | password |
+--------+--------------+----------------+------------------+-----------+----------+----------+
|      1 | Milan        | Dewilde        |             1996 | zwart     | miladewi | test123  |
|      2 | Bernard      | Deploige       |             2055 | zwart     | berndepl | test123  |
|      3 | Sean         | Vancompernolle |             1855 | bruin     | seanvanc | test123  |
|      4 | Thibault     | Dewitte        |             1999 | blauw     | thibdewi | test123  |
|      5 | Olivier      | Rosseel        |             1999 | wit       | oliboss  | test123  |
+--------+--------------+----------------+------------------+-----------+----------+----------+
```

**backupLesmateriaal.sh:**
Dit script wordt gebruikt om het lesmateriaal te synchroniseren naar de Webserver zodat de leden het lesmateriaal daar op kunnen bekijken. Het script ziet er uit als volgt:

```
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
```
De uitvoer van het script ziet er als volgt uit:
```
[vagrant@BackupServer SCRIPTS]$ ./backupLesmateriaal.sh
2019-05-11 11:07:25 STARTING BACKUP SCRIPT
2019-05-11 11:07:25 ADDING WEBSERVER TO KNOWN HOSTS
# 192.168.12.12:22 SSH-2.0-OpenSSH_7.4
# 192.168.12.12:22 SSH-2.0-OpenSSH_7.4
# 192.168.12.12:22 SSH-2.0-OpenSSH_7.4
2019-05-11 11:07:26 STARTING BACKUP
sending incremental file list
geel/leerstofgeel.php

sent 746 bytes  received 55 bytes  1,602.00 bytes/sec
total size is 422  speedup is 0.53
2019-05-11 11:07:26 SUCCESS >> DATA SENT TO BACKUPSERVER @192.168.12.24
2019-05-11 11:07:26 ENDING BACKUP SCRIPT
```
## Stap 4: PHP
We gebruiken PHP zodat de leden van op afstand het les materiaal kunnen bekijken. De leden kunnen inloggen met hun unieke gebruikersnaam en uniek wachtwoord. Afhankelijk van hun graad kunnen ze dan het beschikbare lesmateriaal bekijken. Surf naar `192.168.12.12/login.php`.

### Stap 4.1: config.php
In config.php wordt de nodige databank ingesteld. Dit verwijst naar de databank die zal worden ingelezen. Het script ziet er uit als volgt:
```
<?php
   define('DB_SERVER', 'localhost:3306');
   define('DB_USERNAME', 'root');
   define('DB_PASSWORD', 'root');
   define('DB_DATABASE', 'db_leden');
   $db = mysqli_connect(DB_SERVER,DB_USERNAME,DB_PASSWORD,DB_DATABASE);
?>
```
### Stap 4.2: session.php
Session.php zorgt ervoor dat de nodige gegevens zoals username en graad, tijdens een sessie worden bijgehouden om zo de correcte informatie weer te geven. Het script ziet eruit als volgt:
```
<?php
   include('config.php');
   session_start();
   
   $user_check = $_SESSION['login_user'];
   
   $quer = "SELECT username, lid_voornaam, lid_achternaam, lid_graad FROM leden WHERE username = '$user_check';";
   $ses_sql = mysqli_query($db,$quer);
   
   $row = mysqli_fetch_array($ses_sql,MYSQLI_ASSOC);

   $graad = $row['lid_graad'];
   $naam = $row['lid_voornaam'] . " " . $row['lid_achternaam'];

   if(!isset($_SESSION['login_user'])){
      header("location:login.php");
      die();
   }
?>
```
### Stap 4.3: Login.php
Dit login.php bestand bevat de login pagina die de leden te zien krijgen. Hier kunnen ze inloggen om toegang te verkrijgen tot het lesmateriaal. Er wordt gekeken of de ingegeven username en password overeen komen met een lid uit de databank. Het script ziet er uit als volgt: 
```
<?php
   include("config.php");
   session_start();

   if($_SERVER["REQUEST_METHOD"] == "POST") {
      // username and password sent from form 
      
      $myusername = mysqli_real_escape_string($db,$_POST['username']);
      $mypassword = mysqli_real_escape_string($db,$_POST['password']); 
      
      $sql = "SELECT lid_id FROM leden WHERE username = '$myusername' and password = '$mypassword';";
      $result = mysqli_query($db,$sql);

      $count = mysqli_num_rows($result);
      
      // If result matched $myusername and $mypassword, table row must be 1 row
		
      if($count == 1) {
         $_SESSION['login_user'] = $myusername;
         
         header("location: welcome.php");
      }else {
         $error = "Your Login Name or Password is invalid";
      }
   }
?>
<html>

   <head>
      <title>Login Page</title>
      
      <style type = "text/css">
         body {
            font-family:Arial, Helvetica, sans-serif;
            font-size:14px;
         }
         label {
            font-weight:bold;
            width:100px;
            font-size:14px;
         }
         .box {
            border:#666666 solid 1px;
         }
      </style>
      
   </head>
   
   <body bgcolor = "#FFFFFF">
	
      <div align = "center">
         <div style = "width:300px; border: solid 1px #333333; " align = "left">
            <div style = "background-color:#333333; color:#FFFFFF; padding:3px;"><b>Login</b></div>
				
            <div style = "margin:30px">
               
               <form action = "" method = "post">
                  <label>UserName  :</label><input type = "text" name = "username" class = "box"/><br /><br />
                  <label>Password  :</label><input type = "password" name = "password" class = "box" /><br/><br />
                  <input type = "submit" value = " Submit "/><br />
               </form>

               <div style = "font-size:11px; color:#cc0000; margin-top:10px"><?php echo $error; ?></div>
					
            </div>
				
         </div>
			
      </div>

   </body>
</html>
```
![](Screenshots/login.png?raw=true "Loginscherm")
### Stap 4.4: Welcome.php
Indien het lid succesvol is kunnen inloggen wordt het welkom scherm getoond. Dit gebruikt opnieuw informatie uit `session.php`. Afhankelijk van de ingelezen graad uit de databank krijgt het lid de geselecteerde leerstof te zien. Het script ziet er uit als volgt: 
```
<?php
session_start();
include('session.php');
?>
<html>

<head>
   <title>Welkom </title>
</head>

<body>
   <h1>Welkom <?php echo $naam ?></h1>
   <p>Jouw graad is <b><?php echo $graad ?></b></p>
   <h2>Lessen voor jou: </h2>
   <ul>
      <li><a href="/LESMATERIAAL/wit/leerstofwit.php">Witte gordel</li>
      <?php echo ($graad == 'geel' || $graad == 'oranje' || $graad == 'groen' || $graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/geel/leerstofgeel.php">Gele gordel</li>' : '' ?>
      <?php echo ($graad == 'oranje' || $graad == 'groen' || $graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/oranje/leerstoforanje.php">Oranje gordel</li>' : '' ?>
      <?php echo ($graad == 'groen' || $graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/groen/leerstofgroen.php">Groene gordel</li>' : '' ?>
      <?php echo ($graad == 'blauw' || $graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/blauw/leerstofblauw.php">Blauwe gordel</li>' : '' ?>
      <?php echo ($graad == 'bruin' || $graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/bruin/leerstofbruin.php">Bruine gordel</li>' : '' ?>
      <?php echo ($graad == 'zwart' || $graad == 'rood') ? '<li><a href = "/LESMATERIAAL/zwart/leerstofzwart.php">Zwarte gordel</li>' : '' ?>
      <?php echo ($graad == 'rood') ? '<li><a href = "/LESMATERIAAL/rood/leerstofrood.php">Rode gordel</li>' : '' ?>
   </ul>
   <h2><a href="logout.php">Sign Out</a></h2>
</body>

</html>
```
![](Screenshots/welcome.png?raw=true "Welcomecherm")
### Stap 4.5: Leerstof
Als het lid ingelogd is en leerstof selecteert wordt er een php bestand aangeroepen die de leerstof bevat. Hier is een voorbeeld van één van deze paginas die leerstof bevatten:
```
<?php
session_start();
include('../../session.php');
?>
<html>

<head>
   <title>Les 1 - Blauw </title>
</head>

<body>
   <h1>Op naar de bruine gordel, <?php echo $naam ?></h1>
   <h2>Hier vind je alle lessen om je bruine gordel te behalen!</h2>
   <p>Lorem ipsum dolor sit amet, consectetuer adipiscing
      elit. Aenean commodo ligula eget dolor. Aenean massa
      <strong>strong</strong>. Cum sociis natoque penatibus
      et magnis dis parturient montes, nascetur ridiculus
      mus. Donec quam felis, ultricies nec, pellentesque
      eu, pretium quis, sem. Nulla consequat massa quis
      enim. Donec pede justo, fringilla vel, aliquet nec,
      vulputate eget, arcu. In enim justo, rhoncus ut,
      imperdiet a, venenatis vitae, justo. Nullam dictum
      felis eu pede
      mollis pretium. Integer tincidunt. Cras dapibus.
      Vivamus elementum semper nisi. Aenean vulputate
      eleifend tellus. Aenean leo ligula, porttitor eu,
      consequat vitae, eleifend ac, enim. Aliquam lorem ante,
      dapibus in, viverra quis, feugiat a, tellus. Phasellus
      viverra nulla ut metus varius laoreet. Quisque rutrum.
      Aenean imperdiet. Etiam ultricies nisi vel augue.
      Curabitur ullamcorper ultricies nisi.</p>
   <h2><a href="../../welcome.php">Back</a></h2>
   <h2><a href="../../logout.php">Sign Out</a></h2>
</body>

</html>
```
![](Screenshots/leerstof.png?raw=true "Lesmateriaalscherm")


### Stap 4.6: Logout.php
Als het lid klaar is met het bekijken van de leerstof en beslist om zichzelf uit te loggen uit het systeem wordt dit script gebruikt. Het script ziet er uit als volgt:
```
<?php
   session_start();
   
   if(session_destroy()) {
      header("Location: login.php");
   }
?>
```
