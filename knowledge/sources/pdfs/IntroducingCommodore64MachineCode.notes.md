# Introducing Commodore 64 Machine Code

- Forrás: `IntroducingCommodore64MachineCode.pdf` (162 oldal)
- Szerző: Ian Sinclair
- Kiadó: Prentice-Hall / Spectrum Book, 1984
- Téma: C64 gépi kód bevezetés – BASIC-tól assembly-ig, kézi assembler, MIKRO assembler
- Megbízhatóság: magas (eredeti könyv, részletes magyarázatokkal és példaprogramokkal)
- Megjegyzés: Sok nulla a szövegben „0"-ként jelenik meg tilde karakterrel (~), de a tartalom olvasható; kifejezetten kezdőknek szánt, lépésről lépésre haladó bevezető

---

## Tartalom

| Fejezet | Cím | Tartalom |
|---------|-----|---------|
| 1 | ROM, RAM, Bytes and Bits | Memória fogalmak, bit/bájt, ROM/RAM különbség, ASCII |
| 2 | Digging Inside the C64 | BASIC memória szerkezet, VLT, zero page, kétbájtos számok |
| 3 | The Microprocessor | Hex számok, assembler fogalma, akkumulátor, cím módok |
| 4 | 6502 Details | Regiszterek (A, X, Y, PC, SP, Status), flag-ek, kettes komplement |
| 5 | Register Actions | Branch utasítások, relatív cím, displacement számítás |
| 6 | Taking a Bigger Byte | Folyamatábrák, ciklusok, (IND),Y indexelt cím |
| 7 | Ins and Outs and Roundabouts | Gépi kód mentése/betöltése, BASIC és machine code együtt |
| 8 | Debugging, Checking and MIKRO | Töréspontok, MIKRO assembler, assembly szintaxis, label-ek |
| 9 | The Last Round-up | Összefoglalás |
| App. A | Number Storage | Számábrázolás, float |
| App. B | Hex/Denary Conversion | Konverziós táblázatok |
| App. C | Instruction Set | 6502 utasítás lista |
| App. D | Addressing Methods | Cím módok összefoglalása |
| App. E | ROM/RAM Addresses | Fontosabb memória területek |

---

## 1. fejezet – ROM, RAM, Bytes and Bits

### Alapfogalmak

- **Bit**: egy memória egység – kétértékű (0 vagy 1), mint egy kapcsoló
- **Bájt**: 8 bit = egy memória rekesz; értéke 0–255 (denary) vagy $00–$FF (hex)
- **RAM** (Random Access Memory): írható/olvasható; kikapcsoláskor az adatok elvesznek
- **ROM** (Read Only Memory): csak olvasható; a C64-ben BASIC + KERNAL itt van tárolva

### ROM területek a C64-ben

- `$A000–$BFFF`: BASIC interpreter (BASIC kulcsszavak kódjai és rutinjai)
- `$E000–$FFFF`: KERNAL operációs rendszer

A ROM-ban a BASIC kulcsszavak szövegként vannak tárolva, utolsó karakterükön bit 7 beállítva (+128). Az operációs rendszer ezeken az adatokon keres kulcsszó azonosításhoz.

### ASCII kódok

A C64 az ASCII kódokat használja karakterek tárolásához. A ROM-ban tárolt szövegek utolsó karakterének ASCII kódjához 128 adódik (ez a lezárójel):

```
'E' = 69, 'N' = 78, 'D' + 128 = 196  → "END" szó tárolva
```

---

## 2. fejezet – A C64 belseje

### BASIC memória szerkezet

A BASIC program a $0801 (denary 2049) kezdetű területen van tárolva. A nulla végű struktúra:

```
[2 bájt: következő sor pointere] [2 bájt: sorszám] [byte-ok: tokenek] [00]
```

### Fontos zero page (Page 0) területek

| Cím (denary) | Cím (hex) | Tartalom |
|-------------|-----------|---------|
| 43–44 | $2B–$2C | BASIC kezdet pointer |
| 45–46 | $2D–$2E | BASIC vége / VLT kezdet pointer |
| 150–152 | $96–$98 | Szabad területek delay számlálókhoz |

### Kétbájtos számok tárolása

A C64 16 bites számokat **little-endian** formában tárol (alacsony bájt első):

