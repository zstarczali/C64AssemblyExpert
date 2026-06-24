# Machine Language for the Commodore 64, 128, and Other Commodore Computers

- Forrás: `Machine_Language_for_the_Commodore_Revised_and_Expanded_Edition.pdf` (396 oldal)
- Szerző: Jim Butterfield, Brady Books / Prentice Hall Press, 1986
- Téma: C64/C128 gépi kód programozás alapoktól haladóig, teljes 6502/6510 utasításkészlet, KERNAL rutinok, memóriatérképek, karakterkészletek, IА chip referencia
- Megbízhatóság: magas (Jim Butterfield a C64 gépi kód programozás egyik legismertebb szerzője)
- Érdemes nézni: 6502 utasításkészlet referencia, KERNAL rutinok meghívása, C64 és C128 architektúra különbségei, stack/interrupt kezelés

---

## Tartalom

| Fejezet | Tartalom |
|---------|----------|
| 1 | First Concepts – Binér/hex, regiszterek, monitor, első program |
| 2 | Controlling Output – CHROUT, szubrutinok, ciklusok |
| 3 | Flags, Logic, and Input – Flag regiszter, logikai műveletek, GETIN |
| 4 | Numbers, Arithmetic, and Subroutines – Számítások, JSR/RTS |
| 5 | Address Modes – Összes cím mód részletesen |
| 6 | Linking BASIC and Machine Language – BASIC/ML együttélés |
| 7 | Stack, USR, Interrupt, and Wedge – Stack, IRQ, NMI, BASIC wedge |
| 8 | Timing, Input/Output – Időzítés, I/O fájlok, utasításkészlet összefoglalás |
| App. A | 6502/6510/6509/7501/8500 Instruction Set (részletes) |
| App. B | Commodore gépek jellemzői (C64, C128, VIC-20 stb.) |
| App. C | Memory Maps |
| App. D | Character Sets |
| App. E | Exercises for Alternative Commodore Machines |
| App. F | Floating Point Representation |
| App. G | Uncrashing |
| App. H | Supermon Instructions |
| App. I | IA Chip Information (CIA, VIC, SID) |
| App. J | Disk User's Guide |

---

## Chapter 1: First Concepts

### A számítógép belső működése

**Busz rendszer:**
- **Address Bus** (16 vezék): A mikroprocesszor kiválasztja, melyik chip/memória területet érinti
- **Data Bus** (8 vezék): 8 bites adatátvitel, mindkét irányban
- **Control Bus**: timing, read/write vezérlés

**Memória típusok:**
- **RAM**: Írható/olvasható; programok és adatok
- **ROM**: Csak olvasható; KERNAL, BASIC, karakter ROM
- **IA Chips** (Interface Adaptor): Memória-mappelt I/O eszközök (CIA, VIC, SID, PIA, VIA)

### 650x chip família

| Chip | Gép |
|------|-----|
| 6502 | Commodore PET, VIC-20, Apple II |
| 6510 | Commodore 64 |
| 6509 | Commodore CBM B sorozat |
| 7501/8501 | Commodore PLUS/4 |
| 8502 | Commodore 128 |

### Belső regiszterek

| Regiszter | Méret | Leírás |
|-----------|-------|--------|
| PC | 16 bit | Program Counter – következő utasítás címe |
| A | 8 bit | Accumulator – aritmetika, I/O |
| X | 8 bit | Index Register X |
| Y | 8 bit | Index Register Y |
| SP | 8 bit | Stack Pointer ($01xx, $FF-től csökken) |
| SR | 8 bit | Status Register (N,V,-,B,D,I,Z,C flagek) |

### Utasítás végrehajtás menete
1. PC tartalmát az address buszra küldi
2. PC += 1
3. A visszakapott byte az opcode
4. Az opcode meghatározza a következő byte-ok számát (operandusok)
5. Művelет végrehajtása

### Hexadecimális rendszer

| Decimális | Hex | Bináris |
|-----------|-----|---------|
| 0–9 | 0–9 | 0000–1001 |
| 10 | A | 1010 |
| 11 | B | 1011 |
| 12 | C | 1100 |
| 13 | D | 1101 |
| 14 | E | 1110 |
| 15 | F | 1111 |

### Program elhelyezése memóriában
Jó hely teszt programokhoz: **Kazetta puffer** ($033C decimálisan 828) – 194 byte szabad

### Monitor parancsok (pl. Supermon, 64MON)

