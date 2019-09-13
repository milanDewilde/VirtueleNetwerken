# IOS Cheat Sheet
## Basisconfiguratie van een Switch
### Privileged EXEC modus 
  `enable`
### Configuratiemodus
  `conf t`
### Hostnaam instellen/veranderen
  `Switch(config)# hostname HOSTNAAM`
### Wachtwoord instellen voor privileged EXEC modus
  `Switch(config)# enable secret WACHTWOORD`
### Wachtwoord instellen voor console line 0
  ```
  Switch(config)# line console 0
  Switch(config-line)# password WACHTWOORD
  Switch(config-line)# login
  Switch(config-line)# exit
  ```
### Wachtwoord instellen voor vty line 0
  ```
  Switch(config)# line vty 0
  Switch(config-line)# password WACHTWOORD
  Switch(config-line)# login
  Switch(config-line)# exit
  ```
### Message of the day instellen
  ```
  Switch(config)# banner motd #
  ```
### IP-adres toekennen aan een interface
  ```
  Switch(config)# interface INTERFACE
  Switch(config-if)# ip address IP-ADRES SUBNETMASKER
  Switch(config-if)# no shut
  Switch(config-if)# exit
  ```
### Opslaan van de running-config
  ```
  Switch# copy running-config startup-config 
  ```
### Ongewenste DNS lookups vermijden
  ```
  Switch(config)# no ip domain-lookup
  ```
### Running-config weergeven
  ```
  Switch# show running-config
  ```
### IOS versie weergeven
  ```
  Switch# show version
  ```
### Status interfaces weergeven
  ```
  Switch# show ip interface brief
  ```
### Herladen om running-config te resetten naar startup-config
  ```
  Switch# reload
  ```
  
## Basisconfiguratie van een Router
### Privileged EXEC modus 
  `enable`
### Configuratiemodus
  `conf t`
### Hostnaam instellen/veranderen
  `Router(config)# hostname HOSTNAAM`
### Wachtwoord instellen voor privileged EXEC modus
  `Router(config)# enable secret WACHTWOORD`
### Wachtwoord instellen voor console line 0
  ```
  Router(config)# line console 0
  Router(config-line)# password WACHTWOORD
  Router(config-line)# login
  Router(config-line)# exit
  ```
### Wachtwoord instellen voor vty line 0
  ```
  Router(config)# line vty 0
  Router(config-line)# password WACHTWOORD
  Router(config-line)# login
  Router(config-line)# exit
  ```
### Message of the day instellen
  ```
  Router(config)# banner motd #
  ```
### IP-adres toekennen aan een interface
  ```
  Router(config)# interface INTERFACE
  Router(config-if)# ip address IP-ADRES SUBNETMASKER
  Router(config-if)# no shut
  Router(config-if)# exit
  ```
### Opslaan van de running-config
  ```
  Router# copy running-config startup-config 
  ```
### Ongewenste DNS lookups vermijden
  ```
  Router(config)# no ip domain-lookup
  ```
### Running-config weergeven
  ```
  Router# show running-config
  ```
### IOS versie weergeven
  ```
  Router# show version
  ```
### Status interfaces weergeven
  ```
  Router# show ip interface brief
  ```
### Herladen om running-config te resetten naar startup-config
  ```
  Router# reload
  ```
