# C64 Programmer's Reference Guide – Chapter 3: Programming Graphics

- Forrás: `c64-programmers_reference_guide-03-programming_graphics.pdf` (83 oldal)
- Téma: VIC-II grafikai módok, karakter mód, bitmap mód, sprite-ok, programozható karakterek
- Megbízhatóság: magas (Commodore hivatalos kézikönyv)
- Érdemes nézni: videó bankok, karakterkészlet, sprite programozás, grafikai módok váltása

---

## Tartalom

| Fejezet | Tartalom |
|---------|----------|
| Graphics Overview | VIC-II grafikai lehetőségek áttekintése |
| Graphics Locations | Memóriacímek, Color RAM, VIC-II regiszterek |
| Video Bank Selection | CIA2 $DD00 – 16K bank váltás |
| Screen Memory | $D018 screen pointer |
| Color Memory | $D800–$DBE7, fix pozíció |
| Character Memory | Karakterkészlet elhelyezése, ROM/RAM |
| Standard Character Mode | Normál szöveges mód |
| Character Definitions | 8×8 pixeles karakterek |
| Programmable Characters | RAM karakterkészlet |
| Multi-Color Character Mode | Többszínű karakter mód |
| Extended Background Color Mode | 4 háttérszín mód |
| Bit Mapped Graphics | Hires bitmap (320×200) |
| Multi-Color Bit Map Mode | Multicolor bitmap (160×200) |
| Sprites | Sprite-ok (MOB-ok) |

---

## Graphics Overview

A VIC-II chip (6567/6569) az összes grafikai képességért felelős.

**Grafikai módok:**

**A) CHARACTER DISPLAY MODES**
1. Standard Character Mode (ROM vagy RAM karakterek)
2. Multi-Color Character Mode (ROM vagy RAM karakterek)
3. Extended Background Color Mode (ROM vagy RAM karakterek)

**B) BIT MAP MODES**
1. Standard Bit Map Mode (320×200 pixel)
2. Multi-Color Bit Map Mode (160×200 pixel)

**C) SPRITES**
1. Standard Sprites (2 szín)
2. Multi-Color Sprites (4 szín)

---

## Graphics Locations

| Terület | Decimal | Hex | Méret |
|---------|---------|-----|-------|
| Screen Memory (default) | 1024 | $0400 | 1000 byte |
| Color RAM (fix) | 55296 | $D800 | 1000 byte (4 bit) |
| VIC-II Registers | 53248–53294 | $D000–$D02E | 47 regiszter |
| Sprite Pointers (default) | 2040–2047 | $07F8–$07FF | 8 byte |

- Képernyőn 1000 pozíció (40×25)
- Color RAM = 4 bit/pozíció → 16 szín

---

## Video Bank Selection

