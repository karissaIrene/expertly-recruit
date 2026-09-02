# Expertly Recruit

Marketing site for Expertly Recruit, retained AI leadership search run by a
subject matter expert and an engagement partner. Two pages: a long-form site
(`index.html`) and the current lead page for CEOs, CTOs and COOs hiring their
first AI leader (`explore.html`).

## Files

| Path | What it is |
|---|---|
| `explore.html` | The lead page, for a C-suite hiring their first AI leader. Authored as a **fragment** (no `<html>`/`<head>`/`<body>`). |
| `index.html` | The longer original site. Same fragment convention. |
| `build.sh` | Wraps each fragment into a complete document under `dist/`. One `build_page` line per page. |
| `dist/` | Built, deployable static site. Committed so the Docker image needs no build step. |
| `Dockerfile` | nginx:alpine serving `dist/`. |
| `nginx.conf` | Static config: clean URLs, scanner-probe blocking, asset caching. |

### Why the source is a fragment

Each page is published directly as a Claude artifact for review, and that
publisher supplies its own document skeleton — a page carrying its own
`<!doctype>`/`<html>`/`<head>` is rejected. A deployed site needs the real head
(viewport, description, social cards, favicon), so `build.sh` is the single place
that gap is closed. Edit the fragment, then run `./build.sh`.

## Local

```bash
./build.sh
open dist/explore/index.html   # the lead page
open dist/index.html           # the longer site
```

## Deploy

```bash
docker build -t expertly-recruit .
docker run -p 8080:80 expertly-recruit
```

Mirrors the `skyertalent` static-site setup in the `chem` repo, so it drops into
the same Coolify/Digital Ocean pattern.

## Brand

Colours are taken from expertly.com's live Framer tokens, not approximated:

- `#0099FF` primary blue
- `#8500BA → #009CEB` the signature 113° gradient
- `#4C3DDB` indigo, `#12008A` deep navy
- `#E7E3FF` lavender wash

Type is Inter (Expertly's face) with IBM Plex Mono as the utility face, linked
from Google Fonts. That is the one external host the artifact CSP admits; every
other CDN is blocked, and both stacks still fall back through system fonts.

## Unverified claims

These are placeholders pending confirmation before any public launch:

- "2-3 weeks to a shortlist" carries over from Skyer Talent's current site copy.
- "25+ years", "dozens of AI products" and "used billions of times a year" come
  from the brief, not a verified source. A specific founding year would be
  stronger than "decades".
- The debrief call on `explore.html` is an illustrative example, written to show
  the shape of the conversation. It is not a transcript of a real placement.
- `recruit@expertly.com` may not exist yet.

## Voice

Copy rules confirmed with Karissa live in `../.claude/rules/brand-voice.md`.
The load-bearing ones: no em dashes, no abbreviations, no AI job titles, never
score a candidate, never imply the new hire overrules company leadership, and
never suggest the reader is out of their depth.
