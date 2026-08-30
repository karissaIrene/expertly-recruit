#!/usr/bin/env bash
# Wraps the page source into a complete, deployable HTML document.
#
# WHY two files: index.html is authored as a fragment (no <html>/<head>/<body>)
# because the Artifact publisher supplies its own document skeleton and rejects
# pages that bring their own. A deployed site needs the real head — viewport,
# description, social cards, favicon. This script is the single place that gap
# is closed, so both outputs stay in sync from one source.
set -euo pipefail

cd "$(dirname "$0")"

# page-source : output-path : <title-independent description> : og:title : og:description
# WHY a loop: each page is authored as its own fragment, and both need the same
# head treatment. Adding a page means adding one line here.
build_page() {
  SRC="$1"; OUT="$2"; DESC="$3"; OGTITLE="$4"; OGDESC="$5"

  [ -f "$SRC" ] || { echo "error: $SRC not found" >&2; exit 1; }
  mkdir -p "$(dirname "$OUT")"

{
  cat <<'HEAD'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta name="description" content="__DESC__" />
<link rel="icon" type="image/svg+xml" href="__ROOT__favicon.svg" />
<meta property="og:type" content="website" />
<meta property="og:title" content="__OGTITLE__" />
<meta property="og:description" content="__OGDESC__" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="__OGTITLE__" />
<meta name="twitter:description" content="__OGDESC__" />
<style>
  /* Minimal reset. WHY: the Artifact host supplies one, a plain nginx host does not,
     so the deployed page would otherwise inherit browser default margins. */
  *, *::before, *::after { box-sizing: border-box; }
  body { margin: 0; }
  img, svg { display: block; max-width: 100%; }
</style>
HEAD

  # The source's own <title> and <style> live at the top of the fragment and are
  # valid in <head>; the browser relocates the body content itself.
  cat "$SRC"

  cat <<'FOOT'
</body>
</html>
FOOT
} > "$OUT"

  # Substitute per-page metadata into the shared head.
  ROOT=""
  case "$OUT" in dist/*/*) ROOT="../";; esac
  python3 - "$OUT" "$DESC" "$OGTITLE" "$OGDESC" "$ROOT" <<'META'
import sys
p, desc, ogt, ogd, root = sys.argv[1:6]
s = open(p, encoding="utf-8").read()
for k, v in (("__DESC__", desc), ("__OGTITLE__", ogt), ("__OGDESC__", ogd), ("__ROOT__", root)):
    s = s.replace(k, v)
open(p, "w", encoding="utf-8").write(s)
META

# The fragment opens no <body>, so insert one before the first element that needs it.
# WHY sed over a template: keeps index.html the single source of truth for content.
python3 - "$OUT" <<'PY'
import sys, re
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
marker = '<header class="site">'
if '<body' not in s:
    s = s.replace(marker, '</head>\n<body>\n' + marker, 1)
open(p, "w", encoding="utf-8").write(s)
PY

  echo "built $OUT ($(wc -c < "$OUT" | tr -d ' ') bytes)"
}

build_page index.html dist/index.html \
  "Expertly Recruit places AI leadership. Every hire is run by AI experts who have spent decades building AI themselves, and who stay alongside you through the hire and the first ninety days." \
  "Expertly Recruit — AI leadership, hired by AI experts" \
  "Everyone became an AI expert last year. We've been at it for decades."

build_page explore.html dist/explore/index.html \
  "Expertly Recruit partners with CEOs, CTOs and COOs on hiring AI leadership. Our AI experts shape the role, run the search, interview every shortlisted candidate, and stay through the first ninety days." \
  "Expertly Recruit — AI leadership, hired with you" \
  "Everyone became an AI expert last year. We've been at it for decades."
