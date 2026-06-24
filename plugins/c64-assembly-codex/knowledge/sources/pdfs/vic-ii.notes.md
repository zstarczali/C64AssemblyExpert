# VIC-II (MOS 6567/6569) - Technikai referencia

- Forrás: `vic-ii.pdf` (56 oldal), szerző: Christian Bauer, 1996
- Téma: VIC-II chip teljes technikai leírása - architektúra, regiszterek, timing, Bad Lines, grafikai módok, sprite-ok, speciális effektek
- Megbízhatóság: magas (az egyik legrészletesebb VIC-II referencia)
- Érdemes nézni: Bad Line mechanizmus, raster timing, sprite multiplex, effektek (FLD, FLI, hyperscreen)

---

## Tartalom

- 1. Bevezetés
- 2. C64 architektúra (6510, VIC chip, memória)
- 3. VIC leírása (regiszterek, Bad Lines, grafikai módok, sprite-ok, IRQ, speciális effektek)
- 4. $0000/$0001 és $DE00 terület

---

## 2. A Commodore 64 architektúrája

### 2.1. Hardver áttekintés

- 6510 CPU (1 MHz), 6567/6569 VIC-II, 6581 SID, 2x6526 CIA
- 64 KB DRAM, 0.5 KB Color RAM (SRAM, 1K×4 bit), 16 KB ROM, 4 KB Char ROM

### 2.2. 6510 processzor – fontos jelvezetékek

- **ø2**: Processzor órajel. ø2 low = VIC fázis, ø2 high = CPU fázis.
- **RDY**: Ha low = CPU megáll az olvasásnál (BA-hoz van kötve).
- **AEC**: Ha high = CPU address bus tri-state (VIC veszi át a buszt).
- **P0-P5**: Beépített 6 bit I/O port. $0000 = DDR, $0001 = adatregiszter.

Órajel: 1022.7 kHz (NTSC) / 985.248 kHz (PAL).

### 2.3. VIC-II típusok

| Típus | Felhasználás |
|-------|-------------|
| 6567 | NTSC C64 |
| 6569 | PAL C64 |
| 8562 | Újabb NTSC (= 6567) |
| 8565 | Újabb PAL (= 6569) |

### 2.4. Memória

#### 6510 látóköre

```
$FFFF Kernal ROM (HIRAM)
$E000
$D000 I/O / Char ROM (CHAREN bit)
      VIC $D000-$D3FF, SID $D400-$D7FF
      Color RAM $D800-$DBFF
      CIA1 $DC00, CIA2 $DD00
$C000 RAM
$A000 Basic ROM (LORAM)
$0002 RAM
$0001 I/O port adat
$0000 I/O port DDR
```

CHAREN (I/O bit 2): 1 = I/O regiszterek, 0 = Char ROM látható $D000-nál.
Write a ROM alatti RAM-ba mindig megy (ROM nem írható).

#### VIC látóköre – 4 bank

VIC: 14 bit address bus = 16 KB. CIA 2 port A bit 0-1 (invertálva) = bank select:

| CIA2 $DD00 bit1:0 | VIC Bank | CPU cím tartomány |
|-------------------|----------|-------------------|
| %11 | Bank 0 | $0000-$3FFF |
| %10 | Bank 1 | $4000-$7FFF |
| %01 | Bank 2 | $8000-$BFFF |
| %00 | Bank 3 | $C000-$FFFF |

Char ROM: Bank 0-ban $1000-$1FFF, Bank 2-ben $9000-$9FFF (VIC $1000-nek látja).

Color RAM: Mindig elérhető, A9:0 cím, D8-D11 biten jön be.

#### Bus megosztás

- Minden ciklusban mindkét chip access-el
- VIC Bad Line-on: 40 extra ciklusra átveszi a buszt (karakter pointer + color RAM olvasás)
- BA low 3 ciklussal korábban, CPU legfeljebb 3 write-ot tehet

---

## 3. VIC leírása

### 3.2. Regisztertérkép

