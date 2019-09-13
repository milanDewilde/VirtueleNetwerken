# Testrapport IPv6: Configuring IPv6 Static and Default routes

## Test 1

- Uitvoerder(s) test: Thibault Dewitte
- Uitgevoerd op: 24/02/2019
- Github commit: 16e73d77dffd694e07d77580f5f21489fc438c51

## Te Testen
### Deel 1: Bestudeer het netwerk en evalueer waar Static routing nodig is
 Geen testen mogelijk.

### Deel 2: Configureer de Static en Default IPv6 route
#### Stap 1: Stel IPv6 in op alle routers.
 Geen testen mogelijk.

#### Stap 2: Configureer recursive static routes op router R1
 **Voldaan:** Alle statische IPv6 routes zijn zichtbaar.

#### Stap 3: Configureer recursive static routes op router R2
 **Voldaan:** Alle statische IPv6 routes zijn zichtbaar.

#### Stap 4: Configureer recursive static routes op router R3
 **Voldaan:** Alle statische IPv6 routes zijn zichtbaar. 
 Opmerking: in het testplan staat er R2 i.p.v. R3 in de opgave.

#### Stap 5: Verifieer static route configuratie
  1. Gebruik het ip config commando op de PC's om de IPv6 configuratie te verifiëren. 
  
  **Voldaan** - Opmerking: het commando is `ipconfig` niet `ip config`
  
  2. Open terminal venster op PC's en probeer naar alle PC's te pingen.
  3. Voldaan als alle PC's naar elkaar kunnen pingen.
  
  **Niet voldaan:** De PC's kunnen niet naar elkaar pingen.


### Deel 3: Verifieer de connectie


# Testrapport taak 1: Basisconfiguratie van een switch

## Test 1

- Uitvoerder(s) test: Sean Vancompernolle
- Uitgevoerd op: 24/02/2019
- Github commit: 68e8308bb2f0af312d6b050df1c5bfbfab51fcd7

## Te Testen
#### Overzicht:
 - [x] Zijn er hostnames en IP-adressen geconfigureerd op de switches?
 - [x] Werd de toegang tot de switches beperkt?
 - [x] Werd de running-config op de switch opgeslaan?
 - [x] Werden beide host devices een IP-adres toegekend?
 - [x] Kunnen de toestellen verbinden?
### Zijn er hostnames en IP-adressen geconfigureerd op de switches?
1. Maak een consoleverbinding met de te testen switch
2. Als de prompt iets anders is dan de standaard `switch>`, dan is er een hostname geconfigureerd

**Voldaan**: hostnaam is `CLASS-A` bij switch Class-A, en `CLASS-B` bij switch Class-B.

3. Gebruik command `show ip interface brief` om een overzicht te krijgen van alle interfaces
4. Als één van deze interfaces een IP-adres heeft, dan is er een IP-adres geconfigureerd

```
CLASS-A>show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol 
FastEthernet0/1        unassigned      YES manual up                    up 
FastEthernet0/2        unassigned      YES manual up                    up 
FastEthernet0/3        unassigned      YES manual down                  down 
FastEthernet0/4        unassigned      YES manual down                  down 
FastEthernet0/5        unassigned      YES manual down                  down 
FastEthernet0/6        unassigned      YES manual down                  down 
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
Vlan1                  10.10.10.100    YES manual up                    up
```

```
CLASS-B>show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol 
FastEthernet0/1        unassigned      YES manual up                    up 
FastEthernet0/2        unassigned      YES manual up                    up 
FastEthernet0/3        unassigned      YES manual down                  down 
FastEthernet0/4        unassigned      YES manual down                  down 
FastEthernet0/5        unassigned      YES manual down                  down 
FastEthernet0/6        unassigned      YES manual down                  down 
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
Vlan1                  10.10.10.150    YES manual up                    up
```

**Voldaan**: Zowel Vlan1 bij Class-A als Vlan1 bij Class-B hebben een IP-adres.

### Werd de toegang tot de switches beperkt?
1. Maak een consoleverbinding met de te testen switch
2. Als er bij het openen van een terminalvenster een wachtwoord gevraagd wordt, werd de toegang tot de console line 0 beperkt

**Voldaan**: Zowel bij switch Class-A als switch Class-B werd er naar een wachtwoord gevraagd.

3. Voer het wachtwoord voor all lines in van op het opgavedocument

**Voldaan**: Zowel bij switch Class-A als switch Class-B werd het correcte wachtwoord ingesteld.

