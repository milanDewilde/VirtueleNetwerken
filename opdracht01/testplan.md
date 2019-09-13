Auteur(s) testplan Basisconfiguratie van een switch: Milan Dewilde

# Testplan Basisconfiguratie van een switch

## Doel
- configureer hostnames en IP-adressen op 2 IOS switches via de CLI
- Gebruik IOS commands om toegang tot de switches te beperken
- Gebruik IOS commands om de running config op te slaan
- Geef de twee host devices een IP-adres
- Ga na of de apparaten kunnen verbinden

## Te testen
### Zijn er hostnames en IP-adressen geconfigureerd op de switches?
1. Maak een consoleverbinding met de te testen switch
2. **Als de prompt iets anders is dan de standaard `switch>`, dan is er een hostname geconfigureerd**
3. Gebruik command `show ip interface brief` om een overzicht te krijgen van alle interfaces
4. **Als één van deze interfaces een IP-adres heeft, dan is er een IP-adres geconfigureerd**

### Werd de toegang tot de switches beperkt?
1. Maak een consoleverbinding met de te testen switch
2. **Als er bij het openen van een terminalvenster een wachtwoord gevraagd wordt, werd de toegang tot de console line 0 beperkt**
3. Voer het wachtwoord voor all lines in van op het opgavedocument
4. Gebruik command `enable` om in privileged EXEC modus te gaan
5. **Als er opnieuw een wachtwoord gevraagd wordt, werd de toegang tot EXEC modus beperkt**

### Werd de running-config op de switch opgeslaan?
1. Maak een consoleverbinding met de te testen switch
2. Gebruik command `reload` om de switch te herladen
3. **Als na de reload nog steeds zaken anders zijn dan de standaardinstellingen, zoals bijvoorbeeld een andere hostname, dan werd de          running-config opgeslaan als startup-config**

### Werden beide host devices een IP-adres toegekend?
1. Open de desktop van het te testen host device en open de applicatie 'IPv4'
2. **Als de instellingen hier overeen komen met de gegevens uit de addressing table, werd dit toestel een IP-adres toegekend**

### Kunnen de toestellen verbinden?
1. Open een nieuwe command prompt op Student-1
2. Gebruik command `ping 10.10.10.5` om te pingen naar Student-2
3. **Als we replies terugkrijgen van 10.10.10.5, kunnen deze toestellen verbinden**

# Testplan IPv6: Configuring IPv6 Static and Default routes
## Doel
### Deel 1: Bestudeer het netwerk en evalueer waar Static routing nodig is
### Deel 2: Configureer de Static en Default IPv6 routes
### Deel 3: Verifieer de connectie

## Te testen:
### Deel 1: Bestudeer het netwerk en evalueer waar Static routing nodig is
   - Geen testen mogelijk.

### Deel 2: Configureer de Static en Default IPv6 route
#### Stap 1: Stel IPv6 in op alle routers.
1. Kan moeilijk getest worden. Er is geen commando om te kijken of IPv6 enabled is. Er kunnen wel foutmeldingen optreden tijdens IPv6 configuratie die zeggen dat IPv6 niet enabled is.

#### Stap 2: Configureer recursive static routes op router R1
1. Open router R1 in privileged EXEC mode.
2. Gebruik `show ipv6 route` commando om de IPv6 Route tabel te bekijken.
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
3. **Voldaan als alle statische routes zichtbaar zijn. Statische routes zijn aangeduid met S en directly connected routes met C.**

**Opmerking**: `show ipv6 interface brief` commando toont op welke poorten de statische routes geconfigureerd zijn.
```
R1#show ipv6 interface brief
GigabitEthernet0/0         [up/up]
    FE80::1
    2001:DB8:1:1::1
GigabitEthernet0/1         [administratively down/down]
    unassigned
Serial0/0/0                [up/up]
    FE80::1
    2001:DB8:1:A001::1
Serial0/0/1                [administratively down/down]
    unassigned
Vlan1                      [administratively down/down]
    unassigned
```

