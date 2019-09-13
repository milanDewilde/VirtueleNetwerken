Auteur(s) documentatie: Milan Dewilde

# Documentatie Basisconfiguratie van een switch

## Doel
- configureer hostnames en IP-adressen op 2 IOS switches via de CLI
- Gebruik IOS commands om toegang tot de switches te beperken
- Gebruik IOS commands om de running config op te slaan
- Geef de twee host devices een IP adres
- Ga na of de apparaten kunnen verbinden

## Benodigdheden
- 2 switches
- 2 PCs
- Ethernetkabels
- Consolekabels

## Uitvoering
#### Stap 1: configureer hostnames en IP-adressen op 2 IOS switches via de CLI
  1. Verbind via de consolekabel met de switches
  2. In executive modus, voer `conf t` in
  3. Gebruik command `hostname CLASS-A` om de switch een nieuwe naam te geven
  4. Configureer de VLANs en wijs er IP-adressen aan toe met volgende commands:
  ```
  CLASS-A(config)#interface VLAN 1
  CLASS-A(config-if)#ip address 10.10.10.100 255.255.255.0
  CLASS-A(config-if)#no shutdown
  CLASS-A(config-if)#exit
  ```
  Doe dit voor beide switches, uiteraard de correcte adressering op het opgavedocument volgend
  
#### Stap 2: Gebruik IOS commands om toegang tot de switches te beperken
  1. Ken een wachtwoord toe om toegang tot priviliged EXEC modus te beperken met command `enable secret 6EBUp`
  2. Ken een wachtwoord toe om toegang tot de console te beperken met commands  
  ```
  R1(config)# line console 0
  R1(config-line)# password xAw6k
  R1(config-line)# login
  R1(config-line)# exit
  ```
  3. Ken een wachtwoord toe aan vty met commands
  ```
  R1(config)# line vty 0
  R1(config-line)# password xAw6k
  R1(config-line)# login
  R1(config-line)# exit
  ```
  4. Encrypteer de wachtwoorden met command `service password-encryption`
  5. Maak een banner als waarschuwing met commands
  ```
  R1(config)# banner motd #
  Enter TEXT message. End with the character '#'.
  warning, intruders will get shot!
  #
  ```
 
#### Stap 3: Gebruik IOS commands om de running config op te slaan
  1. Vanuit EXEC modus, gebruik command `copy running-config startup-config` om de configuratie op te slaan

#### Stap 4: Geef de twee host devices een IP adres
  1. Gebruik de Desktop IP tool om IP-adressen aan de computers toe te wijzen

#### Stap 5: Ga na of de apparaten kunnen verbinden
  1. Ping vanop Student-1 naar Student-2 om na te gaan om er verbinding mogelijk is
  
Auteur(s) documentatie taak IPv6: Bernard Deploige
# Documentatie taak IPv6: Configuring IPv6 Static and Default Routes

## Doel
#### Deel 1: Bestudeer het netwerk en evalueer waar Static routing nodig is
#### Deel 2: Configureer de Static en Default IPv6 routes
#### Deel 3: Verifieer de connectie

## Uitvoering
### Deel 1: Bestudeer het netwerk en evalueer waar Static routing nodig is
  1. Bestudeer het topology diagram. Er zijn **5 netwerken**.
  2. Er zijn **3 netwerken** directly connected tot R1, R2 en R3.
  3. Het netwerk bevat static routes. **R1: 3 netwerken R2: 2 netwerken, R3: 3 netwerken**.
  4. Gebruik `ipv6 route <ipv6 adress> <serial x/x/x>` commando om IPv6 routes te configureren.

### Deel 2: Configureer de Static en Default IPv6 routes
#### Stap 1: Stel IPv6 in op alle routers
  1. Met commando `ipv6 unicast-routing` laat u de router toe om IPv6 pakketen te forwarden.
  2. Voer dit commando uit in privileged EXEC mode op alle routers in het netwerk.

#### Stap 2: Configureer recursive static routes op router R1
  1. Configureer een IPv6 recursive staticroute naar elk niet-direct verbonden netwerk van router R1. Gebruik `ipv6 route <ipv6-prefix/prefix-length> <next-hop-ipv6-address>` commando.

| Route   |                      Commando                        |
| ------- | ---------------------------------------------------- |
| route0  | `ipv6 route 2001:DB8:1:2::1/64 2001:DB8:1:A001::2`     |
| route1  | `ipv6 route 2001:DB8:1:A002::1/64 2001:DB8:1:A001::2`  |
| route2  | `ipv6 route 2001:DB8:1:3::1/64 2001:DB8:1:A001::2`     |

#### Stap 3: Configureer recursive static routes op router R2
  1. Configureer een directly attached static route van R2 naar R1 LAN. 
  2. Configureer een fully specific route van R2 naar R3

| Stap    | Route   |                          Commando                       |
| ------- | ------- | ------------------------------------------------------- |
|    1    | route0  | `ipv6 route 2001:DB8:1:1::1/64 s0/0/0`                    |
|    2    | route1  | `ipv6 route 2001:DB8:1:3::1/64 s0/0/1 2001:DB8:1:A002::2` |
  
#### Stap 4: Configureer een default route op R3
  1. Connfigureer een recursive default route op R3 om alle netwerken te bereiken die niet direct verbonden zijn. We gebruiken volgend commando in privileged EXEC mode:
  ```
  ipv6 route ::/0 2001:DB8:1:A002::1
  ```

