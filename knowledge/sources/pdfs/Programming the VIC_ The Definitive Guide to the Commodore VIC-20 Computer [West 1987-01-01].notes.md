# Programming the VIC – The Definitive Guide to the Commodore VIC-20

- Forrás: `Programming the VIC_ The Definitive Guide to the Commodore VIC-20 Computer [West 1987-01-01].pdf` (612 oldal)
- Szerző: Raeto Collin West, COMPUTE! Publications, 1984 (copyright Level Limited)
- Téma: VIC-20 teljes programozási útmutató – BASIC, assembly/gépi kód, grafika, hang, lemez/szalag, I/O; tartalmaz VIC-20 ROM útmutató és 6502 opcode referencia is
- Megbízhatóság: magas (az egyik legteljesebb VIC-20 programozási referencia; a 6502 utasításkészlet és KERNAL rutinok C64-re is alkalmazhatók)
- Érdemes nézni: 6502 gépi kód fejezetek (C64-re is érvényes); VIC chip regiszterek; KERNAL rutinok; grafika és hang programozás elmélete

---

## Tartalom

| Fejezet | Tartalom |
|---------|----------|
| 1 | Introduction – A könyv használata, konvenciók |
| 2 | Getting to Know Your VIC-20 – Hardver áttekintés |
| 3 | BASIC Reference Guide – Összes VIC BASIC parancs |
| 4 | Effective Programming in BASIC – Haladó BASIC |
| 5 | VIC-20 Architecture – Belső felépítés |
| 6 | Beyond VIC-BASIC – BASIC határai, programozási technikák |
| 7 | 6502 Machine Language – 6502 ML alapok |
| 8 | ML Methods Specific to the VIC-20 – VIC-specifikus ML |
| 9 | Mixing BASIC with Machine Language – BASIC + ML integráció |
| 10 | Vocabulary of the 6502 Chip – 6502 utasításkészlet |
| 11 | VIC-20 ROM Guide – KERNAL rutinok, ROM belépési pontok |
| 12 | Graphics – VIC chip grafika programozás |
| 13 | Sound – Hang programozás |
| 14 | Tape – Szalag kezelés |
| 15 | Using the Commodore Disk Drive – Lemez programozás |
| 16 | The Games Port – Joystick, light pen, paddle |
| 17 | Major Peripherals – Nyomtató, modem stb. |
| App. A–B | Programok beírási útmutató |
| App. C | Automatic Proofreader (Charles Brannon) |
| App. D–E | Screen és Color Memory táblázatok |
| App. F–H | Screen Color Codes, Screen/Border Colors |
| App. I–J | ASCII és Screen Kódok |
| App. K | VIC Chip Registers |
| App. L | Device Numbers |
| App. M | Decimal-Hexadecimal Conversion Table |
| App. N | Opcodes in Detail |
| App. O | Table of 6502 Opcodes |
| App. P | 6502 Quasi-Opcodes (illegális opcode-ok) |
| App. Q | Interconverting VIC-20, C64, CBM Programs |

---

## Chapter 1: Introduction

### Konvenciók
- `#` a # jel = érték (nem cím): pl. `LDA #$00` = A töltése 0-val
- `LDA $00` = A töltése a 0-s memórycím tartalmával
- Hex szám: $ prefix; $40960 = $A000
- ML = Machine Language (gépi kód)
- Kernal = Commodore spelling (nem "Kernel")

### VIC-20 vs Commodore 64
Bár ez a könyv VIC-20-ra szól, a 6502 gépi kód fejezetek (7–10) és az architektúra elvek általánosan alkalmazhatók. A C64 6510-es processzora 100%-ban kompatibilis a 6502-es utasításkészletével.

---

## Chapter 2: Getting to Know Your VIC-20

### A VIC-20 fizikai leírása
- **Bővítőport**: Cartridge vagy memória bővítő
- **Video/audio port**: Monitor vagy TV csatlakozó
- **CBM soros port**: Lemezegységek és nyomtatók
- **Kazettaport**: Datassette
- **User port**: RS-232, I/O kísérletekhez
- **Kontrolport**: Joystick, fényceruza, paddle

