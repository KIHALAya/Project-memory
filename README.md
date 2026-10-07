# LaTeX Report Architecture — Professional Blueprint

A modular, scalable, publication-quality LaTeX project structure for
academic and engineering reports. Designed to feel like a professional
software project, not a single monolithic `.tex` file.

---

## Project Structure

```
latex-report/
│
├── main.tex                    ← Master assembly file (entry point)
├── Makefile                    ← Build automation
├── .latexmkrc                  ← latexmk engine configuration
│
├── styles/                     ← All formatting — NEVER content
│   ├── packages.tex            ← Every \usepackage with rationale
│   ├── metadata.tex            ← Single source of truth for names/titles
│   ├── colors.tex              ← Color palette definitions
│   ├── fonts.tex               ← Font configuration (LuaLaTeX + fallback)
│   ├── layout.tex              ← Geometry, chapter/heading styles, headers
│   ├── macros.tex              ← Custom commands and environments
│   ├── listings.tex            ← Code listing styles
│   └── hyperref-setup.tex      ← PDF metadata and hyperlinks
│
├── frontmatter/                ← Pages before Chapter 1
│   ├── cover.tex               ← Professional cover page
│   ├── dedication.tex          ← Dedication page
│   ├── acknowledgements.tex    ← Acknowledgements
│   ├── abstract-fr.tex         ← French abstract
│   └── abstract-en.tex         ← English abstract
│
├── chapters/                   ← Main body — one folder per chapter
│   ├── 00-introduction/
│   │   └── introduction.tex
│   ├── 01-context/
│   │   ├── chapter.tex         ← Chapter root (inputs the sections)
│   │   ├── sec-01-host-organisation.tex
│   │   ├── sec-02-existing-system.tex
│   │   └── sec-03-project-charter.tex
│   ├── 02-state-of-the-art/
│   │   ├── chapter.tex
│   │   ├── sec-01-microservices.tex
│   │   ├── sec-02-streaming-platforms.tex
│   │   └── sec-03-comparative-study.tex
│   ├── 03-analysis-design/
│   ├── 04-implementation/
│   ├── 05-results-evaluation/
│   └── 06-conclusion/
│
├── appendices/                 ← Back matter appendices
│   ├── appendix-a.tex          ← API Reference
│   ├── appendix-b.tex          ← Deployment Guide
│   └── appendix-c.tex          ← Supplementary material
│
├── backmatter/                 ← Glossary, acronyms databases
│   ├── acronyms.tex            ← All \newacronym definitions
│   └── glossary-entries.tex    ← All \newglossaryentry definitions
│
├── bibliography/               ← BibTeX/Biber databases
│   ├── references.bib          ← Books, journals, conference papers
│   └── online.bib              ← Websites, documentation, online sources
│
├── images/                     ← All raster images
│   ├── logos/                  ← University, ministry, company logos
│   ├── figures/                ← Diagrams, screenshots, charts
│   └── screenshots/            ← UI screenshots
│
├── diagrams/                   ← TikZ source files (.tex) for diagrams
│
├── tables/                     ← Complex standalone table files
│
└── resources/                  ← Supporting assets
    ├── fonts/                  ← Custom .otf/.ttf fonts
    └── data/                   ← CSV/JSON data for pgfplots
```

---

## Compilation Workflow

### Recommended: latexmk (automatic)
```bash
# Full build (handles biber + glossaries automatically)
make

# Fast draft (single pass, no bibliography)
make draft

# Auto-recompile on file save
make watch

# Clean auxiliary files
make clean
```

### Manual pipeline
```bash
lualatex -shell-escape main.tex
biber main
makeglossaries main
lualatex -shell-escape main.tex
lualatex -shell-escape main.tex   # Second pass resolves all cross-refs
```

### Why three passes?
| Pass | Purpose |
|------|---------|
| 1st  | Generates `.aux`, `.bbl` requests, `.glo`/`.acn` |
| biber | Resolves bibliography database → `.bbl` |
| makeglossaries | Resolves glossary/acronym entries |
| 2nd  | Inserts bibliography + glossary entries |
| 3rd  | Resolves all cross-references, TOC, page numbers |

---

## Adding a New Chapter

1. Create a new folder:
   ```
   chapters/07-new-topic/
   ```

2. Create the chapter root:
   ```latex
   % chapters/07-new-topic/chapter.tex
   \chapter{New Topic Title}
   \label{chap:new-topic}

   \input{chapters/07-new-topic/sec-01-overview}
   \input{chapters/07-new-topic/sec-02-details}
   ```

