# Codebase64 Wiki – Teljes tartalom

- Forrás: `knowledge/sources/codebase64/pages/` (660 .txt fájl)
- URL: https://codebase.c64.org/doku.php?id=start
- Letöltve: 2026-05-25
- Téma: C64 assembly programozási wiki – rutinok, algoritmusok, effektek, demoscene technikák
- Megbízhatóság: nagyon magas (aktív C64 demoscene közösség által írt, ellenőrzött kódok)
- Formátum: DokuWiki raw markup, assembly kódrészletekkel

---

## Hogyan keress benne

Minden oldal egy `.txt` fájl a `pages/` könyvtárban. A fájlnév egyértelműen jelzi a tartalmat:
- `base__` prefix: az általános kódbázis oldalai (593 fájl)
- `cia__`, `sid__`, `vic__`, stb.: chip-specifikus oldalak
- `magazines__` prefix: demoscene folyóiratok tartalma
- `interrupts__` prefix: interrupt-specifikus cikkek

Keresés: `grep -r "kulcsszó" knowledge/sources/codebase64/pages/`

---

## Namespace-ek és tartalmuk

### base: (593 fájl) – Fő kódbázis

Az összes C64 assembly programozási technika, rutin és algoritmus:

#### Scrolling / Grafikai effektek
- `base__1x1_scroll.txt` – 1×1 pixel scroller változó sebességgel, előre/hátra (Turbo-Assembler)
- `base__1x1_scrolling_message.txt` – 1×1 scrolling üzenet
- `base__1x1_upscroll.txt` – felfelé scrollozás
- `base__2x2_sidescroll.txt` – 2×2 oldal scroll
- `base__4_ways_scroll.txt`, `part_1`, `part_2` – 4 irányú scroll
- `base__acme_1x1_scroll.txt` – ACME assembler verzió
- `base__3d_dot_scroll.txt` – 3D pont scroller
- `base__3d_rotation.txt` – 3D forgatás

#### Raster / IRQ technikák
- `base__stable_raster_routine.txt` – stabil raster rutin (double IRQ, Kick Assembler)
- `base__raster_irq.txt` – alap raster IRQ beállítás
- `base__interrupts.txt` – interrupt és timing összefoglaló
- `base__introduction_to_raster*` – raster bevezető
- `base__6510_instruction_timing.txt` – 6510 utasítás timing részletesen (pipeline, ciklus táblázatok)
- `base__6510_features.txt` – 6510 sajátosságok
- `base__6510_8502_undocumented_commands.txt` – dokumentálatlan opkódok

#### Matematika / Algoritmusok
- `base__8bit_multiplication_8bit_product.txt` – 8 bites szorzás
- `base__8bit_multiplication_16bit_product.txt` – 8×8=16 bites szorzás
- `base__8bit_multiplication_16bit_product_fast_no_tables.txt` – gyors változat táblázat nélkül
- `base__another_fast_8bit_multiplication.txt` – alternatív gyors szorzás
- `base__16bit_multiplication_32-bit_product.txt` – 16×16=32 bites szorzás
- `base__24bit_multiplication_24bit_product.txt` – 24 bites szorzás
- `base__8bit_divide_8bit_product.txt` – 8 bites osztás
- `base__8bit_divide_by_constant_8bit_result.txt` – osztás konstanssal
- `base__16bit_division_16-bit_result.txt` – 16 bites osztás
- `base__24bit_division_24-bit_result.txt` – 24 bites osztás
- `base__16bit_addition_and_subtraction.txt` – 16 bites összeadás/kivonás
- `base__16bit_and_24bit_sqrt.txt` – 16/24 bites négyzetgyök
- `base__8bit_atan2_8-bit_angle.txt` – atan2 szög számítás
- `base__8bit_atan2_using_the_cordic_algorithm.txt` – CORDIC algoritmus
- `base__8bit_logarithm_table_generator_routine.txt` – logaritmus tábla generálás
- `base__approximation_to_distance.txt` – távolság közelítés
- `base__hexadecimal_to_decimal_conversion.txt` – hex→decimal konverzió
- `base__8_bit_to_hexadecimal_conversion.txt` – 8 bit→hex
- `base__32_bit_hexadecimal_to_decimal_conversion.txt` – 32 bites konverzió
- `base__a_faster_radix_sort.txt` – gyors rendezés

#### Véletlenszám generálók
- `base__16bit_pseudo_random_generator.txt`
- `base__another_16bit_pseudo_random_generator.txt`
- `base__16bit_xorshift_random_generator.txt`
- `base__32bit_galois_lfsr.txt`
- `base__6502_6510_maths.txt` – maths összefoglaló

#### Plasma és FLI effektek
- `base__8x8-plasma-basic.txt`, `base__8x8-plasma-looped.txt`, `base__8x8-plasma-optimized-codegen.txt`
- `base__8x8-plasma-codegen.txt`, `base__8x8-plasma-scripted.txt`
- `base__afli.txt` – AFLI (Advanced FLI) technika
- `base__afli-plasma.txt` – AFLI + plasma kombináció
- `base__2nd_pixel_fli_distorter.txt` – FLI distorter
- `base__40_bytes_fli_displayer.txt` – kompakt FLI megjelenítő

#### Sprite technikák
- `base__8_sprite_starfield.txt` – 8 sprite-os csillagmező

#### SID / Hang
- `base__a_sid_player_routine.txt` – SID lejátszó rutin
- `base__sid_programming.txt` – SID programozás összefoglaló
- `base__256_bytes_tune_player.txt` – 256 byte-os dalkiátszó