### VIC BASIC jellemzők
- Közvetlen módban azonnali végrehajtás
- Program módban sorszámozott sorok (1–63999)
- Quote mód: speciális karakterek rögzítése stringben

---

## Chapter 5: VIC-20 Architecture

### Memóriakiosztás (VIC-20 alapkonfiguráció)

```
$0000–$00FF : Zero Page
$0100–$01FF : Stack
$0200–$03FF : OS munkaterület
$0400–$05FF : Default Screen Memory (22×23)
$1000–$1FFF : BASIC program (5K alap memória)
$8000–$9FFF : VIC-20 karaktergenerátor ROM
$C000–$DFFF : KERNAL ROM
$E000–$FFFF : BASIC ROM
```

**VIC-20 chip (6561-es) regiszterek:** $9000–$900F

| Cím | Leírás |
|-----|--------|
| $9000 | Screen origin X (interlace + X) |
| $9001 | Screen origin Y |
| $9002 | Columns + video memory address |
| $9003 | Rows + character size |
| $9004 | Raster |
| $9005 | VIC memory base |
| $9006 | Light pen X |
| $9007 | Light pen Y |
| $9008 | Paddle X |
| $9009 | Paddle Y |
| $900A–$900E | Sound channels (3) + volume |
| $900F | Auxiliary color + screen color |

**Megjegyzés C64-re:** A VIC-20 VIC-I chipje (6561) és a C64 VIC-II (6567/6569) különböző, de az elvek hasonlóak.

---

## Chapter 7: 6502 Machine Language

### A 6502 architektúra

**Regiszterek (azonos a 6510-essel):**

| Regiszter | Méret | Leírás |
|-----------|-------|--------|
| A | 8 bit | Accumulator |
| X | 8 bit | Index X |
| Y | 8 bit | Index Y |
| SP | 8 bit | Stack Pointer ($01xx) |
| SR (P) | 8 bit | Status/Flags |
| PC | 16 bit | Program Counter |

**Status Register bitjei:**
N (Negative), V (Overflow), – (=1), B (Break), D (Decimal), I (IRQ disable), Z (Zero), C (Carry)

### Alapvető utasítások

```asm
; Memória betöltés/tárolás
LDA $1000    ; Load A from $1000
STA $1001    ; Store A to $1001
LDX #10      ; X = 10 (immediate)
STX $FB      ; Store X to zero page $FB
LDY $FB,X   ; Y = mem[$FB+X]
STY ($FB),Y  ; mem[mem[$FB]+Y] = Y

; Aritmetika
CLC
ADC #5       ; A = A + 5 + 0
SEC
SBC #3       ; A = A - 3 - 0

; Branch (feltételes ugrás)
BEQ target   ; if Z=1 then PC=target
BNE loop     ; if Z=0 then PC=loop
BCC skip     ; if C=0
BCS cont     ; if C=1
BPL positive ; if N=0
BMI negative ; if N=1

; Szubruting hívás/visszatérés
JSR subroutine
RTS

; Verem
PHA          ; Stack ← A
PLA          ; A ← Stack
```

### Cím módok (6502)

| Mód | Szintaxis | Byte | Ciklus |
|-----|-----------|------|--------|
| Implicit | `NOP` | 1 | 2 |
| Accumulator | `ASL A` | 1 | 2 |
| Immediate | `LDA #n` | 2 | 2 |
| Zero Page | `LDA $nn` | 2 | 3 |
| Zero Page,X | `LDA $nn,X` | 2 | 4 |
| Zero Page,Y | `LDX $nn,Y` | 2 | 4 |
| Absolute | `LDA $nnnn` | 3 | 4 |
| Absolute,X | `LDA $nnnn,X` | 3 | 4+pc |
| Absolute,Y | `LDA $nnnn,Y` | 3 | 4+pc |
| Relative | `BNE $rr` | 2 | 2+b+pc |
| Indirect | `JMP ($nnnn)` | 3 | 5 |
| (zp,X) | `LDA ($nn,X)` | 2 | 6 |
| (zp),Y | `LDA ($nn),Y` | 2 | 5+pc |

