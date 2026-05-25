# 6502 Instruction Set – Teljes referencia

- Forrás: `6502 Instruction Set.pdf` (19 oldal)
- Téma: 6502 opcode mátrix (HI/LO nibble táblázat), összes utasítás részletes leírása, addressing mode-ok, regiszterek, SR flag-ek, 65xx family
- Megbízhatóság: magas
- Érdemes nézni: opcode mátrix gyors kereséshez, flag-hatás táblázathoz, utasítás részletes működéséhez

---

## Regiszterek

| Regiszter | Méret | Leírás |
|-----------|-------|--------|
| PC | 16 bit | Program Counter |
| AC (A) | 8 bit | Accumulator |
| X | 8 bit | Index X |
| Y | 8 bit | Index Y |
| SR | 8 bit | Status Register [NV-BDIZC] |
| SP | 8 bit | Stack Pointer |

### SR Flag bitek (bit 7 -> bit 0)

| Bit | Jel | Neve |
|-----|-----|------|
| 7 | N | Negative |
| 6 | V | Overflow |
| 5 | - | Ignored |
| 4 | B | Break |
| 3 | D | Decimal |
| 2 | I | Interrupt disable |
| 1 | Z | Zero |
| 0 | C | Carry |

**Flag jelölések a táblázatban:**
- `+` = módosított
- `-` = nem módosított
- `1` = beállítva
- `0` = törölve
- `M6` / `M7` = memória bit 6 / bit 7 értéke másolódik

### Stack
- LIFO, top-down, 8 bit range: $0100–$01FF

### Bytes és szavak
- 8 bit byte, 16 bit word **little-endian** (lo byte előbb)

---

## Addressing Mode-ok

| Jelölés | Neve | Szintaxis | Leírás |
|---------|------|-----------|--------|
| A | Accumulator | OPC A | Operandus az AC |
| abs | Absolute | OPC $HHLL | Operandus cím $HHLL |
| abs,X | Absolute, X-indexed | OPC $HHLL,X | Cím + X (carry-vel) |
| abs,Y | Absolute, Y-indexed | OPC $HHLL,Y | Cím + Y (carry-vel) |
| # | Immediate | OPC #$BB | Operandus maga a bájt |
| impl | Implied | OPC | Operandus implicit |
| ind | Indirect | OPC ($HHLL) | Hatékony cím az adott cím értéke |
| X,ind | X-indexed indirect | OPC ($BB,X) | Zero page $BB+X -> cím |
| ind,Y | Indirect, Y-indexed | OPC ($LL),Y | Zero page $LL-en cím, +Y |
| rel | Relative | OPC $BB | Branch: PC + offset (bit 7 = negatív) |
| zpg | Zero Page | OPC $LL | Lo byte only, hi byte = $00 |
| zpg,X | Zero Page, X-indexed | OPC $LL,X | Zero page, wrap-around! |
| zpg,Y | Zero Page, Y-indexed | OPC $LL,Y | Zero page, wrap-around! |

**Megjegyzés**: `most assemblers use "OPC *oper" for forced zeropage addressing`

---

## Utasítások részletes leírása

### ADC – Add Memory to Accumulator with Carry
`A + M + C -> A, C`  Flagek: N Z C I D V -> `+ + + - - +`

| Mód | Assembler | Opcode | Bytes | Cycles |
|-----|-----------|--------|-------|--------|
| immediate | ADC #oper | 69 | 2 | 2 |
| zeropage | ADC oper | 65 | 2 | 3 |
| zeropage,X | ADC oper,X | 75 | 2 | 4 |
| absolute | ADC oper | 6D | 3 | 4 |
| absolute,X | ADC oper,X | 7D | 3 | 4* |
| absolute,Y | ADC oper,Y | 79 | 3 | 4* |
| (indirect,X) | ADC (oper,X) | 61 | 2 | 6 |
| (indirect),Y | ADC (oper),Y | 71 | 2 | 5* |

---