4. Gebruik command `enable` om in privileged EXEC modus te gaan
5. Als er opnieuw een wachtwoord gevraagd wordt, werd de toegang tot EXEC modus beperkt

**Voldaan**: Zowel bij switch Class-A als switch Class-B werd er naar een wachtwoord gevraagd. Bovendien werd het correcte wachtwoord ingesteld.

### Werd de running-config op de switch opgeslaan?
1. Maak een consoleverbinding met de te testen switch
2. Gebruik command `reload` om de switch te herladen
3. Als na de reload nog steeds zaken anders zijn dan de standaardinstellingen, zoals bijvoorbeeld een andere hostname, dan werd de running-config opgeslaan als startup-config

**Voldaan**: running-config werd correct opgeslagen naar startup-config.

### Werden beide host devices een IP-adres toegekend?
1. Open de desktop van het te testen host device en open de applicatie 'IPv4'
2. Als de instellingen hier overeen komen met de gegevens uit de addressing table, werd dit toestel een IP-adres toegekend

**Voldaan**: De instellingen van zowel Student-1 als Student-2 komen overeen met de gegevens in de addressing tabel.

### Kunnen de toestellen verbinden?
1. Open een nieuwe command prompt op Student-1
2. Gebruik command `ping 10.10.10.5` om te pingen naar Student-2
3. Als we replies terugkrijgen van 10.10.10.5, kunnen deze toestellen verbinden

```
C:\>ping 10.10.10.5

Pinging 10.10.10.5 with 32 bytes of data:

Reply from 10.10.10.5: bytes=32 time=1ms TTL=128
Reply from 10.10.10.5: bytes=32 time<1ms TTL=128
Reply from 10.10.10.5: bytes=32 time<1ms TTL=128
Reply from 10.10.10.5: bytes=32 time<1ms TTL=128

Ping statistics for 10.10.10.5:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 1ms, Average = 0ms
```

**Voldaan**: Student-1 ontvangt pakketten van Student-2. De toestellen zijn verbonden.

# Testrapport taak 1: Labo 1: Establishing a Console Session with Tera Term

## Test 1

- Uitvoerder(s) test: Thibault Dewitte
- Uitgevoerd op: 24/02/2019
- Github commit: 8d8cf59edd3f6b09a5ff38baca2da9e481f06a4d

## Te Testen
### Deel 1: Toegang verkrijgen tot Cisco switch via de 'Serial Console Port'
  1. Rollover console kabel is verbonden met RJ-45 Console poort van de switch
  2. Andere uiteinde van Rollover console kabel is verbonden met de seriele COM poort van de computer (of USB-DB9 Adaptor)
  3. Toestellen staan aan.
  4. Voldaan als je via PC toegang hebt tot Cisco switch
  
  **Stap 1, 2 & 3 zijn voldaan.** 
  Meer uitleg over stap 4 is vereist om ze te testen.


### Deel 2: Juiste software versie en klok instellingen
  1. Terwijl in EXEC mode show version commando tonen om huidige IOS versie te zien van de switch.
  2. show clock commando toont huidige datum en uur.
  3. Voldaan als show clock huidige datum en uur weer geeft
  
  Stap 1 is **voldaan**.
  `show clock commando` toont niet de huidige datum maar 0:21:21.776 UTC Mon Mar 1 1993 = **2/3 niet voldaan**

### Deel 3: Verkrijg toegang tot Cisco Router met Mini-USB console Kabel
  1. Mini-USB is verbonden met de mini-USB poort van de router.
  2. Andere uiteinde is verbonden met USB poort van de computer.
  3. Beide toestellen staan aan.
  4. USB driver is geïnstalleerd.
  5. Voldaan als LED indicator groen is op router
  - Kan niet getest worden op Packet Tracer.


### Deel 4: COM Poort ingeschakelen voor Microsoft Windows PC
  1. Open Device Manager en selecteer Ports (COM & LPT).
  2. Boom vertoont verbonden poorten.
  3. Voldaan als seriele poort(en) zichtbaar zijn en er geen uitroepteken (!) bij staat.
  - Kan niet getest worden op Packet Tracer.

### Conclusie: Deel 1 was in orde. Deel 2 niet, dit kan liggen aan het feit dat de running-config niet was opgeslagen.
Deel 3 en 4 kunnen enkel met fyisieke beproevingen worden getest.

# Testrapport taak 1: Labo 2: Building a Simple Network

## Test 1