```
Ha $0803-ban 3 és $0804-ben 8 van: a cím = 8*256 + 3 = 2051
```

BASIC példa a pointer olvasáshoz:
```basic
?PEEK(46)*256 + PEEK(45)   → BASIC végének (VLT) pointere
```

### VLT (Variable List Table)

A BASIC változók tárolási területe közvetlenül a program kódja után következik. Minden változóhoz:
- 2 bájt: változó neve (ASCII, második bájt +128 ha egybetűs)
- 5 bájt: érték (lebegőpontos számhoz) vagy pointer (stringhez)

---

## 3. fejezet – A mikroprocesszor

### Hexadecimális számok

A hex rendszer 16-os alapú; A–F betűk a 10–15 értékeket jelölik:

| Hex | Denary | Hex | Denary |
|-----|--------|-----|--------|
| 0–9 | 0–9   | A   | 10     |
| B   | 11    | C   | 12     |
| D   | 13    | E   | 14     |
| F   | 15    | 10  | 16     |
| FF  | 255   | 100 | 256    |

Miért hex? Egy bájt = 2 hex jegy; egy 16 bites cím = 4 hex jegy. A 6502 opkódok hex-ben konzisztens mintát mutatnak.

### Az assembler fogalma

Az assembly language mnemonikokat (pl. `LDA`, `STA`) a **assembler program** fordítja gépi kóddá. Ha nincs assembler:
- **Kézi assembly**: utasítások kézi kikeresése opkód táblázatból, hex kódok POKEolása
- **Monitor program**: belső segédprogram (pl. C64 MONITOR) hex szerkesztővel
- **MIKRO assembler**: a könyv által ajánlott önálló assembler program C64-re

### Akkumulátor

A legfontosabb regiszter – a legtöbb adat-műveleti utasítás ezen dolgozik:
- Memóriából betöltés (`LDA`), aritmetika, logika – mind az akkumulátorban
- Max. 8 bit = 0–255 értéktartomány

### Cím módok (alapok)

| Mód | Szintaxis | Leírás |
|-----|-----------|--------|
| Immediate | `LDA #$55` | Az operandus maga az érték |
| Absolute | `LDA $1000` | 16 bites cím |
| Zero Page | `LDA $50` | Page 0 gyors elérés (1 bájt cím) |
| Absolute,X | `LDA $7000,X` | Alap cím + X reg. |
| Absolute,Y | `LDA $7000,Y` | Alap cím + Y reg. |

Zero Page előnye: csak 2 bájtos utasítás (kevesebb memória, gyorsabb végrehajtás).

---

## 4. fejezet – 6502 részletek

### Regiszterek

| Regiszter | Méret | Leírás |
|-----------|-------|--------|
| A (Accumulator) | 8 bit | Fő adat regiszter |
| X | 8 bit | Index/számláló regiszter; INX, DEX |
| Y | 8 bit | Index/számláló regiszter; INY, DEY |
| PC (Program Counter) | 16 bit | Következő utasítás címe |
| SP (Stack Pointer) | 8 bit | Verem tetejére mutat ($01xx) |
| Status (Flags) | 8 bit | N V - B D I Z C |

### Status regiszter flag-ek

- **C (Carry)**: Összeadásnál átvitel ha MSB-ből kinő; kivonásnál borrow indikátor; shift műveleteknél kilépő bit
- **Z (Zero)**: 1 ha az eredmény pontosan 0 – egyenlőség tesztelésnél használatos
- **N (Negative)**: 1 ha az eredmény MSB-je 1 (előjeles számoknál negatív)
- **I (Interrupt Disable)**: 1 = IRQ letiltva
- **D (Decimal)**: BCD mód
- **V (Overflow)**: Előjeles összeadásnál túlcsordulás

### Kettes komplement (negatív számok)

Branch utasítások relatív offset-je negatív szám, ha `>$7F`:

```
Pozitív 53 ($35) → negatív forma:
  1. Bitek invertálása: $35 → $CA
  2. +1: $CA + 1 = $CB

Vagy denary módszer: 256 - 53 = 203 ($CB)
```

Gyors hex módszer: $FF - $35 = $CA, majd +1 = $CB

---

## 5. fejezet – Regiszter műveletek

### Branch utasítások (teljes lista)