### AND – AND Memory with Accumulator
`A AND M -> A`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | 29 | 2 | 2 |
| zeropage | 25 | 2 | 3 |
| zeropage,X | 35 | 2 | 4 |
| absolute | 2D | 3 | 4 |
| absolute,X | 3D | 3 | 4* |
| absolute,Y | 39 | 3 | 4* |
| (indirect,X) | 21 | 2 | 6 |
| (indirect),Y | 31 | 2 | 5* |

---

### ASL – Shift Left One Bit
`C <- [76543210] <- 0`  Flagek: `+ + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| accumulator | 0A | 1 | 2 |
| zeropage | 06 | 2 | 5 |
| zeropage,X | 16 | 2 | 6 |
| absolute | 0E | 3 | 6 |
| absolute,X | 1E | 3 | 7 |

---

### Branch utasítások – mind 2 byte, relative

| Mnemonic | Opcode | Feltétel | Flagek |
|----------|--------|----------|--------|
| BCC | 90 | C=0 | - |
| BCS | B0 | C=1 | - |
| BEQ | F0 | Z=1 | - |
| BMI | 30 | N=1 | - |
| BNE | D0 | Z=0 | - |
| BPL | 10 | N=0 | - |
| BVC | 50 | V=0 | - |
| BVS | 70 | V=1 | - |

Ciklus: 2** (ld. lent)

---

### BIT – Test Bits in Memory with Accumulator
`A AND M, M7 -> N, M6 -> V`  Flagek: `M7 + - - - M6`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| zeropage | 24 | 2 | 3 |
| absolute | 2C | 3 | 4 |

---

### BRK – Force Break
`interrupt, push PC+2, push SR`  Flagek: `- - - 1 - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| implied | 00 | 1 | 7 |

---

### CLC/SEC/CLI/SEI/CLV/CLD/SED – Flag utasítások

| Mnemonic | Opcode | Hatás |
|----------|--------|-------|
| CLC | 18 | 0 -> C |
| SEC | 38 | 1 -> C |
| CLI | 58 | 0 -> I |
| SEI | 78 | 1 -> I |
| CLV | B8 | 0 -> V |
| CLD | D8 | 0 -> D |
| SED | F8 | 1 -> D |

Mind: implied, 1 byte, 2 ciklus.

---

### CMP – Compare Memory with Accumulator
`A - M`  Flagek: `+ + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | C9 | 2 | 2 |
| zeropage | C5 | 2 | 3 |
| zeropage,X | D5 | 2 | 4 |
| absolute | CD | 3 | 4 |
| absolute,X | DD | 3 | 4* |
| absolute,Y | D9 | 3 | 4* |
| (indirect,X) | C1 | 2 | 6 |
| (indirect),Y | D1 | 2 | 5* |

---

### CPX – Compare Memory and Index X
`X - M`  Flagek: `+ + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | E0 | 2 | 2 |
| zeropage | E4 | 2 | 3 |
| absolute | EC | 3 | 4 |

---

### CPY – Compare Memory and Index Y
`Y - M`  Flagek: `+ + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | C0 | 2 | 2 |
| zeropage | C4 | 2 | 3 |
| absolute | CC | 3 | 4 |

---

### DEC – Decrement Memory by One
`M - 1 -> M`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| zeropage | C6 | 2 | 5 |
| zeropage,X | D6 | 2 | 6 |
| absolute | CE | 3 | 6 |
| absolute,X | DE | 3 | 7 |

---

### DEX – Decrement Index X / DEY – Decrement Index Y

| Mnemonic | Opcode | Bytes | Cycles |
|----------|--------|-------|--------|
| DEX | CA | 1 | 2 |
| DEY | 88 | 1 | 2 |

`X - 1 -> X` / `Y - 1 -> Y`  Flagek: `+ + - - - -`

---

### EOR – Exclusive-OR Memory with Accumulator
`A EOR M -> A`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | 49 | 2 | 2 |
| zeropage | 45 | 2 | 3 |
| zeropage,X | 55 | 2 | 4 |
| absolute | 4D | 3 | 4 |
| absolute,X | 5D | 3 | 4* |
| absolute,Y | 59 | 3 | 4* |
| (indirect,X) | 41 | 2 | 6 |
| (indirect),Y | 51 | 2 | 5* |

---

### INC – Increment Memory by One
`M + 1 -> M`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| zeropage | E6 | 2 | 5 |
| zeropage,X | F6 | 2 | 6 |
| absolute | EE | 3 | 6 |
| absolute,X | FE | 3 | 7 |

---

### INX / INY – Increment Index X / Y

| Mnemonic | Opcode | Bytes | Cycles |
|----------|--------|-------|--------|
| INX | E8 | 1 | 2 |
| INY | C8 | 1 | 2 |

---

### JMP – Jump to New Location
Flagek: `- - - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| absolute | 4C | 3 | 3 |
| indirect | 6C | 3 | 5 |

