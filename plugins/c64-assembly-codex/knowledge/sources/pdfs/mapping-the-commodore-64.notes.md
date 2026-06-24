# Mapping the Commodore 64 & 64C – Sheldon Leemon

- Forrás: `mapping-the-commodore-64.pdf` (340 oldal), szerző: Sheldon Leemon, COMPUTE! Publications, 1984/1987
- Téma: Teljes C64 memóriakiosztás – minden cím részletes leírása, Zero Page, BASIC ROM, KERNAL ROM, VIC-II, SID, CIA chipek, Color RAM, GEOS
- Megbízhatóság: magas (a legteljesebb C64 memóriakézikönyv)
- Érdemes nézni: bármely cím/rutin funkciójának meghatározásához; KERNAL rutinok; BASIC interpreter vektorok; GEOS memória

---

## Tartalom

| Fejezet | Tartalom | Oldal |
|---------|----------|-------|
| Introduction | Hogyan kell a könyvet használni, bináris/hex alapok | vii |
| Chapter 1 | Page 0 – Zero Page (0–255 / $00–$FF) | 1 |
| Chapter 2 | Page 1 – Stack, Pages 2–3 | 45 |
| Chapter 3 | Pages 2–3 – BASIC és KERNAL munkaterület | 49 |
| Chapter 4 | 1K–40K – Képernyő, Sprite pointerek, BASIC program | 79 |
| Chapter 5 | 8K BASIC ROM + 4K szabad RAM | 85 |
| Chapter 6 | VIC-II, SID, I/O eszközök, Color RAM, Karakter ROM | 119 |
| Chapter 7 | 8K KERNAL ROM | 203 |
| Chapter 8 | GEOS | 247 |
| Appendix A | Kezdők útmutatója a programok begépeléshez | 303 |
| Appendix B–H | Képernyőtáblázatok, ASCII kódok, Screen kódok, Keykódok | 305–317 |
| Index | Memória cím szerinti index | 318 |

---

## Bevezetés: Alapfogalmak

### Bit és Byte
- 1 bit = 0 vagy 1
- 8 bit = 1 byte (0–255)
- 2 byte = 1 word (0–65535)

### Lapok (Pages)
- 1 lap (page) = 256 byte
- Page 0 = $0000–$00FF, Page 1 = $0100–$01FF, stb.

### Bitmáskák
- **AND** – bitek törlése (kikapcsolás): `BYTE AND (255 - BITVALUE)`
- **OR** – bitek beállítása (bekapcsolás): `BYTE OR BITVALUE`
- **EOR** – bitek toggle-olása: `BYTE EOR BITVALUE`

### Pointer vs Vector
- **Pointer**: adatterület kezdetét mutatja
- **Vector**: gépi kódú rutin kezdetét mutatja

---

## Chapter 1: Zero Page ($00–$FF)

**Zero Page előnyei:** Zero page cím módban 1 byte cím elegendő (gyorsabb, kisebb kód).

### $0000 – 6510 DDR (Data Direction Register)
- Bit0–Bit5: 1=kimenet, 0=bemenet
- Alapértelmezés: $EF ($11101111 – Bit4 bemenet: kazetta switch)

### $0001 – 6510 I/O Port (R6510)
| Bit | Jel | Leírás |
|-----|-----|--------|
| 0 | LORAM | 0=RAM $A000-$BFFF-en, 1=BASIC ROM |
| 1 | HIRAM | 0=RAM $E000-$FFFF-en, 1=KERNAL ROM |
| 2 | CHAREN | 0=Karakter ROM $D000-$DFFF-en, 1=I/O eszközök |
| 3 | – | Kazetta Data Output |
| 4 | – | Kazetta Switch Sense (0=nyomva) |
| 5 | – | Kazetta Motor Control (1=be) |

**BASIC-ba való átmásolás ROM-ból:**
```basic
FOR I=40960 TO 49151 : POKE I, PEEK(I) : NEXT
POKE 1, PEEK(1) AND 254    : REM LORAM=0, RAM aktív
```

