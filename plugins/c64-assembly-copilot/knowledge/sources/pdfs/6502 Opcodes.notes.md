# 6502 Opcodes Reference

- Forrás: `6502 Opcodes.pdf` (13 oldal)
- Téma: 6502 utasításkészlet teljes leírása – minden utasítás összes addressing mode-jával, opcode-jával, hosszával és cikluszámával
- Megbízhatóság: magas
- Érdemes nézni: konkrét opcode és cycle count kereséshez, flag-hatás ellenőrzéshez

---

## Utasítások betűrendben (mód / szintaxis / hex / byte / ciklus)

### ADC – Add with Carry
Érintett flagek: **S V Z C**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | ADC #$44 | $69 | 2 | 2 |
| Zero Page | ADC $44 | $65 | 2 | 3 |
| Zero Page,X | ADC $44,X | $75 | 2 | 4 |
| Absolute | ADC $4400 | $6D | 3 | 4 |
| Absolute,X | ADC $4400,X | $7D | 3 | 4+ |
| Absolute,Y | ADC $4400,Y | $79 | 3 | 4+ |
| Indirect,X | ADC ($44,X) | $61 | 2 | 6 |
| Indirect,Y | ADC ($44),Y | $71 | 2 | 5+ |

`+` = +1 ciklus ha page boundary átlépés van. Nincs carry nélküli összeadás. BCD módban BCD aritmetikát végez.

---

### AND – Bitwise AND with Accumulator
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | AND #$44 | $29 | 2 | 2 |
| Zero Page | AND $44 | $25 | 2 | 2 |
| Zero Page,X | AND $44,X | $35 | 2 | 3 |
| Absolute | AND $4400 | $2D | 3 | 4 |
| Absolute,X | AND $4400,X | $3D | 3 | 4+ |
| Absolute,Y | AND $4400,Y | $39 | 3 | 4+ |
| Indirect,X | AND ($44,X) | $21 | 2 | 6 |
| Indirect,Y | AND ($44),Y | $31 | 2 | 5+ |

---

### ASL – Arithmetic Shift Left
Érintett flagek: **S Z C**
Bit 0-ba 0 kerül, az eredeti bit 7 Carry-be kerül.

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Accumulator | ASL A | $0A | 1 | 2 |
| Zero Page | ASL $44 | $06 | 2 | 5 |
| Zero Page,X | ASL $44,X | $16 | 2 | 6 |
| Absolute | ASL $4400 | $0E | 3 | 6 |
| Absolute,X | ASL $4400,X | $1E | 3 | 7 |

---

### BIT – Test BITs
Érintett flagek: **N V Z**
Z flag = (A AND M) == 0; N = M bit 7; V = M bit 6.
Trükk: két byte kihagyásra is használható ($2C opcode).

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Zero Page | BIT $44 | $24 | 2 | 3 |
| Absolute | BIT $4400 | $2C | 3 | 4 |

---

### Branch utasítások (relatív, 2 byte)
Flagek: egyik sem
Nem vett ugrás: 2 ciklus. +1 ha ág véve. +1 ha page boundary átlépés.

| Mnemonic | Hex | Feltétel |
|----------|-----|----------|
| BPL | $10 | N=0 (Plus) |
| BMI | $30 | N=1 (Minus) |
| BVC | $50 | V=0 (Overflow Clear) |
| BVS | $70 | V=1 (Overflow Set) |
| BCC | $90 | C=0 (Carry Clear) |
| BCS | $B0 | C=1 (Carry Set) |
| BNE | $D0 | Z=0 (Not Equal) |
| BEQ | $F0 | Z=1 (Equal) |

Nincs BRA (Branch Always), de BVC-vel emulálható (V nem változik összeadás/kivonás nélkül).

---

### BRK – Break
Érintett flagek: **B**

| Mód | Hex | Len | Tim |
|-----|-----|-----|-----|
| Implied | $00 | 1 | 7 |

PC+2-re lép RTI után. Debug célra: 3 byte-os utasítást helyettesíthet.

---

### CMP – Compare Accumulator
Érintett flagek: **S Z C**
Carry set ha A >= M.

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | CMP #$44 | $C9 | 2 | 2 |
| Zero Page | CMP $44 | $C5 | 2 | 3 |
| Zero Page,X | CMP $44,X | $D5 | 2 | 4 |
| Absolute | CMP $4400 | $CD | 3 | 4 |
| Absolute,X | CMP $4400,X | $DD | 3 | 4+ |
| Absolute,Y | CMP $4400,Y | $D9 | 3 | 4+ |
| Indirect,X | CMP ($44,X) | $C1 | 2 | 6 |
| Indirect,Y | CMP ($44),Y | $D1 | 2 | 5+ |