`(PC+1) -> PCL, (PC+2) -> PCH`

---

### JSR – Jump to New Location Saving Return Address
`push (PC+2), (PC+1)->PCL, (PC+2)->PCH`  Flagek: `- - - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| absolute | 20 | 3 | 6 |

---

### LDA – Load Accumulator with Memory
`M -> A`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | A9 | 2 | 2 |
| zeropage | A5 | 2 | 3 |
| zeropage,X | B5 | 2 | 4 |
| absolute | AD | 3 | 4 |
| absolute,X | BD | 3 | 4* |
| absolute,Y | B9 | 3 | 4* |
| (indirect,X) | A1 | 2 | 6 |
| (indirect),Y | B1 | 2 | 5* |

---

### LDX – Load Index X with Memory
`M -> X`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | A2 | 2 | 2 |
| zeropage | A6 | 2 | 3 |
| zeropage,Y | B6 | 2 | 4 |
| absolute | AE | 3 | 4 |
| absolute,Y | BE | 3 | 4* |

---

### LDY – Load Index Y with Memory
`M -> Y`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | A0 | 2 | 2 |
| zeropage | A4 | 2 | 3 |
| zeropage,X | B4 | 2 | 4 |
| absolute | AC | 3 | 4 |
| absolute,X | BC | 3 | 4* |

---

### LSR – Shift One Bit Right
`0 -> [76543210] -> C`  Flagek: `- + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| accumulator | 4A | 1 | 2 |
| zeropage | 46 | 2 | 5 |
| zeropage,X | 56 | 2 | 6 |
| absolute | 4E | 3 | 6 |
| absolute,X | 5E | 3 | 7 |

---

### NOP – No Operation
Flagek: `- - - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| implied | EA | 1 | 2 |

---

### ORA – OR Memory with Accumulator
`A OR M -> A`  Flagek: `+ + - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | 09 | 2 | 2 |
| zeropage | 05 | 2 | 3 |
| zeropage,X | 15 | 2 | 4 |
| absolute | 0D | 3 | 4 |
| absolute,X | 1D | 3 | 4* |
| absolute,Y | 19 | 3 | 4* |
| (indirect,X) | 01 | 2 | 6 |
| (indirect),Y | 11 | 2 | 5* |

---

### Stack utasítások

| Mnemonic | Opcode | Bytes | Cycles | Hatás |
|----------|--------|-------|--------|-------|
| PHA | 48 | 1 | 3 | push A |
| PHP | 08 | 1 | 3 | push SR |
| PLA | 68 | 1 | 4 | pull A |
| PLP | 28 | 1 | 4 | pull SR |
| TXS | 9A | 1 | 2 | X -> SP |
| TSX | BA | 1 | 2 | SP -> X |

---

