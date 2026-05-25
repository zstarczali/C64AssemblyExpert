# Commodore 64 Assembly – Erdős Iván

- Forrás: `C64 Assembly.pdf` (151 oldal), szerző: Erdős Iván, LSI Alkalmazástechnika / Tanácsadó Szolgálat, Budapest, 1985
- Téma: C64 6510 assembly programozás magyar nyelven; 6510 programozási modell, utasításkészlet, assembler eszközök, gyakorlati programozási módszerek
- Megbízhatóság: magas (magyar nyelvű szakkönyv C64 assembly-hez)
- Érdemes nézni: 6510 programozási modell, utasításkészlet csoportonként, assembler eszközök (HELP+, PROFMAT, SM-KIT, PTD debugger), C64-specifikus programozási minták

---

## Tartalom

| Fejezet | Tartalom | Oldal |
|---------|----------|-------|
| 1 | Bevezetés – programozási nyelvek áttekintése | 3 |
| 2 | A 6510-es mikroprocesszor programozási modellje | 10 |
| 2.1 | Alapfogalmak (memória, busz, byte, regiszter) | 10 |
| 2.2 | Regiszterek és jelzők | 13 |
| 2.3 | Cím módok | 17 |
| 2.4 | Megszakítások | 23 |
| 3 | Assembly – a kényelmes gépikód | 25 |
| 3.1 | Assembler képességek | 25 |
| 3.2.1 | Töltő utasítások | 27 |
| 3.2.2 | Tároló utasítások | 28 |
| 3.2.3 | Regiszter utasítások | 29 |
| 3.2.4 | Vezérlésátadó utasítások | 29 |
| 3.2.5 | Veremkezelő utasítások | 31 |
| 3.2.6 | Léptető utasítások | 34 |
| 3.2.7 | Logikai utasítások | 34 |
| 3.2.8 | Aritmetikai utasítások | 35 |
| 3.2.9 | Összehasonlító utasítások | 37 |
| 4 | Software eszközök – assemblerek, monitorok, debuggerek | 37 |
| 4.1 | HELP+ assembly programozást segítő eszközei | 40 |
| 4.2 | Makróassembler fejlesztő rendszer C-64-re | 44 |
| 4.3 | PROFIMAT | 53 |
| 4.4 | SM-KIT 64 | 58 |
| 4.5 | PTD interaktív debugger | 62 |
| 5 | ML programozunk – assembly programozási módszerek | 80 |
| 5.1 | Memóriagazdálkodás | 81 |
| 5.2 | Assembly és szerelésmódszerek | 93 |
| 5.3 | A Commodore 64 operációs rendszere – KERNAL | 105 |
| 5.4 | BASIC és assembly békés egymás mellett élése | 108 |
| 5.5 | Gyorsabban, messzebbre, magasabbra... | 116 |
| 5.6 | Nagy feladatok megközelítése | 126 |
| A. Függelék | MOS 6510 utasításkészlet | 136 |
| B. Függelék | KERNAL szubrutinok | 139 |
| C. Függelék | C64 memóriakiosztás | 146 |

---

## 1. Bevezetés: Programozási Nyelvek

A könyv a Commodore 64 assembly programozásával foglalkozik. Programozási nyelvek osztályozása:

1. **Assembly nyelvek**: egy assembly utasítás = egy gépi utasítás
2. **Gépközeli (géporientált) nyelvek**: több gépi utasításnak felelnek meg
3. **Magas szintű nyelvek**: BASIC, PASCAL, FORTRAN (gépfüggetlen)
4. **Nagyon magas szintű nyelvek**: PROLOG, LISP
5. **Újszerű nyelvek**: FORTH, C

**BASIC vs Assembly:**
- BASIC: lassú (interpreter), könnyen tanulható, hordozható
- Assembly: gyors, hardver-specifikus, erőteljes hardware-hozzáférés

---

## 2. A 6510-es Mikroprocesszor Programozási Modellje

### 2.1 Alapfogalmak

**A memória felépítése:**
- RAM: Írható/olvasható, törlődik áramtalanításkor
- ROM: Csak olvasható, permanens tartalom
- Egy byte = 8 bit = 2 hex jegy = $00–$FF = 0–255

**Adatbuszok:**
- 8 bites adatbusz: adatátvitel (olvasás/írás)
- 16 bites cím busz: 65536 (2^16) cím megcímezhetőségéhez
- Vezérlő busz: olvasás/írás jelzés

