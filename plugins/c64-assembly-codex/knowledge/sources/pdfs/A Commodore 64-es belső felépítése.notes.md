# A Commodore 64-es belső felépítése (64 Intern)

- Forrás: `A Commodore 64-es belső felépítése.pdf` (321 oldal)
- Eredeti cím: „64 Intern" (1984), Data Becker GmbH, Düsseldorf
- Magyar fordítás: Dobosné Hartyányi Mária; lektor: Dr. Obádovics J. Gyula és Dr. Lengyel József
- Kiadó: DATA BECKER–NOVOTRADE, Budapest 1985, 4. bővített kiadás
- Szerzők: Michael Angerhausen (sprites/grafika), Rolf Brückmann (hardware), Lothar Englisch (ROM lista/BASIC bővítés), Klaus Gerils (hardver/IEC busz)
- Téma: Teljes C64 hardver és szoftver belső felépítés; SID chip, VIC videovezérlő, CIA I/O, BASIC interpreter, gépi kód programozás, ROM lista
- Megbízhatóság: magas (részletes hardver szintű dokumentáció)
- Érdemes nézni: SID programozás, VIC-II regiszterek, CIA chipek, BASIC bővítés, ROM belépési pontok

---

## Tartalom

| Fejezet | Tartalom | Oldal |
|---------|----------|-------|
| 1 | Lemezvégen a CBM 64 – hardware áttekintés | 7 |
| 1.1 | Amit a készülékről tudni kell | 7 |
| 1.2 | A hardver felépítés (multiplexelés, AM chip) | 7 |
| 1.3 | A 6510-es processzor és sajátosságai | 9 |
| 1.4 | A tárfelosztások (RAM/ROM/I-O) | 10 |
| 1.5 | A bővítő port | 21 |
| 1.6 | A user port és programozása | 22 |
| 2 | A szintetizátor és programozása (SID 6581) | 25 |
| 2.1 | A 6581-es hangvezérlő regiszterei | 27 |
| 2.2 | A SID 6581-es programozása | 33 |
| 2.3 | SYNTHIMAT 64 | 35 |
| 3 | A grafika és programozása (VIC 6569) | 37 |
| 3.1 | A VIC 6569-es videovezérlő regiszterei | 40 |
| 3.2–3.5 | VIC illesztése processzorhoz/RAM-hoz/karaktergenerátorhoz | 54–65 |
| 3.6 | A szín és a grafika programozása | 65 |
| 3.7 | A sprite – a Commodore 64 varázsszava | 69 |
| 4 | INPUT-OUTPUT vezérlés – CIA 6526-os chip | 69 |
| 4.1–4.6 | CIA regiszterek, portok, timerek, valós idejű óra | 69–72 |
| 4.7 | Botkormány kezelése | 73 |
| 4.8 | Az IEC busz | 73 |
| 5 | A BASIC – más szemmel | 85 |
| 5.1–5.3 | BASIC interpreter, kiterjesztési lehetőségek | 85–101 |
| 6 | Gépi kódú programozás a C64-en | 103 |
| 6.1–6.5 | Monitor, OS területek, adatforgalom, LOAD/SAVE, RS-232 | 103–129 |
| 7 | C64, VC-20 és CBM gépek tárfelosztásának összehasonlítása | 119 |
| 8 | A Commodore 64-es ROM listája | 135 |

---

## 1. Fejezet: Hardware Áttekintés

### 1.1 A CBM 64 Komponensei

| Komponens | Leírás |
|-----------|--------|
| 6510 processzor | 8 bites CPU, 980 kHz, 6 db I/O kivezetés |
| 64K dinamikus RAM | 4164-es IC-k |
| 1K szín RAM | Statikus, külön a VIC számára |
| 4K karaktergenerátor ROM | Karakter bitmintázatok |
| VIC-II 6569 | Színes videó chip (PAL) |
| SID 6581 | 3 csatornás hangszintetizátor |
| CIA 6526 × 2 | Complex Interface Adapter (I/O, timer, IEC) |
| 8K BASIC ROM | BASIC 2.0 interpreter |
| 8K KERNAL ROM | Operációs rendszer |