**Karakter ROM bekapcsolása:**
```basic
POKE 56333,127 : POKE 1, PEEK(1) AND 251    : REM I/O ki, Char ROM be
FOR I=0 TO 2048 : POKE BASE+I, PEEK(53248+I) : NEXT
POKE 1, PEEK(1) OR 4 : POKE 56333, 129      : REM I/O vissza
```

### $0002 – Nem használt

### $0003–$0004 – ADRAY1
Vector: Lebegőpontos → signed integer konverzió rutin ($B1AA)

### $0005–$0006 – ADRAY2
Vector: Integer → lebegőpontos konverzió rutin ($B391)

### $0007 – CHARAC
Keresési karakter a BASIC szöveg scanelésnél (idézőjel, kettőspont, vessző)

### $0008 – ENDCHR
Utasítás-lezáró karakter (0 vagy 34 általában)

### $0009 – TRMPOS
TAB/SPC előtti kurzorpozíció oszlop (0–79 logikai sor)

### $000A – AVERCK (VERCK)
Flag: LOAD (0) vagy VERIFY (1) – KERNAL felé adja tovább

### $000B – BCOUNT
Szövegbuffer index / tömb dimenziók száma

### $000C – DIMFLG
Flag: tömb keresés/létrehozás módja (DIM volt-e)

### $000D – VALTYP
Flag: 0=numerikus, $FF=string adat

### $000E – INTFLG
Flag: 0=lebegőpontos, $80=integer

### $000F – GARBFL
LIST, szemétgyűjtés és tokenizálás jelzője

### $0010 – SUBFLG
Flag: tömb index vagy FN hívás jelzés

### $0011 – INPFLG
Flag: $98=READ, $40=GET, 0=INPUT

### $0012 – TANSGN
SIN/TAN előjel jelzés; összehasonlítás eredmény (1=>, 2==, 4=<)

### $0013 – CHANNL
Aktuális I/O csatorna (CMD file szám); 0=képernyő

### $0014–$0015 – LINNUM
Cél sorszám (GOTO, GOSUB); PEEK/POKE/SYS cím

### $0016 – TEMPPT
Pointer: következő szabad hely az ideiglenes string stacken (25–34)

### $0017–$0018 – LASTPT
Utolsó string stack elem pointere

### $0019–$0021 – TEMPST
Ideiglenes string descriptor stack (3×3 byte, max 3 string)

### $0022–$0025 – INDEX1/INDEX2
Indirekt indexek (szubrutinokban)

### $0026–$002A – RESHO
FAC-1 szorzás/osztás maradék puffer

### $002B–$002C – TXTTAB
Pointer: BASIC program szöveg kezdete (alapértelm. $0801)

### $002D–$002E – VARTAB
Pointer: BASIC változók kezdete

### $002F–$0030 – ARYTAB
Pointer: BASIC tömb változók kezdete

### $0031–$0032 – STREND
Pointer: BASIC változók és tömbök vége

### $0033–$0034 – FRETOP
Pointer: következő szabad hely a string stack tetején (magas memória felé nő le)

### $0035–$0036 – FRESPC
String ideiglenes pointer

### $0037–$0038 – MEMSIZ
A legmagasabb RAM cím amelyet BASIC használ ($9FFF default)

### $0039–$003A – CURLIN
Aktuálisan végrehajtott BASIC sor száma ($FFFF = direkt mód)

### $003B–$003C – OLDLIN
Előző BASIC sor szám (CONT folytatáshoz)

### $003D–$003E – OLDTXT
Pointer: legutolsó futó BASIC utasítás (CONT folytatáshoz)

### $003F–$0040 – DATLIN
A legutóbb olvasott DATA utasítás sora

### $0041–$0042 – DATPTR
Pointer: következő DATA elem

### $0043–$0044 – INPPTR
INPUT rutin text pointer

### $0045–$0046 – VARNAM
Aktuális változónév (2 byte, pl. 'A'=0, 'B'=1...)