**Cím tárolás (little-endian):**
- Alacsony byte az alacsonyabb memóriacímen
- Magas byte a következő (magasabb) memóriacímen
- Pl. $0014-$0015-ös cím tartalmából az egész cím: `256 * PEEK(21) + PEEK(20)`

### 2.2 Regiszterek és Jelzők

**7 db belső regiszter:**

| Regiszter | Méret | Leírás |
|-----------|-------|--------|
| A (Akkumulátor) | 8 bit | Aritmetikai műveletek, adatmozgatás |
| X (X index) | 8 bit | Indexelt cím, számláló, ciklus |
| Y (Y index) | 8 bit | Indexelt cím, számláló, ciklus |
| P (Processor Status) | 8 bit | 8 jelző (flag) bit |
| SP (Stack Pointer) | 8 bit | Verem mutató ($0100–$01FF) |
| PC (Program Counter) | 16 bit | Következő utasítás címe |
| (I/O port) | 8 bit | $0001: LORAM, HIRAM, CHAREN, kazetta |

**P regiszter flag bitek:**

| Bit | Jel | Leírás |
|-----|-----|--------|
| 7 | N (Negative) | 1 ha az eredmény bit7=1 |
| 6 | V (Overflow) | 1 ha előjeles overflow |
| 5 | – | Mindig 1 |
| 4 | B (Break) | 1 ha BRK utasítás okozta az IRQ-t |
| 3 | D (Decimal) | 1 ha BCD mód aktív |
| 2 | I (Interrupt) | 1 ha IRQ tiltva (SEI) |
| 1 | Z (Zero) | 1 ha az eredmény = 0 |
| 0 | C (Carry) | 1 ha átvitel (carry/borrow) |

### 2.3 Cím Módok

| Mód | Szintaxis | Leírás |
|-----|-----------|--------|
| Implicit | `NOP` | Nincs operandus |
| Akkumulátor | `ASL A` | A regiszter |
| Azonnali | `LDA #$05` | Konstans érték |
| Zero page | `LDA $10` | $0010 memória |
| Zero page,X | `LDA $10,X` | $0010+X |
| Zero page,Y | `LDX $10,Y` | $0010+Y |
| Abszolút | `LDA $1000` | $1000 memória |
| Abszolút,X | `LDA $1000,X` | $1000+X |
| Abszolút,Y | `LDA $1000,Y` | $1000+Y |
| Indirekt | `JMP ($1000)` | Cím a $1000-$1001-ből |
| (zp,X) Indexelt indirekt | `LDA ($20,X)` | Cím a ($20+X..$21+X)-ből |
| (zp),Y Indirekt indexelt | `LDA ($20),Y` | Cím a ($20-$21)-ből +Y |
| Relatív | `BNE cimke` | PC + signed byte (-128..+127) |

**Zero page előnye:** 1 byte-os cím = gyorsabb kód (3 ciklus ahelyett 4)

### 2.4 Megszakítások

| Tipus | Vektor | Leírás |
|-------|--------|--------|
| IRQ | $FFFE–$FFFF ($0314–$0315) | Maszkolható; CIA timer, VIC raster |
| NMI | $FFFA–$FFFB ($0318–$0319) | Nem maszkolható; RESTORE |
| RESET | $FFFC–$FFFD | Bekapcsolás/reset |
| BRK | $FFFE–$FFFF | Szoftveres; B flag különbözteti az IRQ-tól |

---

## 3. Utasításkészlet Csoportok

### 3.2.1 Töltő utasítások (Load)

| Mnemó | Leírás |
|-------|--------|
| LDA | Load Accumulator |
| LDX | Load X Register |
| LDY | Load Y Register |

Cím módok: immediate, zero page, zero page,X/Y, absolute, absolute,X/Y, (zp,X), (zp),Y

### 3.2.2 Tároló utasítások (Store)

| Mnemó | Leírás |
|-------|--------|
| STA | Store Accumulator |
| STX | Store X Register |
| STY | Store Y Register |

### 3.2.3 Regiszter utasítások (Transfer)

| Mnemó | Leírás |
|-------|--------|
| TAX | Transfer A→X |
| TAY | Transfer A→Y |
| TXA | Transfer X→A |
| TYA | Transfer Y→A |
| TSX | Transfer SP→X |
| TXS | Transfer X→SP |
| INX | Increment X |
| INY | Increment Y |
| DEX | Decrement X |
| DEY | Decrement Y |
| INC | Increment memory |
| DEC | Decrement memory |

### 3.2.4 Vezérlésátadó utasítások (Branch/Jump)

