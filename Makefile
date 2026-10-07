# ============================================================
#  Makefile — Professional LaTeX compilation workflow
#  Targets: make, make draft, make clean, make cleanall, make watch
# ============================================================

# ── CONFIGURATION ────────────────────────────────────────────
MAIN       := main
ENGINE     := lualatex
BIBER      := biber
GLOSSARIES := makeglossaries
LATEXMK    := latexmk

# latexmk flags
LATEXMK_FLAGS := \
  -$(ENGINE) \
  -interaction=nonstopmode \
  -halt-on-error \
  -file-line-error \
  -shell-escape \
  -synctex=1

# ── TARGETS ──────────────────────────────────────────────────

.PHONY: all draft clean cleanall watch help count

## Default: full production build
all:
	@echo "▶ Full production build..."
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)
	@echo "✓ Build complete → $(MAIN).pdf"

## Draft: single pass, fast (no bibliography/glossary update)
draft:
	@echo "▶ Draft build (single pass)..."
	$(ENGINE) -shell-escape -interaction=nonstopmode $(MAIN).tex
	@echo "✓ Draft complete"

## Manual full build (without latexmk)
manual:
	@echo "▶ Manual full build..."
	$(ENGINE)    -shell-escape -interaction=nonstopmode $(MAIN).tex
	$(BIBER)     $(MAIN)
	$(GLOSSARIES) $(MAIN)
	$(ENGINE)    -shell-escape -interaction=nonstopmode $(MAIN).tex
	$(ENGINE)    -shell-escape -interaction=nonstopmode $(MAIN).tex
	@echo "✓ Manual build complete"

## Watch: auto-recompile on file save (requires latexmk)
watch:
	@echo "▶ Watching for changes (Ctrl+C to stop)..."
	$(LATEXMK) $(LATEXMK_FLAGS) -pvc $(MAIN)

## Clean: remove auxiliary files, keep PDF
clean:
	@echo "▶ Cleaning auxiliary files..."
	$(LATEXMK) -c
	rm -f *.acn *.acr *.alg *.glg *.glo *.gls *.ist \
	      *.lod *.lof *.lot *.lol *.idx *.ilg *.ind \
	      *.bbl *.bcf *.blg *.run.xml *.synctex.gz
	@echo "✓ Clean complete"

## Cleanall: remove all generated files including PDF
cleanall: clean
	@echo "▶ Removing PDF..."
	$(LATEXMK) -C
	rm -f $(MAIN).pdf
	@echo "✓ All generated files removed"

## Count words (requires texcount)
count:
	texcount -sum -1 $(MAIN).tex

## Help
help:
	@echo ""
	@echo "  LaTeX Report — Build Targets"
	@echo "  ─────────────────────────────────────────────────"
	@echo "  make          Full production build (via latexmk)"
	@echo "  make draft    Quick single-pass draft"
	@echo "  make manual   Manual biber+glossaries pipeline"
	@echo "  make watch    Auto-recompile on file changes"
	@echo "  make clean    Remove .aux, .log, .bbl, etc."
	@echo "  make cleanall Remove everything including PDF"
	@echo "  make count    Word count via texcount"
	@echo ""