### $0047–$0048 – VARPNT
Pointer: változó érték a változótáblában

### $0049–$004A – FORPNT
Pointer: FOR loop változó (aktív ciklus)

### $004B–$004C – OPPTR
Aktuális aritmetikai operátor prioritása és rutinja

### $0061–$0066 – FAC1
Floating Point Accumulator 1 (lebegőpontos főakkumulátor, 5 byte)

### $0069–$006E – FAC2
Floating Point Accumulator 2

### $0071–$0072 – CHRGET / CHRGOT
BASIC szöveg karakter-olvasó rutin ($0073 a belépési pont, $0077 a no-skip változat)

### $0090 – STATUS (ST)
KERNAL I/O státusz byte

### $0091 – STKEY
Stop billentyű jelzője (a főciklus vizsgálja)

### $0093 – VERCK
LOAD (0) vagy VERIFY (1) – a KERNAL tárolja

### $0094 – C3PO
Soros bus byte puffer teljes flag

### $009B – BSOUR
Soros bus output byte

### $00A0–$00A2 – TIME
Három byte-os TOD (Time of Day) számláló (jiffy timer: 60×/sec)

### $00C5 – LSTX
Utoljára lenyomott billentyű scankód ($40 = nem nyomva)

### $00CB – NDX
Billentyűzetpuffer index (következő üres hely)

### $00D0 – BLNSW
Kurzor villogás bekapcsolva (0)/kikapcsolva (1)

### $00D1–$00D2 – PNTR / QTSW
$D1: kurzor aktuális sora ($D2: quotes mód flag)

### $00EB–$00F2 – Sprite Collision
Sprite-sprite és sprite-background ütközés regiszterek (másolt VIC-II adatok)

---

## Chapter 2: Page 1 – Stack ($0100–$01FF)

- 6510 hardver stack: $0100–$01FF
- SP (Stack Pointer) a legkisebb foglalt helyet mutatja
- JSR, PHA, PHP, interrupt mindannyian ide tolnak
- Stack "alulról" töltődik ($FF → $FE → ...)
- **Egyidejű JSR mélység** max. kb. 128 szint (2 byte/hívás)

---

## Chapter 3: Pages 2–3 ($0200–$03FF) – KERNAL munkaterület

### $0200–$0258 – BASIC Input Buffer
Billentyűzetről beolvasott sor puffere (88 byte)

### $0259–$0262 – LAT/FAT/SAT
Nyitott file-ok táblái (logical, first/secondary address)

### $0263–$026A – FNADDR
File nevek táblái (nevek a string területen)

### $028F – AUTORUN
Szalagos autorun flag

### $02A7–$02FF – Kazetta puffer I.

### $0314–$0315 – IRQ vektor (user)
Alapértelmezett: $EA31 (KERNAL keyboard scan + BASIC rutin)

```asm
SEI
LDA #<myirq
STA $0314
LDA #>myirq
STA $0315
CLI
```

### $0316–$0317 – BRK vektor
Alapértelmezett: $FE66 (monitor belépési pont)

### $0318–$0319 – NMI vektor
Alapértelmezett: $FE47 (RESTORE billentyű kezelő)

### $031A–$0333 – Egyéb KERNAL vektorok
Betölt/SAVE/OPEN/CLOSE/CHROUT stb. vektorok (újraírhatók saját rutinra)

### $033C–$03FB – Kazetta puffer II.
Szabad gépi kód területként is használható (194 byte)

---

## Chapter 4: 1K–40K – Képernyő és BASIC program

### $0400–$07E7 – Screen Memory (default)
1000 byte = 40×25 pozíció, screen code-ok (NEM ASCII!)

### $07F8–$07FF – Sprite pointers
Sprite 0..7 adatok kezdőcímének mutatói (cím = pointer × 64)

### $0800–$9FFF – BASIC program terület
- $0800–$0801: BASIC program megkezdése (SYS cím után)
- Felső határ: $MEMSIZ ($0037-$0038) tartalma

