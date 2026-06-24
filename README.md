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

## VS Code + Claude alatt

Ez a projekt nem klasszikusan forditando program, hanem egy forrasalapu agent csomag, ezert nincs kulon build vagy compile lepes.

Hasznalat VS Code-ban Claude mellett:

1. Nyisd meg ezt a repositoryt a VS Code-ban.
2. Gyozodj meg rola, hogy a projekt gyokerben elerheto a `CLAUDE.md` fajl.
3. Hagyd a `knowledge/` mappat a repo mellett, mert Claude innen fogja hasznalni a helyi forrasokat.
4. Ha a Claude projekt instrukcioit kerdezi, a `CLAUDE.md` legyen az alap instrukcios fajl.
5. Ha kulon Claude workspace-t hasznalsz, a teljes repot nyisd meg ott, vagy masold at ugy, hogy a `CLAUDE.md` es a `knowledge/` egyutt maradjon.

Rovid ellenorzes: kerj egy C64 temaju, forrasalapu valaszt, es nezd meg, hogy a modell a helyi `knowledge/` anyagokra hivatkozik-e.

## A `.plugin` fajl

A `c64-assembly-expert.plugin` fajl egy atnevezett ZIP archivu. Nem forditasbol keletkezik, hanem a plugin tartalmat csomagolja ossze.

A repo gyokerben nincs `skills/` mappa; az a plugin-almappakban van:

- `plugins/c64-assembly-codex/skills/`
- `plugins/c64-assembly-copilot/skills/`

Ez a fajl a plugin-kornyezetbol keszult, nem a repo gyokerbol.

Ujragyartashoz a megfelelo plugin gyokerkonyvtarabol futtasd:

```sh
cd plugins/c64-assembly-codex
zip -r ../../c64-assembly-expert.plugin .claude-plugin skills README.md
```

Ebben a csomagban tipikusan ezek vannak:

1. `.claude-plugin/plugin.json`
2. `skills/` alatti skill fajlok es referenciaanyagok
3. `README.md`

Ha uj verzio kell, eleg a plugin tartalmat modositanod, majd ujracsomagolni.

## Fontos

Ez a projekt nem egy kulon futtathato program, hanem egy ujrafelhasznalhato agent pack:
- promptokkal
- forrasokkal
- strukturalt tudassal

Ezert tobb rendszerben is hasznalhato ugyanazzal a C64 szakertoi alappal.
