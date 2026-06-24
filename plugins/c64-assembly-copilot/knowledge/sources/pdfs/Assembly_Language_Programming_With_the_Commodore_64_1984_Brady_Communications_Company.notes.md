# Assembly Language Programming with the Commodore 64

- Forrás: `Assembly_Language_Programming_With_the_Commodore_64_1984_Brady_Communications_Company.pdf` (316 oldal)
- Szerző: Marvin L. DeJong, The School of the Ozarks
- Kiadó: Brady Communications Company / Prentice-Hall, 1984
- Téma: 6510 assembly alapok és haladó technikák C64-re – SID, VIC, CIA, IRQ
- Megbízhatóság: magas (részletes forráskóddal, lépésről lépésre magyaráz)
- Megjegyzés: A PDF szövegből a szóközök hiányoznak (pl. "AssemblyLanguage"), de a tartalom teljes egészében olvasható; kezdőtől haladóig minden szinten hasznos referencia

---

## Tartalom

| Fejezet | Cím | Tartalom |
|---------|-----|---------|
| 1 | The Commodore 64 Microcomputer System | Memória térkép, rendszerbuszok, belső regiszterek |
| 2 | Writing, Assembling, and Executing Programs | Addressing mode-ok, BASIC→gépi kód munkafolyamat |
| 3 | Data Transfer Instructions | LDA/STA/TAX/TXA/TAY/TYA és regiszter-transzferek |
| 4 | Arithmetic Operations | ADC/SBC, BCD aritmetika, Carry/Overflow flag, P regiszter |
| 5 | Logic Operations | AND/ORA/EOR utasítások, flag-ek, SID/VIC regiszter kezelés |
| 6 | Branches and Loops | Branch utasítások, offset számítás, SID hangpélda |
| 7 | Shift and Rotate Routines | ASL/LSR/ROL/ROR, szorzás assembly-ben |
| 8 | Indexed Addressing Modes | ABS,X / ABS,Y / (IND),Y, screen/color memory kezelés |
| 9 | Jumps, Subroutines, and Interrupts | JMP, JSR, IRQ/NMI, KERNAL jump table, stack kezelés |
| 10 | Programming the 6581 SID Chip | Hangszintézis, ADSR envelope, waveformok, dalkiátszás |
| 11 | Applications Using the 6567 VIC Chip | Karakter mód, bit-mapped grafika, color memory |
| 12 | Input/Output: The 6526 CIA | I/O portok, Timer A/B, TOD óra, paddle/analog bemenet |
| App. A | Decimal, Binary, and Hexadecimal | Számrendszerek, konverzió |
| App. B | The CAI Program | Oktató segédprogram assembly-ben |
| App. C | The 6510 Instruction Set Summary | Teljes opkód táblázat (Rockwell engedélyével) |

---

## 1. fejezet – A C64 mikroszámítógép

### Memória térkép

```
$E000–$FFFF : Operációs rendszer ROM (KERNAL)
$D000–$DFFF : I/O területek (VIC, SID, CIA, Color RAM)
$C000–$CFFF : 4K RAM (szabad)
$A000–$BFFF : BASIC interpreter ROM
$0200–$9FFF : 40K RAM (szabad)
$0100–$01FF : Stack (Page 1)
$0002–$00FF : Zero Page (Page 0)
$0001        : I/O Port Data Register (6510)
$0000        : I/O Port Direction Register (6510)
```

### Rendszerbuszok

- **Adatbusz** (8 bit): adatátvitel CPU és memória között
- **Címbusz** (16 bit): 65536 cím megcímzése ($0000–$FFFF)
- **Vezérlőbusz**: Read/Write és órajel jelek

### 6510 belső regiszterek

- **Accumulator (A)**: 8 bit, fő adatregiszter; aritmetika/logika itt zajlik
- **X regiszter**: 8 bit, index/számláló; `INX`, `DEX` elérhető
- **Y regiszter**: 8 bit, index/számláló; `INY`, `DEY` elérhető
- **Program Counter (PC)**: 16 bit, a következő utasítás címe
- **Stack Pointer (SP)**: 8 bit, stack ($0100–$01FF) aktuális tetejére mutat
- **Processor Status (P)**: 8 bit flag regiszter

### P (Processor Status) regiszter bitjei

```
Bit 7: N (Negative)  – 1 ha az eredmény MSB-je 1
Bit 6: V (Overflow)  – 1 ha előjeles aritmetikában túlcsordulás
Bit 5: (nem használt, mindig 1)
Bit 4: B (Break)     – BRK utasításnál állítódik
Bit 3: D (Decimal)   – BCD mód
Bit 2: I (Interrupt) – 1 = IRQ letiltva
Bit 1: Z (Zero)      – 1 ha az eredmény nulla
Bit 0: C (Carry)     – 1 ha összeadásban átvitel volt
```