### 1.2 Hardware Felépítés (Multiplexelés)

**AM chip (Address Manager, FPLA):** A C64 speciális logikai IC-je, amely kezeli a RAM/ROM/I-O területek közötti váltást. Bemenetek: LORAM, HIRAM, CHAREN, VA14, A13-A15, BA, AEC, R/W, EXROM, GAME, VA12-13. Kimenetek: CASRAM, BASIC, KERNAL, CHAROM, GR/W, I/O, ROML, ROMH.

**Karaktergenerátor és I/O területek átfedése:** Azonos fizikai cím ($D000–$DFFF), de különböző komponensek, CHAREN bit választja meg:
- CHAREN=1: I/O eszközök (VIC, SID, CIA, Color RAM) 
- CHAREN=0: Karakter ROM (a VIC ilyenkor olvassa)

### 1.3 A 6510-es Processzor

**Jelkivezetések:**
| Pin | Jel | Leírás |
|-----|-----|--------|
| 1 | φ2 | Órajel bemenet (~980 kHz) |
| 2 | RDY | Ready; ha 0, processzor adatot vár |
| 3 | /IRQ | Maskable Interrupt Request |
| 4 | /NMI | Non-Maskable Interrupt |
| 5 | AEC | Address Enable Control (buszátadás) |
| 6-7 | Vcc, GND | Tápfeszültség |
| 7-20 | A0-A13 | Cím busz (részleges) |
| 21 | GND | Földelés |
| 22-23 | A14-A15 | Cím busz (felső bitek) |
| 24-29 | P5-P0 | 6 db programozható I/O kivezetés |
| 30-37 | D7-D0 | Adatbusz (8 bit) |
| 38 | R/W | Olvasás=1, Írás=0 |
| 39 | φ2OUT | Órajel kimenet |
| 40 | RES | Reset |

**I/O portok (P0–P5) a $0000/$0001 cím pár:**
- $0000 DDR: adatirány regiszter (1=kimenet)
- $0001 PORT: P0=LORAM, P1=HIRAM, P2=CHAREN, P3=kazetta DATA, P4=kazetta SWITCH, P5=kazetta MOTOR

### 1.4 Tárfelosztások

```
$0000-$FFFF : 64K RAM (teljes RAM mindig jelen van fizikailag)

Logikai nézet (LORAM=1, HIRAM=1, CHAREN=1):
$0000-$9FFF : RAM
$A000-$BFFF : BASIC ROM
$C000-$CFFF : RAM (szabad)
$D000-$DFFF : I/O (VIC, SID, CIA, Color RAM)
$E000-$FFFF : KERNAL ROM

Alternatív konfiguráció (CHAREN=0):
$D000-$DFFF : Karakter ROM (olvasható gépi kódból)
```

**Bővítőport (GAME/EXROM vonalak) hatása:**
- 8K cartridge $8000–$9FFF-en (EXROM=0, GAME=1)
- 8K cartridge $A000–$BFFF-en (EXROM=0, GAME=0)
- 16K cartridge $8000–$BFFF-en
- Max emulator mód (GAME=0, EXROM=1)

---

## 2. Fejezet: SID 6581 Szintetizátor

### 2.1 SID Regiszter Leírás ($D400–$D41C)

**Egy hang (Voice) regiszteri ($D400 = Voice 1 alap):**

| Offset | Regiszter | Leírás |
|--------|-----------|--------|
| $00 | FREQL | Frekvencia alacsony byte |
| $01 | FREQH | Frekvencia magas byte |
| $02 | PWML | Puls szélesség alacsony (8 bit) |
| $03 | PWMH | Puls szélesség magas (4 bit) |
| $04 | CR | Control Register |
| $05 | AD | Attack (4 bit) / Decay (4 bit) |
| $06 | SR | Sustain (4 bit) / Release (4 bit) |

**Voice 1: $D400–$D406, Voice 2: $D407–$D40D, Voice 3: $D40E–$D414**

