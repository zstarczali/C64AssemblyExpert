# Kick Assembler – Reference Manual

- Forrás: `KickAssembler.pdf` (78 oldal), szerző: Mads Nielsen
- Téma: Kick Assembler 65xx cross-assembler, JavaScript-szerű script nyelv, makrók, adatimport, C64 fejlesztés
- Megbízhatóság: magas (ez a PROJEKT DEFAULT ASSEMBLERJE)
- Érdemes nézni: szintaxis kérdésekhez, direktívák, makrók, script funkciók, adatgenerálás, import

---

## Tartalom

| Fejezet | Tartalom |
|---------|----------|
| 1 | Introduction |
| 2 | Getting Started |
| 3 | Basic Assembler Functionality |
| 4 | Introducing the Script Language |
| 5 | Branching and Looping |
| 6 | Data Structures |
| 7 | Functions and Macros |
| 8 | Preprocessor |
| 9 | Scopes and Namespaces |
| 10 | Import and Export |
| 11 | Modifiers |
| 12 | Special Features |
| 13 | Assemble Information |
| 14 | Testing |
| 15 | 3rd Party Java plugins |
| A | Quick Reference |
| B | Technical Details |
| C | Going from v3.x to 4.0 |

---

## 1. Bevezetés

Kick Assembler = MOS 65xx assembler + JavaScript-szerű script nyelv. Java platformon fut (Java 8+).

Főbb jellemzők:
- Illegális opcode-ok és DTV opcode-ok támogatása
- Makrók, pseudo commands
- SID fájl import
- Standard grafikai formátumok importálása
- 3rd party Java plugin support
- VICE emulátorral való integráció

Futtatás:
```bash
java -jar kickass.jar myCode.asm
java -jar kickass.jar -showmem myCode.asm
java -jar kickass.jar -execute "x64.exe --confirmexit" myCode.asm
```

`KickAss.cfg` fájl: default parancssori opciók (sorsoronként, `#` = komment).

---

## 2. Rövid példa – IRQ interrupt

```asm
BasicUpstart2(start)

        * = $4000 "Main Program"
start:  lda #$00
        sta $d020
        sta $d021
        lda #$00
        jsr $1000    // init music
        sei
        lda #<irq1
        sta $0314
        lda #>irq1
        sta $0315
        lda #$7f
        sta $dc0d
        sta $dd0d
        lda #$81
        sta $d01a     // raster IRQ enable
        lda #$1b
        sta $d011
        lda #$80
        sta $d012     // raster line $80
        lda $dc0d
        lda $dd0d
        asl $d019
        cli
        jmp *

irq1:   asl $d019
        SetBorderColor(2)
        jsr $1003    // play music
        SetBorderColor(0)
        jmp $ea81

        *=$1000 "Music"
        .import binary "ode to 64.bin"

.macro SetBorderColor(color) {
        lda #color
        sta $d020
}
```

---

## 3. Alapvető assembler funkciók

### Mnemonics
Több utasítás egy sorban: pontosvesszővel elválasztva (NEM `;` mint komment!):
```asm
lda #0; sta $d020; sta $d021
```

### Összes legális opcode + illegálisak is támogatva

Illegális opcode-ok (válogatás):

| Mnemo | Opcode(ok) | Leírás |
|-------|-----------|--------|
| ahx | $93,$9f | Store A AND X AND (addr_hi+1) |
| alr | $4b | AND then LSR |
| anc | $0b,$2b | AND imm, bit7 -> C |
| arr | $6b | AND then ROR |
| axs | $cb | A AND X - imm -> X |
| dcp | $c7,$d7... | DEC then CMP |
| isc | $e7,$f7... | INC then SBC |
| las | $bb | Stack AND M -> A,X,SP |
| lax | $ab,$a7... | LDA+LDX ugyanabból |
| rla | $27,$37... | ROL then AND |
| rra | $67,$77... | ROR then ADC |
| sax | $87,$97... | Store A AND X |
| slo | $07,$17... | ASL then ORA |
| sre | $47,$57... | LSR then EOR |

DTV opcode-ok (`-dtv` opció szükséges):

| Mnemo | Opcode | |
|-------|--------|-|
| bra | $12 | Branch Always |
| sac | $32 | Set A counter |
| sir | $42 | Set I register |

### Argument Types (addressing modes)

| Mód | Példa |
|-----|-------|
| No argument | `nop` |
| Immediate | `lda #$30` |
| Zeropage | `lda $30` |
| Zeropage,x | `lda $30,x` |
| Zeropage,y | `ldx $30,y` |
| Indirect zp,x | `lda ($30,x)` |
| Indirect zp,y | `lda ($30),y` |
| Absolute | `lda $1000` |
| Absolute,x | `lda $1000,x` |
| Absolute,y | `lda $1000,y` |
| Indirect | `jmp ($1000)` |
| Relative | `bne loop` |