3. Create section files:
   ```latex
   % chapters/07-new-topic/sec-01-overview.tex
   \section{Overview}
   \label{sec:new-topic-overview}
   % Content here
   ```

4. Register in `main.tex`:
   ```latex
   \input{chapters/07-new-topic/chapter}
   ```

That's it. No other file needs to change.

---

## Key Packages and Why

| Package | Purpose |
|---------|---------|
| `fontspec` | OpenType font loading for LuaLaTeX |
| `geometry` | Page margins and layout |
| `fancyhdr` | Custom headers and footers |
| `titlesec` | Chapter/section heading styles |
| `xcolor` | Color definitions |
| `tikz` + `pgfplots` | Vector diagrams and data charts |
| `booktabs` | Professional tables (no vertical lines) |
| `biblatex` + `biber` | Modern bibliography management |
| `glossaries-extra` | Glossary and acronym management |
| `minted` | Syntax-highlighted code listings |
| `tcolorbox` | Callout/info boxes |
| `hyperref` | PDF links, bookmarks, metadata |
| `cleveref` | Smart cross-references ("Figure 3.1") |
| `microtype` | Micro-typography improvements |
| `subfig`/`subcaption` | Multi-panel figures |
| `newfloat` | Custom float types (Diagram list) |
| `algorithm2e` | Algorithm pseudocode |

---

## Naming Conventions

| Resource | Convention | Example |
|----------|------------|---------|
| Chapter folders | `NN-kebab-case` | `03-analysis-design/` |
| Section files | `sec-NN-description` | `sec-01-overview.tex` |
| Figure labels | `fig:kebab-case` | `\label{fig:arch-overview}` |
| Table labels | `tab:kebab-case` | `\label{tab:comparison}` |
| Diagram labels | `diag:kebab-case` | `\label{diag:sequence}` |
| Chapter labels | `chap:kebab-case` | `\label{chap:design}` |
| Section labels | `sec:kebab-case` | `\label{sec:requirements}` |
| Acronyms | lowercase | `\newacronym{api}{API}{...}` |
| Image files | `kebab-case` | `arch-overview.png` |
| BibTeX keys | `author:year:keyword` | `newman:2021:microservices` |

---

## Best Practices

### Content vs. Formatting
- **Never** put `\usepackage` in chapter files
- **Never** hard-code colors, fonts, or spacing in content files
- All formatting lives in `styles/`; all text lives in `chapters/`

### Labels and References
- Always use `\label{}` immediately after `\caption{}`
- Use `\figref{}`, `\tabref{}`, `\chapref{}` macros (defined in macros.tex)
  instead of raw `\ref{}` for consistent formatting
- Use `\acrshort{api}` on first use in each chapter, then `\acrshort{}`

### Images
- Store originals (SVG, AI, PSD) in `resources/`; export PNG/PDF to `images/`
- Use `\includegraphics[width=\textwidth]{images/figures/name}` (no extension)
  so LaTeX picks `.pdf` over `.png` automatically
- Vector PDF figures are preferred for publication quality

### Tables
- Use `booktabs` rules: `\toprule`, `\midrule`, `\bottomrule`
- Never use vertical lines in professional tables
- For wide tables, use `pdflscape` to rotate a single page

### Bibliography
- Use separate `.bib` files by type (academic vs. online)
- Fill `doi` and `url` fields — they become clickable links
- Use `\textcite{key}` for "Newman (2021) argues..." style
- Use `\parencite{key}` for "...(Newman, 2021)" style

### Performance (large documents)
- Use `\includeonly{chapters/04-implementation/chapter}` during writing
  to compile only one chapter at a time
- Reduce minted `\inputminted` calls to the minimum; cache with `-shell-escape`
- Keep image files under 5 MB each; use `draft` mode to skip image rendering

---

## Metadata — Single Source of Truth

All document information is defined **once** in `styles/metadata.tex`:
- Author name, student ID, email
- University, faculty, department
- Company name, supervisor names
- Report title, subtitle, academic year
- Logo paths

Change it there and it updates everywhere: cover page, PDF metadata,
headers, title page, acknowledgements.

---

## Optional Enhancements

- **Git version in footer**: `\usepackage{gitinfo2}` → `\gitAbbrevHash`
- **QR code on cover**: `\qrcode{https://github.com/user/repo}`
- **Word count**: `make count` (requires `texcount`)
- **Accessibility**: add `\usepackage{accessibility}` for tagged PDF
- **Automated cover page from CI**: compile with GitHub Actions on push