#### Stap 3: Configureer recursive static routes op router R2
1. Open router R2 in Privileged EXEC mode.
2. Gebruik `show ipv6 route` om routetabel te krijgen en netwerken te controlleren. Verwachte uitvoer:
```
R2#show ipv6 route
IPv6 Routing Table - 9 entries
Codes: C - Connected, L - Local, S - Static, R - RIP, B - BGP
       U - Per-user Static route, M - MIPv6
       I1 - ISIS L1, I2 - ISIS L2, IA - ISIS interarea, IS - ISIS summary
       O - OSPF intra, OI - OSPF inter, OE1 - OSPF ext 1, OE2 - OSPF ext 2
       ON1 - OSPF NSSA ext 1, ON2 - OSPF NSSA ext 2
       D - EIGRP, EX - EIGRP external
S   2001:DB8:1:1::/64 [1/0]
     via Serial0/0/0, directly connected
C   2001:DB8:1:2::/64 [0/0]
     via GigabitEthernet0/0, directly connected
L   2001:DB8:1:2::1/128 [0/0]
     via GigabitEthernet0/0, receive
S   2001:DB8:1:3::/64 [1/0]
     via 2001:DB8:1:A002::2, Serial0/0/1
C   2001:DB8:1:A001::/64 [0/0]
     via Serial0/0/0, directly connected
L   2001:DB8:1:A001::2/128 [0/0]
     via Serial0/0/0, receive
C   2001:DB8:1:A002::/64 [0/0]
     via Serial0/0/1, directly connected
L   2001:DB8:1:A002::1/128 [0/0]
     via Serial0/0/1, receive
L   FF00::/8 [0/0]
     via Null0, receive
``` 

3. **Voldaan als alle statische routes zichtbaar zijn. Statische routes zijn aangeduid met S en directly connected routes met C.**

**Opmerking**: `show ipv6 interface brief` commando toont op welke poorten de statische routes geconfigureerd zijn.
```
R2#show ipv6 interface brief
GigabitEthernet0/0         [up/up]
    FE80::2
    2001:DB8:1:2::1
GigabitEthernet0/1         [administratively down/down]
    unassigned
Serial0/0/0                [up/up]
    FE80::2
    2001:DB8:1:A001::2
Serial0/0/1                [up/up]
    FE80::2
    2001:DB8:1:A002::1
Vlan1                      [administratively down/down]
    unassigned
```

#### Stap 4: Configureer een default route op R3
1. Open router R2 in Privileged EXEC mode.
2. Gebruik `show ipv6 route` om routetabel te krijgen en netwerken te controlleren. Verwachte uitvoer:
  ```
R3#show ipv6 route 
IPv6 Routing Table - 6 entries
Codes: C - Connected, L - Local, S - Static, R - RIP, B - BGP
       U - Per-user Static route, M - MIPv6
       I1 - ISIS L1, I2 - ISIS L2, IA - ISIS interarea, IS - ISIS summary
       O - OSPF intra, OI - OSPF inter, OE1 - OSPF ext 1, OE2 - OSPF ext 2
       ON1 - OSPF NSSA ext 1, ON2 - OSPF NSSA ext 2
       D - EIGRP, EX - EIGRP external
S   ::/0 [1/0]
     via 2001:DB8:1:A002::1
C   2001:DB8:1:3::/64 [0/0]
     via GigabitEthernet0/0, directly connected
L   2001:DB8:1:3::1/128 [0/0]
     via GigabitEthernet0/0, receive
C   2001:DB8:1:A002::/64 [0/0]
     via Serial0/0/1, directly connected
L   2001:DB8:1:A002::2/128 [0/0]
     via Serial0/0/1, receive
L   FF00::/8 [0/0]
     via Null0, receive
  ```
3. **Voldaan als default route zichtbaar is. S ::/0 [1/0] via 2001:DB8:1:A002::1**

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
  2. Open terminal venster op PC's en probeer naar alle PC's te pingen.
  3. **Voldaan als alle PC's naar elkaar kunnen pingen.**

### Deel 3: Verifieer de connectie
1. Zie bovenstaande stap. Verificatie van de connectie is voldaan als alle PC's naar elkaar kunnen pingen.


Auteur(s) testplan labo 1: Bernard Deploige
# Testplan Labo 1: Establishing a Console Session
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

## Te testen
### Deel 1: Toegang verkrijgen tot Cisco switch via de 'Serial Console Port'
1. Rollover console kabel is verbonden met RJ-45 Console poort van de switch
2. Andere uiteinde van Rollover console kabel is verbonden met de seriele COM poort van de computer (of USB-DB9 Adaptor)
3. Toestellen staan aan.
4. **Voldaan als je via PC toegang hebt tot Cisco switch**

### Deel 2: Juiste software versie en klok instellingen
1. Terwijl in EXEC mode `show version` commando tonen om huidige IOS versie te zien van de switch.
2. `show clock` commando toont huidige datum en uur.
3. **Voldaan als `show clock` huidige datum en uur weer geeft**