| Cím | R/W | Funkció |
|-----|-----|---------|
| $D000-$D001 | R/W | Sprite 0 X, Y |
| $D002-$D003 | R/W | Sprite 1 X, Y |
| $D004-$D005 | R/W | Sprite 2 X, Y |
| $D006-$D007 | R/W | Sprite 3 X, Y |
| $D008-$D009 | R/W | Sprite 4 X, Y |
| $D00A-$D00B | R/W | Sprite 5 X, Y |
| $D00C-$D00D | R/W | Sprite 6 X, Y |
| $D00E-$D00F | R/W | Sprite 7 X, Y |
| $D010 | R/W | Sprite X bit 8 (M7X8..M0X8) |
| $D011 | R/W | Control 1: RST8,ECM,BMM,DEN,RSEL,YSCROLL |
| $D012 | R/W | Raster counter / Raster compare |
| $D013 | R | Light pen X |
| $D014 | R | Light pen Y |
| $D015 | R/W | Sprite enable (M7E..M0E) |
| $D016 | R/W | Control 2: -,-,RES,MCM,CSEL,XSCROLL |
| $D017 | R/W | Sprite Y expand (M7YE..M0YE) |
| $D018 | R/W | Memory pointers: VM13-VM10, CB13-CB11 |
| $D019 | R/W | IRQ status: IRQ,-,-,-,ILP,IMMC,IMBC,IRST |
| $D01A | R/W | IRQ enable: -,-,-,-,ELP,EMMC,EMBC,ERST |
| $D01B | R/W | Sprite-bg priority (M7DP..M0DP) |
| $D01C | R/W | Sprite multicolor (M7MC..M0MC) |
| $D01D | R/W | Sprite X expand (M7XE..M0XE) |
| $D01E | R | Sprite-sprite collision (auto clear) |
| $D01F | R | Sprite-data collision (auto clear) |
| $D020 | R/W | Keret szín (EC) |
| $D021 | R/W | Háttér szín 0 (B0C) |
| $D022 | R/W | Háttér szín 1 (B1C) |
| $D023 | R/W | Háttér szín 2 (B2C) |
| $D024 | R/W | Háttér szín 3 (B3C) |
| $D025 | R/W | Sprite multicolor 0 (MM0) |
| $D026 | R/W | Sprite multicolor 1 (MM1) |
| $D027-$D02E | R/W | Sprite 0-7 szín (M0C..M7C) |

Fontos: Regiszterek $D000-$D3FF között 64 byte-onként ismétlődnek.

### $D011 – Control Register 1

| Bit | Név | Leírás |
|-----|-----|--------|
| 7 | RST8 | Raster counter bit 8 (+ $D012 = 9 bit) |
| 6 | ECM | Extended Color Mode |
| 5 | BMM | Bitmap Mode |
| 4 | DEN | Display Enable (0 = fekete) |
| 3 | RSEL | Row Select: 1 = 25 sor (200 px), 0 = 24 sor (192 px) |
| 2-0 | YSCROLL | Vertical scroll (0-7) |

### $D016 – Control Register 2

| Bit | Név | Leírás |
|-----|-----|--------|
| 4 | MCM | Multicolor Mode |
| 3 | CSEL | Column Select: 1 = 40 col (320 px), 0 = 38 col (304 px) |
| 2-0 | XSCROLL | Horizontal scroll (0-7) |

### $D018 – Memory Pointers

| Bitek | Leírás | Számítás |
|-------|--------|----------|
| 7-4 | VM13-VM10 | Video Matrix base: bits * $0400 (bankon belül) |
| 3-1 | CB13-CB11 | Char/Bitmap base: bits * $0800 |

Példa: $D018 = $15 -> screen @ $0400, charset @ $1000 (ROM bank 0-ban)

### 3.3. Szín paletta

0=fekete, 1=fehér, 2=piros, 3=cián, 4=lila, 5=zöld, 6=kék, 7=sárga,
8=narancs, 9=barna, 10=világos piros, 11=sötét szürke, 12=közepes szürke, 13=világos zöld, 14=világos kék, 15=világos szürke

### 3.4. Képernyő dimenziók

6569 (PAL): 312 rasztervonal, 63 ciklus/sor.
6567 (NTSC): 263 rasztervonal, 65 ciklus/sor.

Display window méretek:

| RSEL | Magasság | Első sor | Utolsó sor |
|------|----------|----------|------------|
| 0 | 24 sor / 192 px | 55 ($37) | 246 ($F6) |
| 1 | 25 sor / 200 px | 51 ($33) | 250 ($FA) |

| CSEL | Szélesség | Első px | Utolsó px |
|------|-----------|---------|-----------|
| 0 | 38 col / 304 px | 31 | 334 |
| 1 | 40 col / 320 px | 24 | 343 |

### 3.5. Bad Lines

**Feltétel**: RASTER & 7 == YSCROLL, DEN=1, vonal 30-247 között.

Bad Line-on a VIC 40 ciklust vesz el a CPU-tól (karakter pointerek + Color RAM olvasása). A CPU megáll BA low esetén.

**Programozási következmény**: YSCROLL-t a sor közepén módosítva kontrollálható, melyik sor lesz Bad Line. Ez az FLD/FLI effektek alapja.

### 3.7. Grafikai módok

| ECM | BMM | MCM | Mód | Felbontás |
|-----|-----|-----|-----|-----------|
| 0 | 0 | 0 | Standard text | 40×25 char, 2 szín/char |
| 0 | 0 | 1 | Multicolor text | 40×25 char, 4 szín/char (ha Color RAM bit3=1) |
| 0 | 1 | 0 | Standard bitmap | 320×200 px, 2 szín/8×8 blokk |
| 0 | 1 | 1 | Multicolor bitmap | 160×200 px, 4 szín/4×8 blokk |
| 1 | 0 | 0 | ECM text | 40×25 char, 4 háttér / 1 előtér / char |
| 1 | x | x | Illegális | Fekete képernyő |