**Control Register (CR) bitek:**

| Bit | Leírás |
|-----|--------|
| 0 | GATE: 1=hangindítás, 0=hangleállítás (release fázis) |
| 1 | SYNC: szinkronizáció az előző Voice-szal |
| 2 | RING: Ring Modulation (oszcillátor moduláció) |
| 3 | TEST: oszcillátor reset |
| 4 | TRI: háromszög hullám |
| 5 | SAW: fűrészfog hullám |
| 6 | PULSE: négyszög hullám |
| 7 | NOISE: zajgenerátor |

**Attack/Decay értékek (milliszekundumban):**

| Érték | Idő |
|-------|-----|
| 0 | 2 ms |
| 1 | 8 ms |
| 2 | 16 ms |
| 3 | 24 ms |
| 4 | 38 ms |
| 5 | 56 ms |
| 6 | 68 ms |
| 7 | 80 ms |
| 8 | 100 ms |
| 9 | 250 ms |
| 10 | 500 ms |
| 11 | 800 ms |
| 12 | 1 s |
| 13 | 3 s |
| 14 | 5 s |
| 15 | 8 s |

**Filter Regiszterek ($D415–$D418):**

| Cím | Regiszter | Leírás |
|-----|-----------|--------|
| $D415 | FCTL | Filter Cutoff Freq alacsony (3 bit) |
| $D416 | FCTH | Filter Cutoff Freq magas (8 bit) |
| $D417 | RES/FILT | Resonance (4 bit) + voice routing |
| $D418 | MODE/VOL | Filter mód + Master Volume (0–15) |

**$D417 bitek:**
- Bit 0: Voice 1 a filterre
- Bit 1: Voice 2 a filterre
- Bit 2: Voice 3 a filterre
- Bit 3: Extern input a filterre
- Bit 4–7: Resonance (0–15)

**$D418 bitek:**
- Bit 0–3: Master Volume (0=csend, 15=maximum)
- Bit 4: Low Pass Filter
- Bit 5: Band Pass Filter
- Bit 6: High Pass Filter
- Bit 7: Voice 3 disconnect (nem megy a kimenetre)

**Olvasható regiszterek:**
- $D419: Paddle X (AD converter)
- $D41A: Paddle Y (AD converter)
- $D41B: Voice 3 Oscillator output (8 bit)
- $D41C: Voice 3 Envelope output (8 bit)

### 2.2 SID Programozás Példa

**Hang lejátszás (A hangnem, fűrészfog hullám):**
```basic
POKE 54296, 15      : REM Hangerő max ($D418 = $0F)
POKE 54276, 0       : REM Gate OFF ($D404)
POKE 54273, 28      : REM Frekvencia HI ($D401) – A4 ≈ 440 Hz
POKE 54272, 177     : REM Frekvencia LO ($D400)
POKE 54277, 0       : REM Attack=0, Decay=0 ($D405)
POKE 54278, 248     : REM Sustain=15, Release=8 ($D406)
POKE 54276, 33      : REM Fűrész hullám + Gate ON ($D404 = SAW|GATE)
```

**Hangfrekvencia kiszámítása:**
`FREQ = note_frequency * 16777216 / 985248` (PAL)

---

## 3. Fejezet: VIC 6569 Videovezérlő

### 3.1 VIC Regiszter Leírás ($D000–$D02E)

→ Részletesen: `vic-ii.notes.md` és `VIC-II reference.notes.md`

**Kivonat a legfontosabb regiszterekből:**

| Cím | Leírás |
|-----|--------|
| $D000–$D00F | Sprite 0–7 X/Y pozíciók |
| $D010 | Sprite X bit 8-ak |
| $D011 | Vertical control (RST8, ECM, BMM, DEN, RSEL, YSCROLL) |
| $D012 | Raster counter / raster compare |
| $D015 | Sprite enable |
| $D016 | Horizontal control (RES, MCM, CSEL, XSCROLL) |
| $D017 | Sprite Y expand |
| $D018 | VM/CB pointer ($D018 bits 7-4: screen; bits 3-1: charset) |
| $D019 | IRQ status (ack: asl $d019) |
| $D01A | IRQ enable |
| $D020 | Border color |
| $D021–$D024 | Background colors 0–3 |
| $D025–$D026 | Sprite multicolor 0 és 1 |
| $D027–$D02E | Sprite 0–7 egyedi szín |