`pc` = +1 ha page cross, `b` = +1 ha branch taken

---

## Chapter 8: ML Methods Specific to VIC-20

### VIC-20 KERNAL belépési pontok
(Hasonlóak a C64 KERNAL-jához, de különböző ROM helyek)

| Cím | Rutin | Leírás |
|-----|-------|--------|
| $FFD2 | CHROUT | Karakter kiírás |
| $FFE4 | GETIN | Billentyű (nem várakozó) |
| $FFCF | CHRIN | Karakter beolvasás |
| $FFB7 | READST | Státusz |
| $FFBA | SETLFS | Logical file |
| $FFBD | SETNAM | Fájlnév |
| $FFC0 | OPEN | Megnyitás |
| $FFC3 | CLOSE | Bezárás |
| $FFC6 | CHKIN | Input csatorna |
| $FFC9 | CHKOUT | Output csatorna |
| $FFCC | CLRCHN | Csatornák reset |
| $FFD5 | LOAD | Betöltés |
| $FFD8 | SAVE | Mentés |
| $FFE1 | STOP | STOP vizsgálat |

---

## Chapter 9: Mixing BASIC with Machine Language

### ML program elhelyezési lehetőségek

**VIC-20 alapmemória felső részén:**
```basic
POKE 44, NEW_TOP/256
POKE 43, NEW_TOP AND 255
CLR
```

**Kassetta puffer** ($033C–$03FB, 194 byte, C64-en és VIC-20-on is):
```asm
; Program elhelyezése a kazetta pufferbe
; $033C = 828 decimálisan
```

### BASIC és ML kommunikáció

**Paraméter átadás BASIC → ML:**
```basic
POKE addr, value1    : SYS start_addr
```

**Visszatérési érték ML → BASIC:**
```basic
X = PEEK(result_addr)
```

**USR() függvény:**
- $0311-$0312: USR rutin vektora
- Paraméter: lebegőpontos FAC-ban
- Visszatérés: FAC-ban lévő értékkel

---

## Chapter 10: Vocabulary of the 6502 Chip

### Teljes utasításkészlet

**Load/Store:**

| Utasítás | Leírás | Flag-ek |
|----------|--------|---------|
| LDA | Load A | N,Z |
| LDX | Load X | N,Z |
| LDY | Load Y | N,Z |
| STA | Store A | – |
| STX | Store X | – |
| STY | Store Y | – |

**Aritmetika:**

| Utasítás | Leírás | Flag-ek |
|----------|--------|---------|
| ADC | Add with Carry | N,V,Z,C |
| SBC | Subtract with Borrow | N,V,Z,C |
| INC | Increment mem | N,Z |
| INX | Increment X | N,Z |
| INY | Increment Y | N,Z |
| DEC | Decrement mem | N,Z |
| DEX | Decrement X | N,Z |
| DEY | Decrement Y | N,Z |

**Logika:**

| Utasítás | Leírás | Flag-ek |
|----------|--------|---------|
| AND | Logical AND | N,Z |
| ORA | Logical OR | N,Z |
| EOR | Exclusive OR | N,Z |
| BIT | Bit test | N,V,Z |

**Léptetők:**

| Utasítás | Leírás | Flag-ek |
|----------|--------|---------|
| ASL | Arithmetic Shift Left | N,Z,C |
| LSR | Logical Shift Right | N,Z,C |
| ROL | Rotate Left | N,Z,C |
| ROR | Rotate Right | N,Z,C |

**Összehasonlítás:**

| Utasítás | Leírás | Flag-ek |
|----------|--------|---------|
| CMP | Compare A | N,Z,C |
| CPX | Compare X | N,Z,C |
| CPY | Compare Y | N,Z,C |

**Ugrás/Szubrutin:**

| Utasítás | Leírás |
|----------|--------|
| JMP | Unconditional jump |
| JSR | Jump to subroutine |
| RTS | Return from subroutine |
| RTI | Return from interrupt |
| BRK | Break (software IRQ) |