---

## 2. fejezet – Programírás és végrehajtás

### Addressing mode-ok (áttekintés)

| Mód | Szintaxis | Példa | Leírás |
|-----|-----------|-------|--------|
| Immediate | `#$xx` | `LDA #$41` | Konstans adat |
| Absolute | `$xxxx` | `LDA $C234` | 16 bites cím |
| Zero Page | `$xx` | `LDA $FB` | Page 0, gyorsabb (2 bájt) |
| Absolute, X | `$xxxx,X` | `LDA $C000,X` | Indexelt |
| Absolute, Y | `$xxxx,Y` | `LDA $C000,Y` | Indexelt |
| Zero Page, X | `$xx,X` | `LDA $FB,X` | Indexelt zero page |
| Indirect | `($xxxx)` | `JMP ($031A)` | Csak JMP-nél |
| (Indirect), Y | `($xx),Y` | `STA ($FB),Y` | Utó-indexelt közvetett |
| Indexed Indirect | `($xx,X)` | `LDA ($FB,X)` | Elő-indexelt közvetett |
| Relative | relatív | `BEQ label` | Branch offset |
| Accumulator | A | `ASL A` | Akkumulátoron |
| Implied | - | `RTS` | Nincs operandus |

### Alap BASIC→gépi kód munkafolyamat

```
1. Programkód BASIC DATA sorokból POKEolva a memóriába
2. SYS <cím> hívás az assembly rutin indításához
3. RTS visszatér a BASIC-be
```

Példa: Program betöltése $C000-ra:
```
10 FOR I=0 TO N : READ D : POKE 49152+I, D : NEXT I
20 SYS 49152
```

---

## 3. fejezet – Adatátviteli utasítások

### Regiszter transzferek

```asm
TAX   ; Accumulator → X
TXA   ; X → Accumulator
TAY   ; Accumulator → Y
TYA   ; Y → Accumulator
TSX   ; Stack Pointer → X
TXS   ; X → Stack Pointer
```

### Betöltés és tárolás

```asm
LDA #$41   ; Immediate betöltés A-ba ($41 = 'A' ASCII)
LDX #$00   ; Immediate betöltés X-be
LDY #$19   ; Immediate betöltés Y-be
STA $D020  ; Tárolás abszolút címre (border szín)
STX $D021  ; Tárolás X-ből
STY $D400  ; Tárolás Y-ből
```

### Verem műveletek

```asm
PHA   ; A → verem (push)
PLA   ; Verem → A (pull)
PHP   ; P regiszter → verem
PLP   ; Verem → P regiszter
```

---

## 4. fejezet – Aritmetika

### ADC/SBC alapok

```asm
CLC        ; Carry törlése összeadás előtt (KÖTELEZŐ!)
LDA NUM1
ADC NUM2   ; A = A + NUM2 + Carry

SEC        ; Carry beállítása kivonás előtt (KÖTELEZŐ!)
LDA MINUEND
SBC SUBTRAHEND   ; A = A - SUBTRAHEND - (1-Carry)
```

### Kétbájtos összeadás

```asm
CLC
LDA ADEND1_LO
ADC ADEND2_LO
STA RESULT_LO
LDA ADEND1_HI
ADC ADEND2_HI    ; Az átvitel automatikusan hozzáadódik
STA RESULT_HI
```

### Kétbájtos kivonás

```asm
SEC
LDA MINUEND_LO
SBC SUBTRAHEND_LO
STA RESULT_LO
LDA MINUEND_HI
SBC SUBTRAHEND_HI   ; Kölcsön automatikusan levonódik
STA RESULT_HI
```

### BCD (Binary Coded Decimal) mód

```asm
SED        ; Decimal mód bekapcsolás
CLC
LDA #$28   ; 28 decimálisan
ADC #$14   ; + 14 decimálisan = $42 (42 decimálisan)
CLD        ; Decimal mód kikapcsolás!
```

A CIA TOD óra ($DC08–$DC0B) BCD-ben tárolja az időt:
- `$DC08`: tized-másodpercek (BCD)
- `$DC09`: másodpercek (BCD)
- `$DC0A`: percek (BCD)
- `$DC0B`: órák (BCD, bit 7 = PM)

---

## 5. fejezet – Logikai műveletek

### AND / ORA / EOR