| Parancs | Leírás |
|---------|--------|
| `M addr1 addr2` | Memória dump megjelenítés |
| `A addr mnemó` | Assembly (beírás) |
| `D addr` | Disassembly (visszafordítás) |
| `G addr` | Go – végrehajtás indítás |
| `R` | Regiszterek megjelenítése |
| `X` | Visszatérés BASIC-be |

---

## Chapter 2: Controlling Output

### CHROUT ($FFD2) – karakter kiírás
```asm
LDA #65        ; 'A' kód
JSR $FFD2      ; KERNAL CHROUT
```

### Ciklusok (Loops)
```asm
        LDX #0
loop:   LDA message,X
        BEQ done       ; nulla byte = vége
        JSR $FFD2      ; kiírás
        INX
        BNE loop       ; nem nulla: folytatás
done:   RTS
```

### Szubruting keretrendszer
```asm
; Fő program hívja JSR-rel, RTS-sel tér vissza
myprint:
        LDA text
        JSR $FFD2
        RTS
```

---

## Chapter 3: Flags, Logic, and Input

### Status Register (SR) flag bitek

| Bit | Neve | Mikor 1 |
|-----|------|---------|
| 7 | N (Negative) | Az eredmény bit7=1 (negatív szám) |
| 6 | V (Overflow) | Előjeles aritmetika overflow |
| 5 | – | Mindig 1 |
| 4 | B (Break) | BRK utasítás okozta IRQ-t |
| 3 | D (Decimal) | BCD mód aktív (C64-en nincs hatása) |
| 2 | I (IRQ Disable) | SEI beállította |
| 1 | Z (Zero) | Az eredmény nulla |
| 0 | C (Carry) | Carry/borrow az aritmetikából |

### Logikai utasítások
```asm
AND     ; bit maszk – bitek törlése
ORA     ; bit set – bitek beállítása
EOR     ; XOR – bitek toggle
```

**Bit vizsgálat AND-dal:**
```asm
LDA $D011
AND #%00100000     ; BMM bit vizsgálata
BEQ not_bitmap     ; ha nulla: nem bitmap módban vagyunk
```

### GETIN ($FFE4) – billentyűzet karakter
```asm
poll:   JSR $FFE4    ; nem blokkoló
        CMP #0       ; nincs billentyű?
        BEQ poll     ; várakozás
        ; A = beütött karakter PETSCII kódja
```

---

## Chapter 4: Numbers, Arithmetic, and Subroutines

### 8 bites összeadás/kivonás
```asm
CLC          ; Carry törlése összeadás előtt!
LDA value1
ADC value2   ; A = A + value2 + C
; C flag = carry out

SEC          ; Borrow beállítása kivonás előtt!
LDA value1
SBC value2   ; A = A - value2 - (1-C)
```

### 16 bites összeadás
```asm
CLC
LDA lo1
ADC lo2
STA result_lo
LDA hi1
ADC hi2          ; carry automatikusan hozzáadódik
STA result_hi
```

### Összehasonlítás
```asm
CMP #10     ; A vs 10: C=1 ha A>=10, Z=1 ha A==10, N=1 ha A<10
BEQ equal   ; Z=1
BNE notequal ; Z=0
BCC less    ; C=0 (unsigned less)
BCS geq     ; C=1 (unsigned >=)
BLT less    ; alias: BCC
BGE geq     ; alias: BCS
BMI negative ; N=1
BPL positive ; N=0
```

### Szorzás (shift és összeadás)
```asm
; A * 2 = ASL A
; A * 4 = ASL A; ASL A
; Általános szorzás: ismételt összeadás vagy look-up táblák
```

### Szubrutinok
```asm
JSR subroutine   ; Push PC-1, jump
; ... kód ...
RTS              ; Pop return address, +1

; FONTOS: stack egyensúly! Minden JSR-hez egy RTS kell
```

---

## Chapter 5: Address Modes

Összes cím mód összefoglalva:

| Mód | Szintaxis | Byteszám | Leírás |
|-----|-----------|---------|--------|
| Implied | `INX` | 1 | Nincs operandus |
| Accumulator | `ASL A` | 1 | A regiszter |
| Immediate | `LDA #$05` | 2 | Érték közvetlenül |
| Zero Page | `LDA $05` | 2 | $0005 cím |
| Zero Page,X | `LDA $05,X` | 2 | $0005+X cím |
| Zero Page,Y | `LDX $05,Y` | 2 | $0005+Y cím |
| Absolute | `LDA $1000` | 3 | $1000 cím |
| Absolute,X | `LDA $1000,X` | 3 | $1000+X cím |
| Absolute,Y | `LDA $1000,Y` | 3 | $1000+Y cím |
| Relative | `BNE loop` | 2 | PC + signed offset (-128..+127) |
| Indirect | `JMP ($1000)` | 3 | Csak JMP; bug: $xxFF oldalbugbugbug |
| (zp,X) Indexed Indirect | `LDA ($10,X)` | 2 | Cím: tartalom($10+X..$11+X) |
| (zp),Y Indirect Indexed | `LDA ($10),Y` | 2 | Cím: tartalom($10..$11)+Y |

### Képernyő manipuláció példa (Indirect Indexed)
```asm
; $20-$21 = képernyőcím pointer (low/high)
; Y = offset a képernyőn
LDA #$00
STA $20
LDA #$04        ; $0400 -> screen start
STA $21
LDY #0
LDA #1          ; 'A' screen code
STA ($20),Y     ; screen[Y] = 'A'
```

---

## Chapter 6: Linking BASIC and Machine Language

### BASIC memória elrendezés

```
$0800 BASIC program start
  [BASIC tokenized program]
$MEMSIZ BASIC változók, tömbök, stringek
```

### ML program meghívása BASIC-ból
```basic
SYS 49152           : REM $C000-ra töltve
SYS PEEK(43)+256*PEEK(44)  : REM BASIC kezpet előtt
```

### BASIC változók elérése ML-ből
- Float változó lookup: BASIC interpreter rutin $B3A2
- A változó neve: első byte = első ASCII, második byte = második ASCII + $80 (ha nincs: $80)
- Lebegőpontos formátum: 1 byte exponent, 4 byte mantissa (MSB jelzett)

### Adatcsere BASIC ↔ ML
```basic
POKE addr, value    : SYS addr
```
vagy USR() vektoron keresztül ($0311–$0312 pointe → $000A–$000B vektor).

---

## Chapter 7: Stack, USR, Interrupt, and Wedge

### Stack (Verem)
- $0100–$01FF, SP = aktuális pozíció (lefelé nő)
- PHA/PLA: A push/pop
- PHP/PLP: SR push/pop
- JSR/RTS: 2 byte (PC-1) push/pop
- Interrupt: 3 byte (PC, SR) push automatikusan

### IRQ megszakítás kezelés
1. Jelenlegi PC és SR elmentődik a verembe
2. I flag beállítódik
3. $FFFE–$FFFF vektor betöltődik → PC
4. RTI visszaállítja (PC, SR)

**IRQ beállítás:**
```asm
SEI
LDA #<myirq
STA $0314       ; IRQ vector low byte
LDA #>myirq
STA $0315       ; IRQ vector high byte
CLI

myirq:
; ... saját kód ...
JMP $EA31       ; KERNAL IRQ folytatás (keyboard scan stb.)
```

**Raster IRQ:**
```asm
; VIC raszter IRQ engedélyezése egy meghatározott vonalra
LDA #$01
STA $D01A       ; ERST engedélyezés
LDA #100        ; rasztervonal
STA $D012
LDA $D011
AND #$7F        ; RST8 törlése (MSB)
STA $D011
```

### NMI (Non-Maskable Interrupt)
- RESTORE billentyű → $FFFA–$FFFB vektor ($0318–$0319 user NMI)
- Nem blokkolható SEI-vel

### BASIC Wedge (interpoze)
A BASIC interpreter fő végrehajtó ciklusát megelőző hook:
```asm
; $0308-$0309 BASIC continuation vector (GONE vektor)
; Saját wedge rutin elé állítva elkaphatók az utasítások
```

---

## Chapter 8: Timing, Input/Output

### CPU Timing (PAL C64)
- Órajel: ~985 kHz
- 1 gépi ciklus ≈ 1.015 μs
- Legtöbb utasítás 2–7 ciklus

| Utasítás típus | Tipikus ciklus |
|---------------|---------------|
| LDA immediate | 2 |
| LDA zero page | 3 |
| LDA absolute | 4 |
| LDA (zp),Y | 5 (+1 ha page cross) |
| JSR | 6 |
| RTS | 6 |
| BNE (nem ugrás) | 2 |
| BNE (ugrás, ugyanaz oldal) | 3 |
| BNE (ugrás, más oldal) | 4 |

