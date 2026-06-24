# C64 Programmer's Reference Guide – Chapter 5: BASIC to Machine Language

- Forrás: `c64-programmers_reference_guide-05-basic_to_machine_language.pdf` (126 oldal)
- Téma: Gépi kód alapjai C64-en, 6510 regiszterek, memóriakiosztás, utasítások, cím módok
- Megbízhatóság: magas (Commodore hivatalos kézikönyv)
- Érdemes nézni: első gépi kód programok, cím módok magyarázata, verem, indexelt cím módok

---

## Tartalom

| Fejezet | Tartalom |
|---------|----------|
| What Is Machine Language? | ML alapfogalmak, BASIC vs ML |
| Simple Memory Map | C64 memóriakiosztás összefoglalás |
| 6510 Registers | Belső regiszterek: A, X, Y, SP, SR, PC |
| Writing ML Programs | Assembler vs POKE |
| Hexadecimal Notation | Hex rendszer, számrendszerek |
| First ML Instruction | LDA – azonnali mód |
| Addressing Modes | Zero page, absolute, immediate, indexed, indirect |
| The Stack | Veremkezelés, JSR/RTS |
| IRQ és NMI | Megszakítás rendszer |

---

## Mi az Assembly/Gépi kód?

A 6510 mikroprocesszor (C64 agya) csak gépi kódot ért meg. Minden más nyelv (BASIC is) gépi kódra fordít.

**Számrendszerek:**

| Alap | Jelölés | Példa |
|------|---------|-------|
| 10 (decimális) | szám | 255 |
| 16 (hexadecimális) | $ prefix | $FF |
| 2 (bináris) | % prefix | %11111111 |

Hex ↔ Decimal: 2 hex jegy = 1 byte (0–255), 4 hex jegy = 1 word (0–65535)

---

## Egyszerű C64 memóriakiosztás

| Cím | Leírás |
|-----|--------|
| $0000–$0001 | 6510 regiszterek (DDR és I/O port) |
| $0002–$00FF | Zero page (OS és BASIC változók) |
| $0100–$01FF | Stack (verem) |
| $0200–$03FF | OS munkaterület, billentyűzet puffer |
| $0400–$07E7 | Képernyőmemória (default) |
| $07F8–$07FF | Sprite pointerek (default) |
| $0800–$9FFF | BASIC program és felhasználói terület |
| $A000–$BFFF | 8K BASIC ROM (LORAM=1) |
| $C000–$CFFF | RAM (szabad gépi kód terület) |
| $D000–$D02E | VIC-II regiszterek (I/O) |
| $D400–$D7FF | SID regiszterek |
| $D800–$DBFF | Color RAM |
| $DC00–$DCFF | CIA #1 (billentyűzet, timer) |
| $DD00–$DDFF | CIA #2 (RS-232, VIC bank) |
| $E000–$FFFF | 8K KERNAL ROM (HIRAM=1) |

---

## A 6510 belső regiszterei

### Az Akkumulátor (A)
- A legfontosabb regiszter
- Matematikai műveletek itt történnek (ADD, SUB)
- LDA/STA: betöltés/tárolás memóriából/ba

### X Index Regiszter
- Indexelt cím módban cím offset
- LDX/STX: betöltés/tárolás
- INX/DEX: növelés/csökkentés
- CPX: összehasonlítás

### Y Index Regiszter
- Hasonló X-hez, de más utasítások
- LDY/STY: betöltés/tárolás
- INY/DEY: növelés/csökkentés
- CPY: összehasonlítás

### Status Register (P – Processor Status)
8 jelző bit:

| Bit | Jel | Leírás |
|-----|-----|--------|
| 7 | N | Negative – az eredmény negatív |
| 6 | V | Overflow – előjeles overflow |
| 5 | - | Mindig 1 |
| 4 | B | Break – BRK utasítás okozta megszakítást |
| 3 | D | Decimal – BCD mód (C64-en nem aktív) |
| 2 | I | Interrupt Disable – IRQ letiltás |
| 1 | Z | Zero – az eredmény nulla |
| 0 | C | Carry – átvitel bit |

### Program Counter (PC)
- 16 bites regiszter
- A következő végrehajtandó utasítás címe
- Minden utasítás végrehajtás után automatikusan növekszik

