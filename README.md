# Expertly Recruit

Marketing site for Expertly Recruit — AI leadership hiring, run by Expertly's AI
experts rather than by recruiters. Combines Skyer Talent's subject-matter-expert
model with Expertly.com's brand.

## Files

| Path | What it is |
|---|---|
| `index.html` | The page source. Authored as a **fragment** (no `<html>`/`<head>`/`<body>`). |
| `build.sh` | Wraps the fragment into a complete document at `dist/index.html`. |
| `dist/` | Built, deployable static site. Committed so the Docker image needs no build step. |
| `Dockerfile` | nginx:alpine serving `dist/`. |
| `nginx.conf` | Static config: clean URLs, scanner-probe blocking, asset caching. |

### Why the source is a fragment

`index.html` is published directly as a Claude artifact for review, and that
publisher supplies its own document skeleton — a page carrying its own
`<!doctype>`/`<html>`/`<head>` is rejected. A deployed site needs the real head
(viewport, description, social cards, favicon), so `build.sh` is the single place
that gap is closed. Edit `index.html`, then run `./build.sh`.

## Local

```bash
./build.sh
open dist/index.html
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

Type is Inter (Expertly's face) with IBM Plex Mono as the utility face. Neither is
loaded from a CDN — an artifact CSP blocks external hosts — so both fall back
through a hardened system stack.

## Unverified claims

These are placeholders pending confirmation before any public launch:

- "200+ AI experts in our network" and "2–3 weeks to a shortlist" carry over from
  Skyer Talent's current site copy.
- "25+ years" / "dozens of AI products" come from the brief, not a verified source.
  A specific founding year would be stronger than "decades".
- Expert profiles are role descriptions only — deliberately no names or photos, so
  illustrative people are never mistaken for real placements.
- `recruit@expertly.com` and `experts@expertly.com` may not exist yet.