### Késleltetési hurok
```asm
; 256 * 5 ciklus = ~1300 ciklus ≈ 1.3 ms
        LDX #$FF
delay:  DEX
        BNE delay
```

### I/O fájlok (KERNAL)
```asm
; Fájl megnyitás
LDA #2       ; logical file number
LDX #8       ; eszköz (disk=8)
LDY #2       ; secondary address
JSR $FFBA    ; SETLFS
LDA #4       ; fájlnév hossza
LDX #<name
LDY #>name
JSR $FFBD    ; SETNAM
JSR $FFC0    ; OPEN

; Karakter küldés a 2-es fájlra
LDA #2
JSR $FFC9    ; CHKOUT
LDA #65      ; 'A'
JSR $FFD2    ; CHROUT
JSR $FFCC    ; CLRCHN

; Fájl zárás
LDA #2
JSR $FFC3    ; CLOSE
```

---

## Appendix A: 6502/6510 Instruction Set

Az összes utasítás csoportosítva:

### Load/Store
```
LDA LDX LDY   – betöltés
STA STX STY   – tárolás
```

### Transfer
```
TAX TAY TSX TXA TXS TYA
```

### Increment/Decrement
```
INX INY INC   – növelés
DEX DEY DEC   – csökkentés
```

### Arithmetic
```
ADC SBC       – összeadás/kivonás (Carry-vel)
```

### Logical
```
AND ORA EOR   – logikai AND, OR, XOR
BIT           – bit teszt (N=bit7, V=bit6, Z=AND eredmény)
```

### Compare
```
CMP CPX CPY   – összehasonlítás (flag beállítás, nem módosít)
```

### Shift/Rotate
```
ASL LSR ROL ROR   – léptetés/forgatás
```

### Branch (feltételes ugrás, relative)
```
BCC BCS BEQ BNE BMI BPL BVC BVS
```

### Jump/Subroutine
```
JMP JSR RTS RTI BRK
```

### Flag műveletek
```
CLC SEC CLI SEI CLV
CLD SED         – BCD mód (C64-en nem hatásos)
```

### Stack
```
PHA PLA PHP PLP
```

### No operation
```
NOP
```

---

## Appendix B: Commodore Gépek Összehasonlítása

| Tulajdonság | VIC-20 | C64 | C128 (C64 mód) | C128 |
|------------|--------|-----|----------------|------|
| CPU | 6502 | 6510 | 8502 (C64 mód) | 8502 |
| RAM | 5K (exp.) | 64K | 64K | 128K |
| ROM BASIC | 8K | 8K | 8K | 32K |
| KERNAL | 8K | 8K | 8K | 16K |
| Video | VIC (6561) | VIC-II (6567/69) | VIC-II | VIC-IIe + 8563 |
| Hang | VIC (3 ch) | SID (3 ch) | SID | SID |
| I/O | 6522×2 | 6526×2 | 6526×2 | 6526×2 |

**C64 Zero page és Stack:** $0000–$00FF és $0100–$01FF (minden Commodore gépen azonos)

---

## Appendix C: Memory Maps (C64)

```
$0000–$00FF : Zero Page
$0100–$01FF : Stack
$0200–$03FF : OS és KERNAL munkaterület
$0400–$07FF : Screen/Sprite pointers
$0800–$9FFF : BASIC program + változók
$A000–$BFFF : BASIC ROM (vagy RAM LORAM=0-val)
$C000–$CFFF : Szabad RAM (általában ML programoknak)
$D000–$D7FF : VIC-II + SID regiszterek (CHAREN=1) / Char ROM (CHAREN=0)
$D800–$DBFF : Color RAM
$DC00–$DCFF : CIA #1
$DD00–$DDFF : CIA #2
$DE00–$DFFF : I/O kiterj. terület 1
$E000–$FFFF : KERNAL ROM (vagy RAM HIRAM=0-val)
```

---

## Appendix I: IA Chip Information

### CIA 6526 Timer módok
- Timer A: free-run vagy one-shot; forrás: CPU órajel, CNT pin, Timer B
- Timer B: similar + Timer A output
- TOD (Time of Day): BCD óra, perc, másodperc, tized (60 Hz vagy 50 Hz)

### VIC-II – lásd `vic-ii.notes.md`

### SID 6581 Regiszter összefoglaló
- 3 voice × 7 regiszter = 21 byte
- 4 filter regiszter
- 3 olvasható regiszter (paddle X, paddle Y, voice 3 osc/env)
- Master volume: $D418 alsó 4 bit (0–15)