- Uitvoerder(s) test: Bernard Deploige
- Uitgevoerd op: 24/02/2019
- Github commit: 38f6da63c67e79461fff120a6848e7261d9155b3

## Te testen
#### Overzicht:
 - [x] Is de netwerk topology zoals gevraagd?
 - [x] Zijn de PCs correct ingesteld en kunnen ze met elkaar communiceren?
 - [x] Zijn de switches correct geconfigureerd?
### Is de netwerk topology zoals gevraagd?
  1. Inspecteer de bekabeling.
  2. Indien een ethernet kabel poort F01/1 op switch S1 met poort F0/1 op switch S2 verbindt, een ethernet kabel poort F0/6 op switch S1 met PC-A verbindt, en een ethernet kabel poort F0/18 op switch S2 met PC-B verbindt is aan deze voorwaarde voldaan.

| S1 | S2 | Status |
| :---     | :---  | :---      |
| F01/1    |   F0/1   |   **Voldaan**   |

| S1 | PC-A | Status |
| :---     | :---  | :---      |
| F0/6     |   PC-A    |   **Voldaan**  |

| S2 | PC-B | Status |
| :-- | :-- | :-- |
| F0/18 |   PC-B    |     **Voldaan**   |

### Zijn de PCs correct ingesteld en kunnen ze met elkaar communiceren?
1. Open een command prompt op PC-A.
2. Geef het commando `ipconfig /all` in.
3. Indien het commando bij IP Address `192.168.1.10` weergeeft en bij Subnet Mask `255.255.255.0` is PC-A correct ingesteld.
```
C:\>ipconfig /all

FastEthernet0 Connection:(default port)

   Connection-specific DNS Suffix..: 
   Physical Address................: 00D0.D338.1615
   Link-local IPv6 Address.........: FE80::2D0:D3FF:FE38:1615
   IP Address......................: 192.168.1.10
   Subnet Mask.....................: 255.255.255.0
   Default Gateway.................: 0.0.0.0
   DNS Servers.....................: 0.0.0.0
   DHCP Servers....................: 0.0.0.0
   DHCPv6 Client DUID..............: 00-01-00-01-4D-94-54-CD-00-D0-D3-38-16-15
```
**Voldaan**: IP adress = `192.168.1.10` Subnetmask = `255.255.255.0`

4. Geef het commando `ping 192.168.1.11` in.
5. Indien het commando pakketten ontvangt (en niet time out) kan PC-A communiceren met PC-B.
```
C:\>ping 192.168.1.11

Pinging 192.168.1.11 with 32 bytes of data:

Reply from 192.168.1.11: bytes=32 time<1ms TTL=128
Reply from 192.168.1.11: bytes=32 time=1ms TTL=128
Reply from 192.168.1.11: bytes=32 time<1ms TTL=128
Reply from 192.168.1.11: bytes=32 time=1ms TTL=128

Ping statistics for 192.168.1.11:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 1ms, Average = 0ms
```
**Voldaan**: PC-A ontvangt ping paketten van PC-B

6. Open een command prompt op PC-B.
7. Geef het commando `ipconfig /all` in.
8. Indien het commando bij IP Address `192.168.1.11` weergeeft en bij Subnet Mask `255.255.255.0` is PC-B correct ingesteld.
```
C:\>ipconfig /all

FastEthernet0 Connection:(default port)

   Connection-specific DNS Suffix..: 
   Physical Address................: 0001.43B3.AB8C
   Link-local IPv6 Address.........: FE80::201:43FF:FEB3:AB8C
   IP Address......................: 192.168.1.11
   Subnet Mask.....................: 255.255.255.0
   Default Gateway.................: 0.0.0.0
   DNS Servers.....................: 0.0.0.0
   DHCP Servers....................: 0.0.0.0
   DHCPv6 Client DUID..............: 00-01-00-01-39-D4-4E-55-00-01-43-B3-AB-8C
```
**Voldaan**: IP adress = `192.168.1.11` Subnetmask = `255.255.255.0`

9. Geef het commando `ping 192.168.1.10` in.
10. Indien het commando pakketten ontvangt (en niet time out) kan PC-B communiceren met PC-A.
```
ping 192.168.1.10

Pinging 192.168.1.10 with 32 bytes of data:

Reply from 192.168.1.10: bytes=32 time<1ms TTL=128
Reply from 192.168.1.10: bytes=32 time<1ms TTL=128
Reply from 192.168.1.10: bytes=32 time<1ms TTL=128
Reply from 192.168.1.10: bytes=32 time<1ms TTL=128

Ping statistics for 192.168.1.10:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
```
**Voldaan**: PC-B ontvangt ping paketten van PC-A

