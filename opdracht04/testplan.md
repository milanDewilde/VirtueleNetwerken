# Testplan taak 4: Microsoft Deployment Toolkit

Auteur(s) testplan: Sean Vancompernolle

## Doel
### Installatie Windows 10
- Verifieer dat Windows 10 is geïnstalleerd
### Installatie Adobe Reader
- Verifieer dat Adobe Reader is geïnstalleerd
### Installatie Java
- Verifieer dat Java is geïnstalleerd
### Installatie Libre Office
- Verifieer dat Libre Office is geïnstalleerd
### Installatie Windows Updates
- Verifieer dat alle Windows Updates zijn geïnstalleerd

## Te testen

We testen dit met behulp van een Virtualbox VM. We veronderstellen dat alle stappen in (de technische handleiding)[documentatie.md] gevolgd zijn om de virtuale machines aan te maken en op te stellen, alsook om de deployment van Windows 10 en de installatie van de programmas uit te voeren.

### Is Windows 10 geïnstalleerd?
1. Start de VM op vanuit de Virtualbox manager.
2. Log in op de VM met wachtwoord `P@ssw0rd`.

**Opmerking:** Standaard staat de virtuele machine ingestelt op QWERTY. Hou hier rekening mee bij het ingeven van tekst.

3. Navigeer naar `Alle Instellingen`, `Systeem`, dan `Info`.
4. **Voldaan indien men succesvol kan inloggen op de VM en de `Editie` onder de kop `Windows-specificaties` `Windows 10` weergeeft.**

### Is Adobe Reader geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op het zoek-iccon in de taakbalk en zoek naar `Adobe Reader`.
3. Open de Adobe Reader app.
4. **Voldaan indien Adobe Reader succesvol opent.**

### Is Java geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op het zoek-iccon in de taakbalk en zoek naar `Java`.
3. Open `About Java`.
4. **Voldaan indien `About Java` succesvol opent en de nieuwste versie weergeeft.**

### Is Libre Office geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Klik op het zoek-iccon in de taakbalk en zoek naar `LibreOffice`.
3. Open de LibreOffice app.
4. **Voldaan indien LibreOffice succesvol opent.**

### Zijn alle Windows updates geïnstalleerd?
1. Start en log in op de VM zoals hierboven aangegeven.
2. Navigeer naar `Alle Instellingen`, dan `Bijwerken en Beveiliging`.
3. **Voldaan indien bij `Windows Updates` geen beschikbare updates worden weergegeven.**