**Feltételes ugrások:**

| Utasítás | Feltétel |
|----------|---------|
| BCC | Carry Clear (C=0) |
| BCS | Carry Set (C=1) |
| BEQ | Equal/Zero (Z=1) |
| BNE | Not Equal (Z=0) |
| BPL | Plus/Positive (N=0) |
| BMI | Minus/Negative (N=1) |
| BVC | Overflow Clear (V=0) |
| BVS | Overflow Set (V=1) |

**Átvitel (Transfer):**

| Utasítás | Leírás |
|----------|--------|
| TAX | A → X |
| TAY | A → Y |
| TXA | X → A |
| TYA | Y → A |
| TSX | SP → X |
| TXS | X → SP |

**Verem:**

| Utasítás | Leírás |
|----------|--------|
| PHA | Push A |
| PLA | Pull A |
| PHP | Push P (Status) |
| PLP | Pull P (Status) |

**Flag műveletek:**

| Utasítás | Hatás |
|----------|-------|
| CLC | Clear Carry |
| SEC | Set Carry |
| CLI | Clear IRQ Disable |
| SEI | Set IRQ Disable |
| CLV | Clear Overflow |
| CLD | Clear Decimal |
| SED | Set Decimal |
| NOP | No Operation |

---

## Appendix K: VIC Chip Registers (VIC-20)

| Cím | Leírás |
|-----|--------|
| $9000 | Interlace + TV X start |
| $9001 | TV Y start |
| $9002 | Columns + video base (bits 7-1) |
| $9003 | Rows + character size (2×=bit0) |
| $9004 | Raster (MSB in $9003 bit7) |
| $9005 | Video base (bits 4-1) + char base (bits 3-1) |
| $9006 | Light pen X |
| $9007 | Light pen Y |
| $9008 | Paddle 1 |
| $9009 | Paddle 2 |
| $900A | Voice 1 frequency + gate |
| $900B | Voice 2 frequency + gate |
| $900C | Voice 3 frequency + gate |
| $900D | Noise frequency + gate |
| $900E | Auxiliary color + volume |
| $900F | Screen color + border/reverse |

---

## Appendix P: 6502 Quasi-Opcodes (Illegális opcode-ok)

A 6502 nem definiált opcode-jai végrehajthatók, de viselkedésük nem garantált:

| Mnemó | Leírás |
|-------|--------|
| LAX | LDA + LDX egyszerre |
| SAX | Store A AND X |
| DCP | DEC, majd CMP |
| ISC | INC, majd SBC |
| SLO | ASL, majd ORA |
| RLA | ROL, majd AND |
| SRE | LSR, majd EOR |
| RRA | ROR, majd ADC |
| ANC | AND, Carry←bit7 |
| ALR | AND, majd LSR |
| ARR | AND, majd ROR |
| AXS | A AND X - imm → X |
| LAE | Load A, X, SP from mem AND SP |
| SHA | Store A AND X AND (addr_hi+1) |

→ Kick Assembler ezeket mind támogatja; részletek: `KickAssembler.notes.md`

---

## Appendix Q: VIC-20 ↔ C64 ↔ CBM Program Konverzió

**Főbb különbségek VIC-20 és C64 között:**

| Jellemző | VIC-20 | C64 |
|----------|--------|-----|
| Screen mem | $1E00 (5K bővítővel), más alapon | $0400 |
| Color mem | $9600 | $D800 |
| Video chip | $9000 | $D000 |
| Sound chip | VIC ($9000) | SID ($D400) |
| BASIC start | $1001 alap | $0801 |
| Screen width | 22 karakter | 40 karakter |
| Screen height | 23 sor | 25 sor |
| IRQ vektor | $0314–$0315 | $0314–$0315 (azonos!) |
| KERNAL rutinok | $FFxx | $FFxx (azonos!) |

**Konverzió elvei:**
1. KERNAL rutinok ($FFxx) azonosak mindkét gépen → ML kód hordozható
2. Screen/Color/VIC regiszter címek különböznek → ezeket át kell írni
3. BASIC program terület más kezdőcímen