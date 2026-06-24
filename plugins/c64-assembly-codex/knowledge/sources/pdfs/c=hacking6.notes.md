# C= Hacking Issue 6

- Forrás: `c=hacking6.pdf` (50 oldal)
- Téma: Commodore hacking net-magazin, 6. szám – haladó C64 demoscene és rendszerprogramozási technikák
- Megbízhatóság: magas (a cikkek szerzői aktív demoscene programozók, részletes forráskóddal)
- Érdemes nézni: border megnyitás (top/bottom/side), DYCP scroller, sprite multiplex, tech-tech effekt, LZW tömörítés assembly-ben, N-key rollover billentyűzet kezelés

---

## Tartalom

| Cikk | Szerző | Tartalom |
|------|--------|---------|
| DYCP – too many sprites | Pasi 'Albert' Ojala | Különböző Y pozíciójú karakterek spriteokban; sprite multiplex technika |
| Opening the borders | Pasi 'Albert' Ojala | Top/bottom/side border eltávolítása; timing, bad lines, PAL |
| LZW Compression | (ismeretlen) | LZW tömörítő/kicsomagoló 6510 assembly-ben |
| Keyscan Utilities | (ismeretlen) | C64/C128 N-key rollover billentyűzet kezelés |
| Tech-tech effects | (ismeretlen) | Vízszintes scroll karakter grafikával teljes szélesség |
| ACE-128/64 Design | (ismeretlen) | KERNAL csere tervezési elvei |

---

## DYCP – Different Y Character Position

A DYCP egy vízszintes szöveggörgető effekt, ahol a karakterek Y pozíciója folyamatosan változik (szinuszos hullám). Mindegyik karaktert egy-egy sprite jeleníti meg.

### Probléma: több mint 8 karakter

- VIC-II egyszerre max. 8 sprite-ot kezel
- Megoldás 1: sprite multiplex (rasztervonalanként sprite Y koordináta újraírás)
- Megoldás 2: karakter módban spriteok helyett karakterkészlet manipuláció

### Technika: karakterkészlet frissítés

```
Minden frame-ben:
1. Kiszámítani minden pozíció Y eltolódását (szinusz tábla alapján)
2. A karakterkészlet RAM területén módosítani a pixelsorokat
3. IRQ-ban: scroll regiszter frissítés, YSCROLL állítás
```

### Kritikus timing

- A karakterkészlet frissítés csak addig lehetséges, amíg VIC nem rajzolja a scroll területét
- Double buffering megoldja a tearing problémát (de több memória kell)
- Speed trükk: `CLC` csak ahol feltétlenül szükséges

### Részlet az IRQ rutinból

```asm
LDA #>IRQ
STA $0315
LDA #$7F        ; Timer IRQ tiltás
STA $DC0D
LDA #$81        ; Raster IRQ engedélyezés
STA $D01A
LDA #$A8        ; Raszter összehasonlítás $A8-nál
STA $D012
LDA #$1B
STA $D011
LDA #30
STA $D018       ; Új karakterkészlet használata
CLI
RTS
```

### Szinusz tábla felépítése (1/4 periódusból a teljes)

```asm
SIN BYT 0,3,6,9,12,15,18,21,24,27,30,32,35,38,40,42,45
    BYT 47,49,51,53,54,56,57,59,60,61,62,62,63,63,63
```
A teljes szinuszt tükrözéssel állítják össze 4 * 32 = 128 byte-ba.

### NTSC megjegyzés

Az NTSC változat csak 32 oszlopot tud lefedni a kevesebb rasztervonal miatt.

---

## Opening the Borders (Border eltávolítás)

**Minden timing PAL értékekre vonatkozik** – az elvek NTSC-n is alkalmazhatók.

### Hogyan működik a border

A VIC-II border logika külön hardver, amely a display ablak szélein és tetején/alján a `$D020` (border szín) regiszter értékét rajzolja ki. A megjelenítési feltételek bizonyos pillanatban ellenőrzi a chip.

### Top/Bottom border eltávolítás

A top/bottom border a rasztervonalszám és az RSEL bit értékének összevetésén múlik:

```asm
; Bottom border megnyitás: RSEL bit toggle a megfelelő pillanatban
; Raszter vonal 247/248 körül (PAL):
LDA #$0B        ; RSEL=0 (24 sor mód) -> töröljük a border triggert
STA $D011
; ... egy ciklus múlva ...
LDA #$1B        ; RSEL=1 visszaállítás
STA $D011
```

### Side border eltávolítás

CSEL bit toggle a rasztersor megfelelő x koordinátájánál:

