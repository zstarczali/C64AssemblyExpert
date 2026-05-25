# VIC-II 6567/6569/856x – Regiszter referencia

- Forrás: `VIC-II reference.pdf` (2 oldal)
- Téma: VIC-II chip teljes regisztertérképe, videó módok táblázata
- Megbízhatóság: magas
- Érdemes nézni: gyors regiszter cím kereséshez, bit definíciókhoz, videó mód kombinációkhoz

---

## VIC-II Regisztertérkép ($D000–$D030)

### Sprite pozíciók

| Cím | R/W | Regiszter | Leírás |
|-----|-----|-----------|--------|
| $D000 | R/W | M0X | Sprite 0 X pozíció (bit 0-7) |
| $D001 | R/W | M0Y | Sprite 0 Y pozíció |
| $D002 | R/W | M1X | Sprite 1 X pozíció |
| $D003 | R/W | M1Y | Sprite 1 Y pozíció |
| $D004 | R/W | M2X | Sprite 2 X pozíció |
| $D005 | R/W | M2Y | Sprite 2 Y pozíció |
| $D006 | R/W | M3X | Sprite 3 X pozíció |
| $D007 | R/W | M3Y | Sprite 3 Y pozíció |
| $D008 | R/W | M4X | Sprite 4 X pozíció |
| $D009 | R/W | M4Y | Sprite 4 Y pozíció |
| $D00A | R/W | M5X | Sprite 5 X pozíció |
| $D00B | R/W | M5Y | Sprite 5 Y pozíció |
| $D00C | R/W | M6X | Sprite 6 X pozíció |
| $D00D | R/W | M6Y | Sprite 6 Y pozíció |
| $D00E | R/W | M7X | Sprite 7 X pozíció |
| $D00F | R/W | M7Y | Sprite 7 Y pozíció |
| $D010 | R/W | M?X8 | Sprite X pozíció bit 8 (minden sprite egy-egy bitje: bit7=S7, bit0=S0) |

### Vezérlő regiszterek

| Cím | R/W | Regiszter | Bitek (7..0) |
|-----|-----|-----------|--------------|
| $D011 | R/W | CR1 | RST8, ECM, BMM, DEN, RSEL, YSCROLL(2:0) |
| $D012 | R | RASTER | Raster Counter bit 7-0 (olvasás = aktuális rasztervonal) |
| $D012 | W | RSTCMP | Raster Comparator bit 7-0 (IRQ trigger vonal) |
| $D013 | R | LPX | Light Pen X pozíció |
| $D014 | R | LPY | Light Pen Y pozíció |
| $D015 | R/W | M?E | Sprite Enable (bit7=S7 .. bit0=S0) |
| $D016 | R/W | CR2 | -, -, RES, MCM, CSEL, XSCROLL(2:0) |
| $D017 | R/W | M?YE | Sprite Y Expand (bit7=S7 .. bit0=S0) |
| $D018 | R/W | VM/CB | Screen Pointer (A13-A10) / Bitmap-Charset Pointer (A13-A11) |

### Interrupt regiszterek

| Cím | R/W | Regiszter | Bitek |
|-----|-----|-----------|-------|
| $D019 | R/W | IRQST | IRQ, -, -, -, ILP, IMMC, IMBC, IRST |
| $D01A | R/W | IRQEN | -, -, -, -, ELP, EMMC, EMBC, ERST |

IRQ forrás bitek:
- **IRST** (bit 0): Raster interrupt
- **IMBC** (bit 1): Sprite-Background collision
- **IMMC** (bit 2): Sprite-Sprite collision
- **ILP** (bit 3): Light pen

### Sprite tulajdonságok

| Cím | R/W | Regiszter | Leírás |
|-----|-----|-----------|--------|
| $D01B | R/W | M?DP | Sprite Display Priority (1=hátul, 0=elöl) |
| $D01C | R/W | M?MC | Sprite Multicolor Enable |
| $D01D | R/W | M?XE | Sprite X Expand |
| $D01E | R/W | M?M | Sprite-Sprite collision (olvassuk, töröljük írással) |
| $D01F | R/W | M?D | Sprite-Background collision |

### Szín regiszterek

| Cím | R/W | Regiszter | Leírás |
|-----|-----|-----------|--------|
| $D020 | R/W | EC | Border Color (keret szín) |
| $D021 | R/W | B0C | Background Color 0 |
| $D022 | R/W | B1C | Background Color 1 |
| $D023 | R/W | B2C | Background Color 2 |
| $D024 | R/W | B3C | Background Color 3 |
| $D025 | R/W | MM0 | Sprite Multicolor 0 |
| $D026 | R/W | MM1 | Sprite Multicolor 1 |
| $D027 | R/W | M0C | Sprite 0 Color |
| $D028 | R/W | M1C | Sprite 1 Color |
| $D029 | R/W | M2C | Sprite 2 Color |
| $D02A | R/W | M3C | Sprite 3 Color |
| $D02B | R/W | M4C | Sprite 4 Color |
| $D02C | R/W | M5C | Sprite 5 Color |
| $D02D | R/W | M6C | Sprite 6 Color |
| $D02E | R/W | M7C | Sprite 7 Color |

### C128-specifikus regiszterek

| Cím | Leírás |
|-----|--------|
| $D02F | KCR – Keyboard Interface (csak C128) |
| $D030 | FAST – 2 MHz mód (csak C128) |

Megjegyzés: Nem használt bitek visszaolvasáskor 1-et adnak.

---

## VIC-II Videó módok

Az ECM, BMM, MCM bitek ($D011 bit 6, $D011 bit 5, $D016 bit 4) kombinációja határozza meg:

| ECM | BMM | MCM | Mód |
|-----|-----|-----|-----|
| 0 | 0 | 0 | Hires character mode (40x25) |
| 0 | 0 | 1 | Multicolor character mode (40x25) |
| 0 | 1 | 0 | Hires bitmap mode (320x200) |
| 0 | 1 | 1 | Multicolor bitmap mode (160x200) |
| 1 | 0 | 0 | Extended background color mode (40x25) |
| 1 | x | x | Illegális mód (fekete képernyő) |

---

## $D011 Vezérlő Regiszter 1 – Bit részletek

| Bit | Név | Leírás |
|-----|-----|--------|
| 7 | RST8 | Raster Counter bit 8 (a felső bit – $D012 a 7:0) |
| 6 | ECM | Extended Color Mode |
| 5 | BMM | Bitmap Mode |
| 4 | DEN | Display Enable (0 = fekete képernyő) |
| 3 | RSEL | Row Select (1 = 25 sor, 0 = 24 sor) |
| 2-0 | YSCROLL | Vertical Scroll (0-7) |

## $D016 Vezérlő Regiszter 2 – Bit részletek

| Bit | Név | Leírás |
|-----|-----|--------|
| 4 | MCM | Multicolor Mode |
| 3 | CSEL | Column Select (1 = 40 kolumna, 0 = 38 kolumna) |
| 2-0 | XSCROLL | Horizontal Scroll (0-7) |

## $D018 Screen/Charset pointer – Bit részletek

| Bitek | Leírás |
|-------|--------|
| 7-4 | Video matrix base address (A13-A10; *$0400 offset a VIC bank-en belül) |
| 3-1 | Character generator / Bitmap base (A13-A11) |

Pl.: $D018 = $15 -> Screen: $0400, Charset: $1000 (ROM)
