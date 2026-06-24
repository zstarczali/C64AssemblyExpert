# Exomizer — C64 Tomorito Eszkoz

**Szerzo:** Magnus Lind  
**Forrasok:**  
- https://github.com/bitshifters/exomizer (1.1.5 forrasfajlok)  
- https://bitbucket.org/magli143/exomizer/wiki/Home (v3 wiki — JS-rendered, kozvetlenul nem fetchelheto)  
- http://www.codebase64.pokefinder.org/doku.php?id=crossdev:exomizer_level_compress_decompression_for_beginners (lasd codebase64 helyi archivum)

---

## Mi az Exomizer?

Cross-platform C64/C16/+4 fajl-tomorito. Nem generikus archivalo, hanem .prg fajlok tomoritesehez optimalizalt cruncher.

**Felhasznalasi teruletek:**
- .prg fajlok meretcsokkentese lemezre
- Onfelho-tomorito fajlok letrehozasa (self-extracting)
- Memoria-ban levo adatteruletek tomorbitese
- Tobb fajl egyetlen kimeneti fajlba linkelse

**Elonyei versenytarsakkal szemben (PuCrunch, ByteBoiler+RLE):**
- Jobb tomoritesi arany
- Hatekony RLE-szekvencia-kezeles
- Hobinya: lassu (akár tobb perc, ~50 MB RAM felhasznalasaval)

---

## Verzio 1.1.5 — Parancsori Hasznalat

### Alap tomorites

```
exomizer mem -l $2000 mypic.prg,$6000 -o mypackedpic.prg
```

Betolti `mypic.prg`-t `$6000`-re, tomoriti, kimenetet `$2000`-re cimezi.

**Exomizer v3 esetén:** a parancs végéhez add hozzá: `-P0`

### Fontos kapcsolok

| Kapcsolo | Funkcioja |
|---------|-----------|
| `-l <addr>` | Kimeneti cim (ahol a tomorited adat kezdodik) |
| `-o <file>` | Kimeneti fajlnev |
| `-p <n>` | Optimalizalasi menetek szama korlatozasa (gyorsabb, gyengebb) |
| `-s sys` | BASIC SYS parancs utani cim hasznalata |
| `-q` | Csendes mod |

---

## Zero Page Hasznalat (1.1.5 Decruncher)

A `exodecrunch.s` ezeket a zero page cimeket foglalja:

| ZP cim | Valtozo neve | Cel |
|--------|-------------|-----|
| `$A7` | `zp_len_lo` | Sorozat hosszanak also bajtja |
| `$AE` | `zp_src_lo` | Forras pointer (lo) |
| `$AF` | `zp_src_hi` | Forras pointer (hi) |
| `$FC` | `zp_bits_hi` | Bitek magas bajtja |
| `$FD` | `zp_bitbuf` | Bit-puffer |
| `$FE` | `zp_dest_lo` | Cel pointer (lo) |
| `$FF` | `zp_dest_hi` | Cel pointer (hi) |

**Fontos:** Ellenorizd, hogy ezek nem utköznek a programodban hasznalt ZP valtozokkal.

---

## Decruncher Beagyas — Elvi Menete

```asm
; (ACME / C64Studio peldakod)
sei
ldx #<PackedDataEnd    ; a tomorited adat VEGE (nem eleje!)
ldy #>PackedDataEnd
stx $c010              ; exomizer depack cim low  (forraskodban: zp_src_lo toltese)
sty $c011              ; exomizer depack cim high
jsr $c000              ; hivas a decruncher beleptesi pontjara

*=$2000
PackedDataStart:
!binary "mypackedpic.prg",,2
PackedDataEnd:
```

**Megjegyzes:** a decruncher VISSZAFELE dolgozik (magasabb cimektol az alacsonyabb fele), ezert a VEGE cimet adjuk meg, nem az elejeet.

### Memoriabank Beallitas

A `$01` regiszter erteket kell beallitani a dekruncholasi celtol fuggoen:
- `#$35` — KERNAL + BASIC ROM lathatoak, I/O is latható
- `#$36` — csak KERNAL ROM, I/O latható
- `#$37` — minden ROM latható, I/O latható

---

## exodecrunch.s — Teljes Forrasfajl (ca65 szintaxis)