---

## Chapter 6: VIC-II ($D000–$D02E), SID ($D400–$D7FF), CIA-k, Color RAM

### VIC-II regiszterek: → lásd `VIC-II reference.notes.md` és `vic-ii.notes.md`

### SID ($D400–$D7FF) – Sound Interface Device
**3 hangcsatorna (Voice 1, 2, 3):**

| Offset | Leírás |
|--------|--------|
| $00–$01 | Voice 1 Frequency (lo/hi) |
| $02–$03 | Voice 1 Pulse Width (lo/hi, 12 bit) |
| $04 | Voice 1 Control Register |
| $05 | Voice 1 Attack/Decay |
| $06 | Voice 1 Sustain/Release |
| $07–$0D | Voice 2 (ugyanolyan struktúra) |
| $0E–$14 | Voice 3 (ugyanolyan struktúra) |
| $15–$16 | Filter Cutoff (lo/hi) |
| $17 | Filter Resonance + Route |
| $18 | Volume + Filter Mode |
| $19 | Paddle X |
| $1A | Paddle Y |
| $1B | Voice 3 Oscillator (olvasható) |
| $1C | Voice 3 Envelope (olvasható) |

**Voice Control Register ($D404/$D40B/$D412) bitek:**
| Bit | Leírás |
|-----|--------|
| 0 | Gate (1=indítás, 0=leállítás) |
| 1 | Sync |
| 2 | Ring Modulation |
| 3 | Test (hanggenerátor reset) |
| 4 | Triangle hullámforma |
| 5 | Sawtooth hullámforma |
| 6 | Pulse hullámforma |
| 7 | Noise hullámforma |

### CIA #1 ($DC00–$DCFF)
| Cím | Leírás |
|-----|--------|
| $DC00 | Port A – Billentyűzet matrix oszlopok / Joystick 2 |
| $DC01 | Port B – Billentyűzet matrix sorok / Joystick 1 |
| $DC02 | DDR A |
| $DC03 | DDR B |
| $DC04–$DC07 | Timer A/B (lo/hi) |
| $DC08–$DC0B | TOD (Time of Day: óra, perc, másodperc, tized) |
| $DC0D | Interrupt Control Register |
| $DC0E | Control Register A |
| $DC0F | Control Register B |

**Billentyűzet olvasás:**
```asm
LDA #%11111110   ; 0. oszlop vizsgálata
STA $DC00
LDA $DC01        ; sor adatok olvasása (0=lenyomva)
AND #1           ; RUNSTOP vizsgálata
```

### CIA #2 ($DD00–$DDFF)
| Cím | Leírás |
|-----|--------|
| $DD00 | Port A – RS-232 + VIC bank (bit1-0) |
| $DD01 | Port B – RS-232 adatok |
| $DD02 | DDR A |
| $DD0D | Interrupt Control |

**VIC bank váltás $DD00 bit1-0-val (invertálva):**
| Bitek | Bank |
|-------|------|
| 11 | Bank 0 ($0000–$3FFF) |
| 10 | Bank 1 ($4000–$7FFF) |
| 01 | Bank 2 ($8000–$BFFF) |
| 00 | Bank 3 ($C000–$FFFF) |

### Color RAM ($D800–$DBE7)
- 1000 byte (4 bit/byte, felső 4 bit nem definiált = 1)
- Nem mozgatható
- $D800 = 1. sor 1. karakter szín
- $D8E8-$DBFF: technikai terület (nem minden modellen)

---

## Chapter 7: KERNAL ROM ($E000–$FFFF)

### Fontos KERNAL belépési pontok:

| Cím | Rutin | Leírás |
|-----|-------|--------|
| $FF81 | CINT | Képernyő és VIC inicializálás |
| $FF84 | IOINIT | I/O eszközök inicializálása |
| $FF87 | RAMTAS | RAM méret teszt és inicializálás |
| $FF8A | RESTOR | Alapértelmezett vektorok visszaállítása |
| $FF8D | VECTOR | Vektorok olvasása/írása |
| $FF90 | SETMSG | Kernel üzenetek be/ki |
| $FF93 | SECOND | ATN + secondary address (soros busz) |
| $FF96 | TKSA | Timeout másodlagos cím |
| $FF99 | MEMTOP | RAM legfelső cím lekérés/beállítás |
| $FF9C | MEMBOT | RAM legalsó cím lekérés/beállítás |
| $FF9F | SCNKEY | Billentyűzet scan |
| $FFA2 | SETTMO | Soros busz timeout |
| $FFA5 | ACPTR | Soros busz byte fogadás |
| $FFA8 | CIOUT | Soros busz byte küldés |
| $FFAB | UNTLK | Soros busz UNLISTEN |
| $FFAE | UNLSN | Soros busz UNLISTEN |
| $FFB1 | LISTEN | Soros busz LISTEN |
| $FFB4 | TALK | Soros busz TALK |
| $FFB7 | READST | I/O státusz (ST) olvasása |
| $FFBA | SETLFS | Logical File set (A=LFN, X=dev, Y=SA) |
| $FFBD | SETNAM | Fájlnév pointer beállítás (A=len, X/Y=ptr) |
| $FFC0 | OPEN | Fájl megnyitás |
| $FFC3 | CLOSE | Fájl bezárás |
| $FFC6 | CHKIN | Bemeneti csatorna megnyitás |
| $FFC9 | CHKOUT | Kimeneti csatorna megnyitás |
| $FFCC | CLRCHN | Minden csatorna bezárása |
| $FFCF | CHRIN | Karakter olvasás az input csatornából |
| $FFD2 | CHROUT | Karakter írás az output csatornába |
| $FFD5 | LOAD | Fájl betöltés (A=0:load, A=1:verify) |
| $FFD8 | SAVE | Fájl mentés |
| $FFDB | SETTIM | Jiffy óra beállítás |
| $FFDE | RDTIM | Jiffy óra olvasás |
| $FFE1 | STOP | STOP billentyű vizsgálat |
| $FFE4 | GETIN | Billentyűzet karakter (nem várakozik) |
| $FFE7 | CLALL | Minden file bezárás, csatornák törlés |
| $FFEA | UDTIM | Jiffy óra frissítés (CIA timer) |
| $FFED | SCREEN | Képernyő méret (X=oszlopok, Y=sorok) |
| $FFF0 | PLOT | Kurzor pozíció get/set |
| $FFF3 | IOBASE | I/O eszközök alap cím lekérése |

### Reset/Interrupt vektorok:
| Cím | Leírás |
|-----|--------|
| $FFFA–$FFFB | NMI vektor |
| $FFFC–$FFFD | RESET vektor |
| $FFFE–$FFFF | IRQ/BRK vektor |

---

## Chapter 8: GEOS

GEOS (Graphic Environment Operating System) memóriatérképe kb. $0040-től felfelé; a legtöbb KERNAL vektor át van irva. GEOS nem tárgyalt részletesen ebben a kiadásban.

---

## Függelékek

### Appendix C: Screen Location Table
Képernyő pozíció → cím: `$0400 + (sor * 40) + oszlop`

### Appendix E: Screen Color Codes
| Szín | Kód |
|------|-----|
| Black | 0 |
| White | 1 |
| Red | 2 |
| Cyan | 3 |
| Purple | 4 |
| Green | 5 |
| Blue | 6 |
| Yellow | 7 |
| Orange | 8 |
| Brown | 9 |
| Light Red | 10 |
| Dark Gray | 11 |
| Medium Gray | 12 |
| Light Green | 13 |
| Light Blue | 14 |
| Light Gray | 15 |

### Appendix F: ASCII vs Screen Codes
- PETSCII és Screen Code különbség: nagybetűk, speciális karakterek eltérnek
- Pl. 'A' ASCII=65, Screen code=1