### Deel 3: Verkrijg toegang tot Cisco Router met Mini-USB console Kabel
1. Mini-USB is verbonden met de mini-USB poort van de router.
2. Andere uiteinde is verbonden met USB poort van de computer.
3. Beide toestellen staan aan.
4. USB driver is geïnstalleerd.
5. **Voldaan als LED indicator groen is op router**

### Deel 4: COM Poort ingeschakelen voor Microsoft Windows PC
1. Open Device Manager en selecteer **Ports (COM & LPT)**. 
2. Boom vertoont verbonden poorten.
3. **Voldaan als seriele poort(en) zichtbaar zijn en er geen uitroepteken (!) bij staat.**

Auteur(s) testplan labo 2: Sean Vancompernolle

# Testplan Labo 2: Building a Simple Network
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
- 2 Cisco switches
- 2 PCs
- 3 Ethernet kabels
- 1 Rollover Console kabel

## Te testen
### Is de netwerk topology zoals gevraagd?
1. Inspecteer de bekabeling.
2. **Indien een ethernet kabel poort F01/1 op switch S1 met poort F0/1 op switch S2 verbindt, een ethernet kabel poort F0/6 op switch S1 met PC-A verbindt, en een ethernet kabel poort F0/18 op switch S2 met PC-B verbindt is aan deze voorwaarde voldaan.**

### Zijn de PCs correct ingesteld en kunnen ze met elkaar communiceren?
1. Open een command prompt op PC-A.
2. Geef het commando `ipconfig /all` in.
3. **Indien het commando bij IP Address `192.168.1.10` weergeeft en bij Subnet Mask `255.255.255.0` is PC-A correct ingesteld.**
4. Geef het commando `ping 192.168.1.11` in.
5. **Indien het commando pakketten ontvangt (en niet time out) kan PC-A communiceren met PC-B.**
6. Open een command prompt op PC-B.
7. Geef het commando `ipconfig /all` in.
8. **Indien het commando bij IP Address `192.168.1.11` weergeeft en bij Subnet Mask `255.255.255.0` is PC-B correct ingesteld.**
9. Geef het commando `ping 192.168.1.10` in.
10. **Indien het commando pakketten ontvangt (en niet time out) kan PC-B communiceren met PC-A.**

### Zijn de switches correct geconfigureerd?
1. Maak een consoleverbinding met de te testen switch.
2. Open een terminalvenster.
3. **Indien bij het openen van de terminal naar een wachtwoord wordt gevraagd is de toegang tot console line 0 beperkt.**
4. Geef als wachtwoord `cisco` in.
5. **Indien je toegang krijgt tot de switch is het wachtwoord correct ingesteld.**
6. Indien na het inloggen de switch de boodschap `Unauthorized access is strictly prohibited and prosecuted to the full extent of the law.` weergeeft is de login banner correct ingesteld.
7. **Indien de commando prompt `S1>` (bij switch S1) of `S2>` (bij switch S2) weergeeft in plaats van de standaard `Switch>` zijn de host namen ingesteld.**
8. Geef het commando `enable` in.
9. **Indien de switch vraagt naar een wachtwoord is de toegang tot privileged EXEC mode beperkt.**
10. Geef als wachtwoord `class` in.
11. **Indien de prompt verandert van `S1>` naar `S1#` (bij switch S1) of van `S2>` naar `S2#` (bij switch S2) is het wachtwoord correct ingesteld.**
12. Geef het commando `reload` in.
13. **Indien na het herladen geen instellingen zijn veranderd (zoals andere hostnaam, geen wachtwoord op login, andere login banner), dan werd de running configuratie correct opgeslagen.**
14. Geef het commando `show running-config` in.
15. **Indien de hierboven genoteerde instellingen worden weergeven wordt de running configuratie correct weergegeven.**
16. Geef het commando `show version` in.
17. **Indien het commando de software versie weergeeft is aan deze voorwaarde voldaan.**
18. Geef het commando `show ip interface brief` in.
19. **Indien het commando een overzicht van alle verbonden interfaces weergeeft is aan deze voorwaarde voldaan.**

Auteur(s) testplan labo 3: Milan Dewilde
# Testplan Labo 3: Building a switch and router network

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

## Wachtwoorden
- EXEC: class
- console line 0: cisco
- vty 0 4: cisco

## Te testen
### Werd er statische IP-informatie aan de netwerkapparaten toegekend?
1. Maak een consoleverbinding met het netwerkapparaat
2. gebruik command `show ip interface brief` om een lijst van de interfaces en hun informatie te krijgen
3. Zoek in deze lijst naar GigabitEthernet0/0 en GigabitEthernet0/1
4. **Als deze interfaces een IP-adres toegekend kregen, werd aan deze voorwaarde voldaan**

