# Copilot instructions for this repository (archi)

## Repository focus
- `archi` is a bilingual (FR/EN) personal coding blog built with Jekyll + Polyglot. It contains short posts in `_posts/{en,fr}/` and longer deep-dive articles in `_articles/`.
- The Graph-Driven Design (GDD) piece is one deep-dive article, not the site’s overall topic. Keep examples domain-grounded (Products, Orders, Pricing) when useful.
- Treat French pages as canonical but keep English mirrors in lockstep after any change.

## Bilingual workflow
- Each page lives as `*.fr.md` and `*.en.md` siblings sharing the same slug/permalink. Front matter must include `lang`, `page_id`, `permalink`, and optional `nav_section`.
- Add a language switch at the top using a language-neutral Liquid URL via the `relative_url` filter (no hard-coded `/en` or `/fr` in the path).
- Mirror structure 1:1 (headings, sections, tables). Translate prose only; keep code/identifiers as-is.

## Layout & styling
- All pages inherit `_layouts/default.html` (header, bilingual nav, skip link, footer). Do not reintroduce Cayman or inline styles.
- Update visual tweaks only in `assets/css/main.scss` to preserve the Inter typography, neutral palette, and card layout.

## Linking & navigation
- Use Liquid relative links so URLs stay language-neutral, e.g. `{{ '/articles/gdd/' | relative_url }}`, `{{ '/blog/' | relative_url }}`.
- When adding primary sections, also update the nav label variants (EN/FR) inside `_layouts/default.html` so the header stays in sync.
- Keep permalinks identical between languages, or bind pages with a shared `page_id`.

## Developer workflow
- Prereqs: Ruby 3.3.x with Bundler available. Scripts will install Bundler if missing and vendor-install gems under `vendor/bundle/`.
- Preview locally (foreground by default): `./scripts/serve.sh`. Background mode: `./scripts/serve.sh --daemon`. Stop background server: `./scripts/stop.sh`.
- Build static export: `./scripts/build.sh` → output in `_site/`.
- Basic endpoint checks: `./scripts/check.sh` (defaults to `BASE_URL=http://127.0.0.1:4000/archi`). Extend its URL list when adding new EN/FR pages.

## Scope guardrails
- This repo ships a static site; avoid adding app runtimes/frameworks. Keep content in Markdown with simple HTML when necessary.
- Code samples are welcome in posts/articles, but don’t add build pipelines beyond Jekyll.

## Quality bar
- Complete when: local server starts cleanly, `scripts/check.sh` returns 0, FR/EN pages remain aligned, language-switch links work, and styles conform to the custom layout.