### 3.2 VIC illesztése processzorhoz (Bad Lines)

A VIC-II minden rasztervonalnál olvashatja a videómemóriát. **Bad Line** feltétel:
```
(RASTER & 7) == YSCROLL && DEN == 1 && RASTER in [30..247]
```
Bad Line-on a processzort várakoztatja (RDY=0) amíg a VIC betölti a karakteradatokat – 40–43 ciklus elrabolva.

### 3.5 illesztés a szín-RAM-hoz

A szín RAM ($D800–$DBFF) a VIC számára mindig elérhető, míg a CPU számára is hozzáférhető. A CPU mindig 8 bitet ír/olvas, de csak az alsó 4 bit érvényes.

### 3.6 Szín és grafika programozása

**Grafikai módok engedélyezése:**

| Mód | $D011 | $D016 | Megjegyzés |
|-----|-------|-------|------------|
| Text | ECM=0, BMM=0 | MCM=0 | Alap mód |
| Text Multicolor | ECM=0, BMM=0 | MCM=1 | Per-karakter bit3=1 → multicolor |
| Extended Background | ECM=1, BMM=0 | MCM=0 | Max 64 karakter kód |
| Hires Bitmap | ECM=0, BMM=1 | MCM=0 | 320×200 pixel |
| Multicolor Bitmap | ECM=0, BMM=1 | MCM=1 | 160×200 pixel, 4 szín |

### 3.7 Sprite-ok

**Sprite adatszerkezet:**
- 24 pixel wide × 21 sor = 504 bit → 63 byte + 1 padding
- Sprite pointer a VM+$03F8–$03FF területen
- Effektív cím = pointer * 64

**Sprite tulajdonságok:**

| Cím | Leírás |
|-----|--------|
| $D015 | Sprite enable (bit n = sprite n) |
| $D017 | Y expand (méret duplázás) |
| $D01B | Priority (0=előtér, 1=háttér) |
| $D01C | Multicolor enable |
| $D01D | X expand |
| $D01E | Sprite-sprite collision |
| $D01F | Sprite-background collision |

---

## 4. Fejezet: CIA 6526 I/O Chip

### 4.2 CIA Regiszter Leírás

**CIA 1 ($DC00) és CIA 2 ($DD00) azonos struktúra:**

| Offset | Regiszter | Leírás |
|--------|-----------|--------|
| 0 | PRA | Port A adatregiszter |
| 1 | PRB | Port B adatregiszter |
| 2 | DDRA | Port A adatirány |
| 3 | DDRB | Port B adatirány |
| 4 | TALO | Timer A alacsony byte |
| 5 | TAHI | Timer A magas byte |
| 6 | TBLO | Timer B alacsony byte |
| 7 | TBHI | Timer B magas byte |
| 8 | TOD10TH | TOD tized másodperc (BCD) |
| 9 | TODSEC | TOD másodperc (BCD) |
| A | TODMIN | TOD perc (BCD) |
| B | TODHR | TOD óra (BCD) + AM/PM bit |
| C | SDR | Soros adatregiszter |
| D | ICR | Interrupt Control Register |
| E | CRA | Control Register A |
| F | CRB | Control Register B |

### CIA 1 ($DC00): Billentyűzet + Joystick

**Billentyűzet matrix:**
- Port A ($DC00): oszlopok kimenetre, 0=vizsgált oszlop
- Port B ($DC01): sorok bemenetre; 0=billentyű lenyomva

**Joystick:**
- Joystick 1: Port B ($DC01) bit0-4
- Joystick 2: Port A ($DC00) bit0-4
- Bit: 0=UP, 1=DOWN, 2=LEFT, 3=RIGHT, 4=FIRE

