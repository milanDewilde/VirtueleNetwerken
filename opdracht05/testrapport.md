Auteur(s) testrapport: Thibault Dewitte
# Testrapport taak 5: BackupNetwerk

Uitvoerder(s) test: Thibault Dewitte
Uitgevoerd op: 12/05/2019
Github commit:  6fb76f9defc35017e655e3fbf2c8ce8e7f4cb306

## Te testen

## Doel
- Databank wordt gehost op de WebServer
- Lesmateriaal wordt gehost op BackupServer
- Databank wordt gesynchroniseerd op de BackupServer
- Lesmateriaal wordt gesynchroniseerd op de WebServer
- PHP Login werkt naar behoren zodat leerlingen hun lesmateriaal kunnen zien
- De synchronisatieprocessen worden op juiste tijdstippen uitgevoerd

## Te testen
### Databank wordt gehost op de WebServer

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

**Voldaan: bovenstaande uitvoer is verkregen.**


### Lesmateriaal wordt gehost op de WebServer
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

**Voldaan: bovenstaande uitvoer is verkregen.**

### Databank wordt gesynchroniseerd op de BackupServer
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

**Voldaan: bovenstaande uitvoer is verkregen op de backup server.**

### Lesmateriaal wordt gesynchroniseerd op de WebServer

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

**Voldaan: de bovenstaande uitvoer is verkregen.**

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
Voer een actie toe aan de crontab en kijk op de Backupserver of het gesynchroniseerd is. Gebruik `ls -l` om de timestamp te checken.
**Voldaan** als timestamp van /home/DATABANK/leden.csv op BackupServer overeen komt met timestamp in crontab.

**Voldaan.**

### PHP Login werkt naar behoren zodat leerlingen hun lesmateriaal kunnen zien
We gebruiken PHP zodat de leden van op afstand het les materiaal kunnen bekijken. De leden kunnen inloggen met hun unieke gebruikersnaam en uniek wachtwoord. Afhankelijk van hun graad kunnen ze dan het beschikbare lesmateriaal bekijken. Surf naar `192.168.12.12/login.php`.

Log in met ongeldige inloggegevens. Dit moet een foutmelding geven
**Voldaan** als rode foutmelding wordt weer gegeven

**Voldaan: "Your Login Name or Password is invalid" komt er op.**

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

**Voldaan: Alle screenshots zoals hierboven werken.**