```asm
AND #$0F    ; Maszkolás – alsó nibble megtartása
ORA #$80    ; Bit beállítás – bit 7 beállítása
EOR #$FF    ; Invertálás – az összes bit megfordítása
```

Opkódok (Immediate / Absolute / Zero Page):

| Utasítás | Immediate | Absolute | Zero Page |
|----------|-----------|----------|-----------|
| AND      | $29       | $2D      | $25       |
| ORA      | $09       | $0D      | $05       |
| EOR      | $49       | $4D      | $45       |

### Tipikus használat

```asm
; VIC regiszter módosítása – csak bizonyos bitek változtatása:
LDA $D018
AND #$F1    ; Bitek 1-3 törlése
ORA #$04    ; Karakter memória pozíció beállítása
STA $D018
```

---

## 6. fejezet – Branch utasítások és ciklusok

### Branch utasítások táblázata

| Mnemonic | Feltétel | Opkód |
|----------|----------|-------|
| BCC | Carry Clear (C=0) | $90 |
| BCS | Carry Set (C=1) | $B0 |
| BEQ | Zero set (Z=1) | $F0 |
| BNE | Zero clear (Z=0) | $D0 |
| BMI | Negative set (N=1) | $30 |
| BPL | Negative clear (N=0) | $10 |
| BVC | Overflow clear (V=0) | $50 |
| BVS | Overflow set (V=1) | $70 |

### Branch offset számítás

```
Offset = Célcím - (Branch utasítás címe + 2)
```

Előre ugrás (pozitív offset): max. $7F (+127)
Visszaugrás (negatív offset): min. $80 (−128); kettes komplement formában

Példa:
```
Program $C123-ban: BMI $C18F-re kell ugrani
Offset = $C18F - $C125 = $6A
→ $30 $6A kerül a memóriába
```

### Delay szubrutin

```asm
DELAY  LDX #$FF
LOAF   DEX
       BNE LOAF
       RTS
```

### SID frekvencia léptetése (branch példa)

```asm
LOOP   LDA LOFREQ
       STA SID00      ; SID Voice 1 Low Freq ($D400)
       LDA HIFREQ
       STA SID01      ; SID Voice 1 High Freq ($D401)
       JSR DELAY
       INC LOFREQ
       BNE PAST
       INC HIFREQ
PAST   BNE LOOP
       RTS
```

---

## 7. fejezet – Shift és Rotate utasítások

### Definíciók

| Utasítás | Leírás | Carry hatás |
|----------|--------|-------------|
| ASL | Aritmetikai bal shift (×2) | bit 7 → Carry; 0 → bit 0 |
| LSR | Logikai jobb shift (÷2) | bit 0 → Carry; 0 → bit 7 |
| ROL | Rotate Left | bit 7 → Carry; Carry → bit 0 |
| ROR | Rotate Right | bit 0 → Carry; Carry → bit 7 |

Opkódok (Absolute / Zero Page / Accumulator):

| Mnemonic | Absolute | Zero Page | Accumulator |
|----------|----------|-----------|-------------|
| ASL | $0E | $06 | $0A |
| ROL | $2E | $26 | $2A |
| LSR | $4E | $46 | $4A |
| ROR | $6E | $66 | $6A |

### 4-bites szorzás

```asm
MULTPL  LDA #00        ; Eredmény nullázása
UP      LSR MLTP       ; Szorzó bit → Carry
        BCC DOWN       ; Ha 0, nem adjuk hozzá
        CLC
        ADC MCND       ; Részeredmény összeadás
DOWN    ASL MCND       ; Szorzandó bal shift
        BNE UP         ; Ha nem nulla, folytatjuk
        STA PROD       ; Eredmény tárolás
        RTS
```

---

## 8. fejezet – Indexelt cím módok

### ABS,X és ABS,Y

```asm
; Screen memory ($0400–$07E7) törlése 4 lépésben:
CLRSCN  LDA #$20    ; Space karakter
        LDX #250
LOOP    DEX
        STA SCN,X       ; $0400+X
        STA SCN+250,X
        STA SCN+500,X
        STA SCN+750,X
        BNE LOOP
        RTS
```

### Color memory töltése

```asm
; Color memory ($D800–$DBE7) töltése az adott számmal:
SETCLR  LDA COLOR      ; Szín kód ($0002-ből)
        LDX #250
LOOP    DEX
        STA CLR,X       ; $D800+X
        STA CLR+250,X
        STA CLR+500,X
        STA CLR+750,X
        BNE LOOP
        RTS
```

### (IND),Y – Közvetett indexelt mód

Képernyő pozíció számítása (x, y) koordinátából:

```
ADDR = $0400 + x + $28 * y
```

