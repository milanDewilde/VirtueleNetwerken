https://docs.microsoft.com/en-us/sccm/mdt/
https://docs.microsoft.com/en-us/windows/deployment/deploy-windows-mdt/deploy-a-windows-10-image-using-mdt
https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install

## Software used: 
- Microsoft Deployment Toolkit (MDT)
- Microsoft ADK for Windows 10
- Windows 10 Enterprise Evaluation
- jacqinthebox/windowsserver2016 uit de vagrant cloud
- VirtualBox 6.0.6
- Vagrant

## Handleiding

**Opmerking**: Gebruik tijdens onderstaande stappen normale `Powershell`-vensters, niet `Powershell (x86)`-vensters.

**Opmerking 2:** Indien men de standaard Vagrant box `jacqinthebox/windowsserver2016` gebruikt voer dan na de eerste opstart het script `extend-trial.cmd` uit op het bureaublad.

### Installatie AD Domain Services en ADDSForest op Domain Controller
1. Gebruik het commando `vagrant up DomainController` in een Powershell-venster met administrator-privileges om de`DomainController` VM op te starten.
2. Log in op VM `DomainController` als gebruiker `Vagrant User` met wachtwoord `vagrant`.
3. Navigeer naar `C:\Setup\Scripts\` en open een Powershell-venster met administrator-privileges.
4. Voer het commando `.\AD-Forest.ps1` in en wacht tot het script volledig uitgevoerd is en de VM automatisch herstart is.

### Toevoegen DNS en DHCP rol aan Domain Controller
1. Log in op VM `DomainController` zoals hierboven aangegeven.
2. Navigeer naar `C:\Setup\Scripts\` en open een Powershell-venster met administrator-privileges.
3. Voer het commando `.\DC-AddRoles.ps1` in en wacht tot het script volledig uitgevoerd is.
4. Log uit van de VM.

### DHCP activeren op Domain Controller en Active Directory Permissies Configureren
1. Log in op VM `DomainController` zoals hierboven aangegeven.
2. Navigeer naar `C:\Setup\Scripts\` en open een Powershell-venster met administrator-privileges.
3. Voer het commando `.\AD-Permissions.ps1` in en wacht tot het script volledig uitgevoerd is.

### MDT Server toevoegen aan hetzelfde domein als de Domain Controller
1. Start de VM `DomainController` op zoals hierboven aangegeven (indien deze nog opgestart is van de vorige stappen volstaat dit ook).
2. Gebruik het commando `vagrant up MDTServer` in een Powershell-venster met administrator-privileges om de`MDTServer` VM op te starten.
3. Log in op VM `MDTServer` als gebruiker `Vagrant User` met wachtwoord `vagrant`.
4. Navigeer naar `C:\Setup\Scripts\` en open een Powershell-venster met administrator-privileges.
4. Voer het commando `.\MDT-JoinDomain.ps1` in en wacht tot het script volledig uitgevoerd is en de VM automatisch herstart is.

### MDT Server Setup en MDT Production Deployment Share opzetten op de MDT Server
1. Start de VM `DomainController` op zoals hierboven aangegeven (indien deze nog opgestart is van de vorige stappen volstaat dit ook).
2. Log in op VM `MDTServer` zoals hierboven aangegeven.
3. Navigeer naar `C:\Setup\Scripts\` en open een Powershell-venster met administrator-privileges.
4. Voer het commando `.\Setup-MDTServer.ps1` in en wacht tot het script volledig uitgevoerd is.

### Windows 10 Reference Image instellen

**Opmerking:** Voor deze stap wordt verondersteld dat een Windows 10 reference image werd aangemaakt volgens [dit stappenplan.](https://docs.microsoft.com/en-us/windows/deployment/deploy-windows-mdt/create-a-windows-10-reference-image) Voor testen bieden wij [hier](https://mega.nz/#!OAYBlQBC!zA8NJ35Z4k_WMWHeZqz4yJkKnE62HZZvolW7M1X5Z9E) een standaard Windows 10 reference image aan om het testen sneller te doen verlopen.

1.Plaats het `.wim` reference image bestand aangemaakt volgens bovenstaand stappenplan in de folder `/scripts` in de hoofdmap van de applicatie. 

### Installatiebestanden Open Office instellen
1. Download de laatste nieuwe versie van Open Office voor de 64-bit versie van Windows 10 van [deze link.](https://www.openoffice.org/nl/download/)
2. Voer het uitvoerbaar bestand uit en pak de installatiebestanden uit naar `/scripts/apps/Open Office` in de hoofdmap van de applicatie. Indien deze folder niet bestaat maak ze aan.

### MDT Deployment voorbereiden
1. Start de VM `DomainController` op zoals hierboven aangegeven (indien deze nog opgestart is van de vorige stappen volstaat dit ook).
2. Log in op VM `DMTServer` zoals hierboven aangegeven.
3. Navigeer naar `C:\Setup\Scripts\` en open een Powershell-venster met administrator-privileges.
4. Voer het commando `.\MDT-PrepareDeployment.ps1` in en wacht tot het script volledig uitgevoerd is.

### Deployment van Windows 10 en installeren van programma's op client PC.
1. Start de VM `DomainController` op zoals hierboven aangegeven (indien deze nog opgestart is van de vorige stappen volstaat dit ook).
2. Start de VM `MDTServer` op zoals hierboven aangegeven (indien deze nog opgestart is van de vorige stappen volstaat dit ook).
3. Start de client PC op in PXE mode.

**Opmerking:** Voor het testen kan deze client PC een VM zijn in Virtualbox. Instructies voor het opstellen van deze VM staan aan de onderkant van deze stap.

4. Wacht tot de MDT wizard start en selecteer `Windows 10 Enterprise x64 RTM Custom Image`.
5. Geef een hostnaam in voor de computer.
6. Selecteer `Adobe Reader`, `Open Office`, en `Java` bij de applicaties alvorens te bevestigen.
7. Wacht tot de deployment volledig is uitgevoerd. Dit kan enkele uren duren.

#### Opstellen VirtualBox VM voor testen

1. Download en installeer het *VirtualBox 6.0.6 Oracle VM VirtualBox Extension Pack* van [deze link.](https://download.virtualbox.org/virtualbox/6.0.6/Oracle_VM_VirtualBox_Extension_Pack-6.0.6.vbox-extpack)
2. Klik in de VirtualBox Manager op `Machine` en dan op `Nieuw`.
3. Geef een naam in voor de VM, laat het Type op `Microsoft Windows` staan, verander de versie naar `Windows 10 (64-bit)`, en klik op `Volgende`.
4. Geef de VM 2048 MB RAM-geheugen en klik op `Volgende`.
5. Selecteer de optie `Maak nieuwe virtuele harde schijf nu aan` en klik op `Aanmaken`.
6. Selecteer als bestandstype `VHD (Virtual Hard Disk)` en klik op `Volgende`.
7. Selecteer de optie `Dynamisch gealloceerd` en klik op `Volgende`.
8. Vergroot de grootte van de harde schijf naar 60GB en klik op `Aanmaken`.
9. Selecteer de nieuwe VM in de lijst en klik op `Instellingen`.
10. Navigeer naar categorie `Netwerk`, verander voor `Adapter 1` de koppeling van `NAT` naar `Intern netwerk`, zorg ervoor dat er bij `Naam` `intnet` ingegeven is, klik op de optie `Geavanceerd`, en verander de `Promiscuous-modus` van `Afwijzen` naar `Alle toestaan`. Zorg ervoor dat de optie `Netwerkadapter inschakelen` aangevinkt staat.
11. Navigeer nu naar `Adapter 2` van categorie `Netwerk`, vink `Netwerkadapter inschakelen` aan, en verander de koppeling van `Niet aangesloten` naar `NAT`.
12. Navigeer naar het tabblad `Moederbord` van categorie `Systeem`, vink bij `Opstartvolgorde` de optie `Netwerk` aan, en gebruik de pijltjes om deze optie bovenaan de volgorde te plaatsen (of versleep de optie).
13. Sla deze instellingen op door te bevestigen met de knop `OK`.
14. Start nu de VM met de knop `Starten`.
15. Wacht tot het VirtualBox splash-screen voorbij is gegaan. Hierna zal de VM een IP-adres toegewezen krijgen door DHCP van de Domain Controller. Meteen hierna zal de VM vragen om `F12` in te geven om op te starten in PXE-mode. Geef dan `F12` in.

De VirtualBox VM is nu aangemaakt en opgestart in PXE-mode.