### Stack Pointer (SP)
- A verem tetejét mutatja ($0100–$01FF tartomány)
- Alapértelmezett érték: $FF (verem teli $01FF-nél)
- PHA: push A a veremre; PLA: pop A a veremből

### Input/Output Port
- $0000: Data Direction Register (DDR)
- $0001: I/O Port (LORAM, HIRAM, CHAREN, kazetta vezérlés)

---

## Hogyan írjunk gépi kód programot?

**Assembler szoftverek (C64-hez):**
- 64MON (Commodore cartridge)
- PAL 64
- Kick Assembler (modern cross-assembler)

**Monitor parancsok (64MON-ban):**
```
.A addr mnemo   – assembly
.M addr1 addr2  – memória megjelenítés
.G addr         – Go (végrehajtás)
.R              – regiszterek megjelenítés
X               – visszatérés BASIC-be
```

---

## Az első ML utasítás: LDA

`LDA` = Load Accumulator (akkumulátor betöltése)

**Azonnali mód (Immediate):**
```asm
LDA #$05    ; A = $05 (az érték maga, NEM cím)
```
Opcode: `$A9`; memóriában: `A9 05`

**Abszolút mód (Absolute):**
```asm
LDA $102E   ; A = tartalom($102E)
```
Opcode: `$AD`; memóriában: `AD 2E 10` (low byte először!)

**STA utasítás:**
```asm
STA $0400   ; tartalom($0400) = A
```
Opcode: `$8D`; memóriában: `8D 00 04`

**Első program – A betű a képernyőre:**
```asm
LDA #$01    ; screen code 1 = 'A'
STA $0400   ; screen memory position 0
LDA #14     ; light blue color
STA $D800   ; color RAM position 0
BRK         ; return to monitor
```

---

## Cím módok (Addressing Modes)

### Implied (nincs operandus)
```asm
NOP    ; semmi sem történik
CLC    ; Carry bit törlése
SEC    ; Carry bit beállítása
```

### Accumulator
```asm
ASL A  ; balra léptetés az akkumulátorban
LSR A  ; jobbra léptetés
ROL A  ; balra forgatás
ROR A  ; jobbra forgatás
```

### Immediate (#érték)
```asm
LDA #$30    ; A = $30 (48 decimálisan)
LDX #0      ; X = 0
```

### Zero Page ($zp)
```asm
LDA $42     ; A = tartalom($0042), 1 byte cím
STA $42     ; tartalom($0042) = A
```
Gyorsabb és kisebb kódot ad, mint abszolút; az első 256 byte-ra vonatkozik.

### Zero Page,X ($zp,X)
```asm
LDA $20,X   ; A = tartalom($0020 + X)
```
Ha X=5: olvassa $0025-t; page cross nem lehetséges (zero page-en marad)

### Zero Page,Y ($zp,Y)
```asm
LDX $30,Y   ; X = tartalom($0030 + Y)
```

### Absolute ($addr)
```asm
LDA $1000   ; A = tartalom($1000)
JMP $C000   ; PC = $C000
```

### Absolute,X ($addr,X)
```asm
LDA $1000,X ; A = tartalom($1000 + X)
```
Ha page cross (X-et hozzáadva más lapra kerülünk): +1 ciklus

### Absolute,Y ($addr,Y)
```asm
LDA $D800,Y ; A = tartalom($D800 + Y)
STA $0400,Y ; képernyő kitöltés Y-indexszel
```

### Relative (csak branch utasítások)
```asm
BNE label   ; ha Z=0: PC = PC + signed_offset
BEQ loop    ; ha Z=1: ugrás loop-ra
```
Offset: -128 és +127 közötti signed byte

### Indirect Indexed – (zp),Y
```asm
LDA ($20),Y ; temp = tartalom($0020..21); A = tartalom(temp + Y)
```
Pointer a zero page-en, majd Y hozzáadása az effektív cím kiszámításához.

Példa: $20/$21 = $0400 (little endian), Y=5 → olvassa $0405-t

### Indexed Indirect – (zp,X)
```asm
LDA ($10,X) ; temp = tartalom($0010+X .. $0011+X); A = tartalom(temp)
```
Ritkábban használt. X hozzáadása a zero page base-hez, majd indirect lookup.

### Indirect (csak JMP)
```asm
JMP ($FFFC) ; PC = tartalom($FFFC..FFFD)
```
**FIGYELEM:** 6502/6510 bug – ha az alacsony byte $xxFF-nél van, a magas byte $xx00-ból jön!

