# PAL 64 – Personal Assembly Language assembler manuál

- Forrás: `pal.pdf` (35 oldal)
- Téma: PAL 64 – C64/6510-es assembler program (Brad Templeton, Pro-Line Software, 1983)
- FONTOS: Ez NEM a PAL videó szabványról szól! Ez egy 6510 assembler program manuálja.
- Megbízhatóság: magas
- Érdemes nézni: PAL 64 szintaxis, pseudo-op-ok, kifejezés kiértékelés, relokálható output, szimbólumtábla kezelés

---

## Tartalom

1. Introduction to PAL 64
2. Basics of Using PAL
3. Source Line Format
4. Expressions
5. Pseudo-ops
6. Error Messages
7. More Notes
- Appendix A: PAL Environment
- Appendix B: Internal Routine Vectors
- Appendix C: PAL Memory Maps
- Appendix D: Converting CBM/MOS Assembler to PAL
- Appendix E: Extra Files
- Appendix F: The Relocatable Object PAL
- Appendix G: The PAL Relocating Loader

---

## 1. Bevezetés

A PAL 64 egy 6510 assembler a Commodore 64-hez. Kb. 4 KB méretű, elfér ROM-ban vagy a memória tetején. MOS Assembler Standard-et követ (Commodore szabvány). Nem makro assembler.

Fő jellemzők:
- BASIC formátumú forrás fájlok (sorszámozott sorok)
- RUN-nal indul az assembly (SYS 700 az első sorban)
- Top of memory-ba tölti magát (pointerek: $37/$38, zero page)
- POWER 64-gyel kombinálható egy 8K blokkban

---

## 2. Használat alapjai

### Betöltés és indítás
```
LOAD "PAL",8
RUN
```
PAL self-relocating: betöltés után mindig a `$9000` alá igazítja magát, frissíti a top of memory pointert.

Hívás PAL-ból: `SYS 700` – ez az első forrássor minden PAL programban.

### Egyszerű assembly példa
```asm
10 SYS 700
20 .OPT P,OO
22 ;SAMPLE TEST PROGRAM
25 *=$C000
30 LDX #0
40 LOOP LDA 0,X   ;GET BYTE FROM ZERO PAGE
50 STA $400,X    ;STORE IT IN SCREEN MEMORY
60 INX
70 BNE LOOP
80 RTS
```
`.OPT P` = listing nyomtatás; `.OPT OO` = object code a kijelölt helyre; `*=$C000` = program counter beállítás.

### Two-pass assembly
- **Pass 1**: Szimbólumok értékelése, byteszámolás, program counter meghatározás
- **Pass 2**: Gépi kód generálás, listing előállítás, kifejezések teljes kiértékelése
- STOP leállítja az assembly-t

---

## 3. Forrássor formátum

```
LABEL OP OPERAND;COMMENT
```

- Szabad formátum (free form) – MOS standard
- Sorok: ugyanolyan mint BASIC, sorszám + tartalom
- Indentálás: `^` (up-arrow) karakterrel lehetséges a sor elején (BASIC editor törli a vezető szóközöket)
- Több utasítás egy sorban: kettősponttal elválasztva `PLA:PLA`
- Komment: pontosvessző után

### Labelek
- Legfeljebb 8 karakter számít (hosszabb label = csak első 8 egyezik)
- Első karakter: betű; többi: betű vagy szám
- Nem lehet mnemonic (LDA, STA, stb.) és nem lehet `A` (accumulator)
- Egyedülálló label sor nem megengedett – `LABEL = *` helyette

### Addressing mode szintaxis

| Szintaxis | Mód | Példa |
|-----------|-----|-------|
| `#expr` | Immediate | `LDA #10` |
| `expr` | Absolute/relative | `JSR SUBRU` |
| `A` | Accumulator | `ASL A` |
| `expr,x` | Indexed X | `LDA TABLE,X` |
| `expr,y` | Indexed Y | `LDA TAB2,Y` |
| `(expr,x)` | Pre-indexed indirect | `LDA (PTAB,X)` |
| `(expr),y` | Post-indexed indirect | `LDA (PTR),Y` |
| `(expr)` | Indirect (JMP only) | `JMP (VECTOR)` |

PAL automatikusan zero page módra optimalizál ahol lehet.

---

## 4. Kifejezések

PAL 16 bites értékekkel dolgozik. Kiértékelés **balról jobbra** (nem precedencia alapján!). `5+4*3 = 27` PAL-ban (BASIC-ben 17 lenne).

### Term típusok

| Típus | Szintaxis | Példa |
|-------|-----------|-------|
| Decimális | szám | `LDA #10` |
| Hexadecimális | `$` prefix | `JSR $FFD2` |
| Bináris | `%` prefix | `ORA #%00000010` |
| Program counter | `*` | `JMP *` |
| Karakter | `"A"` | `LDA #"A"` |
| Label | symbolname | `JSR SUBRTN` |
| Zárójelezett | `(expr)` | `LDA ($100+4)` |
| Negált | `-term` | `LDA #-1` |
| User expression | `@` | egyéni rutin hívás |

