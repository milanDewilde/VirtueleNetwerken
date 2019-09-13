Auteur(s) testplan: Bernard Deploige

# Testplan BackupNetwerk
**Vooraf:** De VM's die hier gebruikt worden zijn dezelfde als in opdracht 2. Deze VM's hebben het testplan van opdracht 2 doorlopen en zijn op alle testen geslaagd.
## Doel
- Databank wordt gehost op de WebServer
- Lesmateriaal wordt gehost op BackupServer
- Databank wordt gesynchroniseerd op de BackupServer
- Lesmateriaal wordt gesynchroniseerd op de WebServer
- PHP Login werkt naar behoren zodat leerlingen hun lesmateriaal kunnen zien
- De synchronisatieprocessen worden op juiste tijdstippen uitgevoerd

## Vooraf
- De VM werd geconfigureerd met sudo wachtwoord 'root'
- MySQL databank werd geconfigureerd met username 'root' en wachtwoord 'root'
- Gebruik `vagrant up` om de VM's op te starten
- Eens de VM's opgestart zijn; gebruik `vagrant ssh WebServer` wachtwoord 'vagrant' om in de CLI van WebServer te geraken. gebruik `vagrant ssh BackupServer` wachtwoord 'vagrant' om in de CLI van BackupServer te geraken. 

## Te testen
### Databank wordt gehost op de WebServer
Om da databank te bezichtigen op de WebServer voer je het commando `mysql -u root -p` uit en vervolgens gebruik je het wachtwoord `root` om in de cli versie van MySQL te werken. Hierna selecteer je de database met het commando `use db_leden`. Vervolgens gebruik je het commando `select * from leden` en daarna `\g` om de tabel te zien te krijgen.

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
**Voldaan** als bovenstaande uitvoer verkregen is.

### Lesmateriaal wordt gehost op de BackupServer
Navigeer naar de lesmateriaal directory: `/home/LESMATERIAAL`.
Commando ziet er uit als volgt
```
$ cd /home/LESMATERIAAL
```
De uitvoer is het lesmateriaal per gordel. De uitvoer is als volgt:
```
[vagrant@BackupServer LESMATERIAAL]$ ls -l
total 0
drwxrwxrwx. 2 root    root    6 May 11 13:00 blauw
drwxrwxrwx. 2 root    root    6 May 11 13:00 bruin
drwxrwxrwx. 1 vagrant vagrant 0 May 11 08:07 geel
drwxrwxrwx. 2 root    root    6 May 11 13:00 groen
drwxrwxrwx. 2 root    root    6 May 11 13:00 oranje
drwxrwxrwx. 2 root    root    6 May 11 13:00 rood
drwxrwxrwx. 2 root    root    6 May 11 13:00 wit
drwxrwxrwx. 2 root    root    6 May 11 13:00 zwart


[vagrant@BackupServer LESMATERIAAL]$ tree
.
├── blauw
├── bruin
├── geel
│   └── leerstofgeel.php
├── groen
├── oranje
├── rood
├── wit
└── zwart

8 directories, 1 file
```
**Voldaan** als bovenstaande uitvoer verkregen is.

### Databank wordt gesynchroniseerd op de BackupServer
Op de Webserver gebruiken we één script om de backup van de Ledendatabank uit te voeren. Dit script vindt u onder de gedeelde map `scripts > SCRIPTSWS > backupLeden.sh`
Bij het uitvoeren van het script wordt een backup gemaakt van de ledendatabank op de BackupServer.

Lanceer het script met `./home/SCRIPTS/backupLeden.sh`
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

Ga nu naar de BackupServer en bekijk de databank:
Voer het script `./home/SCRIPTS/ledenToTable.sh` uit om de CSV file om te zetten naar een table. 
Dit script wordt gebruikt om de backup van de databank om te zetten naar een table. De backup van de databank op WebServer wordt omgezet naar een .csv bestand voor het doorgestuurd wordt naar de BackupServer. In de BackupServer wordt dit bestand ingelezen en omgezet naar een table en in de databank geplaatst op de BackupServer.

De uitvoer is als volgt:
```
[vagrant@BackupServer SCRIPTS]$ ./ledenToTable.sh
2019-05-11 11:02:22 STARTING MAINTENANCE SCRIPT
2019-05-11 11:02:22 SUCCESS >> TABLE ALTERED
2019-05-11 11:02:22 ENDING MAINTENANCE SCRIPT
```