| Mnemó | Feltétel | Leírás |
|-------|---------|--------|
| JMP | – | Feltétel nélküli ugrás |
| JSR | – | Szubrutinhívás |
| RTS | – | Visszatérés szubrutinból |
| RTI | – | Visszatérés megszakításból |
| BCC | C=0 | Branch if Carry Clear |
| BCS | C=1 | Branch if Carry Set |
| BEQ | Z=1 | Branch if Equal (Zero) |
| BNE | Z=0 | Branch if Not Equal |
| BPL | N=0 | Branch if Plus (Positive) |
| BMI | N=1 | Branch if Minus (Negative) |
| BVC | V=0 | Branch if Overflow Clear |
| BVS | V=1 | Branch if Overflow Set |

**Branch hatótávolság:** max ±127 byte (relatív cím)

### 3.2.5 Veremkezelő utasítások (Stack)

| Mnemó | Leírás |
|-------|--------|
| PHA | Push Accumulator |
| PLA | Pull (Pop) Accumulator |
| PHP | Push Processor Status |
| PLP | Pull Processor Status |

Stack: $0100–$01FF, SP csökken lefele (PHA: SP--, majd ír; PLA: olvas, majd SP++)

### 3.2.6 Léptető utasítások (Shift/Rotate)

| Mnemó | Leírás |
|-------|--------|
| ASL | Arithmetic Shift Left (C ← bit7, bit0 ← 0) |
| LSR | Logical Shift Right (C ← bit0, bit7 ← 0) |
| ROL | Rotate Left through Carry |
| ROR | Rotate Right through Carry |

Operandus: A vagy memória cím

### 3.2.7 Logikai utasítások

| Mnemó | Leírás |
|-------|--------|
| AND | Logical AND (bit törlés) |
| ORA | Logical OR (bit beállítás) |
| EOR | Exclusive OR (bit toggle) |
| BIT | Bit Test: N=bit7, V=bit6, Z=(A AND mem)==0 |

### 3.2.8 Aritmetikai utasítások

| Mnemó | Leírás |
|-------|--------|
| ADC | Add with Carry (A = A + M + C) |
| SBC | Subtract with Borrow (A = A − M − (1−C)) |

**FONTOS:** ADC előtt `CLC`, SBC előtt `SEC`!

### 3.2.9 Összehasonlító utasítások

| Mnemó | Leírás |
|-------|--------|
| CMP | Compare Accumulator (jelzők beállítása, A nem változik) |
| CPX | Compare X Register |
| CPY | Compare Y Register |

Eredmény: Z=1 ha egyenlő, C=1 ha A>=M (unsigned), N=1 ha A<M

---

## 4. Software Eszközök

### 4.1 HELP+ Assembly eszközök
- BASIC interpreter alapú rendszer
- `SYS` cím → betöltési mechanizmus
- Forrás kód BASIC formátumban (sorszámokkal)
- `/ASS` = assembly forrás, `/MC` = gépi kód változat

### 4.2 Makróassembler fejlesztő rendszer C-64-re
- Makró definíció és hívás
- Feltételes assembly
- Helyi és globális labelek
- Kifejezés kiértékelő
- Listing és szimbólumtábla generálás

### 4.3 PROFIMAT
- Interaktív assembly fejlesztő rendszer
- Forrásszerkesztő, assembler, linker integrálva
- Label és szimbólum kezelés

### 4.4 SM-KIT 64
- Moduláris assembly rendszer
- Több fájlos projektek

### 4.5 PTD Interaktív Debugger
Funkciók:
- Program modulonkénti végrehajtás (léptetés)
- Szimbólum kezelés
- Kód foltoz (patch)
- Memória kezelés
- Program nyomkövetés (trace)
- DOS kiegészítés (lemez parancsok)
- Kód-foltoz (code patching)

**PTD parancsok (kivonat):**
| Parancs | Leírás |
|---------|--------|
| `B` | Breakpoint beállítás |
| `G addr` | Go – futtatás indítás |
| `S` | Single step (egy lépés) |
| `T` | Trace mód |
| `R` | Regiszter megjelenítés |
| `M addr` | Memória megjelenítés |
| `A addr` | Assembly módban írás |
| `D addr` | Disassembly megjelenítés |

---

## 5. Programozási Módszerek

### 5.1 Memóriagazdálkodás

**C64 memóriatérkép (rövid):**

