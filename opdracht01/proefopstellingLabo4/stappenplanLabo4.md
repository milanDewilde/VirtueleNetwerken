Auteur: Milan Dewilde

# Proefopstelling: Basic Static Route Configuration

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
- 3 Rollover Console Kabels
- 2 Serial DCE Kabels

## Uitvoering
### Taak 1: Bekabel, verwijder en herlaad de routers
#### Stap 1: Bekabel het netwerk zoals aangegeven in het Topology Diagram
  1. Consolekabels van usb op de 3 pc's naar de consoleports op de 3 verschillende routers zoals aangegeven op de topology
  2. Ethernetkabels van de 3 pc's naar de ethernetpoorten op 3 verschillende switches zoals aangegeven op de topology
  3. Ethernetkabels van de 3 switches naar de drie verschillende routers zoals aangegeven op de topology
  4. Serial DCE kabels van Router 1 naar Router 2 en van Router 2 naar Router 3
  
#### Stap 2: Verwijder de configuratie op elke router
  1. Gebruik het `write erase`commando
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
R1(config)#interface g0/0/0
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
R1(config)#interface s0/1/0
R1(config-ig)#ip address 172.16.2.1 255.255.255.0
R1(config-ig)#no shut
```

#### Stap 6: Configureer de serial voor de WAN van R2 terwijl je beide CLI's open hebt om de debugging output te bekijken
  1. Leg  `debug ip routing` van R2 aan
```
R2#debug ip routing
IP routing debugging is on
```

  2. Ga in interface configuration mode voor R2's WAN interface verbonden met R1
```
R2#configure terminal
Enter configuration commands, one per line. End with CNTL/Z.
R2(config)#interface s0/1/0
R2(config-ig)#ip address 172.16.2.2 255.255.255.0
R2(config-ig)#no shut 
```

#### Stap 7: Leg debugging af op beide routers gebruik makende van `no debug ip routing` of simpel `undebug all`
```
R1#no debug ip routing
IP routing debugging is off
```

### Taak 4: Router interfaces configureren
#### Stap 1: Configureer de resterende R2 interfaces
  Voltooi het configureren van de resterende interfaces op R2 volgens het topologiediagram en de adressering tafel.
```
R2(config)#interface g0/0/0 
R2(config-if)#ip address 172.16.1.1 255.255.255.0
R2(config-if)#no shutdown
R2(config-if)#exit
R2(config)#interface s0/1/1
R2(config-if)#ip address 192.168.1.2 255.255.255.0
R2(config-if)#no shutdown
```

#### Stap 2: Configureer de resterende R3 interfaces
  Voltooi het configureren van de resterende interfaces op R3 volgens het topologiediagram en de adressering tafel.
```
R3(config)#interface g0/0/0
R3(config-if)#ip address 192.168.2.1 255.255.255.0
R3(config-if)#no shutdown
R3(config-if)#exit
R3(config)#interface s0/1/0
R3(config-if)#ip address 192.168.1.1 255.255.255.0
R3(config-if)#no shutdown
```

### Taak 5: Configureer IP addressen op de host PCs
#### Stap 1: Configureer de host PC1
1. Via control panel -> network and internet -> adapter settings -> pas het ipv4 adres en de default gateway aan voor de PC die gebruikt wordt als PC1
2. IPV4 adres: 172.16.3.10
   Subnetmask: 255.255.255.0
   Default Gateway: 172.16.3.1
3. Schakel de firewall uit

#### Stap 2: Configureer de host PC2
1. Via control panel -> network and internet -> adapter settings -> pas het ipv4 adres en de default gateway aan voor de PC die gebruikt wordt als PC2
2. IPV4 adres: 172.16.1.10
   Subnetmask: 255.255.255.0
   Default Gateway: 172.16.1.1
3. Schakel de firewall uit

#### Stap 3: Configureer de host PC3
1. Via control panel -> network and internet -> adapter settings -> pas het ipv4 adres en de default gateway aan voor de PC die gebruikt wordt als PC3
2. IPV4 adres: 192.168.2.10
   Subnetmask: 255.255.255.0
   Default Gateway: 192.168.2.1
3. Schakel de firewall uit

### Taak 6: Statische route configureren via een next-hop address
#### Stap 1: Voeg een statische route met een next-hop gespecifieerd toe
 Op R3, configureer een statische route naar het 172.16.1.0 network via de s0/1/0 interface voor de WAN-connectie met R2 als next-hop adres
```
R3(config)#ip route 172.16.1.0 255.255.255.0 192.168.1.2
R3(config)#
```

#### Stap 2: Op R2, configureer een statische route om het 192.168.2.0 netwerk te bereiken
```
R2(config)#ip route 192.168.2.0 255.255.255.0 192.168.1.1
R2(config)#
```

### Taak 7: Configureer een statische route via een exit interface
#### Stap 1: Configureer een statische route op de router R3
```
R3(config)#ip route 172.16.2.0 255.255.255.0 s0/1/0
R3(config)#
```

#### Stap 2: Configureer een statische route op de router R2
```
R2(config)#ip route 172.16.3.0 255.255.255.0 s0/1/1
R2(config)#
```

### Taak 8: Configureer een default static route
#### Stap 1: Configureer de router R1 met een default route
```
R1(config)#ip route 0.0.0.0 0.0.0.0 172.16.2.2
R1(config)#
```

### Taak 9: Configureer een sammenvattende statische route
We kunnen een andere statische route configureren op R3 voor het 172.16.3.0-netwerk. We hebben er echter al twee statische routes naar 172.16.2.0/24 en 172.16.1.0/24. 
Omdat deze netwerken zo dicht bij elkaar staan, kunnen we ze samenvatten in één route. Dit helpt om de grootte van routeringstabellen te verkleinen en helpt om het proces voor het opzoeken van de route efficiënter te maken. 
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

#### Stap 2: Verwijder de statische routes op R3
```
R3(config)#no ip route 172.16.1.0 255.255.255.0 192.168.1.2
R3(config)#no ip route 172.16.2.0 255.255.255.0 Serial3/0
```

## Te testen
De proefopstelling is geslaagd als het lukt om te pingen van elk van de host-PC's naar elk van de andere host-PC's.
1. Vanaf PC3, gebruik command `ping 172.16.3.10` om naar PC1 te pingen
2. Vanaf PC3, gebruik command `ping 172.16.1.10` om naar PC1 te pingen
3. Vanaf PC2, gebruik command `ping 172.16.3.10` om naar PC1 te pingen
4. Vanaf PC2, gebruik command `ping 192.168.2.10` om naar PC3 te pingen
5. Vanaf PC1, gebruik command `ping 172.16.1.10` om naar PC2 te pingen
6. Vanaf PC1, gebruik command `ping 192.168.2.10` om naar PC3 te pingen