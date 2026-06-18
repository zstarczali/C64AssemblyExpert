# C64 Assembly Expert – Knowledge Index

Ez a fajl a C64 assembly tudasbazis teljes, strukturalt indexe.
Cela: az LLM context-be olvasva azonnal tudja, melyik fajlban keressen adott temakhoz.
Minden forrast tartalmaz: 16 PDF, 4 URL, 660 Codebase64 Wiki oldal.

Gyoker: `knowledge/` (minden eleresi ut ehhez kepest relativ)

---

## 1. PDF FORRASOK

### 1.1 6502 Instruction Set
- **Fajl:** `knowledge/sources/pdfs/6502 Instruction Set.pdf`
- **Notes:** `knowledge/sources/pdfs/6502 Instruction Set.pdf.notes.md`
- **Temak:** 6502 opcode matrix (HI/LO nibble tablazat), osszes utasitas reszletes leirasa, addressing mode-ok (implicit, immediate, zero page, absolute, indexed, indirect), SR flag hatasok, cikluszamok, 65xx family osszefoglalo
- **Hasznald ha:** opcode bajt erteket, flag hatast, cikluszamot, cimzesi mod kodolast keresed

### 1.2 6502 Opcodes
- **Fajl:** `knowledge/sources/pdfs/6502 Opcodes.pdf`
- **Notes:** `knowledge/sources/pdfs/6502 Opcodes.pdf.notes.md`
- **Temak:** 6502 utasitaskeszlet tablazat, opkodok hex ertekei, addressing mode-ok listaja, alap mnemonikak
- **Hasznald ha:** gyors opkod-cimmod keresztreferencia kell

### 1.3 A Commodore 64-es belso felepitese (Magyar)
- **Fajl:** `knowledge/sources/pdfs/A Commodore 64-es belso felépítése.pdf`
- **Notes:** `knowledge/sources/pdfs/A Commodore 64-es belso felépítése.pdf.notes.md`
- **Temak:** C64 hardver architektura, 6510 CPU pin-ek es I/O port, SID 6581 belso felepitese, VIC-II 6569 mukodese, CIA 6526 portok/timerek/TOD, billentyuzet matrix, kazetta/soros port
- **Hasznald ha:** hardver szintu architektura, chip pin-kiosztasok, billentyuzet matrix

### 1.4 Assembly Language Programming with the Commodore 64 (DeJong 1984)
- **Fajl:** `knowledge/sources/pdfs/Assembly_Language_Programming_With_the_Commodore_64_1984_Brady_Communications_Company.pdf`
- **Notes:** `knowledge/sources/pdfs/Assembly_Language_Programming_With_the_Commodore_64_1984_Brady_Communications_Company.pdf.notes.md`
- **Szerzo:** Marvin L. DeJong, Brady Communications, 1984
- **Temak:** 6510 assembly alapok es haladok, IRQ/NMI vektorok es mechanizmus (9. fej.), SID 6581 ADSR/waveform programozas dalpeldakkal (10. fej.), VIC karakter es bitmap grafika / color memory (11. fej.), CIA 6526 timer/TOD/portok (12. fej.), aritmetika, logika, App. C: teljes 6510 opkod tablazat
- **Hasznald ha:** IRQ/NMI setup, SID ADSR, CIA timer/TOD, VIC grafikai modok elmelet, opkod tablazat

### 1.5 C= Hacking Issue 6
- **Fajl:** `knowledge/sources/pdfs/c=hacking6.pdf`
- **Notes:** `knowledge/sources/pdfs/c=hacking6.pdf.notes.md`
- **Temak:** Demoscene technikak, border megnyitas PAL timing-gal, DYCP szinusz-alapu scroller, sprite multiplexing, LZW tomorities 6510-ben, N-key rollover / billentyuzet scan, tech-tech effekt; MINDEN timing PAL ertekekre vonatkozik
- **Hasznald ha:** border megnyitas, DYCP, sprite multiplex halado szinten, LZW tomorities, N-key rollover

### 1.6 C64 Assembly (Erdos Ivan, Magyar)
- **Fajl:** `knowledge/sources/pdfs/C64 Assembly.pdf`
- **Notes:** `knowledge/sources/pdfs/C64 Assembly.pdf.notes.md`
- **Szerzo:** Erdos Ivan
- **Temak:** 6510 assembly programozas magyar nyelven, debugger eszkozok, fejlesztesi gyakorlat, peldaprogramok, rendszerprogramozas alapok
- **Hasznald ha:** magyar nyelvu assembly referencia, kezdo-kozep szintu C64 asm kerdesek

### 1.7 C64 Programmer's Reference Guide – Programming Graphics (3. fejezet)
- **Fajl:** `knowledge/sources/pdfs/c64-programmers_reference_guide-03-programming_graphics.pdf`
- **Notes:** `knowledge/sources/pdfs/c64-programmers_reference_guide-03-programming_graphics.pdf.notes.md`
- **Temak:** VIC-II videomodus-rendszer, hires bitmap, multicolor bitmap, karakter modok, MOBok (sprites), sprite regiszterek, sprite-hatter es sprite-sprite utkozes, VIC-II regiszter leirasok
- **Hasznald ha:** VIC-II grafikai modok hivatalos leirasa, sprite rendszer, MOB adatformatum

### 1.8 C64 Programmer's Reference Guide – BASIC to Machine Language (5. fejezet)
- **Fajl:** `knowledge/sources/pdfs/c64-programmers_reference_guide-05-basic_to_machine_language.pdf`
- **Notes:** `knowledge/sources/pdfs/c64-programmers_reference_guide-05-basic_to_machine_language.pdf.notes.md`
- **Temak:** 6510 regiszterek, processzor flag-ek, KERNAL rutinok listaja, IRQ setup assembly-bol, C64 memoria-terkep attekintes, BASIC-bol gepikodra valo atallas
- **Hasznald ha:** KERNAL rutinok, memoria-terkep, IRQ setup, BASIC-asm athidas

### 1.9 Introducing Commodore 64 Machine Code (Sinclair 1984)
- **Fajl:** `knowledge/sources/pdfs/IntroducingCommodore64MachineCode.pdf`
- **Notes:** `knowledge/sources/pdfs/IntroducingCommodore64MachineCode.pdf.notes.md`
- **Szerzo:** Ian Sinclair, Prentice-Hall, 1984
- **Temak:** C64 gepikod bevezetes kezdoknek, hex szamrendszer, akkumulator/regiszter muveletek, cimzesi modok, branch utasitasok es displacement szamitas, kettes komplement, MIKRO assembler szintaxis, debugging technikok, App. C utasitas lista, App. D cimzesi modok
- **Hasznald ha:** branch offset szamitas, kezdo szintu 6510 kerdesek, kezzel assemblalas, MIKRO assembler