### Werd de router geconfigureerd met alle basisinstellingen?
1. Maak een consoleverbinding met de router
2. **Als de router een wachtwoord vraagt, werd toegang tot de console line beperkt**
3. Ga na of de hostname veranderd is door simpelweg de prompt te bekijken
4. **Als deze prompt iets anders is dan de default, werd aan deze voorwaarde voldaan**
5. Gebruik command `enable` om in EXEC modus te gaan
6. **Als hier opnieuw een wachtwoord gevraagd wordt, werd aan deze voorwaarde voldaan**

### Is er verbinding binnen het netwerk?
1. Open een command prompt op PC-A
2. Ping naar het IP-adres van PC-B met `ping 192.168.0.3`
3. **Als we replies krijgen, kunnen we binnen dit netwerk verbinden**


Auteur(s) testplan: Thibault Dewitte

# Testplan Basic Static Route Configuration
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

## Wachtwoorden
Password password

Secret secret

## Te testen
### Een netwerk kabelen aan de hand van een Topology Diagram
  1. Inspecteer de bekabeling en bekijk of deze overeen komt met het topologiediagram.

### Startup configuratie verwijderen en een router herladen naar de default state
  1. Kijk of de startup configuratie is verwijderd en of de router naar de default state is
```
R1>enable
R1#show startup-config
```

### Basis configuratie taken op een router toepassen
  1. Open de CLI van de router
  2. Voer het wachtwoord in
  3. Bekijk de hostname
  4. Typ `configure terminal` en voer het secret in
  5. Typ `show running-config` en check of `no ip domain-lookup` er staat en of `logging synchronous` en `exec-timeout 0 0` bij line con0 en line vty 0 4 staan.

### "Debug ip routing" output interpreteren
Kan niet getest worden.

### Serial en Ethernet interfaces configureren en activeren
Router: Gebruik het commando `show ip interface brief` in de CLI van de router.
PC: Open de command prompt en typ `ipconfig /all`
Vergelijk de gegevens met de addressing table.

### Connectiviteit testen
  #### Stap 1:
  1. Ping van host PC1 naar de default gateway 172.16.3.1
  2. Ping van host PC2 naar de default gateway 172.16.1.1
  3. Ping van host PC3 naar de default gateway 192.168.2.1
Deze zouden alledrie moeten lukken.

#### Stap 2: 
  1. In de CLI van R2 ping 172.16.2.1 (R1)
  2. In de CLI van R2 ping 192.168.1.1 (R3)
Deze zouden allebei moeten lukken.

#### Stap 3: 
  1. Ping van host PC3 naar host PC1 (172.16.3.10)
  2. Ping van host PC3 naar host PC2 (172.16.1.10)
  3. Ping van host PC2 naar host PC1 (172.16.3.10)
  4. Ping van router R1 naar R3 (192.168.1.1)
Deze zouden allemaal niet mogelijk moeten zijn, omdat de routers nog maar enkel de directly connected netwerken kennen.

### Informatie verzamelen om oorzaken van gebrek aan connectiviteit tussen apparaten te ontdekken
Kan niet getest worden.

### Een statische route configureren gebruik makende van een intermediate address
  1. Bekijk de routing tables van R2 en R3 kijk of de statische routes zijn toegevoegd
```
R##show ip route
```
  2. Ping PC1 (172.16.3.10) vanuit de cmd van PC2 

### Een statische route configureren gebruik makende van een exit interface
  1. Bekijk de routing tables van R2 en R3 kijk of de nieuwe statische routes zijn toegevoegd
  2. Als je `show running-config` bekijkt kan je beide routes ook zien staan

### Een statische route met intermediate address vergelijken met een statische route met exit interface
  1. Bekijk de routing table van R3 
De statische route met intermediate address:
`S   172.16.1.0[1/0] via 192.168.1.1`

De statische route met exit interface:
`S   172.16.2.0 is directly connected, Serial3/0`

###  Een default statische route configureren
  1. Bekijk de routing table van R1 en kijk of the gateway of last resort rn S* er in staan.
  2. Ping PC1 (172.16.3.10) in de cmd van PC2 

### Een samenvattende statische route configureren
  1. Bekijk de routing table van R3 en kijk of de twee /24 static routes weg zijn en enkel de /22 statische route er in staat.
  2. Ping PC1 (172.16.3.10) vanuit de cmd van PC3.

### Netwerk implementatie documenteren
Kan niet worden getest.

