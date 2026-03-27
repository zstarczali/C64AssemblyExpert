# How To Use This Agent Pack

This project is designed to work as a portable C64 assembly expert prompt-and-knowledge package.

## What it is

This repository contains:
- a general system prompt
- tool-specific instruction files
- local source material
- an index that maps topics to sources

It is not a standalone executable agent by itself. Instead, you plug these files into the AI tool you want to use.

## Use with Claude

1. Open this project in the Claude environment that supports project instructions.
2. Use `CLAUDE.md` as the project instruction file.
3. Keep the `knowledge/` folder in the same project so Claude can reference it.
4. Ask source-based C64 questions.

## Use with GitHub Copilot

1. Open this repository in VS Code or another Copilot-supported environment.
2. Use `COPILOT_INSTRUCTIONS.md` as the repo instruction file or copy its content into your Copilot custom instructions setup.
3. Keep the `knowledge/` folder in the repo.
4. Ask Copilot to answer using local project sources.

## Use with Other Tools

1. Use `SYSTEM_PROMPT.md` as the system or developer prompt.
2. Give the model access to the `knowledge/` folder.
3. Ask it to cite local sources when answering.

## Recommended Prompt Pattern

Use prompts like:

- Explain how the C64 sprite pointer table works using the local sources.
- Write a Kick Assembler routine for a raster interrupt and cite the relevant references.
- Compare the memory implications of character mode and bitmap mode using the project sources.
- Debug this routine using the project's C64 references.

## Key Files

- `SYSTEM_PROMPT.md`
- `CLAUDE.md`
- `COPILOT_INSTRUCTIONS.md`
- `knowledge/index-template.md`
- `knowledge/sources/urls/reference-sites.md`
- `knowledge/sources/pdfs/`