### 1.10 Kick Assembler (Teljes referencia – PROJEKT DEFAULT)
- **Fajl:** `knowledge/sources/pdfs/KickAssembler.pdf`
- **Notes:** `knowledge/sources/pdfs/KickAssembler.pdf.notes.md`
- **Temak:** Kick Assembler teljes szintaxis, direktiva-keszlet (.pc, .byte, .word, .text, .import stb.), makro rendszer (#define, .macro, .function), script nyelv (JavaScript-szeru), segment-ek es memoriaszervezes, VICE integracio, SID import, cimkek, iteraciok, C64 Studio tamogatas
- **Hasznald ha:** Kick Assembler szintaxis, direktiva, makro, script – EZ A PROJEKT ALAPERTELMEZETT ASSEMBLERE

### 1.11 Machine Language for the Commodore Revised and Expanded (Butterfield 1986)
- **Fajl:** `knowledge/sources/pdfs/Machine_Language_for_the_Commodore_Revised_and_Expanded_Edition.pdf`
- **Notes:** `knowledge/sources/pdfs/Machine_Language_for_the_Commodore_Revised_and_Expanded_Edition.pdf.notes.md`
- **Szerzo:** Jim Butterfield, 1986
- **Temak:** 650x chipcsalad (6502/6510/8502), timing es ciklusok, I/O programozas, C64/C128/VIC-20 kozos es eltero reszei, IRQ/NMI, memoriaszervezes, KERNAL, zero page hasznalat
- **Hasznald ha:** multi-platform Commodore kerdesek, 650x CPU halado, C128 alap kerdesek

### 1.12 Mapping the Commodore 64 (Leemon 1984/1987)
- **Fajl:** `knowledge/sources/pdfs/mapping-the-commodore-64.pdf`
- **Notes:** `knowledge/sources/pdfs/mapping-the-commodore-64.pdf.notes.md`
- **Szerzo:** Sheldon Leemon, 1984/1987
- **Temak:** Teljes C64 memoria-terkep cim szerint, zero page valtozok ($0000–$00FF), KERNAL RAM ($0100–$02FF), BASIC area, ROM/RAM szegmensek, SID regiszterek ($D400–), VIC-II regiszterek ($D000–), CIA1/CIA2 regiszterek ($DC00–, $DD00–), color RAM ($D800), I/O teruletek
- **Hasznald ha:** adott memoria cim pontos funkcioja, zero page valtozok, SID/VIC/CIA regiszter ertelmezese, ROM/RAM bankolas

### 1.13 PAL 64 Assembler (Templeton 1983)
- **Fajl:** `knowledge/sources/pdfs/pal.pdf`
- **Notes:** `knowledge/sources/pdfs/pal.pdf.notes.md`
- **Szerzo:** Brad Templeton, Pro-Line Software, 1983
- **FONTOS FIGYELMEZETES:** Ez NEM a PAL video szabvanyrol szol! Ez a PAL 64 nevu C64/6510 assembler program manualja.
- **Temak:** PAL 64 assembler program (SYS 700-zal indul), two-pass assembly, BASIC formatu forrasfajlok, pseudo-op-ok (.BYTE .WORD .IF .OPT stb.), kifejezeskiertekeles (BALROL JOBBRA, nem standard precedencia!), szimbolutabla, relokalhato objektum (PAL.R), 6510 utasitas referencia
- **Hasznald ha:** historikus C64 assembler eszkozok, PAL 64 assembler szintaxis kerdesek

### 1.14 Programming the VIC: The Definitive Guide to the Commodore VIC-20 (West 1987)
- **Fajl:** `knowledge/sources/pdfs/Programming the VIC_ The Definitive Guide to the Commodore VIC-20 Computer [West 1987-01-01].pdf`
- **Notes:** `knowledge/sources/pdfs/Programming the VIC_ The Definitive Guide to the Commodore VIC-20 Computer [West 1987-01-01].pdf.notes.md`
- **Temak:** VIC-20 platform, VIC-I chip (6560/6561) mukodese, VIC-20 KERNAL, illegalis opkodok leirasa, 6502 assembly VIC-20-on, I/O programozas
- **Hasznald ha:** illegalis/dokumentalatlan opkodok (fo referenciaertek), VIC-I chip (NEM VIC-II!), VIC-20 specifikus kerdesek – C64-re ovatosan alkalmazni!

### 1.15 VIC-II Reference
- **Fajl:** `knowledge/sources/pdfs/VIC-II reference.pdf`
- **Notes:** `knowledge/sources/pdfs/VIC-II reference.pdf.notes.md`
- **Temak:** VIC-II teljes regiszterterkep $D000–$D030, minden regiszter pontos bit-leirasal, videomodus-tablazat (szinhatterek, karakter, bitmap, multicolor kombinaciok)
- **Hasznald ha:** VIC-II regiszter gyors referencia, bit-szintu regiszter leiras, videomodus tablazat

### 1.16 vic-ii (Christian Bauer technikai referencia)
- **Fajl:** `knowledge/sources/pdfs/vic-ii.pdf`
- **Notes:** `knowledge/sources/pdfs/vic-ii.pdf.notes.md`
- **Szerzo:** Christian Bauer
- **Temak:** VIC-II teljes technikai mukodese, Bad Lines mehanizmus, DMA lopas, raster timing, minden grafikai mod reszletes leirasa (karakter/bitmap/multicolor/ECM), sprite rendszer, raster IRQ timing, $D011/$D016 scroll regiszterek, border trigger mehanizmus
- **Hasznald ha:** VIC-II legmelyebb technikai szinten, Bad Lines, DMA timing, border megnyitas elmelet, raster interrupt pontossag

---

## 2. URL FORRASOK

### 2.1 C64 KERNAL Functions
- **URL:** https://sta.c64.org/cbm64krnfunc.html
- **Temak:** KERNAL rutinok teljes listaja nevvel, cimmel, parameterekkel, leirasal – rendszerhivasok API-szintu referencia
- **Hasznald ha:** KERNAL rutin cime vagy parameterezese kell (pl. CHROUT, LOAD, SAVE, SETNAM)

### 2.2 C64 Memory Map
- **URL:** https://sta.c64.org/cbm64mem.html
- **Temak:** C64 memoria-terkep attekintes, cimtartomanyok, rendszerteruletek
- **Hasznald ha:** gyors online memoria-referencia

### 2.3 C64 Colors
- **URL:** https://sta.c64.org/cbm64col.html
- **Temak:** C64 szinpaletta, 16 szin neveivel es kodjaival, VIC-II szinregiszter referencia, RGB ertekek
- **Hasznald ha:** C64 szinrendszer, szinkodok, grafikai UI kerdesek

### 2.4 The MOS 6567/6569 VIC-II Article (Cebix)
- **URL:** https://www.cebix.net/VIC-Article.txt
- **Temak:** VIC-II reszletes technikai cikk, raster timing, sprite rendszer, video modok, szinkronizalas, Bad Lines, DMA
- **Hasznald ha:** VIC-II mukodes online ellenorzese, raster/sprite/DMA kerdesek

### 2.5 Exomizer — Tomorito Dokumentacio (Magnus Lind)
- **Helyi notes:** `knowledge/sources/urls/exomizer.md`
- **Temak:** Exomizer 1.1.5 parancsori hasznalat, zero page cimek ($A7/$AE-$AF/$FC-$FF), decruncher integralas, `exodecrunch.s` teljes ca65 forrasfajl, ExoBasic eszkoz, verziotortenet
- **Online (v3):** https://bitbucket.org/magli143/exomizer/wiki/Home (JS-rendelt, kezzel kell megnyitni)
- **GitHub (v1.1.5):** https://github.com/bitshifters/exomizer
- **Hasznald ha:** Exomizer tomorites/dekruncholasi kerdesek, decruncher beagyas, ZP cimek, `$01` register beallitas dekruncsolas elott/utan

---

## 3. CODEBASE64 WIKI (660 fajl)

**Gyoker:** `knowledge/sources/codebase64/pages/`
**Megjegyzes:** Kiemelten megbizható C64 assembly rutin-archivum. Tobbfele assembler (Kick Assembler, ACME, Turbo Assembler, 64tass). Keresni: grep a pages/ konyvtarban.

---

### 3.1 Kiemelt namespace-ek (nem base__ prefix)

#### Interrupt referencia
- `interrupts__making_stable_raster_routines.txt` – **LEGFONTOSABB** stabil raster IRQ cikk, Marko Makela; double IRQ, cycle-exact timing, PAL/NTSC

#### CIA
- `cia__efficient_tod_initialisation.txt` – TOD (Time of Day) ora hatekonny inicializalasa
- `cia__initialize_tod_clock_on_all_platforms.txt` – TOD inicializalas PAL/NTSC/DREAN platform-fuggetlen modon
- `cia__io_programming.txt` – CIA I/O programozas teljes referencia (CIA1 $DC00, CIA2 $DD00)
- `cia__tod_calibration.txt` – TOD ora kalibracio

#### SID
- `sid__simple_irq_music_player.txt` – Egyszeru IRQ-alapu SID zenelejatszo (ACME assemblerben)

#### VIC
- `vic__demo_programming.txt` – VIC-II demo programozas osszefoglalo
- `vic__gfx_editors_and_converters.txt` – VIC-II grafika szerkesztok es konverterek listaja
- `vic__opening_the_top_bottom_borders.txt` – Felso/also border megnyitas technika
- `vic__opening_up_the_borders_-_a_further_explanation.txt` – Border megnyitas elmeleti magyarazata
- `vic__pixel_aspect_ratio.txt` – C64 pixel aranyok (PAL: 0.9375)
- `vic__vic-ii_color_cheatsheet.txt` – VIC-II szin csokkentett tablazat
- `vic__visible_area.txt` – VIC-II lathato kepterulet meretei

#### Folyoiratok
- `magazines__chacking_toc.txt` – C= Hacking folyoirat tartalomjegyzek
- `magazines__chacking1.txt` – `magazines__chacking21.txt` – C= Hacking 1–21. szam
- `magazines__discovery1.txt` – Discovery magazine
- `magazines__discoveryspecial1.txt` – Discovery Special

#### Konyvek
- `books__hardware_diagnostics.txt` – Hardver diagnosztikai referencia
- `books__start.txt` – Konyvek szekció nyitolap

#### Cross-development
- `crossdev__exomizer_level_compress_decompression_for_beginners.txt` – Exomizer tomorito hasznalata kezdoknek
- `crossdev__tools_for_putting_files_into_a_.d64_image.txt` – D64 lemezképbe fajl bepakolas eszkozei

#### Projektek
- `projects__basic_game.txt` – BASIC jatek projekt
- `projects__c64amp_-_music_player.txt` – C64 MP zenelejatszo projekt
- `projects__fast_rs-232.txt` – Gyors RS-232 projekt
- `projects__game_of_life.txt` – Game of Life C64-en
- `projects__resurrection.txt` – Resurrection demo projekt
- `projects__space_simulator.txt` – Ur-szimulacios projekt
- `projects__sprite_clock.txt` – Sprite-alapu ora
- `projects__star_trek_game.txt` – Star Trek jatek
- `projects__start.txt` – Projektek nyitolap

#### Matematika (nem base__)
- `6502_6510_maths__x_abc_random_number_generator_8_16_bit.txt` – ABC veletlen szam generator 8/16 bit

#### Meta fajlok
- `download_codebase64.txt`, `guidelines.txt`, `history.txt`, `links__start.txt`, `playground__playground.txt`, `quick_howto.txt`, `source_conversion.txt`, `start.txt`, `tools__start.txt`, `wiki__dokuwiki.txt`, `wiki__syntax.txt`, `wiki__welcome.txt`

---

### 3.2 base__ fajlok topik szerint

#### 6502/6510 CPU referencia
- `base__6502_6510_coding.txt` – 6502/6510 kodolas altalanos iranyelvek
- `base__6502_6510_maths.txt` – 6502/6510 matematika osszefoglalo
- `base__6502_registers.txt` – 6502 regiszterek leirasa
- `base__6510_8502_undocumented_commands.txt` – Dokumentalatlan / illegalis opkodok (6510/8502)
- `base__6510_features.txt` – 6510 specifikus jellemzok (I/O port $00/$01, stb.)
- `base__6510_instruction_timing.txt` – Ciklus-szintu timing tablazat minden utasitashoz
- `base__6510_instructions_by_addressing_modes.txt` – Utasitasok cimzesi mod szerint csoportositva
- `base__legalmnemonicslist.txt` – Legalis mnemonikak listaja
- `base__illegalmnemonicslist.txt` – Illegalis mnemonikak listaja
- `base__extra_instructions_of_the_65xx_series_cpu.txt` – 65xx CPU sorozat extra utasitasai
- `base__decimal_mode_in_nmos_6500_series.txt` – BCD decimalis mod NMOS 6500-ban
- `base__different_cpu_types.txt` – Kulonbozo 6502 CPU tipusok osszehasonlitasa
- `base__detect_cpu_type.txt` – CPU tipus detektalas futasidoben
- `base__two_s_complement_system.txt` – Kettes komplement szamrendszer
- `base__numerical_systems.txt` – Szamrendszerek (hex, bin, dec)
- `base__basic_math_operations.txt` – Alapmuveletek assembly-ben

#### Optimalizalas es timing
- `base__advanced_optimizing.txt` – Haladó 6502 optimalizalas technikak
- `base__for_speed_we_need.txt` – Gyorsitasi technikak attekintese
- `base__speeding_up_and_optimising_demo_routines.txt` – Demo rutinok optimalizalasa
- `base__loops_vs_unrolled.txt` – Ciklus vs. kibontott kod osszehas.
- `base__cycle_exact_measuring_of_routine_execution_times.txt` – Rutin vegrehajtasi ido pontos merese
- `base__speedcode.txt` – Speedcode technika
- `base__variable_speedcode_runlength.txt` – Valtoztatható speedcode / run-length
- `base__frame_skipping.txt` – Frame skipping technika
- `base__threads_on_the_6502.txt` – Koroutinok / szalak 6502-n
- `base__register_selection_for_load_and_store.txt` – Regisztervalasztas LDA/STA optimalizalashoz
- `base__decrease_x_register_by_more_than_1.txt` – X regiszter tobb mint 1-gyel csokkentese
- `base__inverse_subtraction.txt` – Forditott kivonas
- `base__sign_extension.txt` – Elojel kiterjesztes
- `base__signed_8bit_16bit_addition.txt` – Elojeles 8bit/16bit osszeadas
- `base__signed_8bit_divide_by_2_arithmetic_shift_right.txt` – Elojeles 8 bites osztaas 2-vel (ASR)
- `base__set_a_byte_to_non-zero.txt` – Byte nemnulla-ra allitas
- `base__shift_bits_and_throw_carry_away_with_alr.txt` – ALR opkod hasznalata (shift + carry eldob)
- `base__some_words_about_the_anc_opcode.txt` – ANC illegalis opkod magyarazat
- `base__use_shy_as_sty_x_or_shx_as_stx_y.txt` – SHY/SHX illegalis opkodok STY/STX helyett
- `base__reversing_bits_in_a_byte.txt` – Bitforditas egy byte-ban
- `base__rotate_byte_and_act_on_1-bits.txt` – Byte forgatas es 1-bitek kezelese
- `base__using_a_byte_as_bitcounter_and_value_container_at_the_same_time.txt` – Byte dual hasznalat (bitszamlalo + ertek)
- `base__streaming_1_2_4_8-bit_numbers_without_spanning_bytes.txt` – Bit-stream olvasas byte-hataron at nem lepve
- `base__dispatch_on_a_byte.txt` – Byte-alapu dispatch / ugrotabla
- `base__decoding_bitstreams.txt` – Bitstream dekodolas
- `base__swapping_zp_data.txt` – Zero page adatok csereje
- `base__ram_beneath_00_and_01.txt` – RAM $00/$01 I/O port mogott

#### IRQ es interrupt technikak
- `base__interrupts.txt` – IRQ/NMI alap osszefoglalo
- `base__raster_irq.txt` – Raster IRQ beallitasa es hasznalata
- `base__stable_raster_routine.txt` – Stabil raster rutin (Kick Assembler double IRQ kod)
- `base__shortest_stable_raster.txt` – Legrovdebb stabil raster megoldas
- `base__double_irq.txt` – Double IRQ technika
- `base__double_irq_explained.txt` – Double IRQ elmeleti magyarazat
- `base__the_double_irq_method.txt` – Double IRQ modszer reszletes
- `base__introduction_to_raster_irqs.txt` – Raster IRQ bevezeto
- `base__introduction_to_stable_timing.txt` – Stabil timing bevezeto
- `base__stable_irq_with_dma.txt` – Stabil IRQ DMA mellett
- `base__stable_raster_with_lightpen.txt` – Stabil raster lightpennel
- `base__stable_timing_-_jackasser.txt` – Stabil timing JackAsser modszerrel
- `base__nmis_and_distributed_jitter-correction_routines.txt` – NMI es elosztott jitter-korrekcios rutinok
- `base__nmi_lock.txt` – NMI lock technika
- `base__nmi_lock_without_kernal.txt` – NMI lock KERNAL nelkul
- `base__timerinterrupts.txt` – CIA timer-alapu IRQ
- `base__how_real_programmers_acknowledge_interrupts.txt` – IRQ nyugtazas helyes modja
- `base__launching_long_tasks_from_irq_handler.txt` – Hosszu feladatok inditasa IRQ-bol
- `base__quick_exit_from_interrupt.txt` – Gyors IRQ-bol kilepes
- `base__introduction_to_vertical_tweaks.txt` – Vertikalis tweakek bevezeto
- `base__using_a_timer_as_an_inverted_raster_x-pos_register_method.txt` – Timer mint invertalt raster X-poz. regiszter
- `base__handling_irqs_with_some_simple_macros.txt` – IRQ kezeles egyszerü makrokkal
- `base__irq_disk_loader.txt` – IRQ-alapu lemez betolto
- `base__irq-tape_loader.txt` – IRQ-alapu szalag betolto
- `base__the_polling_method.txt` – Polling modszer IRQ helyett
- `base__dysp_cycle_table.txt` – DYSP ciklustabla
- `base__dysp_d017.txt` – DYSP D017 sprite Y-stretch technika

#### Matematika es algoritmusok
- `base__16-bit_absolute_comparison.txt` – 16 bites abszolut erteku osszehasonlitas
- `base__16-bit_comparison.txt` – 16 bites osszehasonlitas
- `base__8-bit_ranged_comparison.txt` – 8 bites tartomanyos osszehasonlitas
- `base__16bit_addition_and_subtraction.txt` – 16 bites osszeadas es kivonas
- `base__16bit_and_24bit_sqrt.txt` – 16 es 24 bites negyzetgyok
- `base__fast_sqrt.txt` – Gyors negyzetgyok
- `base__16bit_division_16-bit_result.txt` – 16 bites osztas 16 bites eredmennyel
- `base__24bit_division_24-bit_result.txt` – 24 bites osztas
- `base__8bit_divide_8bit_product.txt` – 8 bites osztas 8 bites eredmeny
- `base__8bit_divide_by_constant_8bit_result.txt` – 8 bites osztaas konstanssal
- `base__multiplication_and_division.txt` – Szorzas es osztas altalanos
- `base__multiplication_with_a_constant.txt` – Szorzas konstanssal
- `base__8bit_multiplication_8bit_product.txt` – 8x8 bites szorzas 8 bites eredmeny
- `base__8bit_multiplication_16bit_product.txt` – 8x8 bites szorzas 16 bites eredmeny (standard)
- `base__8bit_multiplication_16bit_product_fast_no_tables.txt` – Gyors 8x8→16 tabla nelkul
- `base__another_fast_8bit_multiplication.txt` – Masik gyors 8 bites szorzas
- `base__fast_8bit_multiplication_16bit_product.txt` – Gyors 8bit szorzas tablazattal
- `base__short_8bit_multiplication_16bit_product.txt` – Rovid 8x8→16 szorzas
- `base__16bit_multiplication_32-bit_product.txt` – 16x16→32 bites szorzas
- `base__24bit_multiplication_24bit_product.txt` – 24x24 bites szorzas
- `base__seriously_fast_multiplication.txt` – Kiemelkedo gyors szorzas (square table)
- `base__fastest_multiplication.txt` – Leggyorsabb ismert szorzas rutin
- `base__fastest_multiplication_2023.txt` – Leggyorsabb szorzas 2023-as valtozat
- `base__fast_floating_point_multiply.txt` – Gyors lebegopont szorzas
- `base__table_generator_routine_for_fast_8_bit_mul_table.txt` – 8 bites szorzastabla generator
- `base__exponentiation.txt` – Hatvanyozas
- `base__8bit_logarithm_table_generator_routine.txt` – 8 bites logaritmustabla generator
- `base__8bit_atan2_8-bit_angle.txt` – 8 bites atan2 fuggveny
- `base__8bit_atan2_using_the_cordic_algorithm.txt` – atan2 CORDIC algoritmusal
- `base__approximation_to_distance.txt` – Tavolsag kozelites
- `base__trigonometric_functions.txt` – Trigonometrikus fuggvenyek
- `base__generating_approximate_sines_in_assembly.txt` – Szinusz kozelites assembly-ben
- `base__generating_sines_with_basic.txt` – Szinusz tablazat generalas BASIC-kal
- `base__perspective.txt` – Perspektivikus projekcio
- `base__backface_culling.txt` – Backface culling 3D-hez
- `base__3d_rotation.txt` – 3D forgatas matrixokkal
- `base__errata_for_rankin_s_6502_floating_point_routines.txt` – Rankin 6502 lebegopont errata
- `base__floating_point_routines_for_the_6502.txt` – 6502 lebegopont rutinok
- `base__kernal_floating_point_mathematics.txt` – KERNAL lebegopont matematika
- `base__fixed_point_arithmethic.txt` – Fixpontos aritmetika
- `base__mathematics_in_assembly_article_series.txt` – Matematika assembly-ben cikksorozat index
- `base__mathematics_in_assembly_part_1.txt` – 1. resz
- `base__mathematics_in_assembly_part_2.txt` – 2. resz
- `base__mathematics_in_assembly_part_3.txt` – 3. resz
- `base__mathematics_in_assembly_part_4.txt` – 4. resz
- `base__mathematics_in_assembly_part_5.txt` – 5. resz
- `base__mathematics_in_assembly_part_6.txt` – 6. resz
- `base__mathematics_in_assembly_part_7.txt` – 7. resz
- `base__mathematics_in_assembly_part_8.txt` – 8. resz
- `base__6502_6510_maths.txt` – 6502/6510 matematika osszefoglalo

#### Veletlen szam generatorok
- `base__16bit_pseudo_random_generator.txt` – 16 bites PRNG
- `base__another_16bit_pseudo_random_generator.txt` – Masik 16 bites PRNG
- `base__16bit_xorshift_random_generator.txt` – XORshift 16 bites PRNG
- `base__32bit_galois_lfsr.txt` – 32 bites Galois LFSR
- `base__flexible_galois_lfsr.txt` – Rugalmas Galois LFSR
- `base__small_fast_16-bit_prng.txt` – Kis es gyors 16 bites PRNG
- `base__small_fast_8-bit_prng.txt` – Kis es gyors 8 bites PRNG
- `base__fast_8bit_ranged_random_numbers.txt` – Gyors 8 bites tartomanyos veletlen
- `base__ranged_random_numbers_with_even_distribution.txt` – Egyenletes eloszlasu veletlen
- `base__comparison_of_6502_random_generators.txt` – 6502 veletlen generatorok osszehasonlitasa
- `base__ax_tinyrand8.txt` – AX TinyRand8 kompakt PRNG
- `base__two_very_fast_16bit_pseudo_random_generators_as_lfsr.txt` – Ket gyors 16 bites LFSR PRNG
- `base__basic_rnd_routine.txt` – Alap BASIC RND rutin assembly-bol
- `6502_6510_maths__x_abc_random_number_generator_8_16_bit.txt` – ABC veletlen generator 8/16 bit

#### Rendezes es kereses
- `base__a_faster_radix_sort.txt` – Gyorsabb radix rendezes
- `base__bubble_sort_8-bit_elements.txt` – Bubble sort 8 bites elemekre
- `base__bubble_sort_16-bit_elements.txt` – Bubble sort 16 bites elemekre
- `base__combination_sort_8-bit_elements.txt` – Kombinalt rendezes 8 bites
- `base__optimal_sort_8-bit_elements.txt` – Optimalis rendezes 8 bites
- `base__optimal_sort_16-bit_elements.txt` – Optimalis rendezes 16 bites
- `base__quicksort_16-bit_elements.txt` – Quicksort 16 bites elemekre
- `base__shell_sort_16-bit_elements.txt` – Shell sort 16 bites
- `base__flagged_bucket_sort.txt` – Jelzett vedros rendezes

#### Szam megjelenites es konverzio
- `base__8_bit_to_hexadecimal_conversion.txt` – 8 bit → hex konverzio
- `base__hexadecimal_to_decimal_conversion.txt` – Hex → decimal konverzio
- `base__another_hexadecimal_to_decimal_conversion.txt` – Masik hex → decimal
- `base__more_hexadecimal_to_decimal_conversion.txt` – Tovabbi hex → decimal
- `base__decimal_to_hexadecimal_conversion.txt` – Decimal → hex konverzio
- `base__32_bit_hexadecimal_to_decimal_conversion.txt` – 32 bites hex → decimal
- `base__hex_string_to_integer.txt` – Hex string → integer
- `base__integer_to_hex_string.txt` – Integer → hex string
- `base__int16_and_uint16_conversion_to_string.txt` – Int16/UInt16 → string
- `base__petscii_to_screencode.txt` – PETSCII → screencode konverzio
- `base__ascii_char_to_4_bit_integer.txt` – ASCII kar → 4 bites integer
- `base__tiny_.a_to_ascii_routine.txt` – Apro A → ASCII rutin

#### String kezeles
- `base__string_manipulation_routines.txt` – String manipulacios rutinok
- `base__robust_string_input.txt` – Megbizható string bevitel
- `base__print_stringchain.txt` – String lanc kiirasa
- `base__ip_address_input.txt` – IP cim bevitele

#### Grafikai effektek – FLI / FPP / IFLI / AFLI / XFLI / UFLI / SHFLI / SHIFLI
- `base__fli.txt` – FLI (Flexible Line Interpretation) alap
- `base__fli_displayer.txt` – FLI kep megjelenitese
- `base__fli_floffy.txt` – FLI Floffy valtozat
- `base__fli-fpp-scroller.txt` – FLI+FPP scroller kombinacio
- `base__fpp.txt` – FPP (Flexible Pixel Placement) alap
- `base__fpp-first-line.txt` – FPP elso sor
- `base__fpp-last-line.txt` – FPP utolso sor
- `base__ifli.txt` – IFLI (Interlaced FLI)
- `base__afli.txt` – AFLI (Attribute FLI)
- `base__afli-plasma.txt` – AFLI plazma effekt
- `base__hires_fli.txt` – Hires FLI
- `base__2nd_pixel_fli_distorter.txt` – 2. pixel FLI torzito
- `base__40_bytes_fli_displayer.txt` – 40 bajtos FLI megjelenitő
- `base__4x4_fli_chunky_mode.txt` – 4x4 FLI chunky mod
- `base__shfli.txt` – SHFLI mod
- `base__shifli.txt` – SHIFLI mod
- `base__xfli.txt` – XFLI mod
- `base__ufli.txt` – UFLI mod
- `base__drazlace.txt` – Drazlace kep formatum es megjelenitő
- `base__drazlace_displayer.txt` – Drazlace megjelenitő rutin
- `base__techtech_fli.txt` – Tech-tech FLI effekt
- `base__calculate_vic_settings_for_showing_a_koala.txt` – VIC beallitas Koala kep megjeleniteshez
- `base__displaying_a_picture_at_2000.txt` – Kep megjelenitese $2000-tol
- `base__displaying_graphics_using_3fff.txt` – Grafika megjelenitese $3FFF hasznalataval

#### Plasma effektek
- `base__8x8-plasma-basic.txt` – 8x8 plasma alap
- `base__8x8-plasma-codegen.txt` – 8x8 plasma kodgeneralas
- `base__8x8-plasma-effect-switch.txt` – 8x8 plasma effektvaltas
- `base__8x8-plasma-looped.txt` – 8x8 plasma ciklikus
- `base__8x8-plasma-optimized-codegen.txt` – 8x8 plasma optimalizalt kodgeneralas
- `base__8x8-plasma-scripted.txt` – 8x8 plasma scriptelve
- `base__8x8-plasma-scripted-codegenerator.txt` – 8x8 plasma script + kodgenerator
- `base__8x8-plasma-slave-speedcode.txt` – 8x8 plasma slave speedcode
- `base__colorcycleplasma.txt` – Szinkeringo plasma
- `base__copper_style_fli_plasma.txt` – Copper-stilus FLI plasma
- `base__proportional-charset-noter_with_plasma-effect.txt` – Aranyos charset noter plasma effekttel

#### Raszterbar es vizualis effektek
- `base__rasterbars_source.txt` – Raszterbar forras
- `base__rasterbars_small_source.txt` – Kis raszterbar forras
- `base__rasterbars_4_source.txt` – 4-soros raszterbar
- `base__rasterbars_flash_screen_effect.txt` – Raszterbar villogas effekt
- `base__rasterbars_with_screen_on.txt` – Raszterbar kepernyovel egyutt
- `base__overlapping_raster_bars.txt` – Atlappolo raszterbarok
- `base__horizontal_raster_split.txt` – Horizontalis raszter split
- `base__horizontal_screen_positioning_hsp.txt` – Horizontalis kepernyoelhelyezes (HSP)
- `base__colour_flashing_notewriter_style.txt` – Szinvillanas Notewriter stilusban
- `base__4x4_charset_fire_with_lots_of_colors.txt` – 4x4 charset tuz tobb szinnel

#### Border megnyitas es linecrunch
- `base__removing_the_sideborders.txt` – Oldalborderek eltavolítasa
- `base__removing_the_top_bottom_border.txt` – Felso/also border eltavolítasa
- `base__upper_lower_borders.txt` – Felso/also border technika
- `base__sprites_in_bottom_sideborder.txt` – Spritek az also oldalborderben
- `base__fld.txt` – FLD (Flexible Line Distance) technika
- `base__linecrunch.txt` – Linecrunch technika
- `base__smooth_linecrunch.txt` – Sima linecrunch
- `base__junk_modes.txt` – Junk modok (FLI bug, stb.)

#### VIC-II memoria szervezes es beallitas
- `base__vicii_memory_organizing.txt` – VIC-II memoria szervezes ($D018)
- `base__quick_vicii_screen_setup.txt` – Gyors VIC-II kepernyobeallitas
- `base__built_in_screen_modes.txt` – Beepitett kepernyomodok
- `base__memconfig.txt` – Memoria konfiguralasa ($01 port)
- `base__memmanage.txt` – Memoria menedzsment
- `base__memory_management.txt` – Memoria kezeles altalanos
- `base__tiny_screenselection.txt` – Apro kepernyoselektalo rutin
- `base__agsp_any_given_screen_position.txt` – Tetszoleges kepernyopozicio szamitasa
- `base__io_addresses.txt` – I/O cimek teljes listaja
- `base__various_techniques_to_calculate_adresses_fast_common_screen_formats_for_pixel_graphics.txt` – Gyors cimszamitasi technikak pixel grafikahoz
- `base__dots_and_plots.txt` – Pontok rajzolasa
- `base__lines.txt` – Vonalak rajzolasa
- `base__draw_ram_to_screen_or_color_memory.txt` – RAM → kepernyő / szin memoria masolasa
- `base__color_ram_double_buffer.txt` – Szin RAM dupla puffer
- `base__rol_starfield_using_d018.txt` – Forgato csillagter $D018 hasznalataval
- `base__avoiding_the_d000-_dfff_issue_for_playing_music.txt` – $D000-$DFFF problema elkerulese zenelejaiszashoz
- `base__cpu_clocking.txt` – CPU orajelezese

#### Charset es karakter effektek
- `base__make_modified_character_sets.txt` – Modositott karakterkeszlet keszitese
- `base__character_bullets.txt` – Karakter golyok
- `base__charpack.txt` – Karakterkeszlet csomagolas
- `base__merge_char_bullets.txt` – Karakter golyok egyesitese
- `base__bigger_letters.txt` – Nagyobb betuk
- `base__realtime_8x_char_zoom.txt` – Valos ideju 8x karakter zoom
- `base__8x_scale_charset_scrolling_message.txt` – 8x skalazhato karakter goro uzenet
- `base__8x8_charset_pixel-blend-in.txt` – 8x8 karakter pixel blend-in
- `base__16x16_char_matrix.txt` – 16x16 karakter matrix
- `base__16x16_matrix_scroll.txt` – 16x16 matrix scrolling

#### Sprite technikak
- `base__sprites.txt` – Sprite alap ismeretek
- `base__spriteintro.txt` – Sprite bevezeto
- `base__moving_sprites.txt` – Sprite mozgatas
- `base__sprite_data_and_kickassembler.txt` – Sprite adatok Kick Assemblerben
- `base__sprite_converter.txt` – Sprite konverter
- `base__sprite_x-coordinate_calculus.txt` – Sprite X koordinata szamitas (MSB bit)
- `base__spritevectors.txt` – Sprite vektorok
- `base__sprite_interleave.txt` – Sprite interleave technika
- `base__sprite_mirror.txt` – Sprite tukor
- `base__stretching_sprites.txt` – Sprite nyujtas
- `base__sprite-crunching.txt` – Sprite osszenyomas
- `base__scrolltext_using_sprites.txt` – Scrolling szoveg spriteokkal
- `base__waving_sprite_scroll.txt` – Hullamo sprite scroll
- `base__8_sprite_starfield.txt` – 8 spriteos csillagter
- `base__gif_to_sprites.txt` – GIF → sprite konverzio
- `base__sprite_multiplexer.txt` – Sprite multiplexer 1
- `base__sprite_multiplexer_2.txt` – Sprite multiplexer 2
- `base__sprite_multiplexer_3.txt` – Sprite multiplexer 3
- `base__sprite_multiplexing.txt` – Sprite multiplexing altalanos
- `base__simple_sprite-multiplexing_using_sprite_1.txt` – Egyszeru sprite multiplex (sprite 1)
- `base__flexible_32_sprite_multiplexer.txt` – Rugalmas 32 spriteos multiplexer
- `base__flexible_32_sprite_multiplexer_2.txt` – Rugalmas 32 spriteos multiplexer 2
- `base__flexible_48_sprite_multiplexer.txt` – Rugalmas 48 spriteos multiplexer
- `base__sprite_multiplexer_sorting.txt` – Sprite multiplexer rendezessel
- `base__sprite_projectiles.txt` – Sprite lövegek / lövedekek
- `base__sprite_collision_detection.txt` – Sprite utkozes-detektalas altalanos
- `base__simple_hardware_sprite_to_background_collision.txt` – Egyszeru hardware sprite-hatter utkozes
- `base__simple_hardware_sprite_to_sprite_collision.txt` – Egyszeru hardware sprite-sprite utkozes
- `base__simple_software_sprite_to_background_collision.txt` – Szoftver sprite-hatter utkozes
- `base__simple_software_sprite_to_sprite_collision.txt` – Szoftver sprite-sprite utkozes
- `base__hybrid_hardware_software_sprite_collision_detection.txt` – Hibrid hardware/szoftver utkozes-detektalas
- `base__sprite_fpd.txt` – Sprite FPD technika
- `base__sprite_fpp.txt` – Sprite FPP technika

#### Scrolling technikak
- `base__1x1_scroll.txt` – 1x1 pixeles scroll
- `base__1x1_scrolling_message.txt` – 1x1 scrolling uzenet
- `base__1x1_upscroll.txt` – 1x1 felfelé scroll
- `base__2x2_sidescroll.txt` – 2x2 oldalsó scroll
- `base__2x2_upscroll_with_space_linefeed.txt` – 2x2 felfelé scroll szóközzel
- `base__4_ways_scroll.txt` – 4 iranyu scroll
- `base__4_ways_scroll_part_1.txt` – 4 iranyu scroll 1. resz
- `base__4_ways_scroll_part_2.txt` – 4 iranyu scroll 2. resz
- `base__acme_1x1_scroll.txt` – ACME 1x1 scroll pelda
- `base__double_screen_horizontal_scroller.txt` – Dupla kepernyos horizontalis scroller
- `base__double_screen_vertical_scroller.txt` – Dupla kepernyos vertikalis scroller
- `base__discofloor_scroller_as_being_used_in_aechzzeit.txt` – Discofloor scroller (Aechzzeit demoban)
- `base__freedirectional_scrolling_using_map_dumps.txt` – Szabad iranyu scrolling terkepbol
- `base__text_scroll.txt` – Szoveg scroll
- `base__3d_dot_scroll.txt` – 3D pont scroll
- `base__twisters_x-rotators_and_waving_carpets.txt` – Twister, X-rotator, hullamazo szonyeg effektek
- `base__logo_swing.txt` – Logo lengetese
- `base__simple_parallax_shifting.txt` – Egyszeru parallax scroll
- `base__fli-fpp-scroller.txt` – FLI+FPP scroller

#### Hang es SID programozas
- `base__sid_programming.txt` – SID programozas osszefoglalo
- `base__a_sid_player_routine.txt` – SID lejaatszo rutin
- `base__256_bytes_tune_player.txt` – 256 bytes dalk lejaatszo
- `base__very_short_sid_playroutine.txt` – Nagyon rovid SID lejaatszo
- `base__macro_player.txt` – Makro-alapu SID player
- `base__sound_fx_player.txt` – Hang effekt lejaatszo
- `base__sound_fx_routine.txt` – Hang effekt rutin
- `base__fake_music_player.txt` – Imitalt zene lejatszas
- `base__building_a_music_routine.txt` – Zene rutin epitese
- `base__how_to_calculate_your_own_sid_frequency_table.txt` – Sajat SID frekvenciatablazat szamitasa
- `base__pal_frequency_table.txt` – PAL SID frekvenciatablazat
- `base__ntsc_frequency_table.txt` – NTSC SID frekvenciatablazat
- `base__playing_music_on_pal_and_ntsc.txt` – Zene lejatszas PAL es NTSC platformon
- `base__playing_music_a000-_ffff.txt` – Zene lejatszas $A000-$FFFF teruletrol
- `base__avoiding_the_d000-_dfff_issue_for_playing_music.txt` – $D000-$DFFF memoria konfliktus megoldasa
- `base__nmi_sample_player.txt` – NMI-alapu sample lejaatszo
- `base__digis_r_eazy.txt` – Digi (digitalis hang) lejaatszo
- `base__noise_waveform.txt` – Zaj hullamforma (SID)
- `base__triangle_waveform.txt` – Haromszog hullamforma (SID)
- `base__formant.txt` – Formans szintezis SID-en
- `base__reduce_noise.txt` – Zaj csokkentese SID-en
- `base__vicious_sid_demo_routine_explained.txt` – Vicious SID demo rutin magyarazata
- `base__classic_hard-restart_and_about_adsr_in_generally.txt` – Hard-restart es ADSR altalaban
- `base__detecting_sid_type.txt` – SID chip tipus detektalas
- `base__detecting_sid_type_-_safe_method.txt` – SID detektalas biztonsagos modszerrel
- `base__fb-ssid.txt` – FB-SSID SID tipus azonosito
- `base__dtv_dma_sid_digi_player.txt` – DTV DMA SID digi lejaatszo
- `base__spectrometer.txt` – SID spektrometer
- `base__element_114_music_editor.txt` – Element 114 zeneszerkeszto
- `base__jch_20.g4_player_file_format.txt` – JCH 20.g4 player fajlformatum
- `base__c64_midi_data.txt` – C64 MIDI adatok
- `base__c64_midi_interfaces.txt` – C64 MIDI interfeszek
- `base__midi_on_the_c64.txt` – MIDI a C64-en
- `base__tinymidi.txt` – TinyMIDI implementacio
- `base__microtracker_v1.0.txt` – Microtracker v1.0 tracker
- `base__modplay_64.txt` – MOD lejaatszo C64-re
- `base__modplay_128.txt` – MOD lejaatszo C128-ra
- `base__wersiboard_music_64.txt` – Wersiboard Music 64
- `base__scrolling_and_seuck_file_player.txt` – Scrolling + SEUCK fajl lejaatszo

#### Input: eger, joystick, billentyuzet
- `base__c_1351_standard_mouse_routine.txt` – Commodore 1351 eger standard driver; SID POT $D419/$D41A, delta mozgas, sprite frissites
- `base__c_1351_mouse_routine_alternative.txt` – 1351 eger alternativ rovid rutin; gomb: $DC00 bit4 (bal), bit0 (jobb)
- `base__neos_mouse_routine.txt` – NEOS eger driver (digitalis protokoll, CIA1 nibble-kommunikacio, nem SID POT)
- `base__joystick_input_handling.txt` – Joystick olvasas alapjai (CIA1 $DC00/$DC01, bit-terkep)
- `base__fast_joystick_handling.txt` – Gyors joystick polling
- `base__both_joysticks_handling_plus_proper_keyboard_scan.txt` – Mindket joystick + billentyuzet interferencia-mentes
- `base__scanning_the_keyboard_without_joysticks_interfere.txt` – Billentyuzet scan joystick interferencia nelkul
- `base__scanning_the_keyboard_the_correct_and_non_kernal_way.txt` – KERNAL-mentes billentyuzet scan (direkt CIA matrix)
- `base__reading_the_keyboard.txt` – Alap billentyuzet olvasas
- `base__shortest_keyboard_scan.txt` – Legrovdebb billentyuzet scan
- `base__modify_keyboard_decoding.txt` – Billentyuzet dekodolas modositasa
- `base__nonrom_keyboard_v3.0.txt` – ROM-mentes billentyuzet handler v3.0

#### Memoria kezeles es REU
- `base__clearing_a_section_of_memory.txt` – Memoria terulet torlese
- `base__practical_memory_move_routines.txt` – Gyakorlati memoria-masolasi rutinok
- `base__reu_registers.txt` – REU (RAM Expansion Unit) regiszterek
- `base__reu_programming.txt` – REU programozas
- `base__reu_read_and_write.txt` – REU olvasas es iras
- `base__reu_detect.txt` – REU detektalas
- `base__georam_registers.txt` – GeoRAM regiszterek
- `base__changing_registers.txt` – Regiszterek megvaltoztatasa

#### Lemez es szalag I/O
- `base__dos_examples.txt` – DOS peldak (lemez parancsok)
- `base__loading_a_file.txt` – Fajl betoltese
- `base__saving_a_file.txt` – Fajl mentese
- `base__reading_a_file_byte-by-byte.txt` – Fajl olvasasa byte-onkent
- `base__writing_a_file_byte-by-byte.txt` – Fajl irasa byte-onkent
- `base__reading_a_sector_from_disk.txt` – Szektor olvasasa lemezrol
- `base__writing_a_sector_to_disk.txt` – Szektor irasa lemezre
- `base__reading_the_directory.txt` – Konyvtar olvasasa
- `base__reading_the_error_channel_of_a_disk_drive.txt` – Lemezmeghajto hiba csatorna olvasasa
- `base__sending_a_command_to_a_disk_drive.txt` – Parancs kuldese meghajtónak
- `base__formatting_a_disk.txt` – Lemez formattalasa (1)
- `base__formatting_disks.txt` – Lemez formattalas (2)
- `base__fastloaders.txt` – Fastloader technikak osszefoglalo
- `base__flexloader_3.0.txt` – FlexLoader 3.0
- `base__disk_loader_with_flashing_border_for_non-fastload.txt` – Lemez betoltő villanó borderrel
- `base__irq_disk_loader.txt` – IRQ-alapu lemez betoltő
- `base__irq-tape_loader.txt` – IRQ-alapu szalag betoltő
- `base__autostarting_disk_files.txt` – Lemez fajlok automatikus inditasa
- `base__autoboot_tape_turbo_loader.txt` – Autoboot szalag turbo betoltő
- `base__datasette.txt` – Datasette (szalag) programozas
- `base__drivecode.txt` – Meghajtó kod (drive side code)
- `base__drivecalc_vectors.txt` – Drive vektorok szamitasa
- `base__detect_drives_on_iec_bus.txt` – IEC buszon meghajtók detektalas
- `base__how_the_vic_64_serial_bus_works.txt` – VIC-64 soros busz mukodese
- `base__freeload_v5.0_saver.txt` – FreeLOAD v5.0 saver
- `base__making_use_of_the_fastload_save_in_the_cartridge.txt` – Fastload save a cartridge-ben
- `base__rom-load.txt` – ROM-alapu betoltes

#### Szalagatvitel / Tape transfer programok
- `base__burner_tape_transfer_1.0.txt` – Burner szalagatvitel 1.0
- `base__c_pavloda_transfer_1.0a.txt` – C. Pavloda atvitel 1.0a
- `base__chr_load_tape_transfer_2.0.txt` – CHR Load szalagatvitel 2.0
- `base__chr_tape_to_disk_transfer_1.0.txt` – CHR szalag → lemez atvitel 1.0
- `base__novaload_tape_transfer_1.0.txt` – Novaload szalagatvitel 1.0
- `base__novaload_special_tape_transfer_1.0.txt` – Novaload Special atvitel
- `base__ocean_imagine_transfer_-_v1.txt` – Ocean/Imagine atvitel v1
- `base__ocean_imagine_transfer_-_v2.txt` – Ocean/Imagine atvitel v2
- `base__ocean_imagine_transfer_-_v3.txt` – Ocean/Imagine atvitel v3
- `base__u.s.gold_tape_transfer_1.0.txt` – U.S. Gold szalagatvitel
- `base__virgin_tape_transfer_1.0.txt` – Virgin szalagatvitel
- `base__wildload_tape_transfer_1.0.txt` – Wildload szalagatvitel
- `base__turbo250_disassembled.txt` – Turbo250 szetbontva
- `base__cult_loader.txt` – Cult Loader
- `base__turbotape_loader_source.txt` – TurboTape betoltő forras
- `base__electronic_arts_fat_tracks_file_buster.txt` – EA Fat Tracks fajlbuszter

#### KERNAL, BASIC es rendszer
- `base__kernalreference.txt` – KERNAL referencia (rutinok, vektorok)
- `base__kernalbasicinit.txt` – KERNAL/BASIC inicializalas
- `base__using_the_kernal_basic_roms.txt` – KERNAL/BASIC ROM-ok hasznalata
- `base__asm_include_file_for_basic_routines.txt` – BASIC rutinok ASM include fajlja
- `base__filling_the_vectors.txt` – Vektorok feltoltese
- `base__basicwedge.txt` – BASIC wedge implementacio
- `base__runasmfrombasic.txt` – ASM kod futtatasa BASIC-bol
- `base__runbasicprg.txt` – BASIC program futtatasa assembly-bol
- `base__autostart_code.txt` – Autostart kod
- `base__a_new_kind_of_hard-restart.txt` – Uj fajta hard-restart
- `base__protecting_against_soft-resets.txt` – Vedelem soft-reset ellen
- `base__restore_and_cia_2.txt` – RESTORE gomb es CIA2 kapcsolata
- `base__making_a_counter.txt` – Szamlalo keszitese
- `base__scoring_points.txt` – Pontszam kezeles
- `base__high_score_detection.txt` – Csucspont detektalas

#### Tomorites es csomagolas
- `base__rle_pack_unpack.txt` – RLE tomorites es kitomorites
- `base__the_secret_of_fast_lzw_crunching.txt` – Gyors LZW tomorites titka
- `base__dictionary_compression.txt` – Szotar alapu tomorites
- `base__compression_benchmarks.txt` – Tomoritesei benchmarkok
- `base__lzmpi_compression.txt` – LZMPI tomorites
- `base__decruncher_for_mdg-packer_linker_1.1.txt` – MDG-Packer Linker 1.1 detomorito
- `base__mdg_bytesmasher_0.04.txt` – MDG ByteSmasher 0.04
- `base__exomizer_adding_decrunch_splash_screens_during_sfx_decrunch.txt` – Exomizer detomoritas splash screen-nel
- `base__exomizer_making_custom_oldschool_decrunch_effects.txt` – Exomizer egyedi oldschool decrunch effektek

#### Cross-development es tooling
- `base__crossdev.txt` – Cross-development attekintes
- `base__cross_development_using_makefile.txt` – Cross-dev Makefile-lal
- `base__makefile_to_use_with_ca65_vice.txt` – Makefile ca65 + VICE-hoz
- `base__using_a_running_vice_session_for_development.txt` – Futó VICE session fejleszteshez
- `base__using_the_vice_monitor.txt` – VICE monitor hasznalata
- `base__acme_notepadplusplus_syntax.txt` – ACME Notepad++ szintaxis kiemelés
- `base__acme-macro-tut.txt` – ACME makro tutorial
- `base__acme-macros_for_frequency_table_calculation.txt` – ACME makrók frekvenciatábla számitashoz
- `base__syntax_highligthing_acme_vim.txt` – ACME szintaxis kiemelés Vim-ben
- `base__kick_assembler_macros.txt` – Kick Assembler makrók
- `base__kick_assembler_tips_tricks.txt` – Kick Assembler tippek es trükkök
- `base__create_labels_on_the_fly_using_macros.txt` – Cimkek letrehozasa makrokkal menet kozben
- `base__populating_several_related_arrays_from_a_single_macro.txt` – Tobbe kapcsolodo tomb feltoltes egy makrobol
- `base__codegen-scripts.asm.txt` – Kodgeneralas script assembly-ben
- `base__safeguard_against_putting_data_in_wrong_segment.txt` – Vedelem helytelen szegmensbe iras ellen
- `base__thirdparty.txt` – Harmadik feles eszkozok listaja

#### Detektalas es platform azonositas
- `base__detect_pal_ntsc.txt` – PAL/NTSC detektalas futasidoben
- `base__ntsc_pal_differences.txt` – NTSC es PAL kulonbsegek
- `base__detect_vic_type.txt` – VIC chip tipus detektalas
- `base__detect_cpu_type.txt` – CPU tipus detektalas
- `base__detecting_6526_vs_6526a_cia_chips.txt` – CIA 6526 vs 6526A megkulonboztetese
- `base__detecting_sid_type.txt` – SID chip detektalas
- `base__detecting_sid_type_-_safe_method.txt` – SID detektalas biztonsagos modszerrel
- `base__cartridge_detection.txt` – Cartridge detektalas
- `base__c64gs_detection.txt` – C64GS detektalas
- `base__dtv_detect.txt` – C64 DTV detektalas
- `base__multi-adapter_support.txt` – Multi-adapter tamogatas

#### Cartridge es hardverfejlesztes
- `base__assembling_your_own_cart_rom_image.txt` – Sajat cartridge ROM image keszitese
- `base__code_frame_for_16_kb_crt-images.txt` – 16 KB CRT image kod keret
- `base__code_frame_for_64_kb_crt-images_i.e._for_rgcd.txt` – 64 KB CRT image kod keret (RGCD)
- `base__crt_file_format.txt` – CRT fajlformatum leiras
- `base__about_easyflash.txt` – EasyFlash cartridge ismertetoje
- `base__cartridge_bugs.txt` – Ismert cartridge hibak
- `base__inside_retro_replay.txt` – Retro Replay belso mukodese
- `base__inside_retrosurfer.txt` – RetroSurfer belso mukodese
- `base__inside_surfer.txt` – Surfer belso mukodese
- `base__rr_chip_data.txt` – Retro Replay chip adatok
- `base__rr_detect.txt` – Retro Replay detektalas
- `base__rr_flashing.txt` – Retro Replay flasheles
- `base__rr-net_memory_map_docs.txt` – RR-Net memoria terkep dokumai
- `base__supercpu_bra.txt` – SuperCPU BRA utasitas
- `base__scpu_bitmode8.txt` – SuperCPU 8 bites mod
- `base__scpu_bitmode16.txt` – SuperCPU 16 bites mod
- `base__scpu_emulatedmode.txt` – SuperCPU emulalt mod
- `base__scpu_memcpy.txt` – SuperCPU memoria masolasas
- `base__scpu_nativemode.txt` – SuperCPU native mod
- `base__scpu_rastercompare.txt` – SuperCPU raster osszehasonlitas
- `base__scpu_rasterirq_init.txt` – SuperCPU raster IRQ inicializalas
- `base__scpu_rasterirq_leadin.txt` – SuperCPU raster IRQ bevezeto
- `base__scpu_rasterirq_leadout.txt` – SuperCPU raster IRQ kivezeto
- `base__scpu_setbitmapmode.txt` – SuperCPU bitmap mod beallitasa
- `base__scpu_setchermode.txt` – SuperCPU karakter mod beallitasa
- `base__scpu_setgraphicsbank.txt` – SuperCPU grafika bank beallitasa
- `base__scpu_setrambank.txt` – SuperCPU RAM bank beallitasa
- `base__scpu_setscrncol.txt` – SuperCPU kepernyoszin beallitasa

#### Halozat es kommunikacio
- `base__rs232silversurfer.h.txt` – SilverSurfer RS-232 header
- `base__rs232silversurfer.s.txt` – SilverSurfer RS-232 forras
- `base__silversurfer_hardware-defines.txt` – SilverSurfer hardver definiciok
- `base__silversurfer_polling.txt` – SilverSurfer polling rutin
- `base__x-modem_file_transfer_protocol.txt` – X-Modem protokoll
- `base__xmodem-receive.txt` – XModem fogadó rutin
- `base__xmodem-send.txt` – XModem kuldő rutin
- `base__xmodem-send_and_receive.txt` – XModem kuldes es fogadas
- `base__simple_basic_x-modem_receive.txt` – Egyszeru BASIC X-Modem fogado

#### Terkep es tile engine
- `base__decoding_tile_based_maps.txt` – Tile-alapu terkep dekodolasa
- `base__extract_column_from_tile_based_map.txt` – Oszlop kinyerese tile terképbol
- `base__extract_row_from_tile_based_map.txt` – Sor kinyerese tile terképbol

#### Tutorial sorozatok
- `base__machine_language_tutorial.txt` – Gepikod tutorial alap
- `base__machine_language_tutorial_part_1.txt` – Gepikod tutorial 1. resz
- `base__machine_language_tutorial_part_2.txt` – 2. resz
- `base__machine_language_tutorial_part_3.txt` – 3. resz
- `base__machine_language_tutorial_part_4.txt` – 4. resz
- `base__machine_language_tutorial_part_5.txt` – 5. resz
- `base__machine_language_tutorial_part_6.txt` – 6. resz
- `base__game_programming.txt` – Jatekprogramozas osszefoglalo
- `base__guide_to_programming_games.txt` – Jatekprogramozas utmutato

#### Grafikus fajlformátumok
- `base__c64_grafix_files_specs_list_v0.03.txt` – C64 grafikus fajlformátumok specifikacio lista v0.03
- `base__drazlace.txt` – Drazlace formatum
- `base__gif_to_sprites.txt` – GIF → sprite konverzio
- `base__calculate_vic_settings_for_showing_a_koala.txt` – VIC beallitas Koala kephez
- `base__reference_for_hes_graphics_basic_1.07.txt` – HES Graphics BASIC 1.07 referencia

#### Demo projektek es peldaprogramok
- `base__ballon_demo_from_manual.txt` – Ballon demo a manualbol
- `base__balloonacy_ii.txt` – Balloonacy II demo
- `base__berzerk_redux.txt` – Berzerk Redux jatek
- `base__bomb_chase_2009.txt` – Bomb Chase 2009
- `base__duo_blast.txt` – Duo Blast
- `base__hyper_duel.txt` – Hyper Duel
- `base__julia_fractal_morpher.txt` – Julia fractal morpher
- `base__just_animation.txt` – Egyszeru animacio
- `base__mandelbrot.txt` – Mandelbrot halmaz
- `base__micropong.txt` – MicroPong
- `base__quest_for_cash.txt` – Quest for Cash
- `base__racked_off.txt` – Racked Off
- `base__repeating_char-lines.txt` – Ismetlodo karakter sorok
- `base__2mhz_time_crunch_v5_disassembled.txt` – 2MHz Time Crunch v5 visszafejtve
- `base__matt_gray_-_driller.txt` – Matt Gray: Driller disassembly
- `base__vicious_sid_demo_routine_explained.txt` – Vicious SID demo rutin magyarazata
- `base__starfield.txt` – Csillagter effekt
- `base__static_starfield.txt` – Statikus csillagter

#### Haladó demoscene es geometria
- `base__4x4_mode_and_circle_routine.txt` – 4x4 mod es kor rutin
- `base__bresenham_circle_routine.txt` – Bresenham kor rajzolo
- `base__bresenham_s_line_algorithm.txt` – Bresenham vonalrajzolo 1
- `base__bresenham_s_line_algorithm_2.txt` – Bresenham vonalrajzolo 2
- `base__circle_routine.txt` – Kor rajzolo rutin
- `base__commodore_vic-ii_color_analysis.txt` – C64 VIC-II szin elemzes
- `base__rather_small_and_rather_fast_screen_offset_component_splitter.txt` – Gyors kepernyoeltolas osszetevo szeto
- `base__improved_clockslide.txt` – Javitott clockslide technika

#### Egyeb es vegyes
- `base__c64doc.txt` – C64 dokumentacios fajl
- `base__all_american_bbs_-_finding_the_serial_number.txt` – All American BBS sorozatszam keresese
- `base__viruslist.txt` – C64 virusok listaja
- `base__programming_languages.txt` – Programozasi nyelvek C64-en
- `base__references.txt` – Hivatkozasok
- `base__notes.txt` – Egyeb megjegyzesek
- `base__sh.txt` – Shell script pelda
- `base__common_pitfalls.txt` – Tipikus programozasi hibak es keruleseik
- `base__sizecoding.txt` – Merettudatos kodolas (size coding)
- `base__delay.txt` – Kesleltetesi rutinok
- `base__fpd.txt` – FPD technika
- `base__fps.txt` – FPS szamitas
- `base__pds.txt` – PDS technika
- `base__cpv.txt` – CPV technika
- `base__rant4.txt` – Rant 4 (demoscene eszmefuttatas)
- `base__rant9.txt` – Rant 9
- `base__rant11.txt` – Rant 11
- `base__start.txt` – Codebase64 base nyitolap
- `base__jeffy.txt` – Jeffy DOS implementacioja
- `base__newshell.txt` – New Shell (parancssor)
- `base__mc_al.txt` – MC assembler leiro
- `base__pallo.txt` – Pallo demo

---

## 4. TEMATIKUS KERESZTINDEX

### 4.1 Stabil raster IRQ / double IRQ
1. `knowledge/sources/codebase64/pages/interrupts__making_stable_raster_routines.txt` – **LEGJOBB**
2. `knowledge/sources/codebase64/pages/base__stable_raster_routine.txt` – Kick Assembler kod
3. `knowledge/sources/codebase64/pages/base__double_irq.txt`
4. `knowledge/sources/codebase64/pages/base__double_irq_explained.txt`
5. `knowledge/sources/codebase64/pages/base__the_double_irq_method.txt`
6. `knowledge/sources/codebase64/pages/base__shortest_stable_raster.txt`
7. `knowledge/sources/pdfs/vic-ii.pdf` – Bad Lines, DMA timing
8. `knowledge/sources/pdfs/c=hacking6.pdf` – Border/raster PAL timing

### 4.2 VIC-II memoria szervezes ($D018)
1. `knowledge/sources/codebase64/pages/base__vicii_memory_organizing.txt`
2. `knowledge/sources/pdfs/VIC-II reference.pdf`
3. `knowledge/sources/pdfs/vic-ii.pdf`
4. `knowledge/sources/pdfs/mapping-the-commodore-64.pdf`
5. `knowledge/sources/pdfs/c64-programmers_reference_guide-03-programming_graphics.pdf`

### 4.3 Sprite multiplex / tobb mint 8 sprite
1. `knowledge/sources/codebase64/pages/base__sprite_multiplexer.txt`
2. `knowledge/sources/codebase64/pages/base__flexible_32_sprite_multiplexer.txt`
3. `knowledge/sources/codebase64/pages/base__flexible_48_sprite_multiplexer.txt`
4. `knowledge/sources/codebase64/pages/base__sprite_multiplexer_sorting.txt`
5. `knowledge/sources/pdfs/c=hacking6.pdf` – DYCP sprite multiplex technika
6. `knowledge/sources/pdfs/vic-ii.pdf` – Sprite DMA timing

### 4.4 SID programozas / zene
1. `knowledge/sources/codebase64/pages/base__sid_programming.txt`
2. `knowledge/sources/codebase64/pages/sid__simple_irq_music_player.txt`
3. `knowledge/sources/pdfs/Assembly_Language_Programming_With_the_Commodore_64_1984_Brady_Communications_Company.pdf` – 10. fej.
4. `knowledge/sources/codebase64/pages/base__pal_frequency_table.txt`
5. `knowledge/sources/codebase64/pages/base__classic_hard-restart_and_about_adsr_in_generally.txt`

### 4.5 CIA timerek, TOD ora
1. `knowledge/sources/codebase64/pages/cia__io_programming.txt`
2. `knowledge/sources/codebase64/pages/cia__efficient_tod_initialisation.txt`
3. `knowledge/sources/codebase64/pages/cia__initialize_tod_clock_on_all_platforms.txt`
4. `knowledge/sources/pdfs/Assembly_Language_Programming_With_the_Commodore_64_1984_Brady_Communications_Company.pdf` – 12. fej.
5. `knowledge/sources/pdfs/mapping-the-commodore-64.pdf`

### 4.6 Kick Assembler szintaxis
1. `knowledge/sources/pdfs/KickAssembler.pdf` – **PRIMER FORRAS**
2. `knowledge/sources/codebase64/pages/base__kick_assembler_macros.txt`
3. `knowledge/sources/codebase64/pages/base__kick_assembler_tips_tricks.txt`
4. `knowledge/sources/codebase64/pages/base__sprite_data_and_kickassembler.txt`
5. `knowledge/sources/codebase64/pages/base__handling_irqs_with_some_simple_macros.txt`

### 4.7 Memoria terkep, cimek
1. `knowledge/sources/pdfs/mapping-the-commodore-64.pdf` – **LEGJOBB**
2. `knowledge/sources/urls/reference-sites.md` → https://sta.c64.org/cbm64mem.html
3. `knowledge/sources/pdfs/c64-programmers_reference_guide-05-basic_to_machine_language.pdf`
4. `knowledge/sources/codebase64/pages/base__io_addresses.txt`
5. `knowledge/sources/codebase64/pages/base__memconfig.txt`

### 4.8 Border megnyitas
1. `knowledge/sources/codebase64/pages/base__removing_the_sideborders.txt`
2. `knowledge/sources/codebase64/pages/base__removing_the_top_bottom_border.txt`
3. `knowledge/sources/codebase64/pages/vic__opening_the_top_bottom_borders.txt`
4. `knowledge/sources/codebase64/pages/vic__opening_up_the_borders_-_a_further_explanation.txt`
5. `knowledge/sources/pdfs/vic-ii.pdf` – Border trigger mehanizmus
6. `knowledge/sources/pdfs/c=hacking6.pdf` – PAL timing reszletek

### 4.9 6502/6510 dokumentalatlan opkodok
1. `knowledge/sources/codebase64/pages/base__6510_8502_undocumented_commands.txt`
2. `knowledge/sources/codebase64/pages/base__illegalmnemonicslist.txt`
3. `knowledge/sources/pdfs/Programming the VIC_ The Definitive Guide to the Commodore VIC-20 Computer [West 1987-01-01].pdf`
4. `knowledge/sources/codebase64/pages/base__extra_instructions_of_the_65xx_series_cpu.txt`

### 4.10 FLI es grafikai modok
1. `knowledge/sources/codebase64/pages/base__fli.txt`
2. `knowledge/sources/codebase64/pages/base__ifli.txt`
3. `knowledge/sources/codebase64/pages/base__afli.txt`
4. `knowledge/sources/pdfs/vic-ii.pdf`
5. `knowledge/sources/pdfs/c64-programmers_reference_guide-03-programming_graphics.pdf`

### 4.11 KERNAL rutinok
1. `knowledge/sources/urls/reference-sites.md` → https://sta.c64.org/cbm64krnfunc.html
2. `knowledge/sources/pdfs/mapping-the-commodore-64.pdf`
3. `knowledge/sources/codebase64/pages/base__kernalreference.txt`
4. `knowledge/sources/pdfs/c64-programmers_reference_guide-05-basic_to_machine_language.pdf`
5. `knowledge/sources/pdfs/Assembly_Language_Programming_With_the_Commodore_64_1984_Brady_Communications_Company.pdf` – 9. fej.

### 4.12 Gyors szorzas / matematika
1. `knowledge/sources/codebase64/pages/base__seriously_fast_multiplication.txt`
2. `knowledge/sources/codebase64/pages/base__fastest_multiplication.txt`
3. `knowledge/sources/codebase64/pages/base__8bit_multiplication_16bit_product.txt`
4. `knowledge/sources/codebase64/pages/base__mathematics_in_assembly_article_series.txt` (+ part_1–8)
5. `knowledge/sources/codebase64/pages/base__fixed_point_arithmethic.txt`

### 4.13 Lemez I/O / fastloader
1. `knowledge/sources/codebase64/pages/base__fastloaders.txt`
2. `knowledge/sources/codebase64/pages/base__loading_a_file.txt`
3. `knowledge/sources/codebase64/pages/base__dos_examples.txt`
4. `knowledge/sources/codebase64/pages/base__irq_disk_loader.txt`

### 4.14 Eger es joystick input
1. `knowledge/sources/codebase64/pages/base__c_1351_standard_mouse_routine.txt`
2. `knowledge/sources/codebase64/pages/base__neos_mouse_routine.txt`
3. `knowledge/sources/codebase64/pages/base__joystick_input_handling.txt`
4. `knowledge/sources/codebase64/pages/base__both_joysticks_handling_plus_proper_keyboard_scan.txt`

### 4.15 REU programozas
1. `knowledge/sources/codebase64/pages/base__reu_programming.txt`
2. `knowledge/sources/codebase64/pages/base__reu_registers.txt`
3. `knowledge/sources/codebase64/pages/base__reu_read_and_write.txt`

### 4.16 PAL vs NTSC kulonbsegek
1. `knowledge/sources/codebase64/pages/base__detect_pal_ntsc.txt`
2. `knowledge/sources/codebase64/pages/base__ntsc_pal_differences.txt`
3. `knowledge/sources/codebase64/pages/cia__initialize_tod_clock_on_all_platforms.txt`
4. `knowledge/sources/codebase64/pages/base__playing_music_on_pal_and_ntsc.txt`

### 4.17 Cartridge fejlesztes
1. `knowledge/sources/codebase64/pages/base__assembling_your_own_cart_rom_image.txt`
2. `knowledge/sources/codebase64/pages/base__about_easyflash.txt`
3. `knowledge/sources/codebase64/pages/base__crt_file_format.txt`
4. `knowledge/sources/codebase64/pages/base__code_frame_for_16_kb_crt-images.txt`

### 4.18 Tomorites (Exomizer, LZW, RLE)
1. `knowledge/sources/urls/exomizer.md` – **Exomizer 1.1.5 teljes dokumentacio + exodecrunch.s forras**
2. `knowledge/sources/codebase64/pages/crossdev__exomizer_level_compress_decompression_for_beginners.txt` – kezdoknek szolo utmutato
3. `knowledge/sources/codebase64/pages/base__exomizer_adding_decrunch_splash_screens_during_sfx_decrunch.txt`
4. `knowledge/sources/codebase64/pages/base__exomizer_making_custom_oldschool_decrunch_effects.txt`
5. `knowledge/sources/codebase64/pages/base__rle_pack_unpack.txt`
6. `knowledge/sources/codebase64/pages/base__the_secret_of_fast_lzw_crunching.txt`
7. `knowledge/sources/pdfs/c=hacking6.pdf` – LZW 6510-ben

### 4.19 Scrolling (1x1, 2x2, 4 iranyu)
1. `knowledge/sources/codebase64/pages/base__1x1_scroll.txt`
2. `knowledge/sources/codebase64/pages/base__2x2_sidescroll.txt`
3. `knowledge/sources/codebase64/pages/base__4_ways_scroll.txt`
4. `knowledge/sources/codebase64/pages/base__double_screen_horizontal_scroller.txt`
5. `knowledge/sources/codebase64/pages/base__freedirectional_scrolling_using_map_dumps.txt`

### 4.20 Veletlen szam generatorok
1. `knowledge/sources/codebase64/pages/base__comparison_of_6502_random_generators.txt`
2. `knowledge/sources/codebase64/pages/base__16bit_pseudo_random_generator.txt`
3. `knowledge/sources/codebase64/pages/base__32bit_galois_lfsr.txt`
4. `knowledge/sources/codebase64/pages/6502_6510_maths__x_abc_random_number_generator_8_16_bit.txt`

---

*Index letrehozva: 2026-05-26 | Forrasok: 16 PDF + 4 URL + 660 Codebase64 Wiki oldal*