#### VIC-II
- `base__agsp_any_given_screen_position.txt` – tetszőleges képernyő pozíció
- `base__16x16_char_matrix.txt` – 16×16 karakter mátrix
- `base__16x16_matrix_scroll.txt` – mátrix scroll

#### Disk / Fájl I/O
- `base__dos_examples.txt` – DOS/KERNAL fájl műveletek példák
- `base__flexloader_3.0.txt` – IRQ/Fast loader (1541)
- `base__disk_loader_with_flashing_border_for_non-fastload.txt`
- `base__autostarting_disk_files.txt`
- `base__formatting_disks.txt`
- `base__drivecode.txt`

#### KERNAL és ROM
- `base__using_the_kernal_basic_roms.txt` – KERNAL/BASIC ROM használat
- `base__asm_include_file_for_basic_routines.txt` – BASIC rutinok ASM-ből
- `base__a_new_kind_of_hard-restart.txt` – hard restart technika

#### Cross-development
- `base__crossdev.txt` – cross-dev összefoglaló
- `base__acme_notepadplusplus_syntax.txt` – ACME szintaxis highlight
- `base__acme-macro-tut.txt` – ACME macro tutorial
- `base__acme-macros_for_frequency_table_calculation.txt`

#### Assembler-specifikus
- `base__6502_registers.txt` – 6502 regiszterek referencia
- `base__6510_instructions_by_addressing_modes.txt` – utasítások cím mód szerint
- `base__advanced_optimizing.txt` – haladó optimalizálási technikák
- `base__machine_language_tutorial_part_*.txt` – több részes ML tutorial

#### Hardver specifikus
- `base__reu_registers.txt` – REU (RAM Expansion Unit) regiszterek
- `base__supercpu_bra.txt` – SuperCPU specifikus
- `base__about_easyflash.txt` – EasyFlash cartridge
- `base__assembling_your_own_cart_rom_image.txt` – saját cartridge ROM
- `base__6510_features.txt` – 6510 chip jellemzők

---

### interrupts: (1 fájl)

- `interrupts__making_stable_raster_routines.txt` – **Marko Makela** részletes cikke a stabil raster
  interrupt routinokról (C64 és VIC-20). Double IRQ technika, cycle-exact timing, NMI kezelés.
  **NAGYON FONTOS REFERENCIA** – ~27KB, a legtöbb C64 timing kérdésre választ ad.

---

### cia: (4 fájl)

- `cia__efficient_tod_initialisation.txt` – TOD óra hatékony inicializálása
- `cia__initialize_tod_clock_on_all_platforms.txt` – TOD C64/C128/VIC-20/Plus4 összes platformon
- `cia__io_programming.txt` – CIA I/O programozás (disk, joystick, keyboard, soros)
- `cia__tod_calibration.txt` – TOD óra kalibrálás

---

### sid: (1 fájl)

- `sid__simple_irq_music_player.txt` – Egyszerű IRQ-alapú zenelejátszó (ACME formátum)
  `$0810`-re töltve, `$1000`-nél zenei adat; init+play rutin; `$314`/`$315` vektor, `$d012`=0

---

### vic: (7 fájl)

- `vic__start.txt` – VIC programozás összefoglaló és linkek
- `vic__vic.txt` – VIC-II leírás
- Karakter mód, sprite-ok, grafikai módok referenciák

---

### magazines: (28 fájl)

C64/demoscene folyóiratok archivált tartalma:
- `magazines__chacking1.txt` ... `magazines__chacking*.txt` – C= Hacking folyóirat számok
- Különböző demoscene magazinok cikkei

---

### books: (2 fájl)

- `books__start.txt` – könyv lista
- `books__hardware_diagnostics.txt` – 1541 drive hardware diagnosztika

---

### crossdev: (2 fájl)

- `crossdev__exomizer_level_compress_decompression_for_beginners.txt` – Exomizer tömörítő
- `crossdev__tools_for_putting_files_into_a_*.txt` – fájlok D64 lemezképbe csomagolása

---

### projects: (9 fájl)

Felhasználói C64 projektek forráskóddal:
- `projects__basic_game.txt` és társai

---

## Kulcs oldalak – Fontos referenciák

| Fájl | Miért fontos |
|------|-------------|
| `interrupts__making_stable_raster_routines.txt` | **A** stabil raster IRQ referencia, Marko Makela tollából |
| `base__stable_raster_routine.txt` | Kész double-IRQ kód Kick Assembler formátumban |
| `base__6510_instruction_timing.txt` | Ciklus-szintű timing minden utasításhoz |
| `base__6510_instructions_by_addressing_modes.txt` | Teljes utasítás lista cím módok szerint |
| `base__6510_8502_undocumented_commands.txt` | Dokumentálatlan opkódok |
| `base__advanced_optimizing.txt` | Haladó 6502/6510 optimalizálás |
| `base__interrupts.txt` | Interrupt típusok és timing összefoglaló |
| `cia__io_programming.txt` | CIA I/O teljes referencia |
| `base__8bit_multiplication_16bit_product.txt` | Standard szorzás rutin |
| `base__sid_programming.txt` | SID programozás összefoglaló |

---

## Felhasználás

A `pages/` könyvtárban lévő `.txt` fájlok közvetlenül olvashatók. A DokuWiki markup
minimálisan formázott szöveget tartalmaz, ahol `<code>...</code>` tagek között van az assembly kód.

Keresés példák:
```
# Összes raster-related oldal:
grep -rl "raster" knowledge/sources/codebase64/pages/

# Stable IRQ kód keresése:
grep -rl "stable" knowledge/sources/codebase64/pages/

# Multiplication rutinok:
grep -rl "multipli" knowledge/sources/codebase64/pages/
```
