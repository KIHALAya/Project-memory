# ============================================================
#  .latexmkrc — latexmk configuration
#  Place in project root. Overrides system-wide settings.
# ============================================================

# ── ENGINE ───────────────────────────────────────────────────
$pdf_mode = 4;              # 4 = lualatex
$lualatex = 'lualatex -shell-escape -interaction=nonstopmode '
           . '-halt-on-error -file-line-error -synctex=1 %O %S';

# ── BIBLIOGRAPHY ─────────────────────────────────────────────
$biber     = 'biber %O %S';
$bibtex_use = 2;             # Use biber (not bibtex)

# ── GLOSSARIES ───────────────────────────────────────────────
# Run makeglossaries automatically when .glo changes
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
  my ($base_name, $path) = fileparse( $_[0] );
  # On some systems, makeglossaries fails if the .glo file is empty.
  # We check the size and skip if 0.
  if (-e $_[0] && -s $_[0] == 0) {
    warn "Latexmk: Skipping makeglossaries for '$_[0]' because it is empty.\n";
    return 0;
  }
  pushd $path;
  my $return = system "makeglossaries \"$base_name\"";
  popd;
  return $return;
}

# Clean these extra extensions on 'latexmk -c'
$clean_ext = '%R.acn %R.acr %R.alg %R.glg %R.glo %R.gls '
           . '%R.ist %R.lod %R.idx %R.ilg %R.ind '
           . '%R.run.xml %R.synctex.gz';

# ── OUTPUT ───────────────────────────────────────────────────
# Uncomment to put aux files in a build directory:
# $out_dir   = 'build';
# $aux_dir   = 'build/aux';

# ── PREVIEWER (optional) ─────────────────────────────────────
# $pdf_previewer = 'evince %O %S';   # Linux
# $pdf_previewer = 'open %S';        # macOS