```asm
; CSEL=0 -> 38 oszlopos mód, border trigger törlése
LDA #$C8        ; CSEL=0
STA $D016
; ... ciklusok múlva ...
LDA #$C9        ; CSEL=1
STA $D016
```

### Bad Lines problémája a border megnyitásnál

Bad Line-on kevés szabad ciklus áll rendelkezésre → border megnyitás és 8 sprite egyszerre általában nem fér el. Megoldások:
- Bad line-ok elkerülése: YSCROLL manipulálásával
- Kevesebbel sprite-al dolgozni bad line-on (PAL-on max. 6 sprite + side border)

### $3FFF terület – extra grafika

A border területen megjelenő új grafikus adat a `$3FFF` VIC buszon olvasott értékből jön. Ez használható tech-tech szerű effektekhez a border területen is.

### Vízszintes scroll a borderben

```
$D016 (XSCROLL) regiszter befolyásolja a border területi grafikát is
→ korlátozott tech-tech effekt elérhető a border területen
```

---

## LZW Tömörítés 6510 Assembly-ben

Teljes LZW (Lempel-Ziv-Welch) tömörítő és kicsomagoló, C64-re írva, 14336-os tábla bázissal.

### Konstansok

```asm
EOS      = 256   ; End of Stream
FIRSTCODE= 259
MAXCODE  = 4096  ; Max dictionary méret
BUMPCODE = 257   ; Olvasandó bitek számának növelése
FLUSHCODE= 258   ; Dictionary törlése
TABLEBASE= 14336 ; Dictionary helye a memóriában
DECODESTACK=9300 ; 4K LIFO stack a kicsomagoláshoz
```

### Fontos megjegyzések a 6510 implementációhoz

- Dictionary méret: 4096 entry = 5 byte/entry → 20K memória
- Bit-szintű I/O szükséges (változó hosszú kódok)
- KERNAL fájl rutinok: `$FFC9`/`$FFC6` (CHKOUT/CHKIN), `$FFD2` (CHROUT), `$FFCC` (CLRCHN)

---

## Keyscan Utilities – N-Key Rollover

### Probléma a standard KERNAL keyscannel

- A KERNAL csak 1 billentyűt kezel egyszerre
- Joystick ghosting problémák
- C128-on 88 scankód (nem 64)

### C64 keyscan

Port A ($DC00): sor kiválasztás (aktív 0)
Port B ($DC01): oszlop olvasás (0 = lenyomva)

```asm
; Egy sor vizsgálata:
lda #$fe        ; 0. sor
sta pa          ; $DC00
lda pb          ; $DC01 olvasás
eor #$ff        ; invertálás (1=lenyomva)
sta scanTable,x
```

### C128 keyscan

`$D02F` (VIC keyboard select port) szükséges, nem csak CIA1.

```asm
; C128: CIA #1 Port A ($DC00) ÉS $D02F regiszter
poke $DC00, row_mask
poke $D02F, row_mask
```

### N-key rollover megvalósítás

A program 3 egyidejű billentyűt képes kezelni (`rollover = 3`). A scanTable tartalmazza az összes lenyomott sort; keydecode kinyeri az egyedi scankódokat.

### Joystick ghosting elleni védelem

```asm
; Joystick push ellenőrzés scan előtt és után
; Ha joystick aktív: ignoráljuk a scan eredményt
```

---

## Tech-Tech Effekt

A tech-tech egy vízszintes scroll effekt karakter grafikával a **teljes 320 pixeles szélességen** (beleértve a bordert is).

### Hogyan működik

1. Karakter ROM-ból (vagy RAM-ból) minden rasztervonalban más sort olvastatja a VIC
2. XSCROLL regiszter ($D016 bit 2:0) folyamatosan változtatva
3. Screen RAM tartalmát rasztervonalanként módosítva

### Elvek

- Minden karakterbe csak egyetlen pixel-sor kerül
- A karakterek "csempéként" ismételgetik a grafikát
- Az XSCROLL pixelszintű vízszintes eltolást ad

---

## ACE-128/64 KERNAL Csere

Az ACE (Advanced Command Environment) egy teljes KERNAL csere C64/C128-ra.

### Céljai

- UNIX-szerű parancssor környezet
- Saját kernel interfész
- Kompatibilitás a standard KERNAL rutinokkal ahol lehetséges

### Memória elrendezés (C128 verzió)

```
$1500–$17BA : ACE program (5376–6074 decimális)
```

IRQ vektor és BASIC restart vektor ($A00) is át van írva. RUN/STOP+RESTORE után megmarad.