### Operátorok

| Op | Hatás |
|----|-------|
| `+` | Összeadás |
| `-` | Kivonás |
| `*` | Szorzás |
| `!` | Logikai VAGY |
| `&` | Logikai ÉS |
| `^` | XOR |
| `>` | Jobbra shift (pl. `SIZE>3` = osztás 8-cal) |
| `<` | Balra shift |

### Modifierek (az egész kifejezés elejére kerülnek)

| Modifier | Hatás |
|----------|-------|
| `<expr` | Alsó byte (lo byte) – kb. `expr & $FF` |
| `>expr` | Felső byte (hi byte) – kb. `expr >> 8` |
| `!expr` | Kényszerített absolute addressing (nem zero page) |

---

## 5. Pseudo-op-ok

### `=` – Szimbólum értékadás (egyszer)
```asm
SCREEN = $0400
```

### `_` – Újra értékelhető értékadás (mind két pass-on)
```asm
COUNT _ COUNT-1
CURRENT _ *
```

### `*=` – Program Counter beállítás
```asm
*=$C000         ; program origin
TABLE *=*+256   ; 256 bájt helyfoglalás
```

### `.BYTE` – Bájt értékek beírása
```asm
.BYTE $2C,$00,$EA
.BYTE <ADDRESS,>ADDRESS
```

### `.WORD` – Szó (2 bájt) beírása little-endian sorrendben
```asm
.WORD $1234    ; -> $34, $12 a memóriában
```

### `.FILE` – Következő forrásfájl betöltése (chaining)
```asm
.FILE 8,"0:PART2"
```

### `.IF` – Feltételes assembly
```asm
1000 .IF COL80:.GOTO 1050
```

### `.GOTO` – Feltétel nélküli ugrás soron belül
```asm
.GOTO 40
```
Leginkább `.IF`-fel kombóban.

### `.GTB` – Visszatérés BASIC-be
PAL zero page-t swap-olja. Visszatérés: `SYS PEEK(701)*256+PEEK(702)-6`

### `.ASC` – ASCII string beírása
```asm
STRING .ASC "HELLO"
STRLEN = * - STRING
```

### `.SYS` – Subrutin hívás assembly közben
```asm
.SYS MYCHECK
```

### `.STM` – Szimbólumtábla minimum cím
Pl. `.STM $3000`

### `.SST` / `.LST` – Szimbólumtábla mentése/betöltése
```asm
.SST 8,2,"0:SYMBOLS,S,W"
.LST 8,2,"0:SYMBOLS,S,R"
```
Hasznos: CBM 64 ROM belépési pontok és zero page szimbólumok újrafelhasználásához.

### `.END` – Forrásfájl vége
```asm
.END 8,"0:MAIN"   ; pass 1 végén a MAIN-re ugrik pass 2-höz
```

### `.OPT` – Output opciók
| Opció | Leírás |
|-------|--------|
| `P` | Listing a képernyőre |
| `P#` | Listing CBM fájlra (pl. `P4` = printer) |
| `P=addr` | Listing egyéni rutinra |
| `O` | Object code bufferbe |
| `OO` | Object code origined helyre |
| `OF,dev,sa,name` | Object code fájlba |
| `OB,dev,sa,name` | Object code PRG fájlba (2 bájtos fejléc) |
| `OR` | Relokálható output |

---

## 6. Hibaüzenetek (fontosabbak)

| Hiba | Ok |
|------|----|
| SYNTAX | Helytelen szintaxis |
| UNDEF SYMBOL | Nem definiált szimbólum pass 2-ben |
| REDEF | Szimbólum újradefiniálása (= pseudo-op-pal) |
| PHASE | Zero page/absolute mismatch pass 1 és 2 között |
| ILL QUANT | Illegális érték (pl. szorzás overflow) |
| SYM TABLE OVF | Szimbólumtábla megtelt |

---

## Appendix összefoglalók

### Appendix B: Internal Routine Vectors
PAL belső rutinjaihoz jump table az assembler elejétől -6 byte-nál. Visszatérés PAL-ba: `SYS PEEK(701)*256+PEEK(702)-6`

### Appendix C: PAL Memory Map
- PAL a top of memory alá töltődik ($9000 alatt ha BASIC $A000-nál van)
- Zero page: PAL saját változói (swap-olva van BASIC bufferbe assembly közben)
- Page 2 ($200): BASIC input buffer – PAL zero page swap helye

### Appendix D: CBM/MOS -> PAL konverzió
Fő különbség: `.ASC` kell string literálokhoz (`.BYTE "ABC"` nem megy PAL-ban)

### Appendix F: Relokálható output (PAL.R)
PAL.R fájl: FLOADER-rel tetszőleges helyre tölthető. Pure code: ROM-ba is érhető.

### Appendix G: Relocating Loader (FLOADER)
Relokálható objektumfájl tetszőleges helyre töltése.