---

### CPX – Compare X Register
Érintett flagek: **S Z C**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | CPX #$44 | $E0 | 2 | 2 |
| Zero Page | CPX $44 | $E4 | 2 | 3 |
| Absolute | CPX $4400 | $EC | 3 | 4 |

---

### CPY – Compare Y Register
Érintett flagek: **S Z C**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | CPY #$44 | $C0 | 2 | 2 |
| Zero Page | CPY $44 | $C4 | 2 | 3 |
| Absolute | CPY $4400 | $CC | 3 | 4 |

---

### DEC – Decrement Memory
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Zero Page | DEC $44 | $C6 | 2 | 5 |
| Zero Page,X | DEC $44,X | $D6 | 2 | 6 |
| Absolute | DEC $4400 | $CE | 3 | 6 |
| Absolute,X | DEC $4400,X | $DE | 3 | 7 |

---

### EOR – Exclusive OR
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | EOR #$44 | $49 | 2 | 2 |
| Zero Page | EOR $44 | $45 | 2 | 3 |
| Zero Page,X | EOR $44,X | $55 | 2 | 4 |
| Absolute | EOR $4400 | $4D | 3 | 4 |
| Absolute,X | EOR $4400,X | $5D | 3 | 4+ |
| Absolute,Y | EOR $4400,Y | $59 | 3 | 4+ |
| Indirect,X | EOR ($44,X) | $41 | 2 | 6 |
| Indirect,Y | EOR ($44),Y | $51 | 2 | 5+ |

---

### Flag utasítások (implied, 1 byte, 2 ciklus)

| Mnemonic | Hex | Hatás |
|----------|-----|-------|
| CLC | $18 | Carry törlése |
| SEC | $38 | Carry beállítása |
| CLI | $58 | Interrupt disable törlése (IRQ engedélyezés) |
| SEI | $78 | Interrupt disable beállítása (IRQ tiltás) |
| CLV | $B8 | Overflow törlése |
| CLD | $D8 | Decimal mód törlése |
| SED | $F8 | Decimal mód beállítása |

Megjegyzések:
- **I flag**: SEI tiltja, CLI engedélyezi a maskable interrupt-ot. A 6502 automatikusan beállítja interrupt esetén.
- **D flag**: BCD aritmetika. Nincs meghatározva power-up után -> CLD használandó boot/interrupt kódban.
- **V flag**: ADC/SBC/CLV/PLP/RTI módosítja. Csak BIT teszttel lehet beállítani (RTS utasításon).

---

### INC – Increment Memory
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Zero Page | INC $44 | $E6 | 2 | 5 |
| Zero Page,X | INC $44,X | $F6 | 2 | 6 |
| Absolute | INC $4400 | $EE | 3 | 6 |
| Absolute,X | INC $4400,X | $FE | 3 | 7 |

---

### JMP – Jump
Flagek: egyik sem

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Absolute | JMP $5597 | $4C | 3 | 3 |
| Indirect | JMP ($5597) | $6C | 3 | 5 |

FONTOS BUG: Indirect JMP page boundary-n NEM lép page-t! JMP ($30FF) a low byte-ot $30FF-ből, a high byte-ot $3000-ból veszi (NEM $3100-ból). Soha ne tegyen JMP vektort page utolsó byte-jára!

---

### JSR – Jump to Subroutine

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Absolute | JSR $5597 | $20 | 3 | 6 |

Stackre menti a visszatérési cím-1-et.

---

### LDA – Load Accumulator
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | LDA #$44 | $A9 | 2 | 2 |
| Zero Page | LDA $44 | $A5 | 2 | 3 |
| Zero Page,X | LDA $44,X | $B5 | 2 | 4 |
| Absolute | LDA $4400 | $AD | 3 | 4 |
| Absolute,X | LDA $4400,X | $BD | 3 | 4+ |
| Absolute,Y | LDA $4400,Y | $B9 | 3 | 4+ |
| Indirect,X | LDA ($44,X) | $A1 | 2 | 6 |
| Indirect,Y | LDA ($44),Y | $B1 | 2 | 5+ |

---

### LDX – Load X Register
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | LDX #$44 | $A2 | 2 | 2 |
| Zero Page | LDX $44 | $A6 | 2 | 3 |
| Zero Page,Y | LDX $44,Y | $B6 | 2 | 4 |
| Absolute | LDX $4400 | $AE | 3 | 4 |
| Absolute,Y | LDX $4400,Y | $BE | 3 | 4+ |