#### Standard text mode
- Screen RAM (VM cím): char kód byte
- Color RAM ($D800): előtér szín (4 bit)
- Char ROM/RAM (CB cím): 8×8 bit bitmap / karakter
- Háttér: B0C ($D021)

#### Multicolor text mode
- Ha Color RAM bit 3 = 0: normal text módként működik
- Ha Color RAM bit 3 = 1: 4 szín / karakter dupla szélességű pixelekkel
  - B0C, B1C, B2C = pixel értékek 01/10/11-hez
  - Color RAM (3:0) = karakter előtér (csak páros X koordinátákon van hatása)

#### Standard bitmap mode
- Bitmap: 8000 byte = 320×200 pixel
- Screen RAM (VM): felső nibble = szín ha bit=1, alsó nibble = szín ha bit=0
- Elrendezés: 8×8 pixeles blokkonként, balról jobbra, felülről lefelé

#### Multicolor bitmap mode
- 160×200 pixel (4×8 blokk = 4 pixel széles × 8 pixel magas)
- Szín 00 = B0C, 01 = VM upper nibble, 10 = VM lower nibble, 11 = Color RAM

#### ECM text mode
- Char kód 0-63 (felső 2 bit = háttér szín selector)
- Háttér szín: B0C-B3C alapján
- Előtér: Color RAM

### 3.8. Sprite-ok

- 8 MOB (Movable Object Block)
- Méret: 24×21 pixel = 63 byte adat + 1 byte padding = 64 byte
- Sprite pointer: Video Matrix + $03F8-$03FF (8 pointer byte)
- Sprite adat cím = pointer × 64 (a VIC bankban)

Sprite jellemzők táblázata:

| Tulajdonság | Regiszter | Leírás |
|-------------|-----------|--------|
| Pozíció X | $D000+2n, $D010 | X koordináta (9 bit) |
| Pozíció Y | $D001+2n | Y koordináta (8 bit) |
| Enable | $D015 | Sprite megjelenítés |
| Priority | $D01B | 0 = grafika előtt, 1 = grafika mögött |
| Multicolor | $D01C | Dupla széles pixelek (4 szín) |
| X expand | $D01D | 2x szélesség |
| Y expand | $D017 | 2x magasság |
| Szín | $D027+n | Sprite egyedi szín |
| MC szín 0 | $D025 | Multicolor pixel érték 01 |
| MC szín 1 | $D026 | Multicolor pixel érték 11 |

### 3.12. VIC Interrupt

**IRQ forrás** ($D019 / $D01A):

| Bit | Status | Enable | Forrás |
|-----|--------|--------|--------|
| 0 | IRST | ERST | Raster egyezés |
| 1 | IMBC | EMBC | Sprite-háttér collision |
| 2 | IMMC | EMMC | Sprite-sprite collision |
| 3 | ILP | ELP | Light pen él |
| 7 | IRQ | – | Összesített (bármelyik és engedélyezett) |

**Raster IRQ beállítás:**
```asm
lda #target_line_lo
sta $d012
lda $d011
and #$7f
ora #target_line_hi    // bit8 ha vonal > 255
sta $d011
lda #%00000001         // ERST enable
sta $d01a
```

**IRQ vége (ACK):**
```asm
asl $d019              // minden pending bit törölve
jmp $ea81              // vagy $ea31
```

### 3.14. Speciális effektek

#### FLD – Flexible Line Distance
YSCROLL rasztervonalanként módosítva a display scrollozik.

#### FLI – Flexible Line Interpretation
Screen RAM pointer (VM) rasztervonalanként változtatva: minden sorban más forrásból olvassa a karakter adatokat. Eredmény: 8 szín/char helyett 1 szín/char.

#### Hyperscreen / Border effekt
$D011 / $D016 határvonal-ellenőrzési feltételét manipulálva a keret eltávolítható egyes sorokban (top, bottom, left, right border mind külön kezelhető).

#### DMA delay
Bad Line-t megkésleltetni tudja a programozó: RASTER & 7 == YSCROLL de a sor közepén. A VIC extra ciklusokat vesz el, de a display tartalma eltolódik.

#### Sprite stretching
$D017 (Y expand) rasztervonalanként kapcsolgatva sprite magasság növelhető a 42 pixel felett is.

---

## 4. $0000/$0001 és $DE00 terület

**$0000**: I/O port DDR (1=output, 0=input)
**$0001**: I/O port adat

Standard C64 konfiguráció ($0001 = $37):
- Bit 0: LORAM (1=Basic ROM on)
- Bit 1: HIRAM (1=Kernal ROM on)
- Bit 2: CHAREN (1=I/O, 0=Char ROM)
- Bit 3-4: Kazettás eszköz
- Bit 5: Kazetta motor

**$DE00-$DFFF**: Expansion port I/O 1 és I/O 2 – alap esetben nyílt (utolsó VIC bus read értéket adja vissza sok C64-en).