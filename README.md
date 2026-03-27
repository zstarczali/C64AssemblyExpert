# C64 Assembly Agent Pack

Ez a projekt egy hordozhato, forrasalapu Commodore 64 assembly agent csomag.

Cel:
- URL-ekbol, PDF-ekbol es konyvanyagokbol epitett tudasbazis hasznalata
- 6510/C64 assembly temakban megbizhato segitseg
- Claude, Copilot es egyeb promptalapu agentek tamogatasa

## Fobb fajlok

- `SYSTEM_PROMPT.md`: altalanos agent prompt
- `CLAUDE.md`: Claude projekthez valo instrukciok
- `COPILOT_INSTRUCTIONS.md`: GitHub Copilothoz valo instrukciok
- `HOW_TO_USE.md`: rovid hasznalati utmutato
- `docs/plugin-install.md`: Codex es Copilot plugin telepitesi jegyzetek
- `docs/smoke-test.md`: smoke test eredmenyek
- `knowledge/index-template.md`: tematikus forrasindex
- `knowledge/sources/`: PDF-ek, URL-ek, jegyzetek, kodreferenciak
- `plugins/`: helyi plugin csomagok Codexhez es Copilothoz

## Milyen temakra jo

- memoria-terkep
- zero page
- VIC-II
- spriteok
- raster interruptok
- SID hang
- CIA chipek
- KERNAL rutinok
- BASIC ROM / KERNAL ROM kapcsolodas
- cycle counting
- PAL vs NTSC
- assembler toolchain

## Gyors hasznalat

1. Tartsd a forrasokat a `knowledge/sources/` alatt.
2. Frissitsd a `knowledge/index-template.md` fajlt, ha uj anyagot adsz hozza.
3. Hasznald a megfelelo instrukciofajlt az adott AI eszkozhöz.
4. Kerd az agentet, hogy a valaszokban nevezze meg a hasznalt forrasokat.

## Fontos

Ez a projekt nem egy kulon futtathato program, hanem egy ujrafelhasznalhato agent pack:
- promptokkal
- forrasokkal
- strukturalt tudassal

Ezert tobb rendszerben is hasznalhato ugyanazzal a C64 szakertoi alappal.