```asm
; IAL:IAL+1 tartalmaz egy 16 bites pointert
; Y az oszlopindex
STA (IAL),Y   ; Tárolás a (IAL)+Y címre
```

---

## 9. fejezet – Ugrások, szubrutinok, megszakítások

### JMP és JSR

```asm
JMP $C000      ; Feltétel nélküli ugrás
JSR SUBRT      ; Szubrutin hívás (visszatérési cím verembe)
RTS            ; Visszatérés szubutinból (veremből)
```

### KERNAL jump table (részlet, $FF-os szekció)

A könyv tartalmazza a teljes KERNAL jump table-t ($FFB1–$FFF3):

```
$FFD2 : JMP ($0326) → CHROUT – karakter kimenet
$FFE4 : JMP ($032A) → GETIN – karakter bemenet
$FFB4 : JMP ($ED09) → LISTEN (soros)
$FFC6 : JMP ($031E) → CHKIN
$FFC9 : JMP ($0320) → CHKOUT
$FFCC : JMP ($0322) → CLRCHN
```

Az indirekt JMP-k a RAM vektorokon keresztül csatlakoznak, így saját rutinokra cserélhetők.

### IRQ megszakítás mechanizmusa

Amikor IRQ jelet kap a 6510 (ha I flag = 0):

1. Az aktuális utasítás befejezése
2. PCH → verem
3. PCL → verem
4. P regiszter → verem
5. I flag beállítása (1 = további IRQ-k letiltva)
6. PC betöltése IRQ vektorból: $FFFE/$FFFF

Az IRQ rutinból visszatérés:
```asm
RTI   ; P, PCL, PCH visszaállítása veremből
```

### NMI vs. IRQ

| Tulajdonság | IRQ | NMI |
|-------------|-----|-----|
| Maszkolható? | Igen (I flag) | Nem |
| Vektor | $FFFE/$FFFF | $FFFA/$FFFB |
| Kiváltó esemény | CIA timer, raster | RESTORE gomb, cartridge |

---

## 10. fejezet – SID 6581 hangszintézis

### SID regiszter térkép ($D400)

| Offset | Regiszter | Leírás |
|--------|-----------|--------|
| $00–$01 | FREQ_LO/HI Voice 1 | Frekvencia (16 bit) |
| $02–$03 | PW_LO/HI Voice 1 | Pulzusszélesség |
| $04 | CR1 | Voice 1 Control Register |
| $05 | ATK/DCY1 | Attack/Decay Voice 1 |
| $06 | STN/RLS1 | Sustain/Release Voice 1 |
| $07–$0D | Voice 2 (hasonlóan) | |
| $0E–$13 | Voice 3 (hasonlóan) | |
| $15–$16 | Filter Cutoff | Szűrő vágófrekvencia |
| $17 | Filter Resonance/Route | Szűrő rezonancia |
| $18 | MOD/VOL | Master volume + filter mód |

### Control Register (CR) bitek (Voice 1: $D404)

```
Bit 7: NOISE waveform
Bit 6: PULSE waveform
Bit 5: SAWTOOTH waveform
Bit 4: TRIANGLE waveform
Bit 3: TEST bit
Bit 2: RING modulation
Bit 1: SYNC
Bit 0: GATE (1 = hang indítás, 0 = lecsengés)
```

### ADSR paraméterek

```asm
; Voice 1 inicializálás – triangle, 24ms attack/decay, sustain 11, 24ms release:
LDA #$10    ; Triangle waveform
STA CR1     ; $D404
LDA #$31    ; Attack nibble $3 (24ms), Decay nibble $1 (24ms)
STA ATK_DCY1  ; $D405
LDA #$B1    ; Sustain $B (11), Release nibble $1 (24ms)
STA STN_RLS1  ; $D406
```

ADSR időparaméterek (Bit értéktől az idő):

| Érték | Attack | Release/Decay |
|-------|--------|---------------|
| $0 | 2ms | 6ms |
| $3 | 24ms | 72ms |
| $9 | 250ms | 750ms |
| $F | 8s | 24s |

### Gate vezérlés (hang indítás)

```asm
; Hang indítás:
LDA CR1
ORA #$01    ; Gate bit beállítása
STA CR1

; Hang leállítás (lecsengés indítása):
LDA CR1
AND #$FE    ; Gate bit törlése
STA CR1
```

---

## 11. fejezet – VIC 6567 grafika

### Karakter mód

- Screen memory: $0400 (1000 bájt, 25×40 karakter)
- Color memory: $D800 (1000 bájt, 1 nibble/karakter szín)
- Character ROM: $D000 (de VIC bankolt, általában $1000-nél)
- Háttérszín: `$D021`
- Border szín: `$D020`