### CIA 2 ($DD00): RS-232 + VIC Bank

**$DD00 Port A:**
- Bit 0-1: VIC bank (invertálva: 11=Bank0, 00=Bank3)
- Bit 2-7: RS-232 vonalak

**$DD01 Port B:** RS-232 adatok

### 4.4 Timerek

**Timer A/B működési módok (CRA/CRB bits):**
- Bit 0: START (1=futás)
- Bit 3: ONE-SHOT (1=egyszeri, 0=folyamatos)
- Bit 4: FORCE LOAD (1=azonnali töltés)
- Bit 5-6: INPUT MODE (00=φ2, 01=CNT pin, 10=Timer A, 11=Timer A CNT-vel)

**Timer IRQ beállítás:**
```asm
LDA #$00
STA $DC0E    ; Timer A stop
LDA #time_lo
STA $DC04    ; Timer A alacsony
LDA #time_hi
STA $DC05    ; Timer A magas
LDA #$81
STA $DC0D    ; Timer A IRQ engedélyezés
LDA #$01
STA $DC0E    ; Timer A start, continuous
```

### 4.5 TOD (Time of Day) Valós Idejű Óra

**BCD formátum:** Óra:Perc:Másodperc.Tized

Beállítás: $DC0B óra → $DC0A perc → $DC09 másodperc → $DC08 tized
Olvasás: $DC08 tizedtől → $DC0B óráig (olvasás "fagyasztja" az állapotot)

### 4.8 IEC Busz

Az IEC (International Electrotechnical Commission) busz a Commodore sorozatbusz implementációja (CIA 2 Port B-n):

| Bit | Jel | Leírás |
|-----|-----|--------|
| 0 | CLK IN | Órajel bemenet |
| 2 | CLK OUT | Órajel kimenet |
| 4 | DATA IN | Adat bemenet |
| 5 | DATA OUT | Adat kimenet |
| 6 | ATN OUT | ATN (Attention) kimenet |

---

## 5. Fejezet: BASIC – Más Szemmel

### 5.1 BASIC Interpreter Működése

A BASIC tokenizálása:
1. Beírás: ASCII szöveg a $0200-as pufferbe
2. Tokenizálás: kulcsszavak → 1 byte tokenek
3. Láncolás: sor → következő sor pointer

**BASIC tokenizált sor formátum:**
```
[2 byte: következő sor pointer] [2 byte: sor száma] [tokenek...] [0x00 záró]
```

### 5.3 BASIC Kiterjesztési Lehetőségek

**Új BASIC parancs hozzáadása (Wedge módszer):**
1. CHRGET rutin elcsere ($0073–$0079 területen)
2. Saját rutin az ismeretlen token azonosítására
3. BASIC GO szubroutin elcsere ($0308–$0309 vektor)

---

## 6. Fejezet: Gépi Kódú Programozás

### 6.1 Monitor programokról

C64 monitorok: 64MON (cartridge), Simon's BASIC beépített monitor, EXMON stb.

### 6.2 Commodore 64 OS fontos területei

| Cím | Területe |
|-----|---------|
| $0000-$00FF | Zero Page (OS és BASIC változók) |
| $0100-$01FF | Stack |
| $0200-$02FF | OS munkaterület, BASIC input buffer |
| $0300-$03FF | OS vektorok ($0314-$0315 IRQ vektor) |
| $0314-$0315 | IRQ vektor (user) |
| $0316-$0317 | BRK vektor |
| $0318-$0319 | NMI vektor |
| $033C-$03FB | Kazetta puffer (ML teszt terület) |

### 6.3 Adatforgalom Gépi Programokkal

**Byte kiírás a képernyőre:**
```asm
LDA #karakter   ; PETSCII kód
JSR $FFD2       ; KERNAL CHROUT
```

**Byte beolvasás:**
```asm
poll:   JSR $FFE4   ; GETIN
        CMP #0
        BEQ poll
        ; A = karakter
```