Om da databank te bezichtigen op de BackupServer voer je het commando `mysql -u root -p` uit en vervolgens gebruik je het wachtwoord `root` om in de cli versie van MySQL te werken. Vervolgens gebruik je het commando `use db_leden` en vervolgens `select * from leden` gevolgd door `\g` om de tabel te zien te krijgen.

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
**Voldaan** als bovenstaande uitvoer verkregen is.

### Lesmateriaal wordt gesynchroniseerd op de WebServer
Dit script wordt gebruikt om het lesmateriaal te synchroniseren naar de Webserver zodat de leden het lesmateriaal daar op kunnen bekijken. Voer dit script uit door `./home/SCRIPTS/backupLesmateriaal.sh` uit te voeren.

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
Ga nu naar de WebServer en kijk onder de directory `var/www/html/LESMATERIAAL`
De uitvoer is als volgt:
```
[vagrant@WebServer home]$ cd /var/www/html/LESMATERIAAL/
[vagrant@WebServer LESMATERIAAL]$ ls
blauw  bruin  geel  groen  oranje  rood  wit  zwart
[vagrant@WebServer LESMATERIAAL]$ ls -l
total 0
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 blauw
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 bruin
drwxrwxrwx. 1 vagrant vagrant 0 May 11 13:19 geel
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 groen
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 oranje
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 rood
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 wit
drwxrwxrwx. 1 vagrant vagrant 0 May 10 19:06 zwart
[vagrant@WebServer LESMATERIAAL]$ tree
.
├── blauw
│   └── leerstofblauw.php
├── bruin
│   └── leerstofbruin.php
├── geel
│   └── leerstofgeel.php
├── groen
│   └── leerstofgroen.php
├── oranje
│   └── leerstoforanje.php
├── rood
│   └── leerstofrood.php
├── wit
│   └── leerstofwit.php
└── zwart
    └── leerstofzwart.php

8 directories, 8 files
```
**Voldaan** als bovenstaande uitvoer verkregen is.

Om dit synchronisatieproces te timen gebruiken we `cronjob`. Dit kan niet gescript worden. Om een actie toe te voegen aan cronjob gebruiken we `crontab -e`. Dit opent een document waar je de actie aan kan toevoegen. De syntax om een actie toe te voegen gaat als volgt:
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
Voer een actie toe aan de crontab en kijk op de Backupserver of het gesynchroniseerd is. Navigeer in BackupServer naar `/home/DATABANK/` en gebruik `ls -l` om de timestamp te checken.
**Voldaan** als timestamp op backupServer overeen komt met timestamp in crontab

### PHP Login werkt naar behoren zodat leerlingen hun lesmateriaal kunnen zien
We gebruiken PHP zodat de leden van op afstand het les materiaal kunnen bekijken. De leden kunnen inloggen met hun unieke gebruikersnaam en uniek wachtwoord. Afhankelijk van hun graad kunnen ze dan het beschikbare lesmateriaal bekijken. Surf naar `192.168.12.12/login.php`.

Log in met ongeldige inloggegevens. Dit moet een foutmelding geven
**Voldaan** als rode foutmelding wordt weer gegeven

Log in met juiste inlog gegevens. Kies gebruiker uit onderstaande tabel en gebruik username en password om in te loggen. Indien het lid succesvol is kunnen inloggen wordt het welkom scherm getoond. 

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
![](Screenshots/login.png?raw=true "Loginscherm")
![](Screenshots/welcome.png?raw=true "Welcomescherm")
**Voldaan** als bovenstaand screenshot is bereikt.

Indien het lid succesvol is kunnen inloggen wordt het welkom scherm getoond. Hier wordt het lesmateriaal getoont. Gebruiker kan hier kiezen welk lesmateriaal hij/zij wil zien. Kies een gordel.

![](Screenshots/welcome.png?raw=true "Welcomescherm")
![](Screenshots/leerstof.png?raw=true "Lesmateriaalscherm")
**Voldaan** als bovenstaand screenshot is bereikt.

Als gebruiker op terug knop drukt wordt hij/zij terug gestuurd naar het Welkom scherm. 

![](Screenshots/welcome.png?raw=true "Welcomescherm")
**Voldaan** als bovenstaand screenshot is bereikt.

Als gebruiker op Logout knop drukt wordt hij/zij terug gestuurd naar het Login scherm. 

![](Screenshots/login.png?raw=true "Loginscherm")
**Voldaan** als bovenstaand screenshot is bereikt.