### Zijn de switches correct geconfigureerd?
1. Maak een consoleverbinding met de te testen switch.
2. Open een terminalvenster.
3. Indien bij het openen van de terminal naar een wachtwoord wordt gevraagd is de toegang tot console line 0 beperkt.
**Voldaan**
4. Geef als wachtwoord `cisco` in.
5. Indien je toegang krijgt tot de switch is het wachtwoord correct ingesteld.
6. Indien na het inloggen de switch de boodschap `Unauthorized access is strictly prohibited and prosecuted to the full extent of the law.` weergeeft is de login banner correct ingesteld.
7. Indien de commando prompt `S1>` (bij switch S1) of `S2>` (bij switch S2) weergeeft in plaats van de standaard `Switch>` zijn de host namen ingesteld.
**Voldaan**
8. Geef het commando `enable` in.
9. Indien de switch vraagt naar een wachtwoord is de toegang tot privileged EXEC mode beperkt.
10. Geef als wachtwoord `class` in.
11. Indien de prompt verandert van `S1>` naar `S1#` (bij switch S1) of van `S2>` naar `S2#` (bij switch S2) is het wachtwoord correct ingesteld.
12. Geef het commando `reload` in.
**Voldaan**
13. Indien na het herladen geen instellingen zijn veranderd (zoals andere hostnaam, geen wachtwoord op login, andere login banner), dan werd de running configuratie correct opgeslagen.
**Voldaan**
14. Geef het commando `show running-config` in.
15. Indien de hierboven genoteerde instellingen worden weergeven wordt de running configuratie correct weergegeven.
**Voldaan**
16. Geef het commando `show version` in.
17. Indien het commando de software versie weergeeft is aan deze voorwaarde voldaan.
**Voldaan**
18. Geef het commando `show ip interface brief` in.
19. Indien het commando een overzicht van alle verbonden interfaces weergeeft is aan deze voorwaarde voldaan.
**Voldaan**

# Testrapport taak 1: Labo 3: Building a switch and router network

## Test 1

- Uitvoerder(s) test: Sean Vancompernolle
- Uitgevoerd op: 24/02/2019
- Github commit: 96bcd2651de500cb9da0d942cfd15b71388b2ea1

#### Overzicht:
 - [ ] Is de netwerktopologie zoals gevraagd?
 - [x] Werd er statische IP-informatie aan de netwerkapparaten toegekend?
 - [x] Werd de router geconfigureerd met alle basisinstellingen?
 - [x] Is er verbinding binnen het netwerk?
  
### Is de netwerktopologie zoals gevraagd?

| PC-A | S1 | Status |
| :--- | :--- | :--- |
| PC-A | F0/6 | **Voldaan** |
| PC-A | Console | **Niet Voldaan** |

| S1 | R1 | Status |
| :--- | :--- | :--- |
| F0/5 | G0/1 | **Voldaan** |

| PC-B | R1 | Status |
| :--- | :--- | :--- |
| PC-B | G0/0 | **Voldaan** |
| PC-B | Console | **Niet Voldaan** |

**Niet voldaan**. De ethernetkabels tussen PC-A en S1, S1 en R1, en R1 en PC-B zijn allen aanwezig en in de correcte poorten, maar er zijn twee overbodig consolekabels tussen PC-A en S1, en PC-B en R1 aanwezig. De netwerktopologie is niet volledig zoals gevraagd.

### Werd er statische IP-informatie aan de netwerkapparaten toegekend?

1. Maak een consoleverbinding met het netwerkapparaat
2. gebruik command `show ip interface brief` om een lijst van de interfaces en hun informatie te krijgen
3. Zoek in deze lijst naar GigabitEthernet0/0 en GigabitEthernet0/1
4. Als deze interfaces een IP-adres toegekend kregen, werd aan deze voorwaarde voldaan
```
R1>show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol 
GigabitEthernet0/0     192.168.0.1     YES NVRAM  up                    up 
GigabitEthernet0/1     192.168.1.1     YES NVRAM  up                    up 
Vlan1                  unassigned      YES unset  administratively down down
```
**Voldaan:** `GigabitEthernet0/0` en `GigabitEthernet0/1` hebben beide een IP-adres.