**Fájl megnyitás/olvasás/zárás pattern:**
```asm
; 1. SETLFS
LDA #1      ; logical file
LDX #8      ; device (disk)
LDY #0      ; secondary address
JSR $FFBA

; 2. SETNAM
LDA #4      ; name length
LDX #<name
LDY #>name
JSR $FFBD

; 3. OPEN
JSR $FFC0

; 4. CHKIN
LDA #1
JSR $FFC6

; 5. Adatolvasás ciklusban
rdloop: JSR $FFCF   ; CHRIN
        ; feldolgozás...
        LDA $90     ; STATUS olvasás (ST)
        BNE done    ; EOF vagy hiba
        JMP rdloop

; 6. CLRCHN + CLOSE
done:   JSR $FFCC
        LDA #1
        JSR $FFC3
```

---

## 7. Fejezet: C64, VC-20, CBM Összehasonlítás

### 7.1 Zero Page és Fontos Területek

**Zero Page különbségek C64 vs VC-20:**
- $0000-$00FF: Mindkét gépen rendszer változók, de különböző elrendezéssel
- $D000–$DFFF: C64-en VIC-II, VC-20-on VIC-I ($9000–$900F)
- Stack: Mindkét gépen $0100–$01FF

**C64 vs CBM 8000 főbb különbségek:**
- CBM 8000: IEEE-488 busz, nem IEC soros
- Különböző zero page elrendezés

### 7.3 VC-20 ↔ C64 összehasonlítás

| Tulajdonság | VC-20 | C64 |
|------------|-------|-----|
| CPU | 6502 | 6510 |
| Video | VIC-I (6561) | VIC-II (6567/6569) |
| Hang | VIC-I (3+1 ch) | SID 6581 (3 ch) |
| RAM | 5K (alap) | 64K |
| Screen | 22×23 | 40×25 |
| Sprite | Nincs | 8 MOB |
| IRQ vektor | $0314 | $0314 |
| Screen base | $1E00 (alap) | $0400 (alap) |

---

## 8. Fejezet: ROM Lista

### 8.2 ROM Rutinok Jegyzéke

A ROM tartalmaz BASIC interpreter rutinokat ($A000–$BFFF) és KERNAL rutinokat ($E000–$FFFF).

**Fontos KERNAL belépési pontok (jump table):**

| Cím | Rutin | Leírás |
|-----|-------|--------|
| $FF81 | CINT | Képernyő inicializálás |
| $FF84 | IOINIT | I/O inicializálás |
| $FF87 | RAMTAS | RAM teszt |
| $FF8A | RESTOR | Vektorok alaphelyre |
| $FF8D | VECTOR | Vektorok írás/olvasás |
| $FFB7 | READST | ST státusz olvasás |
| $FFBA | SETLFS | Logical file set |
| $FFBD | SETNAM | Fájlnév set |
| $FFC0 | OPEN | Fájl megnyitás |
| $FFC3 | CLOSE | Fájl zárás |
| $FFC6 | CHKIN | Input csatorna |
| $FFC9 | CHKOUT | Output csatorna |
| $FFCC | CLRCHN | Csatorna reset |
| $FFCF | CHRIN | Karakter olvasás |
| $FFD2 | CHROUT | Karakter írás |
| $FFD5 | LOAD | Betöltés |
| $FFD8 | SAVE | Mentés |
| $FFDB | SETTIM | Jiffy timer beállítás |
| $FFDE | RDTIM | Jiffy timer olvasás |
| $FFE1 | STOP | STOP vizsgálat |
| $FFE4 | GETIN | Billentyű karakter |
| $FFE7 | CLALL | Összes file zárás |
| $FFEA | UDTIM | Timer frissítés |
| $FFED | SCREEN | Képernyő méret lekérés |
| $FFF0 | PLOT | Kurzor pozíció |
| $FFF3 | IOBASE | I/O alap cím |

### 8.3 ROM Lista

Tartalmaz teljes disassembly-t a KERNAL és BASIC ROM területekről kommentekkel.