#### Stap 5: Verifieer static route configuratie
  1. Gebruik het `ip config` commando op de PC's om de IPv6 configuratie te verifiëren. De uitvoer is als volgt:
  ```
  C:\>ipconfig

  FastEthernet0 Connection:(default port)

   Link-local IPv6 Address.........: FE80::20A:F3FF:FE15:580C
   IP Address......................: 0.0.0.0
   Subnet Mask.....................: 0.0.0.0
   Default Gateway.................: 0.0.0.0  
  ```
  2. Gebruik het `show ipv6 interface brief` om de geconfigureeerde IPv6 adressen te zien op een een router. De uitvoer is als volgt: 
  ```
  R1#show ipv6 interface brief
  GigabitEthernet0/0         [up/up]
    FE80::1
    2001:DB8:1:1::1
  GigabitEthernet0/1         [administratively down/down]
  Serial0/0/0                [up/up]
    FE80::1
    2001:DB8:1:A001::1
  Serial0/0/1                [administratively down/down]
  Vlan1                      [administratively down/down]
  ```
  3. Om de inhoud van de IPv6 routing tabel te zien gebruik je het `show ipv6 route` commando.
  ```
  R1#show ipv6 route
  IPv6 Routing Table - 8 entries
  Codes: C - Connected, L - Local, S - Static, R - RIP, B - BGP
       U - Per-user Static route, M - MIPv6
       I1 - ISIS L1, I2 - ISIS L2, IA - ISIS interarea, IS - ISIS summary
       O - OSPF intra, OI - OSPF inter, OE1 - OSPF ext 1, OE2 - OSPF ext 2
       ON1 - OSPF NSSA ext 1, ON2 - OSPF NSSA ext 2
       D - EIGRP, EX - EIGRP external
  C   2001:DB8:1:1::/64 [0/0]
     via GigabitEthernet0/0, directly connected
  L   2001:DB8:1:1::1/128 [0/0]
     via GigabitEthernet0/0, receive
  S   2001:DB8:1:2::/64 [1/0]
     via 2001:DB8:1:A001::2
  S   2001:DB8:1:3::/64 [1/0]
     via 2001:DB8:1:A001::2
  C   2001:DB8:1:A001::/64 [0/0]
     via Serial0/0/0, directly connected
  L   2001:DB8:1:A001::1/128 [0/0]
     via Serial0/0/0, receive
  S   2001:DB8:1:A002::/64 [1/0]
     via 2001:DB8:1:A001::2
  L   FF00::/8 [0/0]
  ```


Auteur(s) documentatie: Bernard Deploige

# documentatie taak 1: Labo 1: Establishing a Console Session with Tera Term

## Doel
### Deel 1: Verkrijg toegang tot een Cisco switch via de 'Serial Console Port'
- Maak verbinding met de Cisco switch door gebruik te maken van een 'serial console cable'.
- Breng een console sessie tot stand door gebruikt te maken van een terminal emulator, zoals Tera Term.
### Deel 2: Vertoon en configureer de basis instellingen van het toestel.
- Gebruik `show` commando om de systeem instellingen te tonen.
- Configureer de klok van de switch.
### Deel 3: Verkrijg toegang tot een Cisco router met Mini-USB Console Kabel

## Benodigdheden
- 1 Cisco router
- 1 Switch
- 1 Pc
- 1 Rollover Console kabel
- 1 Mini-USB Console kabel
- (Optioneel) 1 USB-DB9 adaptor

## Uitvoering
### Deel 1: Verkrijg toegang tot een Cisco switch via de ' Serial Console Port'
#### Stap 1: Verbind de Cisco switch en computer door middel van een rollover console kabel
  1. Verbind de rollover console kabel met de RJ-45 console poort van de switch
  2. Verbind het andere uiteinde van de kabel met de seriele COM poort van de computer.
     **Opmerking:** COM poorten zijn meestal niet meer aanwezig op hedendaagse computers. Gebruik een USB-DB9 Adaptor.
  3. Zet de toestellen aan.
  
##### Troubleshoot
  1. Controleer of de rollover console kabel in de juiste poort van de juiste switch zit.
  2. Controleer of de rollover console kabel in de juiste COM poort zit van de juiste computer.
  3. Controleer of beide toestellen aan staan.
  
  #### Stap2: Gebruik een terminal om een console sessie tot stand te brengen met de switch.
   1. Download Tera Term en volg de instructies op het scherm.
   
 ### Deel 2: Vertoon en configureer basis instellingen van het toesel.
 #### Stap 1: Vertoon de basis instellingen van het toestel
  1. Terwijl u zich bevind in EXEC mode, kan u met het `show version` commando zien op welke IOS versie de switch draait.
     De uitvoer van de terminal zou er ongeveer zo uit moeten zien: 
     
```
Switch> show version

Cisco IOS Software, C2960 Software (C2960-LANBASE-M), Version 12.2(25)FX, RELEASE SOFTWARE (fc1)
Copyright (c) 1986-2005 by Cisco Systems, Inc.
Compiled Wed 12-Oct-05 22:05 by pt_team

ROM: C2960 Boot Loader (C2960-HBOOT-M) Version 12.2(25r)FX, RELEASE SOFTWARE (fc4)

System returned to ROM by power-on

Cisco WS-C2960-24TT (RC32300) processor (revision C0) with 21039K bytes of memory.


24 FastEthernet/IEEE 802.3 interface(s)
2 Gigabit Ethernet/IEEE 802.3 interface(s)

63488K bytes of flash-simulated non-volatile configuration memory.
Base ethernet MAC Address       : 00D0.9712.BB93
Motherboard assembly number     : 73-9832-06
Power supply part number        : 341-0097-02
Motherboard serial number       : FOC103248MJ
Power supply serial number      : DCA102133JA
Model revision number           : B0
Motherboard revision number     : C0
Model number                    : WS-C2960-24TT
System serial number            : FOC1033Z1EY
```

#### Stap 2: Configureer de klok.
 1. Terwijl u zich bevind in EXEC mode, kan u met `show clock` de huidige instelling van de klok zien.
 ```
 Switch> show clock
 
 *0:18:57.364 UTC Mon Mar 1 1993
 ```
 2. De klok instellingen kunnen veranderd worden in privileged EXEC mode. Om toegang te krijgen tot privileged EXEC mode, gebruik het `enable` commando.
 ```
 Switch> enable
 ```
 Aan de hand van `#` na de naam van de switch weet je zeker dat je in privileged EXEC mode zit.
 
 3. Om de instellingen van de klok te veranderen gebruiken we `clock set ?` commando. Het vraagteken (?) bied help en laat u toe om de verwachte input te bepalen bij het configureren van de huidige tijd, datum en jaar.
```
Switch# clock set ?
hh:mm:ss Current time

Switch# clock set 10:30:00 feb 19 2019
```
 Met het `Show clock` commando kan u na gaan of de klok juist staat.
 ##### Troubleshoot
 1. Voor het configureren van de klok moet u zich in privileged EXEC mode bevinden. Gebruik `enable` commando. De commandline ziet er zo uit:
 ```
 Switch> enable
 Switch# 
 ```
 2. Bij het instellen van de klok moet je rekening houden met de syntax. Gebruik het vraagteken (?) bij `set clock` commando. De uitvoer toont wat er verwacht wordt.