### Werd de router geconfigureerd met alle basisinstellingen?
1. Maak een consoleverbinding met de router
2. Als de router een wachtwoord vraagt, werd toegang tot de console line beperkt

**Voldaan:** router vroeg om wachtwoord, en wachtwoord `cisco` was correct ingesteld.

3. Ga na of de hostname veranderd is door simpelweg de prompt te bekijken
4. Als deze prompt iets anders is dan de default, werd aan deze voorwaarde voldaan

**Voldaan:** prompt is `R1>` in plaats van default.

5. Gebruik command `enable` om in EXEC modus te gaan
6. Als hier opnieuw een wachtwoord gevraagd wordt, werd aan deze voorwaarde voldaan

**Voldaan:** router vroeg om wachtwoord, en wachtwoord `class` was correct ingesteld.

### Is er verbinding binnen het netwerk?
1. Open een command prompt op PC-A
2. Ping naar het IP-adres van PC-B met `ping 192.168.0.3`
3. Als we replies krijgen, kunnen we binnen dit netwerk verbinden
```
C:\>ping 192.168.0.3

Pinging 192.168.0.3 with 32 bytes of data:

Request timed out.
Reply from 192.168.0.3: bytes=32 time<1ms TTL=127
Reply from 192.168.0.3: bytes=32 time<1ms TTL=127
Reply from 192.168.0.3: bytes=32 time<1ms TTL=127

Ping statistics for 192.168.0.3:
    Packets: Sent = 4, Received = 3, Lost = 1 (25% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
```
**Voldaan:** PC-A ontving pakketten van PC-B.

## Test 2

- Uitvoerder(s) test: Sean Vancompernolle
- Uitgevoerd op: 24/02/2019
- Github commit: 51887788b0c4e2c77b9c0f776ec1008599717704

#### Overzicht:
 - [x] Is de netwerktopologie zoals gevraagd?
 - [x] Werd er statische IP-informatie aan de netwerkapparaten toegekend?
 - [x] Werd de router geconfigureerd met alle basisinstellingen?
 - [x] Is er verbinding binnen het netwerk?
  
### Is de netwerktopologie zoals gevraagd?

| PC-A | S1 | Status |
| :--- | :--- | :--- |
| PC-A | F0/6 | **Voldaan** |

| S1 | R1 | Status |
| :--- | :--- | :--- |
| F0/5 | G0/1 | **Voldaan** |

| PC-B | R1 | Status |
| :--- | :--- | :--- |
| PC-B | G0/0 | **Voldaan** |

**Voldaan**. De ethernetkabels tussen PC-A en S1, S1 en R1, en R1 en PC-B zijn allen aanwezig en in de correcte poorten, en de overbodige consolekabels van de vorige test zijn verwijderd. De netwerktopologie is zoals gevraagd.

### Werd er statische IP-informatie aan de netwerkapparaten toegekend?

1. Maak een consoleverbinding met het netwerkapparaat
2. gebruik command `show ip interface brief` om een lijst van de interfaces en hun informatie te krijgen
3. Zoek in deze lijst naar GigabitEthernet0/0 en GigabitEthernet0/1
4. Als deze interfaces een IP-adres toegekend kregen, werd aan deze voorwaarde voldaan
```
R1>show ip interface brief
Interface              IP-Address      OK? Method Status                Protocol 
GigabitEthernet0/0     192.168.0.1     YES NVRAM  up                    up 
GigabitEthernet0/1     192.168.1.1     YES NVRAM  up                    up 
Vlan1                  unassigned      YES unset  administratively down down
```
**Voldaan:** `GigabitEthernet0/0` en `GigabitEthernet0/1` hebben beide een IP-adres.

### Werd de router geconfigureerd met alle basisinstellingen?
1. Maak een consoleverbinding met de router
2. Als de router een wachtwoord vraagt, werd toegang tot de console line beperkt

**Voldaan:** router vroeg om wachtwoord, en wachtwoord `cisco` was correct ingesteld.

3. Ga na of de hostname veranderd is door simpelweg de prompt te bekijken
4. Als deze prompt iets anders is dan de default, werd aan deze voorwaarde voldaan

**Voldaan:** prompt is `R1>` in plaats van default.

5. Gebruik command `enable` om in EXEC modus te gaan
6. Als hier opnieuw een wachtwoord gevraagd wordt, werd aan deze voorwaarde voldaan

**Voldaan:** router vroeg om wachtwoord, en wachtwoord `class` was correct ingesteld.

