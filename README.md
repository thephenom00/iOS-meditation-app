# ZenZone Meditační Aplikace

## Přehled aplikace

Jako svoji semestrální práci jsem zvolil je meditační aplikaci s názvem **ZenZone**, která uživatelům umožňuje poslouchat meditační skladby, využít možnosti dechových cvičení, nastavit si denní připomenutí pro meditaci a sledovat jejich oblíbené meditace.

## Použité technologie

- **SwiftUI**: Pro vytvoření uživatelského rozhraní aplikace.
- **Core Motion**: Pro sledování pohybu zařízení pomocí akcelerometru.
- **AVKit**: Pro přehrávání zvukových souborů.
- **UserDefaults**: Pro trvalé uložení uživatelských dat, jako jsou oblíbené meditace a profilové informace.
- **PhotosUI**: Pro integraci s výběrem fotek pro nastavení profilového obrázku.


## Ukázka aplikace

### Domovská stránka
Na domovská stránce se může uživatel rozhodnout buď pro dechová cvičení nebo pro poslech meditační hudby.
<div align="center">
    <img src="imgs/main.png" width="220"/>
</div> 

### Dechová cvičení
Uživatel si následně bude moci vybrat z nabízených barev a poté bude následovat vizuální animace, která jej provede dechovým cvičením.
<div align="center">
    <img src="imgs/breathe_select.png" width="220"/>
    <img src="imgs/breathe.png" width="220"/>
</div> 

### Spuštění meditační hudby
Kliknutím na skladbu, která uživateoe zajímá, si uživatel zobrazí podrobnější informace. a pro spuštění klikne na tlačítko "Play". Během přehrávání ovládat různé funkce, jako je přetáčení, pauzování nebo opakování skladby.

<div align="center">
    <img src="imgs/song_select.png" width="170"/>
    <img src="imgs/song_describtion.png" width="170"/>
    <img src="imgs/player.png" width="170"/>
</div> 

### Akcelerometr
V případě, že bude v průběhu poslechu hudby pohnuto se zařízením, bude zobrazeno upozornění.
<div align="center">
    <img src="imgs/popup.png" width="220"/>
</div> 

### Oblíbené meditace
Stránka zobrazující všechny uživatelovy oblíbené skladby. Skladbu může přidat kliknutím na srdíčko přímo vedle skladby v domovské obrazovce.
<div align="center">
    <img src="imgs/likes.png" width="220"/>
</div> 

### Uživatelský profil
Uživatel má možnost si změnit profilový obrázek, jméno, či nastavit kdy má být notifikován o meditaci.
<div align="center">
    <img src="imgs/profile.png" width="220"/>
</div> 

### Změna profilového obrázku a jména
<div align="center">
    <img src="imgs/change_image.png" width="170"/>
    <img src="imgs/change_username.png" width="170"/>
    <img src="imgs/profile_changed.png" width="170"/>
</div> 

### Nastavení notifikace
<div align="center">
    <img src="imgs/set_reminder.png" width="220"/>
    <img src="imgs/notification.png" width="220"/>
</div> 

## **Testování**

**Názor uživatele I:**

+ **Klady:**
    - Uživatelské rozhraní je velmi přehledné.
    - Funkce dechových cvičení je dobře provedená.

- **Zápory:**
    - Při kliknutí na tlačítko pro spuštění meditační hudby trvá dlouho, než se skladba spustí.

**Názor uživatele II:**

+ **Klady:**
    - Uživatelské rozhraní
    - Uživatelský profil s možností změny profilového obrázku a jména.
    - Možnost nastavit denní připomenutí pro meditaci.

- **Zápory:**
    - U některých skladeb kvalita zvuku není optimální.
    - Ocenil by searchbar pro hledání skladeb


<!-- 
<img src="imgs/profile.png" alt="Profile Image" width="170"/>
<img src="imgs/profile.png" alt="Profile Image" width="170"/>
<img src="imgs/profile.png" alt="Profile Image" width="171"/> -->


