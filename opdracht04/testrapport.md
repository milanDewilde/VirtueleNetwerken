# Testrapport taak 4: Microsoft Deployment Toolkit

Uitvoerder(s) test: Thibault Dewitte
Uitgevoerd op: 12/05/2019
Github commit:  a117f4137ecb222162aff7af42c7dc9d70bf395

## Te testen

We testen dit met behulp van een Vagrant VM.

### Is Windows 10 geïnstalleerd?
1. Start de VM op vanuit de Virtualbox manager.
2. Log in op de VM met wachtwoord `P@ssw0rd`.
3. Navigeer naar `Alle Instellingen`, `Systeem`, dan `Info`.
4. **Voldaan indien men succesvol kan inloggen op de VM en de `Editie` onder de kop `Windows-specificaties` `Windows 10` weergeeft.**

**Voldaan: editie is Windows 10 Enterprise Evaluation.**

### Is Adobe Reader geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op het zoek-iccon in de taakbalk en zoek naar `Adobe Reader`.
3. Open de Adobe Reader app.
4. **Voldaan indien Adobe Reader succesvol opent.**

**Voldaan maar niet via zoekfunctie: Acrobat Reader DC stond op de desktop.** 

### Is Java geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op het zoek-iccon in de taakbalk en zoek naar `Java`.
3. Open `About Java`.
4. **Voldaan indien `About Java` succesvol opent en de nieuwste versie weergeeft.**

**Voldaan: Java Version 8 Update 211.**

### Is Libre Office geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op het zoek-iccon in de taakbalk en zoek naar `LibreOffice`.
3. Open de LibreOffice app.
4. **Voldaan indien LibreOffice succesvol opent.**

**Niet voldaan: LibreOffice staat niet tussen de apps.**

### Zijn alle Windows updates geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Navigeer naar `Alle Instellingen`, dan `Bijwerken en Beveiliging`.
3. **Voldaan indien bij `Windows Updates` geen beschikbare updates worden weergegeven.**

**Voldaan: Geen updates beschikbaar.**

Alles is voldaan behalve LibreOffice.