### ROL – Rotate One Bit Left
`C <- [76543210] <- C`  Flagek: `+ + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| accumulator | 2A | 1 | 2 |
| zeropage | 26 | 2 | 5 |
| zeropage,X | 36 | 2 | 6 |
| absolute | 2E | 3 | 6 |
| absolute,X | 3E | 3 | 7 |

---

### ROR – Rotate One Bit Right
`C -> [76543210] -> C`  Flagek: `+ + + - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| accumulator | 6A | 1 | 2 |
| zeropage | 66 | 2 | 5 |
| zeropage,X | 76 | 2 | 6 |
| absolute | 6E | 3 | 6 |
| absolute,X | 7E | 3 | 7 |

---

### RTI – Return from Interrupt
`pull SR, pull PC`  Flagek: from stack

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| implied | 40 | 1 | 6 |

---

### RTS – Return from Subroutine
`pull PC, PC+1 -> PC`  Flagek: `- - - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| implied | 60 | 1 | 6 |

---

### SBC – Subtract Memory from Accumulator with Borrow
`A - M - C -> A`  Flagek: `+ + + - - +`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| immediate | E9 | 2 | 2 |
| zeropage | E5 | 2 | 3 |
| zeropage,X | F5 | 2 | 4 |
| absolute | ED | 3 | 4 |
| absolute,X | FD | 3 | 4* |
| absolute,Y | F9 | 3 | 4* |
| (indirect,X) | E1 | 2 | 6 |
| (indirect),Y | F1 | 2 | 5* |

---

### STA – Store Accumulator in Memory
Flagek: `- - - - - -`

| Mód | Opcode | Bytes | Cycles |
|-----|--------|-------|--------|
| zeropage | 85 | 2 | 3 |
| zeropage,X | 95 | 2 | 4 |
| absolute | 8D | 3 | 4 |
| absolute,X | 9D | 3 | 5 |
| absolute,Y | 99 | 3 | 5 |
| (indirect,X) | 81 | 2 | 6 |
| (indirect),Y | 91 | 2 | 6 |

---

### STX – Store Index X / STY – Store Index Y

| Mnemonic | Mód | Opcode | Bytes | Cycles |
|----------|-----|--------|-------|--------|
| STX | zeropage | 86 | 2 | 3 |
| STX | zeropage,Y | 96 | 2 | 4 |
| STX | absolute | 8E | 3 | 4 |
| STY | zeropage | 84 | 2 | 3 |
| STY | zeropage,X | 94 | 2 | 4 |
| STY | absolute | 8C | 3 | 4 |

---

### Register Transfer utasítások

| Mnemonic | Opcode | Bytes | Cycles | Hatás | Flagek |
|----------|--------|-------|--------|-------|--------|
| TAX | AA | 1 | 2 | A -> X | N Z |
| TAY | A8 | 1 | 2 | A -> Y | N Z |
| TSX | BA | 1 | 2 | SP -> X | N Z |
| TXA | 8A | 1 | 2 | X -> A | N Z |
| TXS | 9A | 1 | 2 | X -> SP | N Z |
| TYA | 98 | 1 | 2 | Y -> A | N Z |

---

## Ciklus jelölések

- `*` = +1 ciklus ha page boundary átlépés
- `**` = +1 ciklus ha branch same page; +2 ha different page

---

## 65xx Family összefoglalás

| Típus | Leírás |
|-------|--------|
| 6502 | Eredeti NMOS, 16 bit address bus, 8 bit data bus |
| 6502A | Gyorsított 6502 |
| 6502C | Gyorsított, CMOS |
| 65C02 | 16 bit, extra utasítások |
| 6503/05/06 | 12 bit address bus (4 KiB) |
| 6504 | 13 bit address bus (8 KiB) |
| 6507 | 13 bit, nincs interrupt |
| 6509 | 20 bit bank switching (1 MiB) |
| **6510** | **6502 + 6 bit I/O port – ez van a C64-ben!** |
| 8500 | 6510 CMOS |
| 8502 | 6510 + 2 MHz, 7 bit I/O (C128) |
| 65816 | 16 bit regiszterek, 24 bit address bus (16 MiB) |
| 65802 | 65816 pin-kompatibilis 6502-vel |
