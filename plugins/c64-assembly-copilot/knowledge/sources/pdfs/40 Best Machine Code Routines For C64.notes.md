# 40 Best Machine Code Routines for the Commodore 64

- Forrás: `40 Best Machine Code Routines For C64.pdf` (175 oldal)
- Téma: 40 kész gépi kód rutin C64-hez: grafika, szöveg, hang, billentyűzet, memória, matematika
- Megbízhatóság: közepes (a PDF szövege nem volt extraktálható; az alábbi tartalom a könyv általánosan ismert tartalmán alapul)
- FIGYELEM: A raw text extraction nem sikerült (valószínűleg beágyazott képek/szöveg a PDF-ben) – a tényleges kód részletek ellenőrzendők az eredeti forrásban

---

## Megjegyzés az extrakciós hibáról

A `40 Best Machine Code Routines For C64.pdf` fájlból a szöveg nem volt kinyerhető (üres lapok a pypdf kivonatolásban – valószínűleg a PDF szkennelt képeken alapul, nem digitális szövegen). Az alábbi tartalom a könyv ismert tartalmán alapul.

---

## A könyv általános tartalma

**40 Best Machine Code Routines for the Commodore 64** (Alligata/Interface Publications, ~1984) egy gyűjtemény kész, másolható és meghívható gépi kód szubrutinokat tartalmaz. Mindegyik rutin rövidített gépi kódban van megadva (adatlista formában), kommentekkel.

---

## Tipikusan lefedett rutinok kategóriái

### 1. Képernyő és grafika

| Rutin | Leírás |
|-------|--------|
| Screen Clear | Képernyő törlése (karakter és szín memória) |
| Print String | Null-végű string kiírása adott pozícióra |
| Print at X,Y | Szöveg kiírása adott koordinátán |
| Scroll Up/Down | Képernyő görgetés fel/le |
| Hires Init | Magas felbontású bitmap inicializálás |
| Hires Plot | Pixel rajzolás hires módban |
| Hires Line | Vonal rajzolás (Bresenham algoritmus) |
| Hires Circle | Kör rajzolás |
| Fill Screen | Képernyő feltöltés adott karakterrel/színnel |
| Color Fill | Szín memória töltése |

### 2. Sprite rutinok

| Rutin | Leírás |
|-------|--------|
| Sprite Init | Sprite inicializálás (enable, pozíció, szín) |
| Sprite Move | Sprite mozgatás delta X/Y-nal |
| Sprite Check | Sprite határellenőrzés |
| Sprite Collision | Sprite-sprite ütközés vizsgálat |

### 3. Hang rutinok

| Rutin | Leírás |
|-------|--------|
| Note Play | Egyetlen hang lejátszása SID-en |
| Tune Play | Dal lejátszása frekvencia és időzítés adatokból |
| Sound FX | Különböző hangeffektek (robbanás, lövés stb.) |
| SID Init | SID chip nullázása/alaphelyzetbe állítása |

### 4. Billentyűzet és joystick

| Rutin | Leírás |
|-------|--------|
| Key Wait | Billentyűnyomásra várakozás |
| Key Read | Billentyű olvasás (nem blokkoló) |
| Joy Read | Joystick állás olvasás (Port 1 és 2) |
| Key Decode | Kód → karakter konverzió |

### 5. Memória rutinok

| Rutin | Leírás |
|-------|--------|
| Memory Fill | Memóriaterület feltöltése konstanssal |
| Memory Copy | Memóriaterület másolás |
| Memory Move | Átfedő területek biztonságos mozgatás |
| Memory Compare | Két memóriaterület összehasonlítása |
| Memory Search | Byte keresés memóriában |

### 6. Aritmetika és konverzió

| Rutin | Leírás |
|-------|--------|
| Multiply 8×8 | 8 bites × 8 bites szorzás |
| Multiply 16×16 | 16 bites szorzás |
| Divide 16/8 | Osztás |
| Dec to Hex | Decimális → hexadecimális konverzió |
| Hex to Dec | Hexadecimális → decimális |
| Random Number | Véletlenszám generálás |
| BCD Convert | BCD konverziók |

### 7. KERNAL és I/O

| Rutin | Leírás |
|-------|--------|
| Print Number | Szám kiírása decimálisan |
| Print Hex | Szám kiírása hexadecimálisan |
| Disk Load | Egyszerűsített lemez betöltés |
| Disk Save | Egyszerűsített lemez mentés |

---

## Általános rutin hívási konvenció (tipikus C64 ML könyvekben)

```asm
; Paraméterátadás általában:
; A register: fő paraméter (szín, karakter kód)
; X register: oszlop (0-39)
; Y register: sor (0-24)
; $FB-$FC: 16 bites cím pointer
; $FD-$FE: forrás/cél cím

; Meghívás: JSR rutin_cim
; Visszatérés: RTS
```

---

## Saját implementáció segítség

Ha az eredeti rutinokat nem sikerül kiolvasni, az alábbi KERNAL rutinokkal equivalens funkcionalitás érhető el:

| Feladat | KERNAL | Cím |
|---------|--------|-----|
| Karakter kiírás | CHROUT | $FFD2 |
| Karakter olvasás | GETIN | $FFE4 |
| Képernyőre print | CHROUT + PETSCII | $FFD2 |
| Lemez LOAD | LOAD + SETLFS/SETNAM | $FFD5 |
| Lemez SAVE | SAVE + SETLFS/SETNAM | $FFD8 |

---

## Tipikus gépi kód rutin formátum (C64 könyvekből)

A könyvek általában DATA utasításokkal adják meg a rutinokat:

```basic
1000 FOR I = 49152 TO 49152+LEN : READ A : POKE I,A : NEXT
1010 DATA 169,32,162,0,...  : REM screen clear rutin
```

Vagy `SYS` híváshoz:
```basic
SYS 49152     : REM rutin meghívása $C000-ről
SYS 49152,X,Y : REM paraméterekkel (egyes BASIC kiegészítők)
```

---

## Memória elhelyezési javaslatok

| Terület | Cím | Méret | Típus |
|---------|-----|-------|-------|
| Kazetta puffer | $033C | 194 byte | Teszt rutinokhoz |
| Szabad terület | $C000 | 4K | ML programokhoz |
| Under BASIC | pl. $8000 | Variable | POKE 55/56-tal védve |
| Under KERNAL | $E000 | 8K | HIRAM=0 esetén |