---

### LDY – Load Y Register
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | LDY #$44 | $A0 | 2 | 2 |
| Zero Page | LDY $44 | $A4 | 2 | 3 |
| Zero Page,X | LDY $44,X | $B4 | 2 | 4 |
| Absolute | LDY $4400 | $AC | 3 | 4 |
| Absolute,X | LDY $4400,X | $BC | 3 | 4+ |

---

### LSR – Logical Shift Right
Érintett flagek: **S Z C**
Bit 7-be 0 kerül, bit 0 Carry-be kerül.

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Accumulator | LSR A | $4A | 1 | 2 |
| Zero Page | LSR $44 | $46 | 2 | 5 |
| Zero Page,X | LSR $44,X | $56 | 2 | 6 |
| Absolute | LSR $4400 | $4E | 3 | 6 |
| Absolute,X | LSR $4400,X | $5E | 3 | 7 |

---

### NOP – No Operation

| Mód | Hex | Len | Tim |
|-----|-----|-----|-----|
| Implied | $EA | 1 | 2 |

Helyfoglalásra vagy kód "REM"-elésére használható.

---

### ORA – Bitwise OR with Accumulator
Érintett flagek: **S Z**

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | ORA #$44 | $09 | 2 | 2 |
| Zero Page | ORA $44 | $05 | 2 | 2 |
| Zero Page,X | ORA $44,X | $15 | 2 | 3 |
| Absolute | ORA $4400 | $0D | 3 | 4 |
| Absolute,X | ORA $4400,X | $1D | 3 | 4+ |
| Absolute,Y | ORA $4400,Y | $19 | 3 | 4+ |
| Indirect,X | ORA ($44,X) | $01 | 2 | 6 |
| Indirect,Y | ORA ($44),Y | $11 | 2 | 5+ |

---

### Register utasítások (implied, 1 byte, 2 ciklus)
Érintett flagek: **S Z**

| Mnemonic | Hex | Hatás |
|----------|-----|-------|
| TAX | $AA | A -> X |
| TXA | $8A | X -> A |
| DEX | $CA | X-- |
| INX | $E8 | X++ |
| TAY | $A8 | A -> Y |
| TYA | $98 | Y -> A |
| DEY | $88 | Y-- |
| INY | $C8 | Y++ |

---

### ROL – Rotate Left
Érintett flagek: **S Z C**
Carry -> bit 0, bit 7 -> Carry.

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Accumulator | ROL A | $2A | 1 | 2 |
| Zero Page | ROL $44 | $26 | 2 | 5 |
| Zero Page,X | ROL $44,X | $36 | 2 | 6 |
| Absolute | ROL $4400 | $2E | 3 | 6 |
| Absolute,X | ROL $4400,X | $3E | 3 | 7 |

---

### ROR – Rotate Right
Érintett flagek: **S Z C**
Carry -> bit 7, bit 0 -> Carry.

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Accumulator | ROR A | $6A | 1 | 2 |
| Zero Page | ROR $44 | $66 | 2 | 5 |
| Zero Page,X | ROR $44,X | $76 | 2 | 6 |
| Absolute | ROR $4400 | $6E | 3 | 6 |
| Absolute,X | ROR $4400,X | $7E | 3 | 7 |

---

### RTI – Return from Interrupt

| Mód | Hex | Len | Tim |
|-----|-----|-----|-----|
| Implied | $40 | 1 | 6 |

Stack-ről: PSW, majd PC. (Ellentétben RTS-sel: a stack-en lévő cím a tényleges cím, nem cím-1.)

---

### RTS – Return from Subroutine

| Mód | Hex | Len | Tim |
|-----|-----|-----|-----|
| Implied | $60 | 1 | 6 |

Stack-ről: low byte, high byte, majd PC+1. Jump table trükk: cím-1 stack-re, majd RTS.

```asm
EXEC
    LDA HIBYTE,X
    PHA
    LDA LOBYTE,X
    PHA
    RTS
```

---

### SBC – Subtract with Carry
Érintett flagek: **S V Z C**
Carry = inverse borrow. Kivonás előtt: SEC. BCD módban BCD kivonás.

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Immediate | SBC #$44 | $E9 | 2 | 2 |
| Zero Page | SBC $44 | $E5 | 2 | 3 |
| Zero Page,X | SBC $44,X | $F5 | 2 | 4 |
| Absolute | SBC $4400 | $ED | 3 | 4 |
| Absolute,X | SBC $4400,X | $FD | 3 | 4+ |
| Absolute,Y | SBC $4400,Y | $F9 | 3 | 4+ |
| Indirect,X | SBC ($44,X) | $E1 | 2 | 6 |
| Indirect,Y | SBC ($44),Y | $F1 | 2 | 5+ |

