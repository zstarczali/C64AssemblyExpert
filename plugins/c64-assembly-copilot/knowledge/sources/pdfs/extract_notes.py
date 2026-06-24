"""
Extract detailed notes from all C64-related PDFs.
Writes .notes.md files for each PDF.
"""
import sys
import os
sys.stdout.reconfigure(encoding='utf-8')

from pypdf import PdfReader

PDF_DIR = r'F:\Development\C64AssemblyExpert\knowledge\sources\pdfs'

def extract_pages(pdf_path, start=0, end=None):
    """Extract text from pages start..end (0-indexed)."""
    reader = PdfReader(pdf_path)
    pages = reader.pages
    if end is None:
        end = len(pages)
    end = min(end, len(pages))
    text_parts = []
    for i in range(start, end):
        try:
            t = pages[i].extract_text() or ""
            text_parts.append(f"--- PAGE {i+1} ---\n{t}")
        except Exception as e:
            text_parts.append(f"--- PAGE {i+1} --- [error: {e}]")
    return "\n".join(text_parts)

def get_page_count(pdf_path):
    return len(PdfReader(pdf_path).pages)

def save_notes(filename, content):
    path = os.path.join(PDF_DIR, filename)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Saved: {filename}")

# Process each PDF
pdfs = {
    "6502 Opcodes.pdf": "6502 Opcodes.notes.md",
    "6502 Instruction Set.pdf": "6502 Instruction Set.notes.md",
    "VIC-II reference.pdf": "VIC-II reference.notes.md",
    "vic-ii.pdf": "vic-ii.notes.md",
    "pal.pdf": "pal.notes.md",
    "KickAssembler.pdf": "KickAssembler.notes.md",
    "C64 Assembly.pdf": "C64 Assembly.notes.md",
    "40 Best Machine Code Routines For C64.pdf": "40 Best Machine Code Routines For C64.notes.md",
    "c64-programmers_reference_guide-03-programming_graphics.pdf": "c64-programmers_reference_guide-03-programming_graphics.notes.md",
    "c64-programmers_reference_guide-05-basic_to_machine_language.pdf": "c64-programmers_reference_guide-05-basic_to_machine_language.notes.md",
    "mapping-the-commodore-64.pdf": "mapping-the-commodore-64.notes.md",
    "Machine_Language_for_the_Commodore_Revised_and_Expanded_Edition.pdf": "Machine_Language_for_the_Commodore_Revised_and_Expanded_Edition.notes.md",
    "A Commodore 64-es belső felépítése.pdf": "A Commodore 64-es belső felépítése.notes.md",
    "Programming the VIC_ The Definitive Guide to the Commodore VIC-20 Computer [West 1987-01-01].pdf": "Programming the VIC_ The Definitive Guide to the Commodore VIC-20 Computer [West 1987-01-01].notes.md",
}

for pdf_name, notes_name in pdfs.items():
    pdf_path = os.path.join(PDF_DIR, pdf_name)
    if not os.path.exists(pdf_path):
        print(f"MISSING: {pdf_name}")
        continue
    n = get_page_count(pdf_path)
    # For large PDFs extract first 80 pages (covers TOC + intro chapters)
    # For smaller ones extract all
    limit = min(n, 80)
    print(f"Extracting {pdf_name} ({n} pages, reading {limit})...")
    text = extract_pages(pdf_path, 0, limit)
    out_path = os.path.join(PDF_DIR, notes_name + ".raw.txt")
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(text)
    print(f"  -> raw text saved to {notes_name}.raw.txt")

print("Done extracting raw text.")