A VIC-II chip egyszerre 16K memóriát lát. A 64K eléréséhez 4 bank van (CIA #2).

**CIA2 Port A ($DD00) – bit 0 és bit 1:**

```
POKE 56578, PEEK(56578) OR 3         : REM bit0/bit1 kimenetre
POKE 56576, (PEEK(56576) AND 252) OR A  : REM bank váltás
```

| A értéke | Bitek | Bank | Tartomány |
|----------|-------|------|-----------|
| 3 | 11 | 0 | $0000–$3FFF (DEFAULT) |
| 2 | 10 | 1 | $4000–$7FFF |
| 1 | 01 | 2 | $8000–$BFFF |
| 0 | 00 | 3 | $C000–$FFFF |

**FONTOS:** Bankváltás után értesíteni kell a KERNAL screen editort is:
```
POKE 648, page    (ahol page = address/256, pl. 1024/256 = 4)
```

---

## Screen Memory ($D018, felső 4 bit)

Képernyőmemória pozíciójának megváltoztatása:
```
POKE 53272, (PEEK(53272) AND 15) OR A
```

| A értéke | Bitek | Bank-relatív cím | Offset a bankban |
|----------|-------|-----------------|-----------------|
| 0 | 0000XXXX | $0000 | 0 |
| 16 | 0001XXXX | $0400 | 1024 (DEFAULT) |
| 32 | 0010XXXX | $0800 | 2048 |
| 48 | 0011XXXX | $0C00 | 3072 |
| 64 | 0100XXXX | $1000 | 4096 |
| 128 | 1000XXXX | $2000 | 8192 |
| 192 | 1100XXXX | $3000 | 12288 |
| 240 | 1111XXXX | $3C00 | 15360 |

---

## Color Memory

Color RAM **nem mozgatható** – mindig $D800–$DBE7 ($D800–$D8E7 az 1000 pozícióhoz).
- 4 bites értékek: 0–15 (16 szín)
- Bit 3 = 1: multicolor mód az adott pozícióban

---

## Character Memory ($D018, alsó 3+1 bit)

Karakterkészlet elhelyezése a VIC-II bankban (2K blokkok):
```
POKE 53272, (PEEK(53272) AND 240) OR A
```

| A értéke | Bitek | Cím a bankban | Megjegyzés |
|----------|-------|---------------|------------|
| 0 | XXXXOOO | $0000–$07FF | |
| 2 | XXXX001 | $0800–$0FFF | |
| 4 | XXXX010 | $1000–$17FF | ROM IMAGE Bank 0 és 2 (DEFAULT) |
| 6 | XXXX011 | $1800–$1FFF | ROM IMAGE Bank 0 és 2 |
| 8 | XXXX100 | $2000–$27FF | |
| 10 | XXXX101 | $2800–$2FFF | |
| 12 | XXXX110 | $3000–$37FF | |
| 14 | XXXX111 | $3800–$3FFF | |

### Karakter ROM elrendezése

| Blokk | ROM cím (I/O kikapcsolt) | VIC-II kép | Tartalom |
|-------|-------------------------|------------|---------|
| 0 | $D000–$D1FF | $1000–$11FF | Nagybetűs karakterek |
| 0 | $D200–$D3FF | $1200–$13FF | Grafikus karakterek |
| 0 | $D400–$D5FF | $1400–$15FF | Fordított nagybetűk |
| 0 | $D600–$D7FF | $1600–$17FF | Fordított grafikák |
| 1 | $D800–$D9FF | $1800–$19FF | Kisbetűs karakterek |
| 1 | $DA00–$DBFF | $1A00–$1BFF | Nagy+kis+grafikus |
| 1 | $DC00–$DDFF | $1C00–$1DFF | Fordított kisbetűk |
| 1 | $DE00–$DFFF | $1E00–$1FFF | Fordított nagy+grafikus |

### Karakter ROM olvasása (I/O ki + ROM be):
```basic
POKE 56334, PEEK(56334) AND 254   : REM keyboard IRQ ki
POKE 1, PEEK(1) AND 251           : REM CHAREN=0, ROM be
FOR I = 0 TO 2048 : POKE BASE+I, PEEK(53248+I) : NEXT
POKE 1, PEEK(1) OR 4              : REM I/O vissza
POKE 56334, PEEK(56334) OR 1      : REM IRQ vissza
```

### Karakter cím kiszámítása:
```
CHARACTER ADDRESS = SCREEN_CODE * 8 + (CHARSET * 2048) + (BANK * 16384)
```

---

## Standard Character Mode

- Alapértelmezett mód bekapcsoláskor
- 40×25 karakter képernyő
- Minden pozícióhoz: screen code (melyik karakter) + color RAM (milyen szín)
- Karakterek ROM-ból vagy RAM-ból

---

## Character Definitions (8×8 rács)

Minden karakter = 8 byte, minden bit = 1 pixel (1=be, 0=ki).

Példa – smajli karakter:
```
DATA 60, 66, 165, 129, 165, 153, 66, 60
```

Bitmintázat:
```
ROW 0: 00111100 = 60
ROW 1: 01000010 = 66
ROW 2: 10100101 = 165
ROW 3: 10000001 = 129
ROW 4: 10100101 = 165
ROW 5: 10011001 = 153
ROW 6: 01000010 = 66
ROW 7: 00111100 = 60
```

---

## Programmable Characters

Saját karakterkészlet RAM-ban:

1. BASIC memóriát csökkenteni: `POKE 52,48 : POKE 56,48 : CLR`
2. ROM karaktereket átmásolni RAM-ba (pl. $3000-ra)
3. Karaktermutatót RAM-ra átírni: `POKE 53272, (PEEK(53272) AND 240) + 12`

Teljes karakter szett másolása $3000-ra:
```basic
POKE 56334, PEEK(56334) AND 254  : REM IRQ ki
POKE 1, PEEK(1) AND 251          : REM ROM be
FOR I = 0 TO 511 : POKE I+12288, PEEK(I+53248) : NEXT
POKE 1, PEEK(1) OR 4             : REM I/O vissza
POKE 56334, PEEK(56334) OR 1     : REM IRQ vissza
```

Egyedi karakter módosítása ($3000 + kód*8):
```basic
FOR I = 12288 TO 12288+7 : POKE I, 255 - PEEK(I) : NEXT  : REM fordított @
```

**Hasznos egyezések:**

| Képernyő kód | Karakter | RAM cím ($3000 alapnál) |
|-------------|---------|----------------------|
| 0 | @ | 12288 |
| 1 | A | 12296 |
| 33 | ! | 12552 |
| 62 | > | 12784 |

---

## Multi-Color Character Mode

Multi-color bekapcsolása:
```
POKE 53270, PEEK(53270) OR 16    : REM $D016 bit4 = 1
```

Per-karakter multi-color: ha Color RAM bit 3 = 1 (szín ≥ 8)

**Bit pár → szín megfeleltetés:**

| Bit pár | Szín forrás | Cím |
|---------|-------------|-----|
| 00 | Background #0 (képernyő szín) | $D021 (53281) |
| 01 | Background #1 | $D022 (53282) |
| 10 | Background #2 | $D023 (53283) |
| 11 | Color RAM (alsó 3 bit) | $D800+ |

**Megjegyzés:** Multi-color módban a vízszintes felbontás feleannyi (160 pozíció), mert minden dot 2-szer széles.

---

## Extended Background Color Mode

4 különböző háttérszín egyetlen képernyőn.

Bekapcsolás: `POKE 53265, PEEK(53265) OR 64`  ($D011 bit 6 = ECM = 1)

**Korlátozás:** Csak az első 64 karakter használható (a felső 2 bit háttérszínt választ):

| Kód tartomány | Bit 7 | Bit 6 | Háttérszín regiszter | Cím |
|---------------|-------|-------|---------------------|-----|
| 0–63 | 0 | 0 | Background #0 | $D021 |
| 64–127 | 0 | 1 | Background #1 | $D022 |
| 128–191 | 1 | 0 | Background #2 | $D023 |
| 192–255 | 1 | 1 | Background #3 | $D024 |

---

## Bit Mapped Graphics (Hires Bitmap Mode)

**320×200 pixel**, minden pixel saját bit = 8000 byte szükséges.

Engedélyezés: `POKE 53265, PEEK(53265) OR 32`  ($D011 bit 5 = BMM = 1)

**Memória szervezés:**
- 8×8 karakter blokkok, bal-jobb, fel-le haladva
- Byte-ok: 8 egymást követő byte = egy karakter blokk sorai
- Foreground szín: Screen RAM felső 4 bit
- Background szín: Screen RAM alsó 4 bit
- Color RAM: nem használt (bitmap módban)

**Bitmap elhelyezése:**
- Bitmap: $2000 vagy $6000 (2K határon belül a bankban)
- $D018 bit 3: bitmap kezdete ($D018 AND 8 = 0 → $0000, AND 8 = 8 → $2000)

---

## Multi-Color Bit Map Mode

**160×200 pixel** (160 felső szín, 200 sor), 4 szín per 4×8 pixel blokk.

Engedélyezés: `$D011 BMM=1` ÉS `$D016 MCM=1`

**Bit pár → szín:**

| Bit pár | Forrás |
|---------|--------|
| 00 | Background Color 0 ($D021) |
| 01 | Screen RAM felső 4 bit szín |
| 10 | Screen RAM alsó 4 bit szín |
| 11 | Color RAM |

---

## Sprites (MOB-ok)

8 sprite (MOB = Movable Object Block) egyszerre.

### Sprite méret és szerkezet
- 24×21 pixel (3 byte × 21 sor = 63 byte adatban; 64. byte nem használt)
- Sprite pointer = VM+$03F8 ... VM+$03FF (8 byte, minden sprite 1 pointer)
- Sprite adat kezdőcíme = pointer értéke × 64

### Sprite pointerek (default képernyő = $0400):
| Pointer cím | Sprite |
|------------|--------|
| $07F8 (2040) | Sprite 0 |
| $07F9 (2041) | Sprite 1 |
| ... | ... |
| $07FF (2047) | Sprite 7 |

### Sprite engedélyezése
```
POKE 53269, PEEK(53269) OR 1   : REM $D015 bit 0 = sprite 0 be
```

### Sprite pozíció
```
POKE 53248, X_lo    : REM $D000 – Sprite 0 X (bit 0-7)
POKE 53249, Y       : REM $D001 – Sprite 0 Y
POKE 53264, msb     : REM $D010 – X bit 8 minden sprite-hoz
```

### Multi-color sprite
```
POKE 53276, PEEK(53276) OR 1   : REM $D01C – Sprite 0 multicolor
POKE 53285, mc0_color           : REM $D025 – Sprite Multicolor 0
POKE 53286, mc1_color           : REM $D026 – Sprite Multicolor 1
POKE 53287, sprite0_color       : REM $D027 – Sprite 0 saját szín
```

**Multicolor sprite bit pár → szín:**

| Bit pár | Szín forrás |
|---------|-------------|
| 00 | Átlátszó |
| 01 | Sprite Multicolor 0 ($D025) |
| 10 | Sprite saját szín ($D027+n) |
| 11 | Sprite Multicolor 1 ($D026) |

### Sprite X-kiterjesztés és Y-kiterjesztés
```
POKE 53277, PEEK(53277) OR mask   : REM $D01D – X dupla méret
POKE 53271, PEEK(53271) OR mask   : REM $D017 – Y dupla méret
```

### Sprite elsőbbség (háttér előtt/mögött)
```
POKE 53275, PEEK(53275) AND NOT_mask  : REM $D01B – 0=előtérben, 1=háttérben
```

### Ütközés érzékelés
- `PEEK(53278)` – $D01E: Sprite-Sprite ütközés
- `PEEK(53279)` – $D01F: Sprite-Background ütközés
- Olvasás törli a regisztert

---

## Gyakorlati programozási tippek

1. **Bank választás:** Default Bank 0 ($0000–$3FFF); Bank 1 és 3 mentes a karakter ROM képtől
2. **Karakter ROM másolás:** I/O ki → ROM be → másolás → ROM ki → I/O vissza (IRQ tiltás kötelező!)
3. **Karakterkészlet védése BASIC-tól:** `POKE 52,48 : POKE 56,48 : CLR` (48 = $3000/256)
4. **Multi-color és hires keverése:** Lehetséges – per-pozíció Color RAM bit 3-val
5. **Sprite adat helye:** Bármely 64-gyel osztható cím; pointer = cím/64
6. **Hires bitmap:** 8000 byte, általában $2000-ra vagy $6000-ra mozgatva

---

## Fontos regiszterek összefoglalás

| Cím | Leírás |
|-----|--------|
| $D011 (53265) | ECM (bit6), BMM (bit5), DEN (bit4), RSEL (bit3), YSCROLL (bit2-0) |
| $D016 (53270) | MCM (bit4), CSEL (bit3), XSCROLL (bit2-0) |
| $D018 (53272) | Screen pointer (bit7-4), Charset pointer (bit3-1) |
| $D015 (53269) | Sprite Enable (bit7-0) |
| $D017 (53271) | Sprite Y Expand |
| $D01B (53275) | Sprite Display Priority (1=háttérben) |
| $D01C (53276) | Sprite Multicolor Enable |
| $D01D (53277) | Sprite X Expand |
| $D01E (53278) | Sprite-Sprite Collision (olvasásra törlődik) |
| $D01F (53279) | Sprite-Background Collision |
| $D025 (53285) | Sprite Multicolor 0 |
| $D026 (53286) | Sprite Multicolor 1 |
| $D021 (53281) | Background Color 0 |
| $D022 (53282) | Background Color 1 |
| $D023 (53283) | Background Color 2 |
| $D024 (53284) | Background Color 3 |
| $DD00 (56576) | CIA2 Port A – VIC bank select (bit1-0, invertálva) |
| $DD02 (56578) | CIA2 DDR – bit1-0 kimenetté kell tenni |