| Utasítás | Jelentés | Flag feltétel |
|----------|----------|--------------|
| BEQ | Branch if Equal (zero) | Z=1 |
| BNE | Branch if Not Equal | Z=0 |
| BCC | Branch if Carry Clear | C=0 |
| BCS | Branch if Carry Set | C=1 |
| BMI | Branch if Minus | N=1 |
| BPL | Branch if Plus | N=0 |
| BVC | Branch if Overflow Clear | V=0 |
| BVS | Branch if Overflow Set | V=1 |
| JMP | Jump (unconditional) | – |

Minden branch utasítás **relatív cím módot** használ – egyetlen signed bájt követi az opkódot (displacement).

### Branch displacement számítás

```
Displacement = Célcím - Forrás cím - 2
```

Ha az eredmény negatív, kettes komplement formába kell alakítani.

Hatótávolság: −128 ... +127 bájt (a branch utasítás után)

Példa (flowchart-based assembly program):

```asm
LOOP:  LDA $0200      ; Billentyű olvasás rendszer területről
       BEQ LOOP       ; Ha nulla (nincs karakter), várakozás
       STA $05F4      ; Karakter tárolása
       RTS
```

---

## 6. fejezet – Nagyobb kihívások

### Folyamatábrák (Flowcharts)

A könyv hangsúlyozza a flowchart-ok fontosságát assembly programok tervezésekor. Alap elemek:
- **Téglalap**: folyamat/utasítás
- **Rombusz**: döntés (feltétel)
- **Ovális**: start/end
- **Nyíl**: vezérlés átadás

### INX/DEX, INY/DEY

```asm
LDX #$FF    ; X = 255 (legnagyobb 8 bites szám)
LOOP: DEX
      BNE LOOP   ; Ha X ≠ 0, folytassuk
```

Az X és Y regiszternek van `INX/DEX` és `INY/DEY` utasítása – az akkumulátornak **nincs** közvetlen increment/decrement parancsa.

### Ciklusok zero page-gel (nagy számoláshoz)

```asm
; 3 byte-os countdown = 16,777,215 iteráció:
LDA #$FF
STA $96    ; Counter byte 0
STA $97    ; Counter byte 1
STA $98    ; Counter byte 2

; Belső ciklus rövidítve:
LOOP3 LDA $96   ; Az akkumulátor $FF marad, ezért nincs LDA #$FF ismét
      DEC $96
      BNE LOOP3
      DEC $97
      BNE LOOP3
      DEC $98
      BNE LOOP3
      RTS
```

### Képernyő töltése (IND),Y példával

```asm
; 1000 karakter screen memory feltöltése $7C (|) karakterrel
LDA #$7C       ; Karakter
LDX #$00
STX $96        ; Pointer low bájt
LDX #$04
STX $97        ; Pointer high bájt ($0400 = screen start)
LDY #$00
LOOP: STA ($96),Y   ; Tárolás (pointer)+Y
      INY
      BNE LOOP
      INC $97       ; Pointer high bájt növelése (következő lap)
      LDX $97
      CPX #$08      ; $0800 = screen vége (25×40=1000 bájt)
      BNE LOOP
      RTS
```

---

## 7. fejezet – Be- és kimenet

### Gépi kód program mentése BASIC-ból

A machine code nem menthető egyszerű `SAVE`-vel – a BASIC rendszer nem tud róla. Megoldás: a BASIC zero page pointer-eit módosítjuk:

```basic
10 POKE 56,159         : REM memória lefoglalás $9F00-tól
20 A = 40704           : REM machine code kezdet (denary)
30 FOR N=1 TO 100 : POKE A+N, N : NEXT   : REM adatok feltöltése
40 POKE 43,255 : POKE 44,158    : REM BASIC start pointer = program -2
50 POKE 45,101 : POKE 46,159    : REM BASIC end pointer = program vége
60 SAVE "MC"                    : REM mentés
70 POKE 43,1 : POKE 44,8        : REM pointer visszaállítás
80 POKE 45,3 : POKE 46,8
```

Az eltolás (-2 a valódi kezdettől) azért kell, mert a BASIC rutinja az első 2 bájtot a következő sor pointerének tekinti.

### SYS hívás

```basic
SYS 40705    : REM Machine code futtatása $9F01 (=40705 denary) től
```

A machine code `RTS` utasítással tér vissza a BASIC-be.

---

## 8. fejezet – Hibakeresés és MIKRO assembler