### Karakter memória beállítás ($D018)

```asm
; Karakter memória helye a 16K VIC bankban ($D018 bit 3:1):
LDA #$F1    ; Bitek 3:1 törlése
AND $D018
ORA #$04    ; $1000 = karakter memória kezdet
STA $D018
```

| Bitek 3:1 | Karaktermemória kezdet |
|-----------|------------------------|
| 000 | $0000 |
| 001 | $0800 |
| 010 | $1000 (ROM!) |
| 011 | $1800 |
| ... | ... |
| 111 | $3800 |

### Bit-mapped grafika (Hires mód)

- Méret: 320×200 pixel = 64000 bit = 8000 bájt
- Memória: $A000–$BFFF (tipikus elhelyezés)
- Pixel cím képlete:

```
BAH = $A0 + INT(y/8) + (XHI)
BAL = (XLO AND $F8) OR (y AND $07)
Bit pozíció = 7 - (x AND $07)
```

### Color memory feltöltése

```asm
SETCLR  LDA COLOR
        LDX #250
LOOP    DEX
        STA $D800,X
        STA $D8FA,X
        STA $D9F4,X
        STA $DAEE,X
        BNE LOOP
        RTS
```

---

## 12. fejezet – CIA 6526 I/O

### Portok

- **CIA #1**: $DC00 (Port A – billentyűzet sorok), $DC01 (Port B – billentyűzet oszlopok)
- **CIA #2**: $DD00 (Port A – VIC bank és soros), $DD01 (Port B – user port)
- DDR (Data Direction Register): $DC02/$DC03/$DD02/$DD03 (1=kimenet, 0=bemenet)

### Timer A/B

- Timer A: $DC04/$DC05 (latch: $DC06/$DC07-ben is)
- Timer B: $DC06/$DC07
- Control Register A: $DC0E
- Control Register B: $DC0F
- Interrupt Control Register: $DC0D

50000 ciklus = ~50ms késleltetés:

```asm
SEI             ; Megszakítások tiltása
LDA #$7F
STA $DC0D       ; Összes CIA interrupt letiltása
LDA #$7F        ; Latch LO: $C37F = 50000-1
STA $DC04
LDA #$C3        ; Latch HI
STA $DC05
LDA #$09        ; One-shot mód, belső óra
STA $DC0E       ; CRA: start Timer A

WAIT LDA #$01
     BIT $DC0D   ; Timer A underflow ellenőrzés
     BEQ WAIT
CLI
RTS
```

### TOD óra

A TOD (Time-of-Day) óra BCD formátumban:

| Regiszter | Cím | Tartalom |
|-----------|-----|---------|
| Tized mp. | $DC08 | BCD, 0–9 |
| Másodpercek | $DC09 | BCD, 0–59 |
| Percek | $DC0A | BCD, 0–59 |
| Órák | $DC0B | BCD, 1–12, bit 7 = PM |

Írás: PCH sorrendben (óra→perc→mp→tized), CRB bit 7 = 0
Alarm: CRB bit 7 = 1 esetén ugyanarra a regisztercímre írva

### Paddle/Analog bemenet

- Paddle X (Joystick port 1): $DC00 bit 2 + `$DC01`
- ADC értékek: 0–255, $DC05/$DD05-ből olvasva

---

## Függelékek

### App. C – 6510 Instruction Set Summary

A könyv tartalmaz egy teljes opkód táblázatot (Rockwell International engedélyével), amely felsorolja:
- Összes mnemonikot
- Összes addressing mode-hoz tartozó opkódot
- Ciklus számokat (`n`)
- Bájt számokat (`#`)
- P regiszter flag hatásokat (`N V . B D I Z C`)

### App. A – Számrendszerek

- Binary–Hex–Decimal konverziós táblázat
- Kettes komplement (negatív számok)
- $0000–$FFFF fontosabb értékek: $0400=1024 (screen), $C000=49152, $FFFF=65535

---

## Érdemes megjegyezni

- A könyv BASIC-ból indul és fokozatosan vezet be assembly fogalmakat
- Minden fejezet végén gyakorló feladatok és a CAI (Computer-Assisted Instruction) program
- A SID fejezet részletes ADSR táblázattal és dalkiátszó példaprogrammal
- A VIC fejezet lefedi a karakter módot és a bit-mapped (hires) módot is
- A CIA fejezet timer coupling-ot (Timer B számol Timer A underflow-t) is bemutat
- Kiváló referencia: Appendix C az összes 6510 utasítás opkódjával és flag hatásaival
