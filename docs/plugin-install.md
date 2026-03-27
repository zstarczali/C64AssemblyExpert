# Plugin Install Notes

This repository now contains two local plugin scaffolds:

- Codex plugin: `plugins/c64-assembly-codex`
- GitHub Copilot CLI plugin: `plugins/c64-assembly-copilot`

## Codex

Codex plugin docs say local plugins can be exposed through a repo marketplace at `.agents/plugins/marketplace.json`.

This repository already includes:
- `.agents/plugins/marketplace.json`
- `plugins/c64-assembly-codex/.codex-plugin/plugin.json`

Typical flow:
1. Open this repository in Codex.
2. Restart Codex if it was already open.
3. Open the plugins surface.
4. Look for the `Local C64 Plugins` marketplace.
5. Install or enable `C64 Assembly Expert`.

## GitHub Copilot CLI

Copilot CLI plugins can be installed from a local path.

Typical flow:
1. Open a terminal in this repository.
2. Run `copilot plugin install ./plugins/c64-assembly-copilot`
3. Start Copilot CLI in this repository so it can see the local `knowledge/` folder.

The repository also includes `.github/plugin/marketplace.json` as a local marketplace scaffold for Copilot CLI.

## Important

The plugin instructions assume the repository's `knowledge/` folder is present, because that is where the C64 PDFs, URLs, and index live.