### Töréspont technika ($60 = RTS)

```
Stratégia: A program egy kritikus pontján a következő utasítás bájtját
           $60 (RTS) értékre cseréljük → a program ott "megáll" és
           visszatér a BASIC-be. PEEK-kel ellenőrizzük az eredményt.
```

Ha a memória tartalma helyes, a $60-at visszacseréljük az eredeti kódra, és a $60-at az következő ellenőrzési pontra tesszük.

**Figyelem**: Végtelen ciklus RESTORE+STOP sem mindig szakítja meg, ha a kód megváltoztatja az `$0328` (STOP key disable at 808 denary) értékét.

### MIKRO assembler

A könyv a **MIKRO assembler** programot ajánlja C64-re:

- Kulcsszavakat (label nevek) automatikusan számokra cseréli
- Hexadecimális kódokat és data számokat automatikusan generál
- Szintaxis: `LABEL  MNEMONIC  OPERAND  ; megjegyzés`

Példa MIKRO szintaxisban:
```asm
SCRNST EQU $0400       ; Képernyő kezdet
CARRET EQU $0D         ; Kocsi vissza (CR karakter)

START  LDA #CARRET     ; CR betöltése
       STA SCRNST      ; Képernyő első pozíció
       RTS
```

A label-ek (SCRNST, CARRET) ahol előfordulnak, a megfelelő értékekkel kerülnek behelyettesítésre.

### Debuggolási elvek

1. **Szegmentálás**: A programot kis egységekre bontva tesztelni
2. **Breakpoint**: $60 (RTS) ideiglenes behelyezés
3. **Monitor**: Belső hexadecimális szerkesztő memória vizsgálathoz
4. **Flowchart**: Logikai hibák megtalálásához írjuk fel a programot grafikusan
5. **Tipikus hiba**: Branch visszaugrás rossz helyre → végtelen ciklus

---

## Függelékek

### App. C – Utasítás lista (részlet)

A könyv tartalmaz egy 6502 utasítás listát a fontosabb utasításokhoz, addressing mode-okkal és opkódokkal.

### App. D – Cím módok összefoglalása

| Mód | Szintaxis | Bájt-szám | Leírás |
|-----|-----------|-----------|--------|
| Immediate | `LDA #$55` | 2 | Közvetlen érték |
| Zero Page | `LDA $50` | 2 | Page 0, gyorsabb |
| Absolute | `LDA $1000` | 3 | Teljes 16 bit cím |
| Abs,X | `LDA $1000,X` | 3 | +X regiszter |
| Abs,Y | `LDA $1000,Y` | 3 | +Y regiszter |
| (Ind),Y | `LDA ($50),Y` | 2 | Pointer page 0-ban, +Y |
| (Ind,X) | `LDA ($50,X)` | 2 | Pointer offset X-szel |
| Relative | `BEQ label` | 2 | Branch offset (signed) |
| Implied | `RTS` | 1 | Nincs operandus |
| Accumulator | `ASL A` | 1 | Akkumulátoron |

### App. E – Fontosabb memória területek

| Cím (denary) | Leírás |
|-------------|--------|
| 43–44 | BASIC start pointer |
| 45–46 | BASIC end / VLT start pointer |
| 808 ($0328) | STOP key check (poke 0 = letiltja a STOP-ot) |
| 2049 ($0801) | BASIC program kezdet |
| 40704 ($9F00) | Szabad terület machine code-nak |
| 49152 ($C000) | Alternatív machine code terület |

---

## Összefoglalás – A könyv fő jellemzői

- **Célközönség**: Teljes kezdő, BASIC ismerettel rendelkező felhasználó
- **Módszer**: Minden fogalmat analógiákkal vezet be (pl. memória = kapcsoló)
- **Kézi assembly**: A könyv elsősorban kézi opkód keresésre és POKE-olásra épít, majd fokozatosan vezet a MIKRO assembler felé
- **Hangsúlyos témák**: Zero page (rendszer területek elkerülése), branch offset számítás, kettes komplement, BASIC-machine code integráció
- **Hiányosságok**: Nem foglalkozik IRQ rutinokkal, SID-del, VIC-cel mélységében – ezekhez más forrásra van szükség
- **Értékes részek**: App. B hex/denary konverzió, App. C utasítás lista, debugging fejezet a töréspontos technikával