### Is er verbinding binnen het netwerk?
1. Open een command prompt op PC-A
2. Ping naar het IP-adres van PC-B met `ping 192.168.0.3`
3. Als we replies krijgen, kunnen we binnen dit netwerk verbinden
```
C:\>ping 192.168.0.3

Pinging 192.168.0.3 with 32 bytes of data:

Request timed out.
Reply from 192.168.0.3: bytes=32 time<1ms TTL=127
Reply from 192.168.0.3: bytes=32 time<1ms TTL=127
Reply from 192.168.0.3: bytes=32 time<1ms TTL=127

Ping statistics for 192.168.0.3:
    Packets: Sent = 4, Received = 3, Lost = 1 (25% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
```
**Voldaan:** PC-A ontving pakketten van PC-B.

# Testrapport taak 1: Labo 4: Basic Static Route Configuration

## Test 1

- Uitvoerder(s) test: Milan Dewilde
- Uitgevoerd op: 24/02/2019
- Github commit:  35b3660310dba919c4eab68bd56a84ab7ba7dad8

## Te testen
### Een netwerk kabelen aan de hand van een Topology Diagram
  1. Inspecteer de bekabeling en bekijk of deze overeen komt met het topologiediagram.
  
  **Deze topologie komt overeen**

### Basis configuratie taken op een router toepassen
  1. Open de CLI van de router
  2. Voer het wachtwoord in
  3. Bekijk de hostname
  4. Typ `configure terminal` en voer het secret in
  5. Typ `do show running-config` en check of `no ip domain-lookup` er staat en of `logging synchronous` en `exec-timeout 0 0` bij line con0 en line vty 0 4 staan.

  **Hostname, wachtwoord voor console line 0 en wachtwoord voor toegang tot EXEC modus werd ingesteld. De gevraagde lijnen zijn te vinden in het running-config bestand.**

### Serial en Ethernet interfaces configureren en activeren
Router: Gebruik het commando `show ip interface brief` in de CLI van de router.
PC: Open de command prompt en typ `ipconfig /all`
Vergelijk de gegevens met de addressing table.

**Router: de nodige interfaces werden geconfigureerd en geactiveerd**
**PC: de nodige interfaces werden geconfigureerd**

### Connectiviteit testen
  #### Stap 1:
  1. Ping van host PC1 naar de default gateway 172.16.3.1
  2. Ping van host PC2 naar de default gateway 172.16.1.1
  3. Ping van host PC3 naar de default gateway 192.168.2.1

**In elk van deze gevallen krijgen we replies**

#### Stap 2: 
  1. In de CLI van R2 ping 172.16.2.1 (R1)
  2. In de CLI van R2 ping 192.168.1.1 (R3)

**In beide gevallen krijgen we replies**

#### Stap 3: 
  1. Ping van host PC3 naar host PC1 (172.16.3.10)
  2. Ping van host PC3 naar host PC2 (172.16.1.10)
  3. Ping van host PC2 naar host PC1 (172.16.3.10)
  4. Ping van router R1 naar R3 (192.168.1.1)
Deze zouden allemaal niet mogelijk moeten zijn, omdat de routers nog maar enkel de directly connected netwerken kennen.

**Enkel geval 2 werkt correct**

### Een statische route configureren gebruik makende van een intermediate address
  1. Bekijk de routing tables van R2 en R3 kijk of de statische routes zijn toegevoegd
```
R##show ip route
```
  2. Ping PC1 (172.16.3.10) vanuit de cmd van PC2 

**Er werden statische routes toegekend**

### Een statische route met intermediate address vergelijken met een statische route met exit interface
  1. Bekijk de routing table van R3 
De statische route met intermediate address:
`S   172.16.1.0[1/0] via 192.168.1.1`

De statische route met exit interface:
`S   172.16.2.0 is directly connected, Serial3/0`

**De statische route met intermediate address is aanwezig**
**De statische route met exit interface is niet aanwezig**

###  Een default statische route configureren
  1. Bekijk de routing table van R1 en kijk of the gateway of last resort rn S* er in staan.
  2. Ping PC1 (172.16.3.10) in de cmd van PC2 

**De gateway of last resort is aanwezig in deze routing table**

### Een samenvattende statische route configureren
  1. Bekijk de routing table van R3 en kijk of de twee /24 static routes weg zijn en enkel de /22 statische route er in staat.
  2. Ping PC1 (172.16.3.10) vanuit de cmd van PC3.

**De /22 statische route staat in de lijst**