```asm
;
; Copyright (c) 2002, 2003 Magnus Lind.
; Zlib-szerű licenc — szabad felhasználás, módosítás, terjesztés megengedett.
;
; get_crunched_byte: a decruncher ezt hívja, amikor tömörített byte-ot akar olvasni.
; Meg kell őriznie X és Y regisztert, és NEM módosíthatja a carry flaget.
;
.import get_crunched_byte

; A fő decruncher exportja:
.export decrunch

; Zero page cimek:
zp_len_lo  = $a7
zp_src_lo  = $ae
zp_src_hi  = zp_src_lo + 1
zp_bits_hi = $fc
zp_bitbuf  = $fd
zp_dest_lo = zp_bitbuf + 1
zp_dest_hi = zp_bitbuf + 2

tabl_bi = decrunch_table
tabl_lo = decrunch_table + 52
tabl_hi = decrunch_table + 104

; JSR ide a dekruncholashoz (inicializalja a tablakatés meghivja a dekruncsert)
; Decimal flag = 0 kell! (szinte mindig az, de ha nem: CLD)
decrunch:
    ldy #0
    ldx #3
init_zp:
    jsr get_crunched_byte
    sta zp_bitbuf - 1,x
    dex
    bne init_zp

nextone:
    inx
    tya
    and #$0f
    beq shortcut
    txa
    lsr a
    ldx tabl_bi-1,y
rolle:
    rol a
    rol zp_bits_hi
    dex
    bpl rolle
    adc tabl_lo-1,y
    tax
    lda zp_bits_hi
    adc tabl_hi-1,y
shortcut:
    sta tabl_hi,y
    txa
    sta tabl_lo,y
    ldx #4
    jsr get_bits
    sta tabl_bi,y
    iny
    cpy #52
    bne nextone
    ldy #0
    beq begin

get_bits:
    lda #$00
    sta zp_bits_hi
    cpx #$01
    bcc bits_done
bits_next:
    lsr zp_bitbuf
    bne ok
    pha
literal_get_byte:
    jsr get_crunched_byte
    bcc literal_byte_gotten
    ror a
    sta zp_bitbuf
    pla
ok:
    rol a
    rol zp_bits_hi
    dex
    bne bits_next
bits_done:
    rts

copy_next_hi:
    dex
    dec zp_dest_hi
    dec zp_src_hi
copy_next:
    dey
    lda (zp_src_lo),y
literal_byte_gotten:
    sta (zp_dest_lo),y
copy_start:
    tya
    bne copy_next
begin:
    txa
    bne copy_next_hi
    dey
begin2:
    inx
    jsr bits_next
    lsr a
    iny
    bcc begin2
    beq literal_start
    cpy #$11
    bcs bits_done
    ldx tabl_bi - 1,y
    jsr get_bits
    adc tabl_lo - 1,y
    sta zp_len_lo
    lda zp_bits_hi
    adc tabl_hi - 1,y
    pha
    bne nots123
    ldy zp_len_lo
    cpy #$04
    bcc size123
nots123:
    ldy #$03
size123:
    ldx tabl_bit - 1,y
    jsr get_bits
    adc tabl_off - 1,y
    tay
    lda zp_len_lo
literal_start:
    sbc zp_dest_lo
    bcc noborrow
    dec zp_dest_hi
noborrow:
    eor #$ff
    sta zp_dest_lo
    cpy #$01
    bcc literal_get_byte
    ldx tabl_bi,y
    jsr get_bits
    adc tabl_lo,y
    bcc skipcarry
    inc zp_bits_hi
    clc
skipcarry:
    adc zp_dest_lo
    sta zp_src_lo
    lda zp_bits_hi
    adc tabl_hi,y
    adc zp_dest_hi
    sta zp_src_hi
    pla
    tax
    ldy zp_len_lo
    bcc copy_start

tabl_bit:
    .byte 2,4,4
tabl_off:
    .byte 48,32,16

decrunch_table:
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,0
```

**Megjegyzes:** Ez ca65 szintaxis. Kick Assembler-re portolashoz:
- `.import` → nincs szukseg, direktbe beillesztheto
- `.export` → nincs szukseg  
- `.byte` → `.byte` (Kick Assembler-ben is megy)
- A `get_crunched_byte` egy user-defined szubrutin — neked kell megirni, ami visszafele olvassa a tomorited adatot

---

## ExoBasic 1.0b2 — BASIC Programok Optimalizalasa Tomorites Elott

Az `exobasic` eszkoz BASIC programokat optimalizal a jobb tomorites erdekeben:

| Kapcsolo | Muvelet | Megjegyzes |
|---------|---------|-----------|
| `-n<n>,<m>` | Sorok atsz'amozasa, <n>-tol <m> lepeskozzel | Jobb tomorithetoseg |
| `-N` | Extreme atsz'amozas (sok sor → 0) | Sokkal jobb tomorites |
| `-p` | Link-ertek csereje optimalizalt ertekre | Mivel a BASIC betoltesekor a linkeket regeneralja |
| `-t` | Trambulin (ML startup rutin) hozzaadasa | Automatikusan kezeli az inicializalast |
| `-r` | REM sorok torlese (GOTO/GOSUB targetek megtartasaval) | |
| `-c` | Szintablazat regeneralasa (C16/+4-hez, `-t -4`-gyel) | |

---

## Verzio Tortenelem (Fontos Merek)

| Datum | Verzio | Fontosabb valtozas |
|-------|--------|-------------------|
| 2004-10-03 | **1.1.5** | Jobb RLE, bugfixek a decruncher safety marginra es -ssys-re |
| 2003-06-14 | 1.1.2 | exobasic eszkoz, dual stream decruncher, cc65 peldak |
| 2003-01-25 | 1.1.1 | Safety buffer csokkentese, decruncher 1 byte-tal rovidebb |
| 2002-12-30 | 1.1.1b1 | Hex prefix ($) tamogatas, fajl-relokacio |
| 2002-05-01 | 1.0 | Elso stabil kiad'as, decrunch memoriahiba javitva |
| 2002-03-06 | 1.0beta1 | Elso beta, ca65 forrasfajlok |

---

## Megjegyzes a Helyi Archivumhoz

A Codebase64 helyi tukoeben mar megvan:
- `crossdev__exomizer_level_compress_decompression_for_beginners.txt` — kezdoknek szolo utmutato
- `base__exomizer_adding_decrunch_splash_screens_during_sfx_decrunch.txt` — splash screen decrunching
- `base__exomizer_making_custom_oldschool_decrunch_effects.txt` — egyedi decrunch effektek

**Exomizer 3 (legujabb verzio) dokumentacioja:** https://bitbucket.org/magli143/exomizer/wiki/Home  
(JavaScript-rendelt oldal, kezzel kell megnyitni)