| Cím | Tartalom |
|-----|---------|
| $0000–$00FF | Zero page |
| $0100–$01FF | Stack |
| $0200–$03FF | OS munkaterület |
| $0400–$07FF | Képernyő/Sprite (default) |
| $0800–$9FFF | BASIC program / szabad RAM |
| $A000–$BFFF | BASIC ROM |
| $C000–$CFFF | Szabad RAM (gépi kódhoz) |
| $D000–$DFFF | VIC/SID/CIA/Color RAM/Char ROM |
| $E000–$FFFF | KERNAL ROM |

**Memória foglalás módjai:**
1. Fix cím (pl. $C000) – egyszerű, de nem hordozható
2. BASIC memória csökkentése (POKE 55/56) – BASIC-kompatibilis
3. KERNAL top memory lekérdezés ($FF99 MEMTOP)

### 5.2 Assembly Módszerek

**Moduláris programozás:**
- Részprogramok (szubrutinok) JSR-rel hívva
- Paraméter átadás: regisztereken (A, X, Y), zero page-en, stacken
- Visszatérési érték: akkumulátorban vagy jelzőkkel

**Optimalizálási technikák:**
- Zero page változók → gyorsabb hozzáférés
- Loop unrolling (ciklusok kitekerése)
- Look-up táblák a komplex számításokhoz
- Bitmanipuláció instead of multiply/divide by 2

**Példa – képernyő törlés:**
```asm
LDA #$20        ; space karakter
LDX #0
clear:  STA $0400,X     ; sor 0
        STA $04FA,X     ; sor + 250
        STA $05F4,X     ; sor + 500
        STA $06EE,X     ; sor + 750
        INX
        CPX #250
        BNE clear
```

### 5.3 KERNAL Rutinok

**Legfontosabb KERNAL belépési pontok:**

| Cím | Rutin | Funkció |
|-----|-------|---------|
| $FFD2 | CHROUT | Karakter kiírás |
| $FFCF | CHRIN | Karakter beolvasás |
| $FFE4 | GETIN | Billentyűpuffer (nem várakozó) |
| $FFB7 | READST | Státusz olvasás |
| $FFBA | SETLFS | Logical File beállítás |
| $FFBD | SETNAM | Fájlnév beállítás |
| $FFC0 | OPEN | Fájl megnyitás |
| $FFC3 | CLOSE | Fájl bezárás |
| $FFC6 | CHKIN | Input csatorna nyitás |
| $FFC9 | CHKOUT | Output csatorna nyitás |
| $FFCC | CLRCHN | Csatorna reset |
| $FFD5 | LOAD | Betöltés (A=0:load, A=1:verify) |
| $FFD8 | SAVE | Mentés |
| $FF9F | SCNKEY | Billentyűzet scan |
| $FF81 | CINT | VIC inicializálás |

### 5.4 BASIC és Assembly Együttélés

**ML program hívása BASIC-ból:**
```basic
SYS 49152          : REM $C000 = 49152
SYS 828            : REM $033C (kazetta puffer)
```

**BASIC változó olvasása ML-ből:**
```asm
; Pointer a változóhoz: $45-$46 (VARPNT)
LDA ($45),Y    ; lebegőpontos érték olvasása
```

**ML → BASIC hívása:**
Ritkán szükséges; inkább shared memory (POKE/PEEK) vagy USR() javasolt.

### 5.5 Optimalizálási Módszerek

**Összehasonlítás BASIC vs ML teljesítmény:**
- Egyszerű számolás: ML ~100× gyorsabb mint BASIC
- Grafikai rutinok: ML ~50–200× gyorsabb

**Ciklus optimalizálás:**
```asm
; Lassabb (CMP, majd BNE)
        LDX #100
lp:     ; ... munka ...
        DEX
        CPX #0
        BNE lp

; Gyorsabb (DEX beállítja Z-t)
        LDX #100
lp:     ; ... munka ...
        DEX
        BNE lp    ; DEX állítja a Z flagot!
```

**Mutatás optimalizálás:**
```asm
; Közvetlen cím: 4 ciklus
LDA $D020

; Zero page (ha $20 = $20): 3 ciklus
LDA $20       ; ha $20 ↔ $D020 (pointer)
```

---

## Függelékek

### A. Függelék: MOS 6510 Utasításkészlet

Teljes utasításkészlet táblázatban: opcode hex, összes cím mód, flag hatások, ciklus számok.

(Részletes táblázat a `6502 Opcodes.notes.md` és `6502 Instruction Set.notes.md` fájlokban)

### B. Függelék: KERNAL Szubrutinok

Cím lista az összes KERNAL belépési ponthoz, bemeneti/kimeneti paraméterekkel.

### C. Függelék: C64 Memóriakiosztás

Teljes memóriatérkép $0000–$FFFF, minden területhez magyarázat.