---

## A Stack (Verem)

- $0100–$01FF tartomány
- LIFO (Last In, First Out)
- SP = Stack Pointer (8 bites, $00–$FF relatív)
- `PHA` – A push a veremre; SP--
- `PLA` – pop a veremből → A; SP++
- `PHP` – Status Register push
- `PLP` – Status Register pop
- `JSR addr` – szubrutinhívás: visszatérési cím − 1 push, majd ugrás
- `RTS` – visszatérés: pop cím, +1, PC = cím

### JSR/RTS példa:
```asm
        JSR $FFD2   ; KERNAL CHROUT hívás
        ...
        RTS         ; visszatérés a hívóhoz
```

---

## Megszakítások (Interrupts)

### IRQ (Maskable Interrupt)
- CIA timer, VIC-II raster stb. váltja ki
- Vektor: $FFFE–$FFFF (KERNAL setup-ban $0314–$0315 a user IRQ vector)
- Blokkolható SEI-vel (Set Interrupt Disable); feloldás CLI-vel

### NMI (Non-Maskable Interrupt)
- Nem blokkolható
- Vektor: $FFFA–$FFFB ($0318–$0319 a user NMI vector)
- RESTORE billentyű váltja ki

### BRK (Software Interrupt)
- Szoftveres megszakítás
- Vektor: $FFFE–$FFFF (azonos az IRQ vektorával; B flag különbözteti meg)
- Monitor-belépési pontként használják

### Raszter IRQ Minta (64MON/assembly):
```asm
SEI             ; megszakítások tiltása a setup alatt
LDA #<irq      ; IRQ vektor alacsony byte
STA $0314
LDA #>irq      ; IRQ vektor magas byte
STA $0315
LDA #$01        ; Raster IRQ engedélyezése ($D01A)
STA $D01A
LDA #$7F
STA $DC0D       ; CIA1 timer IRQ letiltása
LDA #100        ; Rasztervonal: 100
STA $D012
LDA #$1B        ; DEN=1, RSEL=1, YSCROLL=3
STA $D011
CLI             ; megszakítások engedélyezése
JMP *           ; végtelen hurok

irq:
ASL $D019       ; IRQ nyugtázás
; ... effekt kód ...
JMP $EA81       ; KERNAL IRQ befejező rutin
```

---

## KERNAL Rutinok (fontos szubrutinok)

| Cím | Neve | Leírás |
|-----|------|--------|
| $FFD2 | CHROUT | Karakter kiírás a képernyőre/fájlba |
| $FFCF | CHRIN | Karakter beolvasás |
| $FFE4 | GETIN | Karakter a billentyűzetpufferből |
| $FFB7 | READST | Státusz olvasás |
| $FFBA | SETLFS | Logical File Set |
| $FFBD | SETNAM | Fájlnév beállítás |
| $FFC0 | OPEN | Fájl megnyitás |
| $FFC3 | CLOSE | Fájl bezárás |
| $FFC6 | CHKIN | Bemeneti csatorna |
| $FFC9 | CHKOUT | Kimeneti csatorna |
| $FFCC | CLRCHN | Csatornák törlése |
| $FFD5 | LOAD | Betöltés |
| $FFD8 | SAVE | Mentés |
| $FF81 | CINT | Képernyő inicializálás |
| $FF84 | IOINIT | I/O inicializálás |
| $FF87 | RAMTAS | RAM teszt |

**CHROUT példa:**
```asm
LDA #65         ; 'A' ASCII kód
JSR $FFD2       ; kiírás képernyőre
```

---

## Számítási tippek

**16 bites összeadás (A+X szimulálva carry-vel):**
```asm
CLC
LDA low_byte
ADC #$10
STA low_byte
LDA high_byte
ADC #$00        ; carry hozzáadása
STA high_byte
```

**Byte kiválasztás:**
```asm
LDA #<$1234     ; alacsony byte: $34
LDA #>$1234     ; magas byte: $12
```

**Bitmanipuláció:**
```asm
LDA $D011
ORA #%00100000  ; BMM bit beállítás (OR)
STA $D011

LDA $D011
AND #%11011111  ; BMM bit törlés (AND + NOT)
STA $D011

LDA $D011
EOR #%00100000  ; BMM bit toggle (XOR)
STA $D011
```