Forced modes:
```asm
lda.abs $0040,x   // Kényszerített absolute mode
lda.a $0030,x     // Rövidítés: .a = .abs
stx.zp zpLabel,y  // Kényszerített zero page
stx.z zpLabel,y   // Rövidítés: .z = .zp
```

### Number Formats

| Prefix | Formátum | Példa |
|--------|----------|-------|
| (nincs) | Decimális | `lda #42` |
| `$` | Hexadecimális | `lda #$2a` |
| `%` | Bináris | `lda #%101010` |

### Labelek

```asm
loop:   inc $d020    // standard label (label:)
        jmp loop

        stx tmpX:#$00  // argument label (self-modifying)

!loop:  inc $d020    // multi label (!label:)
        dex
        bne !loop-   // -> előző !loop
        jmp !loop+   // -> következő !loop

!:      nop          // névtelen multi label
        jmp !+       // -> következő !
```

`*` = aktuális program counter értéke:
```asm
jmp *       // végtelen hurok
jmp *-6
```

### Memory Directives

```asm
*=$1000 "Program"       // PC beállítás + blokk névvel
*=$0400 "Data" virtual  // virtuális blokk (nem kerül a fájlba)
.align $100             // igazítás page határra
```

`.pseudopc` direktíva – kód másik helyre generálva:
```asm
*=$1000 "Program to be relocated at $2000"
.pseudopc $2000 {
loop:   jmp loop   // -> jmp $2000 generálódik, nem jmp $1000
}
```

### Data Directives

```asm
.byte 1,2,3,4
.word $2000,$1234     // little-endian
.dword $12341234
.text "Hello World"
.by, .wo, .dw         // rövidítések

.fill 5, 0            // 0,0,0,0,0
.fill 5, i            // 0,1,2,3,4
.fill 256, 127.5 + 127.5*sin(toRadians(i*360/256))  // szinusz görbe!
```

### Encoding

```asm
.encoding "screencode_mixed"   // default: nagy/kis betű screencode
.encoding "screencode_upper"   // csak nagybetű + grafika
.encoding "petscii_mixed"
.encoding "petscii_upper"
```

### Import

```asm
.import binary "Music.bin"
.import binary "Music.bin", 100          // 100 byte-ot ugorj
.import c64 "charset.c64"               // első 2 byte (cím) kihagyva
.import c64 "charset.c64", $400, $200   // offset, hossz
.import text "scroll.txt"
```

### Kommentek
```asm
// Ez sor komment (NEM a ';' !)
/* Ez blokk
   komment */
lda /* inline komment */ #10
```

Megjegyzés: `;` nem komment, hanem utasítás elválasztó Kick Assemblerben!

### Console Output
```asm
.print "Hello world"
.print "x="+x
.printnow "loop=$" + toHexString(loop)   // azonnal (debug)
.error "width too large"
.errorif width>40, "width can't be higher than 40"
```

---

## 4. Script Nyelv

Kick Assembler beépített kifejezés-kiértékelőt tartalmaz. Matematikai precedencia szerint (ellentétben PAL-lal): `5+4*3 = 17`.

Értéktípusok: Number, Boolean, String, List, Vector, Matrix.

### Változók és konstansok

```asm
.var x = 10
.const MY_CONST = $d020
.label MY_LABEL = $1000

// Label és .label különbség:
// label: (kettőspont) -> PC-hez rendelve, fizikai helyen
// .label = expr -> tetszőleges értékű szimbólum
```

### Scope-ok

```asm
.var x = 1
{
    .var x = 2    // helyi x; kívül nem látható
    lda #x        // -> lda #2
}
lda #x            // -> lda #1
```

### Numerikus értékek

```asm
.var a = 10
.var b = $1a
.var c = %1010
.var d = 10.5

// Operátorok: + - * / ^ (hatványozás)
// Bit ops: & | ^ (xor) ~ (not) << >>
```

### String értékek

```asm
.var s = "Hello"
.print s.size()        // 5
.print s.charAt(0)     // H
.print s.substring(1,3) // el
.print s.toUpperCase()
```

### Math Library (fontosabb függvények)

```asm
sin(x)  cos(x)  tan(x)
asin(x) acos(x) atan(x) atan2(y,x)
sqrt(x) pow(x,y) log(x) exp(x)
abs(x) floor(x) ceil(x) round(x)
min(a,b) max(a,b)
mod(a,b)
toRadians(deg) toDegrees(rad)
random()
```

---

## 5. Elágazás és ciklusok

