# Agent instructions for this repository (archi)

## Repository focus

- `archi` is a bilingual (FR/EN) personal coding blog. Short posts live under `_posts/{en,fr}/`, longer deep-dive articles under `_articles/`.
- Graph-Driven Design (GDD) is one deep-dive article, not the site’s topic. Keep examples practical (Products, Orders, Pricing) when needed.
- French pages are canonical; always mirror edits in English to keep both languages aligned.

## Bilingual workflow

- Every page has `*.fr.md` and `*.en.md` siblings sharing the same slug/permalink. Front matter should define `lang`, `page_id`, `permalink`, and optional `nav_section`.
- Add a top-of-page language switch using language-neutral Liquid links (use the `relative_url` filter); do not hard-code `/fr` or `/en` in URLs.
- Mirror structure 1:1 (headings, sections, tables). Translate prose only—leave code/identifiers unchanged.

## Layout & styling

- All pages use `_layouts/default.html` for header, bilingual nav, skip link, and footer. Don’t reintroduce Cayman or inline styles.
- Make visual tweaks only in `assets/css/main.scss` to keep the Inter typography, neutral palette, and card layout consistent.

## Linking & navigation

- Use language-neutral Liquid links like `{{ '/articles/gdd/' | relative_url }}` and `{{ '/blog/' | relative_url }}` so Polyglot rewrites them per locale.
- When adding primary sections, update the EN/FR nav labels in `_layouts/default.html` so the header matches.
- Keep identical permalinks across languages, or bind pages via a shared `page_id`.

## Developer workflow

- Prereqs: Ruby 3.3.x and Bundler. Scripts install Bundler if missing and vendor-install gems to `vendor/bundle/`.
- Local preview (foreground default): `./scripts/serve.sh`. Background mode: `./scripts/serve.sh --daemon`. Stop background server: `./scripts/stop.sh`.
- Static build: `./scripts/build.sh` (outputs to `_site/`).
- Endpoint checks: `./scripts/check.sh` (uses `BASE_URL=http://127.0.0.1:4000/archi` by default). Add new EN/FR URLs there when introducing pages.

## Scope guardrails

- This is a static Jekyll site. Avoid adding app runtimes/frameworks; keep content in Markdown with minimal HTML.
- Code samples are encouraged in posts/articles, but don’t add build pipelines beyond Jekyll.

## Quality bar

- Done when: local server starts cleanly, checks pass, FR/EN pages remain aligned, language-switch links work, and styling remains consistent with the custom layout.
