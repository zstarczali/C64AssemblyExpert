# Smoke Test

Datum: 2026-03-27

## Copilot CLI plugin

Statusz: sikeres betoltes igazolva

Vegrehajtott lepesek:
1. `copilot plugin install ./plugins/c64-assembly-copilot`
2. `copilot plugin list`
3. `copilot -p "/skills list"`
4. `copilot -p "/agent"`

Eredmenyek:
- a plugin sikeresen telepult
- a `c64-assembly-expert` plugin latszik a telepitett pluginok listajaban
- a `c64-assembly-expert` skill latszik a skill listaban
- a Copilot a helyi `knowledge/` mappabol olvasta be a C64 forrasokat

Fobb bizonyitek:
- `Plugin "c64-assembly-expert" installed successfully. Installed 1 skill.`
- `Installed plugins: c64-assembly-expert (v0.1.0)`
- a `/skills list` valaszban megjelent a `c64-assembly-expert`

## Codex plugin

Statusz: plugin scaffold es repo marketplace rendben, aktiv betoltes nem igazolt nem-interaktiv modban

Vegrehajtott lepesek:
1. Codex CLI elerhetoseg ellenorzese
2. repo marketplace ellenorzese: `.agents/plugins/marketplace.json`
3. manifest ellenorzese: `plugins/c64-assembly-codex/.codex-plugin/plugin.json`
4. nem-interaktiv proba: `codex exec ... "Use the c64-assembly-expert plugin or skill if available"`

Eredmenyek:
- a Codex CLI telepitve van
- a repo-s marketplace fajl a dokumentalt helyen van
- a plugin manifest a dokumentalt helyen van
- a nem-interaktiv session latta a skill fajlt a repoban
- de a session visszajelzese szerint a plugin/skill nem volt aktiv session skillkent regisztralva

Fobb bizonyitek:
- `c64-assembly-expert exists locally in the repo, but it is not registered in this session's AGENTS skill list`

## Kovetkeztetes

- Copilot CLI: mukodik, betoltodott
- Codex: a plugin csomag es a marketplace kesz, de a tenyleges aktivalas valoszinuleg interaktiv plugin install/enabled lepeshez kotott

## Javasolt kezi Codex ellenorzes

1. Nyisd meg a repot Codexben.
2. Inditsd ujra a Codexet, ha mar nyitva volt.
3. Nyisd meg a plugin feluletet.
4. Keresd a `Local C64 Plugins` marketplace-et.
5. Engedelyezd vagy telepitsd a `C64 Assembly Expert` plugint.
6. Uj sessionben kerdezd meg: `Use the c64-assembly-expert plugin and list the C64 sources you can access.`