---

### STA – Store Accumulator
Flagek: egyik sem

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Zero Page | STA $44 | $85 | 2 | 3 |
| Zero Page,X | STA $44,X | $95 | 2 | 4 |
| Absolute | STA $4400 | $8D | 3 | 4 |
| Absolute,X | STA $4400,X | $9D | 3 | 5 |
| Absolute,Y | STA $4400,Y | $99 | 3 | 5 |
| Indirect,X | STA ($44,X) | $81 | 2 | 6 |
| Indirect,Y | STA ($44),Y | $91 | 2 | 6 |

---

### Stack utasítások (implied, 1 byte)

| Mnemonic | Hex | Tim | Hatás |
|----------|-----|-----|-------|
| TXS | $9A | 2 | X -> SP |
| TSX | $BA | 2 | SP -> X |
| PHA | $48 | 3 | A stackre |
| PLA | $68 | 4 | A stack-ről |
| PHP | $08 | 3 | SR stackre |
| PLP | $28 | 4 | SR stack-ről |

Stack: $0100-$01FF, top-down (LIFO).

---

### STX – Store X Register
Flagek: egyik sem

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Zero Page | STX $44 | $86 | 2 | 3 |
| Zero Page,Y | STX $44,Y | $96 | 2 | 4 |
| Absolute | STX $4400 | $8E | 3 | 4 |

---

### STY – Store Y Register
Flagek: egyik sem

| Mód | Szintaxis | Hex | Len | Tim |
|-----|-----------|-----|-----|-----|
| Zero Page | STY $44 | $84 | 2 | 3 |
| Zero Page,X | STY $44,X | $94 | 2 | 4 |
| Absolute | STY $4400 | $8C | 3 | 4 |

---

## Technikai megjegyzések

### Zero Page Wrap-Around
Zero page indexelt műveleteknél figyelem: ha X=$FF és LDA $80,X, az NEM $017F-et ér el, hanem $7F-et (wrap-around page 0-n belül). Ezzel tudatosan is lehet trükközni.

### Program Counter viselkedés
A PC a következő utasítás fetch előtt inkrementálódik. Branch offset számításnál: forward +6 = PC+8. JSR visszatérési cím-1-et ment (ezért RTS PC+1-re ugrik). Jump table: cím-1-et kell stackre tenni RTS-sel való ugráshoz.

### Execution Times
1 gépciklus = 2 órajel. + = +1 ciklus page boundary átlépésnél. Brancheknél ** = +1 same page, +2 different page.

---

## Registers összefoglalás

| Register | Méret | Leírás |
|----------|-------|--------|
| PC | 16 bit | Program Counter |
| AC (A) | 8 bit | Accumulator |
| X | 8 bit | Index X |
| Y | 8 bit | Index Y |
| SR | 8 bit | Status Register [NV-BDIZC] |
| SP | 8 bit | Stack Pointer |

### SR Flag bitek (bit 7 -> bit 0)
N Negative | V Overflow | - ignored | B Break | D Decimal | I Interrupt | Z Zero | C Carry

---

## Addressing mode-ok összefoglalás

| Jelölés | Leírás | Példa |
|---------|--------|-------|
| A | Accumulator | OPC A |
| abs | Absolute | OPC $HHLL |
| abs,X | Absolute, X-indexed | OPC $HHLL,X |
| abs,Y | Absolute, Y-indexed | OPC $HHLL,Y |
| # | Immediate | OPC #$BB |
| impl | Implied | OPC |
| ind | Indirect | OPC ($HHLL) |
| X,ind | X-indexed indirect | OPC ($BB,X) |
| ind,Y | Indirect, Y-indexed | OPC ($LL),Y |
| rel | Relative | OPC $BB |
| zpg | Zero Page | OPC $LL |
| zpg,X | Zero Page, X-indexed | OPC $LL,X |
| zpg,Y | Zero Page, Y-indexed | OPC $LL,Y |

## 65xx Family tagjai

| Típus | Leírás |
|-------|--------|
| 6502 | NMOS, 16 bit address bus, 8 bit data bus |
| 6510 | 6502 + 6 bit I/O port (ez van a C64-ben) |
| 8500 | 6510 CMOS változat |
| 8502 | 6510 + 2 MHz opció, 7 bit I/O port (C128) |
| 65C02 | 16 bit, extra utasítások és addressing mode-ok |
| 65816 | 16 bit regiszterek, 24 bit address bus, 16 MiB |