```asm
.if (x > 5) {
    lda #1
} else {
    lda #0
}

// Egysoros if:
.if (x > 5) lda #1

// Ternáris (? :)
.var y = (x > 5) ? 1 : 0
```

`.for` és `.while`:
```asm
.for (var i=0; i<8; i++) {
    lda #i
    sta $d800+i
}

.var i = 0
.while (i < 8) {
    lda #i
    sta $d800+i
    .eval i++
}
```

---

## 6. Adatstruktúrák

```asm
// Lista
.var myList = List().add(10).add(20).add(30)
lda #myList.get(1)    // 20

// Hashtable
.var ht = Hashtable()
.eval ht.put("key", 42)
lda #ht.get("key")

// Struct
.struct Point { x, y }
.var p = Point(10, 20)
lda #p.x
```

---

## 7. Funkciók és Makrók

### Funkciók (visszatérési értékkel)

```asm
.function double(x) {
    .return x * 2
}
lda #double(5)   // -> lda #10
```

### Makrók (gépi kódot generálnak)

```asm
.macro SetBorderColor(color) {
    lda #color
    sta $d020
}
SetBorderColor(2)    // meghívás (NEM ponttal!)
```

### Pseudo Commands (mint makró, de speciális szintaxis)

```asm
.pseudocommand myCmd arg {
    lda arg
    sta $d020
}
myCmd #5
```

---

## 8. Preprocessor

```asm
#define MY_FLAG
#undef MY_FLAG
#ifdef MY_FLAG
    lda #1
#endif
#ifndef MY_FLAG
    lda #0
#endif

#import "library.asm"
#importif STAND_ALONE "upstart.asm"
#importonce                    // csak egyszer importálódik
```

Boolean operátorok: `&&`, `||`, `!`

---

## 9. Scope-ok és Namespace-ek

```asm
.namespace colors {
    .const border = $d020
    .const background = $d021
}
sta colors.border

// Scope escape: :: prefix
lda ::globalVar
```

---

## 10. Import és Export

### SID import

```asm
.var music = LoadSid("MySong.sid")
*=music.location "Music"
.fill music.size, music.getData(i)

// SID adatok:
music.location   // betöltési cím
music.init       // init rutin
music.play       // play rutin
music.songs      // dalok száma
music.startSong  // kezdő dal
```

### Grafika konverzió

```asm
// Sprite: 12×21 pixel
.var spr = LoadPicture("sprite.png", List().add($000000, 0).add($ffffff, 1))
.for (var i=0; i<spr.height; i++) {
    .byte spr.getSinglecolorByte(0, i)
}
```

### Label export VICE-hez

```asm
// Parancssori opció: -viceSymbols
// Generál: myProgram.vs fájlt VICE-hoz betölthető szimbólumtáblával
```

---

## 12. Speciális funkciók

### BasicUpstart2

```asm
BasicUpstart2(start)    // SYS start BASIC programot generál
```

### Opcode konstansok

```asm
CmdLda.getValue(IMMEDIATE)   // -> $A9
CmdJsr.getValue(ABSOLUTE)    // -> $20
```

### Szín konstansok

```asm
BLACK, WHITE, RED, CYAN, PURPLE, GREEN, BLUE, YELLOW
ORANGE, BROWN, LIGHT_RED, DARK_GRAY, MEDIUM_GRAY, LIGHT_GREEN, LIGHT_BLUE, LIGHT_GRAY
```

---

## Appendix A – Quick Reference

### Command Line Options (fontosabbak)

| Opció | Leírás |
|-------|--------|
| `-showmem` | Memory map megjelenítés |
| `-execute "path"` | Futtatás assemblálás után |
| `-libdir path` | Keresési könyvtár |
| `-dtv` | DTV opcode-ok engedélyezése |
| `-viceSymbols` | VICE szimbólumtábla exportálás |
| `-asminfo path` | AsmInfo fájl generálás |
| `-o outfile` | Kimeneti fájl neve |

### Assembler Directives

```
* =              Program counter beállítás
.align           PC igazítás
.pseudopc        Relokálható kód generálás
.byte .word .dword .text .fill
.import binary/c64/text/source
.encoding        Text kódolás
.macro .function .pseudocommand
.struct .const .var .label
.namespace .zp
.if .for .while
.print .printnow .error .errorif
.assert
```

---

## Megjegyzések C64 fejlesztéshez

- `BasicUpstart2(label)` makró helyettesíti a kézi BASIC SYS sort
- `.import binary` a legjobb módszer SID/grafika betöltésre
- `*= $addr "Name"` blokknevekkel a `-showmem` olvasható memory map-et ad
- Illegális opcode-ok: `dcp`, `isc`, `lax`, `sax` stb. demoscene kódban gyakoriak
- Page boundary kerülés: `.align $100` automatikusan az adattáblák elé