### Deel 3: Verkrijg toegang tot een Cisco router met Mini-USB Console Kabel
#### Stap 1: Opstellen fysieke connectie met mini-USB kabel.
1. Verbind de mini-USB kabel met de mini-USB poort van de router
2. Verbind het andere uiteinde van de kabel met een USB poort van de computer.
3. Schakel beide toestellen aan.

#### Stap 2: Verifieer dat USB poort van de console klaar is voor gebruik
Als u werkt op een computer met Microsoft Windows als besturingssysteem zal de USB driver geüpdate moeten worden. Deze driver moet geinstalleerd worden voor gebruik van de Cisco router en kan je terug vinden op de [Cisco website](https://software.cisco.com/download/home/282774238/type/282855122/release/3.1).
De USB console poort is klaar als de LED indicator groen wordt.

#### Stap 3: COM poort inschakelen voor Microsoft Windows PC
1. Open **Control panel** via de **Windows start** toets.
2. Open **Device manager**
3. Klik op **Ports (COM & LPT)** om het open te vouwen. Het Cisco Virtual Comm Port icoon toont een uitroepteken.
4. Rechterklik op **Cisco Virtual Comm Port00** en kies update driver software. Selecteer vervolgens "Browse from my computer for driver software".
5. Kies **Let me pick from a list of device drivers on my computer** en klik op **Next**.
6. Kies de **Cisco serial** driver en klik **Next**.
7. De driver installatie is succesvol.

#### Stap 4: (Optioneel) Bepaald het COM poort nummer.
1. Open **Device manager** via **Control Panel** (zie hierboven).
2. Klik op **Ports (COM & LPT)** om het open te vouwen. Selecteer **Cisco Serial**.
3. Open Tera Term (Terminal venster). Kies optie *Serial* en kies de poort. Deze poort is nu klaar voor communicatie met de router.

Auteur(s) documentatie: Sean Vancompernolle

# Documentatie taak 1: Labo 2: Building a Simple Network

## Doel
### Deel 1: Netwerk topology opstelling
- Identificeer de kabels en poorten nodig in het netwerk
- Bekabel de topology in het fysieke labo
### Deel 2: Configureer de PC hosts
- Geef de statische IP adressen in in de LAN interfaces van de hosts
- Verifieer dat the PCs kunnen communiceren via `ping`
### Deel 3: Configureer en verifieer basis switch instellingen
- Configureer elke switch met een hostnaam, lokale wachtwoorden, en een login banner
- Sla de running configuratie op
- Geef de running configuratie weer
- Geef de IOS versie van de switch weer
- Geef de interface statussen weer

## Benodigdheden
- 2 Cisco switches (hierna genoemd S1 en S2)
- 2 PCs (hierna genoemd PC-A en PC-B)
- 3 Ethernet kabels
- 1 Rollover Console kabel

## Uitvoering
### Deel 1: Netwerk topology opstelling
#### Stap 1: Verbind de PCs en switches met elkaar met behulp van de kabels
  1. Schakel alle apparaten aan.
  2. Verbind poort `F0/6` (`FastEthernet0/6`) van switch S1 met de ethernetaansluiting van PC-A.
  3. Verbind poort `F0/18` (`FastEthernet0/18`) van switch S2 met de ethernetaansluiting van PC-B.
  4. Verbind poort `F0/1` (`FastEthernet0/1`) van switch S1 met poort `F0/1` van switch S2.

### Deel 2: Configureer de PC hosts
#### Stap 1: Zet de statische IP-adressen in op de PCs
  1. Open het **Startmenu** en selecteer de optie **Instellingen** (het tandwiel-icoon links).
  2. Selecteer de optie **Netwerk en internet**.
  3. In het tabblad **Status** (standaard geselecteerd als men het venster **Netwerk en internet** opent) selecteer de optie **Adapteropties wijzigen**.
  4. Rechtsklik het icoon **Ethernet** en selecteer de optie **Eigenschappen**.
  5. In de weergegeven lijst op tabblad **Netwerken** selecteer de optie **Internet Protocol versie 4 (TCP/IPv4)** en klik op **Eigenschappen**.
  
  #### Opmerking
  Klik op de tekst **Internet Protocol versie 4 (TCP/IPv4)** en *niet* op het aanvinkhokje links.
  
  6. Selecteer de optie **Het volgende IP-adres gebruiken** en vul het **IP-adres** en **Subnetmasker** in zoals in de onderstaande tabel. Laat de optie **Standaardgateway** leeg.
  7. Sla de instellingen op door te klikken op **OK** en herhaal deze stappen voor de andere PC.
  
  #### IP-adressen en Subnetmaskers
  |PC|IP-adres|Subnetmasker|
  |-|-|-|
  |PC-A|192.168.1.10|255.255.255.0|
  |PC-B|192.168.1.11|255.255.255.0|
#### Stap 2: Verifieer dat the PCs kunnen communiceren via `ping`
  1. Klik op PC-A op het **vergrootglasicoon** in de taakbalk en open het **zoekmenu**.
  2. Geef `cmd` in en klik op enter.
  3. Geef het commando `ipconfig /all` in en bevestig met enter.
  4. Verifieer dat het IP-adres en Subnetmasker correct worden weergegeven.
  ```
  Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : home
   Description . . . . . . . . . . . : Realtek PCIe GBE Family Controller
   Physical Address. . . . . . . . . : D4-3D-7E-FB-41-4B
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
   IPv6 Address. . . . . . . . . . . : 2a02:1811:dc38:ce00:c507:de4e:45de:bae9(Preferred)
   Link-local IPv6 Address . . . . . : fe80::c507:de4e:45de:bae9%23(Preferred)
   IPv4 Address. . . . . . . . . . . : 192.168.1.10(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
  ```
  5. Geef het commando `ping 192.168.1.11` in en bevestig met enter. Verifieer dat de `ping` succesvol was, zoals hieronder aangegeven.
  ```
  > ping 192.168.1.11

  Pinging 192.168.1.11 with 32 bytes of data:
  Reply from 192.168.1.11: bytes=32 time=1ms TTL=64
  Reply from 192.168.1.11: bytes=32 time=1ms TTL=64
  Reply from 192.168.1.11: bytes=32 time=1ms TTL=64
  Reply from 192.168.1.11: bytes=32 time=1ms TTL=64

  Ping statistics for 192.168.1.11:
      Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
  Approximate round trip times in milli-seconds:
      Minimum = 1ms, Maximum = 1ms, Average = 1ms
  ```

### Deel 3: Configureer en verifieer basis switch instellingen
#### Stap 1: Stel een connectie op tussen switch S1 en PC-A
  1. Verbind switch S1 met PC-A door de **Rollover Console kabel** te verbinden met de **RJ-45 console poort** van switch S1 en de **seriële COM poort** van PC-A. Indien PC-A geen COM poort heeft gebruikt een **USB-DB9 Adapter** en verbind de console kabel met een **USB poort**.
  2. Open een terminalemulatie-programma zoals **Tera Term** of **Putty** en verbind met de switch door de seriële COM poort of de gebruikte USB poort.
### Stap 2: Activeer Privileged EXEC modus
  Geef het commando `enable` in. De prompt zal veranderen van `Switch>` naar `Switch#` indien succesvol.
  ```
  Switch>enable
  Switch#
  ```
#### Opmerking
  Indien de switch om een wachtwoord vraagt is de switch niet ingesteld op de basisinstellingen. Reset de switch en probeer opnieuw.
### Stap 3: Activeer configuratie modus
  Geef het commando `configuratie terminal` in om configuratie modus to activeren. De prompt zal veranderen van `Switch#` naar `Switch(config)#` indien succesvol.
  ```
  Switch#configuratie terminal
  Enter configuration commands, one per line.  End with CNTL/Z.
  Switch(config)#
  ```
### Stap 4: Stel de hostnaam in
  Gebruik het commando `hostname S1` om de hostnaam in te stellen op **S1**. De prompt zal veranderen van `Switch(config)#` naar `S1(config)#` indien succesvol.
  ```
  Switch(config)#hostname S1
  S1(config)#
  ```
### Stap 5: Stop ongewenste DNS-opzoekingen
  Om te voorkomen dat de switch verkeerde commandos als als hostnamen beschouwt, geef het commando `no ip domain-lookup` in.
  ```
  S1(config)#no ip domain-lookup
  S1(config)#
  ```
### Stap 6: Stel lokale wachtwoorden in
  Om te voorkomen dat personen zonder correct autorisatie toegang verkrijgen tot de switch stellen we wachtwoorden in, zowel om toegang te verkrijgen via de **console-verbinding** alsook de **Privileged EXEC modus**.
  1. Stel een wachtwoord in voor de **Privileged EXEC modus** via het commando `enable secret WACHTWOORD`. Hier stellen we het wachtwoord in op `class`.
  ```
  S1(config)#enable secret class
  S1(config)#
  ```
  2. Stel een wachtwoord in voor de **console-verbinding** door eerst de console poort te selecteren via het commando `line con 0`. De prompt zal veranderen van `S1(config)#` naar `S1(config-line)#` indien succesvol.
  ```
  S1(config)#line con 0
  S1(config-line)#
  ```
  3. Stel nu een wachtwoord in bij het **inloggen  op de console-verbinding** door het invoeren van de commandos `password WACHTWOORD` gevolgd door `login`. Hier stellen we het wachtwoord in op `cisco`.
  ```
  S1(config-line)#password cisco
  S1(config-line)#login
  S1(config-line)#
  ```
  4. Verlaat nu de instellingen voor de console poort en ga terug naar de normale **configuratiemodus** via het commando `exit`. De prompt zal terug veranderen van `S1(config-line)#` naar `S1(config)#` indien succesvol.
  ```
  S1(config-line)#exit
  S1(config)#
  ```
### Stap 7: Stel een login banner in
  We kunnen een **login banner** instellen via het commando `banner motd #`. De `#` op het einde van het commando kan eender welk karakter zijn, zolang het niet in de boodschap zelf voorkomt, dus pas aan indien nodig. Vul hierna de boodschap in, sluit af met het gebruikte afsluitkarakter (`#`), en bevestig met enter.
  ```
  S1(config)#banner motd #
  Enter TEXT message. End with the character '#'.
  Unauthorized access is strictly prohibited and prosecuted to the full extent of the law. #
  S1(config)#
  ```
### Stap 8: Sla de running configuratie op
  1. Verlaat de **configuratiemodus** via het `exit` commando. De prompt zal terug veranderen van `S1(config)#` naar `S1#` indien succesvol.
  ```
  S1(config)#exit
  S1#
  ```
  2. Sla nu de **running configuratie** op als de **startup configuratie** via het commando `copy running-config startup-config`.
  ```
  S1#copy running-config startup-config
  Destination filename [startup-config]?
  ```
  3. Wanneer de switch de bovenstaande boodschap weergeeft bevestig met enter.
  ```
  Destination filename [startup-config]? [Enter]
  Building configuration...
  [OK]
  S1#
  ```
### Stap 9: Geef de running configuratie weer
  Geef het commando `show running-config` in om de volledige **running configuratie** van de switch weer te geven.
  ```
  S1#show running-config
  Building configuration...
  
  Current configuration : 1271 bytes
  !
  version 12.2
  no service timestamps log datetime msec
  no service timestamps debug datetime msec
  no service password-encryption
  !
  hostname S1
  !
  enable secret 5 $1$mERr$9cTjUIEqNGurQiFU.ZeCi1
  !
  !
  !
  no ip domain-lookup
  !
  !
  spanning-tree mode pvst
  spanning-tree extend system-id
  !
  interface FastEthernet0/1
  !
  interface FastEthernet0/2
  !
  interface FastEthernet0/3
  !
  interface FastEthernet0/4
  !
  interface FastEthernet0/5
  !
  interface FastEthernet0/6
  !
  interface FastEthernet0/7
  !
  interface FastEthernet0/8
  !
  interface FastEthernet0/9
  !
  interface FastEthernet0/10
  !
  interface FastEthernet0/11
  !
  interface FastEthernet0/12
  !
  interface FastEthernet0/13
  !
  interface FastEthernet0/14
  !
  interface FastEthernet0/15
  !
  interface FastEthernet0/16
  !
  interface FastEthernet0/17
  !
  interface FastEthernet0/18
  !
  interface FastEthernet0/19
  !
  interface FastEthernet0/20
  !
  interface FastEthernet0/21
  !
  interface FastEthernet0/22
  !
  interface FastEthernet0/23
  !
  interface FastEthernet0/24
  !
  interface GigabitEthernet0/1
  !
  interface GigabitEthernet0/2
  !
  interface Vlan1
   no ip address
   shutdown
  !
  banner motd ^C
  Unauthorized access is strictly prohibited and prosecuted to the full extent of the law. ^C
  !
  !
  !
  line con 0
   password cisco
   login
  !
  line vty 0 4
   login
  line vty 5 15
   login
  !
  !
  !
  !
  end


  S1#
  ```
### Stap 10: Geef de IOS versie van de switch weer
  Geef het commando `show version` in om de volledige info over de **IOS versie** van de switch weer te geven.
  ```
  S1#show version
  Cisco IOS Software, C2960 Software (C2960-LANBASE-M), Version 12.2(25)FX, RELEASE SOFTWARE (fc1)
  Copyright (c) 1986-2005 by Cisco Systems, Inc.
  Compiled Wed 12-Oct-05 22:05 by pt_team

  ROM: C2960 Boot Loader (C2960-HBOOT-M) Version 12.2(25r)FX, RELEASE SOFTWARE (fc4)

  System returned to ROM by power-on

  Cisco WS-C2960-24TT (RC32300) processor (revision C0) with 21039K bytes of memory.


  24 FastEthernet/IEEE 802.3 interface(s)
  2 Gigabit Ethernet/IEEE 802.3 interface(s)

  63488K bytes of flash-simulated non-volatile configuration memory.
  Base ethernet MAC Address       : 00E0.F9A1.2A5B
  Motherboard assembly number     : 73-9832-06
  Power supply part number        : 341-0097-02
  Motherboard serial number       : FOC103248MJ
  Power supply serial number      : DCA102133JA
  Model revision number           : B0
  Motherboard revision number     : C0
  Model number                    : WS-C2960-24TT
  System serial number            : FOC1033Z1EY
  Top Assembly Part Number        : 800-26671-02
  Top Assembly Revision Number    : B0
  Version ID                      : V02
  CLEI Code Number                : COM3K00BRA
  Hardware Board Revision Number  : 0x01


  Switch   Ports  Model              SW Version              SW Image
  ------   -----  -----              ----------              ----------
  *    1   26     WS-C2960-24TT      12.2                    C2960-LANBASE-M

  Configuration register is 0xF


  S1#
  ```
### Stap 11: Geef de interface statussen weer
  Geef het commando `show ip interface brief` om de **statussen van alle interfaces** weer te geven.
  ```
  S1#show ip interface brief
  Interface              IP-Address      OK? Method Status                Protocol 
  FastEthernet0/1        unassigned      YES manual up                    up 
  FastEthernet0/2        unassigned      YES manual down                  down 
  FastEthernet0/3        unassigned      YES manual down                  down 
  FastEthernet0/4        unassigned      YES manual down                  down 
  FastEthernet0/5        unassigned      YES manual down                  down 
  FastEthernet0/6        unassigned      YES manual up                    up 
  FastEthernet0/7        unassigned      YES manual down                  down 
  FastEthernet0/8        unassigned      YES manual down                  down 
  FastEthernet0/9        unassigned      YES manual down                  down 
  FastEthernet0/10       unassigned      YES manual down                  down 
  FastEthernet0/11       unassigned      YES manual down                  down 
  FastEthernet0/12       unassigned      YES manual down                  down 
  FastEthernet0/13       unassigned      YES manual down                  down 
  FastEthernet0/14       unassigned      YES manual down                  down 
  FastEthernet0/15       unassigned      YES manual down                  down 
  FastEthernet0/16       unassigned      YES manual down                  down 
  FastEthernet0/17       unassigned      YES manual down                  down 
  FastEthernet0/18       unassigned      YES manual down                  down 
  FastEthernet0/19       unassigned      YES manual down                  down 
  FastEthernet0/20       unassigned      YES manual down                  down 
  FastEthernet0/21       unassigned      YES manual down                  down
  FastEthernet0/22       unassigned      YES manual down                  down 
  FastEthernet0/23       unassigned      YES manual down                  down 
  FastEthernet0/24       unassigned      YES manual down                  down 
  GigabitEthernet0/1     unassigned      YES manual down                  down 
  GigabitEthernet0/2     unassigned      YES manual down                  down 
  Vlan1                  unassigned      YES manual administratively down down
  S1#
  ```
### Stap 12: Herhaal stappen 1 tot 11 voor switch S2 om deze in te stellen
  Het enige verschil is de **hostnaam** van `S1` op `S2` instellen.

Auteur(s) documentatie: Milan Dewilde

# documentatie taak 1: Labo 3: Building a Switch and Router Network

## Doel
### Deel 1: Maak een nieuwe topology met de gevraagde instellingen
- Maak een topology volgens de afbeelding en tabel op het opgavedocument
- Initialiseer en herstart de router en de switch
### Deel 2: Configureer de apparaten en ga na of er verbinding gemaakt kan worden
- Ken statische IP informatie toe aan de PC interfaces
- Configureer de router
- Ga na of er verbinding is binnen het netwerk
### Deel 3: Toon informatie van de netwerkapparaten
- Toon hardware- en softwareinformatie van de netwerkapparaten
- Bekijk de routing table
- Toon informatie over de interfaces van de router
- Toon een lijst van alle interfaces op de router en de switch

## Benodigdheden
- 1 Router
- 1 Switch
- 2 PCs
- Consolekabels
- Ethernetkabels

## Uitvoering
### Deel 1: Maak een nieuwe topology en initialiseer de apparaten
#### Stap 1: Zorg dat het netwerk bekabeld is volgens de figuur op het opgavedocument
  1. Gebruik ethernetkabels om de apparaten met elkaar te verbinden
  2. Zorg dat alle apparaten aan staan
  
#### Stap 2: Initialiseer and herlaad de router
  1. Verbind met de router via de consolekabel en ga in EXEC modus
  2. Verwijder de startup configuratie van de router met het command `erase startup-config`
  3. Herlaad de router met het command `reload`  **Opmerking** Als er gevraagd wordt om de configuratie te saven, antwoorden we `no`
  4. Na de reload krijgen we prompt die vraagt of we de 'initial configuration dialog' willen starten, antwoord `no` 
  5. We krijgen een nieuwe prompt die vraagt of we de autoinstall willen beëindigen, antwoord `yes`
  
#### Stap 3: Initialiseer en herlaad de switch
  1. Verbind met de switch via de consolekabel en ga in EXEC modus 
  2. Ga na of er al 'virtual local-area networks' of VLANs zijn aangemaakt met `show flash`  
  als we in deze lijst ergens 'vlan.dat' zien, bestaat er dus al een VLAN en moeten we deze verwijderen
  3. Verwijder, indien gevonden, het 'vlan.dat' bestand met het command `delete vlan.dat`
  4. Verwijder de startup configuratie van de switch met het command `erase startup-config`
  5. Herlaad de switch met het command `reload` **Opmerking**  Als er gevraagd wordt om de configuratie te saven, antwoorden we `no`
  6. Na de reload krijgen we prompt die vraagt of we de 'initial configuration dialog' willen starten, antwoord `no`
  
### Deel 2: Configureer de apparaten en ga na of er verbinding gemaakt kan worden
#### Stap 1: Ken statische IP informatie toe aan de PC interfaces
  1. Ken een IP-adres, subnet mask en default gateway toe aan PC-A volgens de tabel op het opgavedocument  
  Maak gebruik van de Desktop applicatie van het toestel
  2. Ken een IP-adres, subnet mask en default gateway toe aan PC-B volgens de tabel op het opgavedocument  
  Maak gebruik van de Desktop applicatie van het toestel

#### Stap 2: Configureer de router
  1. Verbind met de router via de consolekabel en ga in EXEC modus
  2. Ga in configuratiemodus met command `conf t`
  3. Geef de router een naam met command `hostname R1`
  4. Schakel 'DNS lookup' uit om te voorkomen dat de router verkeerd ingevoerde commands leest als hostname  
  Maak gebruik van command `no ip domain-lookup`
  5. Ken een wachtwoord toe om toegang tot privileged EXEC modus te beperken met command `enable secret JOUWWACHTWOORDHIER`
  6. Ken een wachtwoord toe om toegang tot de console te beperken met commands  
  ```
  R1(config)# line console 0
  R1(config-line)# password ANDERWACHTWOORD
  R1(config-line)# login
  R1(config-line)# exit
  ```
  7. Ken een wachtwoord toe aan vty met commands
  ```
  R1(config)# line vty 0
  R1(config-line)# password NOGEENWACHTWOORD
  R1(config-line)# login
  R1(config-line)# exit
  ```
  8. Encrypteer de wachtwoorden met command `service password-encryption`
  9. Maak een banner als waarschuwing met commands
  ```
  R1(config)# banner motd #
  Enter TEXT message. End with the character '#'.
  Hack mijn router niet aub
  #
  ```
  10. Configureer en activeer beide interfaces op de router met commands 
  ```
  R1(config)# interface g0/0
  R1(config-if)# description verbinding met PC-B.
  R1(config-if)# ip address 192.168.0.1 255.255.255.0
  R1(config-if)# no shutdown
  R1(config-if)#
  *Nov 29 23:49:44.195: %LINK-3-UPDOWN: Interface GigabitEthernet0/0, changed state to down
  *Nov 29 23:49:47.863: %LINK-3-UPDOWN: Interface GigabitEthernet0/0, changed state to up
  *Nov 29 23:49:48.863: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0, changed state to up
  R1(config-if)# interface g0/1
  R1(config-if)# description verbinding met S1.
  R1(config-if)# ip address 192.168.1.1 255.255.255.0
  R1(config-if)# no shutdown
  R1(config-if)# exit
  R1(config)# exit
  *Nov 29 23:50:15.283: %LINK-3-UPDOWN: Interface GigabitEthernet0/1, changed state to down
  *Nov 29 23:50:18.863: %LINK-3-UPDOWN: Interface GigabitEthernet0/1, changed state to up
  *Nov 29 23:50:19.863: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/1, changed state to up
  ```
  11. Sla de running config op als startup config  met command `copy running-config startup-config`
  12. Stel de klok in op de router met command `clock set 22:22:22 19 Feb 2019`
  13. Ping PC-B vanaf PC-A
  
### Deel 3: Toon informatie van de netwerkapparaten
#### Stap 1: Toon hardware en software informatie van de netwerkapparaten
  1. Gebruik command `show version` om de naam van de IOS image, de hoeveelheid DRAM, de hoeveelheid NVRAM en de hoeveelheid Flash geheugen van de **router** te zien
  2. Gebruik command `show version` om de naam van de IOS image, de hoeveelheid DRAM, de hoeveelheid NVRAM en het model number van de **switch** te zien

#### Stap 2: Bekijk de routing table 
  1. Gebruik command `show ip route`

#### Stap 3: Toon informatie over de interfaces van de router
  1. Gebruik command `show interface g0/1` **Opmerking** 'g0/1' uiteraard te vervangen door de interface die je nodig hebt

#### Stap 4: Toon een lijst van alle interfaces op de router en de switch  
  1. Gebruik command `show ip interface brief` op de **router** om een lijst van alle interfaces van de router te zien
  2. Gebruik command `show ip interface brief` op de **switch** om een lijst van alle interfaces van de switch te zien


Auteur(s) documentatie: Thibault Dewitte

# Documentatie Labo 4: Basic Static Route Configuration

## Doelen

- Een netwerk kabelen aan de hand van een Topology Diagram
- Startup configuratie verwijderen en een router herladen naar de default state
- Basis configuratie taken op een router toepassen
- "debug ip routing" output interpreteren
- Serial en Ethernet interfaces configureren en activeren
- Connectiviteit testen
- Informatie verzamelen om oorzaken van gebrek aan connectiviteit tussen apparaten te ontdekken
- Een statische route configureren gebruik makende van een intermediate address
- Een statische route configureren gebruik makende van een exit interface
- Een statische route met intermediate address vergelijken met een statische route met exit interface
- Een default statische route configureren
- Een samenvattende statische route configureren
- Netwerk implementatie documenteren

## Benodigdheden
- 3 Cisco Routers
- 3 Switches
- 3 PCs
- 6 Rollover Console Kabels
- 2 Serial DCE Kabels

## Uitvoering
### Taak 1: Bekabel, verwijder en herlaad de routers
#### Stap 1: Bekabel het netwerk zoals aangegeven in het Topology Diagram
  
#### Stap 2: Verwijder de configuratie op elke router
  1. Gebruik het `erase startup-config`commando
  2. Gebruik het `reload` commando
  3. Antwoord "no" wanneer ze vragen om de veranderingen op te slaan

### Taak 2: Basis router configuratie uitvoeren
#### Stap 1: Gebruik globale configuratie commando's
  1. Open de CLI van de router 1
  2. Typ `enable` om in EXEC modus te gaan
  3. Ga in configuratiemodus met command `configure terminal`
  4. Geef de router een naam met command `hostname R1`
  5. Gebruik het commando `no ip domain-lookup`
  6. Voeg een secret toe:`enable secret SECRET`
  7. Herhaal dit voor alle andere routers


#### Stap 2: Configureer de console en virtual terminal line wachtwoorden op elk van de routers
  1. Ga in configuratiemodus
  2. Voeg een wachtwoord toe

  ```
  R1(config)# line console 0
  R1(config-line)# password PASSWORD
  R1(config-line)# login
  R1(config-line)# exit
  ```
  3. Herhaal dit voor elke router

#### Stap 3: Voeg het `logging synchronous` commando toe aan de console en virtual terminal lines 
Het commando `logging synchronous` voorkomt het onderbreken van je keyboard input door IOS berichten die op de console of Telnet lijnen verschijnen.

  1. Ga in configuratiemodus
  2. Voeg `logging synchronous` toe aan de console en virtual terminal lines
```
R1(config)#line console 0
R1(config-line)#logging synchronous
R1(config-line)#line vty 0 4
R1(config-line)#logging synchronous
```
  3. Herhaal dit voor elke router

#### Stap 4: Voeg het `exec-timeout` commando toe aan de console en virtual terminal lines 
Het commando `exec-timeout minutes seconds` zet het interval dat de EXEC command interpreter wacht tot gebruikers ingave wordt gedetecteerd.

  1. Ga in configuratiemodus
  2. Voeg `exec-timeout 0 0` toe aan de console en virtual terminal lines
```
R1(config)#line console 0
R1(config-line)#exec-timeout 0 0
R1(config-line)#line vty 0 4
R1(config-line)#exec-timeout 0 0
```
  3. Herhaal dit voor elke router


### Taak 3: Debug output interpreteren
#### Stap 1: Op R1 van privileged EXEC mode, voeg het `debug ip routing` commando in
```
R1#debug ip routing
IP routing debugging is on
```

Dit commando toont wanneer routes toegevoegd, aangepast of verwijderd worden van de routing table.

#### Stap 2: Ga in interface configuration mode voor R1's LAN interface
```
R1#configure terminal
Enter configuration commands, one per line. End with CNTL/Z.
R1(config)#interface fastethernet 0/0
R1(config-ig)#ip address 172.16.3.1 255.255.255.0
```

#### Stap 3: Voeg het commando nodig om de route in de routing table te installeren

```
R1(config-ig)#no shutdown
```

#### Stap 4: Verifieer of de nieuwe route in de routing table is
```
R1#show ip route
```

#### Stap 5: Ga in interface configuration mode voor R1's WAN interface verbonden met R2
```
R1#configure terminal
Enter configuration commands, one per line. End with CNTL/Z.
R1(config)#interface Serial 2/0
R1(config-ig)#ip address 172.16.2.1 255.255.255.0
```

#### Stap 6: Voeg het `clock rate` commando toe aan R1
```
R1(config-if)#clock rate 64000
```

#### Stap 7: Voeg het commando nodig om de route in de routing table te installeren

```
R1(config-ig)#no shutdown
```
In tegenstelling tot het configureren van de LAN-interface, garandeert een volledige configuratie van de WAN-interface niet altijd dat de route wordt ingevoerd in de routeringstabel, zelfs als de kabelverbindingen correct zijn. De andere kant van de WAN link moet ook worden geconfigureerd.

#### Stap 8: Configureer de serial voor de WAN van R2 terwijl je beide CLI's open hebt om de debugging output te bekijken
  1. Leg  `debug ip routing` van R2 aan
```
R2#debug ip routing
IP routing debugging is on
```

  2. Ga in interface configuration mode voor R2's WAN interface verbonden met R1
```
R2#configure terminal
Enter configuration commands, one per line. End with CNTL/Z.
R2(config)#interface Serial 2/0
R2(config-ig)#ip address 172.16.2.2 255.255.255.0
```

#### Stap 9: Voeg het commando nodig om de route in de routing table te installeren

```
R2(config-ig)#no shutdown
```

#### Stap 10: Verifieer of de nieuwe route in de routing table van R1 en R2 zijn
```
R1#show ip route
```

```
R2#show ip route
```

#### Stap 11: Leg debugging af op beide routers gebruik makende van `no debug ip routing` of simpel `undebug all`
```
R1(config-if)#end
R1#no debug ip routing
IP routing debugging is off
```


### Taak 4: Router interfaces configureren
#### Stap 1: Configureer de resterende R2 interfaces
  Voltooi het configureren van de resterende interfaces op R2 volgens het topologiediagram en de adressering tafel.
```
R2(config)#interface FastEthernet0/0 
R2(config-if)#ip address 172.16.1.1 255.255.255.0
R2(config-if)#no shutdown
R2(config-if)#exit
R2(config)#interface Serial3/0
R2(config-if)#ip address 192.168.1.2 255.255.255.0
R2(config-if)#no shutdown
```

#### Stap 2: Configureer de resterende R3 interfaces
  Voltooi het configureren van de resterende interfaces op R3 volgens het topologiediagram en de adressering tafel.
```
R3(config)#interface FastEthernet0/0 
R3(config-if)#ip address 192.168.2.1 255.255.255.0
R3(config-if)#no shutdown
R3(config-if)#exit
R3(config)#interface Serial3/0
R3(config-if)#ip address 192.168.1.1 255.255.255.0
R3(config-if)#no shutdown
```


### Taak 5: Configureer IP addressen op de host PCs
#### Stap 1: Configureer de host PC1
Configureer de host PC1 met een IP-adres van 172.16.3.10, subnet mask 255.255.255.0 en een default gateway van 172.16.3.1

#### Stap 2: Configureer de host PC2
Configureer de host PC2 met een IP-adres van 172.16.1.10, subnet mask 255.255.255.0 en een default gateway van 172.16.1.1

#### Stap 3: Configureer de host PC3
Configureer de host PC3 met een IP-adres van 192.168.2.10 ,subnet mask 255.255.255.0 en een default gateway van 192.168.2.1

### Taak 6: Test en verifieer de configuraties
#### Stap 1: Test de connectiviteit
  1. Ping van host PC1 naar de default gateway
  2. Ping van host PC2 naar de default gateway
  3. Ping van host PC3 naar de default gateway
Deze zouden alledrie moeten lukken.

#### Stap 2: Gebruik het `ping` commando om de connectiviteit tussen directly connected routers te testen
  1. In de CLI van R2 ping 172.16.2.1 (R1)
  2. In de CLI van R2 ping 192.168.1.1 (R3)
Deze zouden allebei moeten lukken.

#### Stap 3: Gebruik `ping` om de connectiviteit tussen apparaten die niet verbonden zijn te testen - deze zouden allemaal moeten falen.
  1. Ping van host PC3 naar host PC1
  2. Ping van host PC3 naar host PC2
  3. Ping van host PC2 naar host PC1
  4. Ping van router R1 naar R3
Deze zouden allemaal niet mogelijk moeten zijn, omdat de routers nog maar enkel de directly connected netwerken kennen.

### Taak 7: Verzamel informatie
#### Stap 1: Check de status van de interfaces 
Check de status van de interfaces op elke router met het commando `show ip interface brief`

#### Stap 2: Bekijk de routing table informatie voor alle drie de routers via `show ip route`
De routers zijn niet geconfigureerd met statische of dynamische routing. Daarom kennen de routers enkel de directly connected routers.
Oplossing? Statische routes toevoegen.

### Taak 8: Statische route configureren via een next-hop address
#### Stap 1: Voeg een statische route met een next-hop gespecifieerd toe
 Op de router R3, configureer een statische route naar het 172.16.1.0 network via de Serial3/0 interface van R2 als next-hop adres
```
R3(config)#ip route 172.16.1.0 255.255.255.0 192.168.1.2
R3(config)#
```

#### Stap 2: Verifieer de nieuwe statische route in de routing table van R3 via `show ip route`.
De route zou er moeten bij gekomen zijn, dit kan je bevestigen door dat er een "S" voor de route staat.

#### Stap 3: Gebruik `ping` om de connectiviteit tussen PC3 en PC2 te checken.
Het is niet mogelijk om PC2 te pingen vanaf PC3

#### Stap 4: Op de router R2, configureer een statische route om het 192.168.2.0 netwerk te bereiken
```
R2(config)#ip route 192.168.2.0 255.255.255.0 192.168.1.1
R2(config)#
```

#### Stap 5: Verifeer de statische route in de routing table van R2
De route zou er moeten bij gekomen zijn, dit kan je bevestigen door dat er een "S" voor de route staat

#### Stap 6: Gebruik `ping` om connectiviteit tussen PC3 en PC2 te testen.
Deze ping zou moeten succesvol zijn.
**Eventueel firewall uitzetten indien dit niet lukt.**

### Taak 9: Configureer een statische route via een exit interface
#### Stap 1: Configureer een statische route op de router R3
```
R3(config)#ip route 172.16.2.0 255.255.255.0 Serial3/0
R3(config)#
```

#### Stap 2: Verifeer de statische route in de routing table van R3 via `show ip route`.
Je kan ook `show running-config` gebruiken om te verifiëren dat de statische routes zijn geconfigureerd zijn op R3

#### Stap 3: Configureer een statische route op de router R2
```
R2(config)#ip route 172.16.3.0 255.255.255.0 Serial2/0
R2(config)#
```
#### Stap 4: Verifeer de statische route in de routing table van R2 via `show ip route`.

#### Stap 5: Gebruik `ping` om connectiviteit te checken tussen PC2 en PC1
Deze ping zou moeten falen omdat de router R1 geen return route heeft naar het 172.16.1.0 netwerk in de routing table.

### Taak 10: Configureer een default static route
#### Stap 1: Configureer de router R1 met een default route
```
R1(config)#ip route 0.0.0.0 0.0.0.0 172.16.2.2
R1(config)#
```

#### Stap 2:  Verifeer de statische route in de routing table van R1 via `show ip route`.
Dit zal er bij staan met "Gateway of last resort" en S*.

#### Stap 3: Gebruik `ping` om de connectiviteit tussen PC2 en PC1 te checken.
Van host PC2 kan je PC1 pingen.
Van host PC3 kan je PC1 niet pingen.
Er is geen route naar het 172.16.3.0 netwerk op de R3 router.

### Taak 11: Configureer een samenvattende statische route
We kunnen een andere statische route configureren op R3 voor het 172.16.3.0-netwerk. We hebben er echter al twee statische routes naar 172.16.2.0/24 en 172.16.1.0/24. 
Omdat deze netwerken zo dicht bij elkaar staan, kunnen we ze samenvatten in één route. Dit helpt om de grootte van routeringstabellen te verkleinen, wat maakt het proces voor het opzoeken van de route efficiënter. 
Kijkend naar de drie netwerken op het binaire niveau, kunnen we een gemeenschappelijke grens op de 22e bit vanaf de linkerkant zien.
```
172.16.1.0  10101100.00010000.000000001.00000000
172.16.2.0  10101100.00010000.000000010.00000000
172.16.3.0  10101100.00010000.000000011.00000000

Prefix 172.16.0.0

Bit Mask    11111111.11111111.11111100.00000000

Mask        255.255.252.0
```

#### Stap 1: Configureer de samenvattende statische route op de router R3
```
R3(config)#ip route 172.16.0.0 255.255.252.0 192.168.1.2
```

#### Stap 2:  Verifeer de statische route in de routing table van R3 via `show ip route`.
De twee statische routes met subnet /24 staan er allebei nog op, deze zijn reduntant dus mogen verwijderd worden.

#### Stap 3: Verwijder de statische routes op R3
```
R3(config)#no ip route 172.16.1.0 255.255.255.0 192.168.1.2
R3(config)#no ip route 172.16.2.0 255.255.255.0 Serial3/0
```

#### Stap 4: Verifieer dat de routes niet meer in de routing table zijn
```
R3# show ip route
```
R3 heeft nu slechts één route naar elke host behorende bij netwerken 172.16.0.0/24, 172.16.1.0/24, 172.16.2.0/24 en 172.16.3.0/24. 
Verkeer dat voor deze netwerken is bestemd, wordt via 192.168.1.2 naar R2 gestuurd.

#### Stap 5: Gebruik ping om de connectiviteit tussen PC3 en PC1 te checken
Het is mogelijk om van PC3 naar PC1 te pingen.

Auteur(s): Thibault Dewitte

