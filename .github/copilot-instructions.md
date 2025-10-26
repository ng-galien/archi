# Copilot instructions for this repository (archi)

## Repository focus
- `archi` is a bilingual (FR/EN) personal coding blog built with Jekyll + Polyglot. It contains short posts in `_posts/{en,fr}/` and longer deep-dive articles in `_articles/`.
- The Graph-Driven Design (GDD) piece is one deep-dive article, not the site's overall topic. Keep examples domain-grounded (Products, Orders, Pricing) when useful.
- Treat French pages as canonical but keep English mirrors in lockstep after any change.

## Architecture: Jekyll + Polyglot multi-language
- **Plugin-driven routing**: `_config.yml` uses `jekyll-polyglot` with `languages: ["en", "fr"]` and `default_lang: "en"`. Polyglot auto-generates `/fr/` prefixed paths for French content.
- **Collections**: `_articles/` is a Jekyll collection with `output: true`. Posts use standard `_posts/` with language subdirectories.
- **Theming paradox**: `_config.yml` declares `theme: jekyll-theme-cayman` but the site uses a custom `_layouts/default.html` that completely overrides it. Do NOT add Cayman-specific markup or expect Cayman includes.
- **CSS architecture**: Single entry point `assets/css/main.scss` with Jekyll front matter (`---\n---`) to enable Sass processing. Uses CSS custom properties for theming with `prefers-color-scheme: dark` media query. Config sets `sourcemap: never` to avoid Polyglot conflicts.

## Bilingual workflow
- Each page lives as `*.fr.md` and `*.en.md` siblings sharing the same slug/permalink. Front matter must include `lang`, `page_id`, `permalink`, and optional `nav_section`.
- **Language switch pattern**: Template in `_layouts/default.html` lines 86-112 uses conditional logic based on `page.page_id` to route between languages. The pattern uses `{% static_href %}` tags and handles special cases for home, articles-index, blog-index vs. article permalinks.
- Mirror structure 1:1 (headings, sections, tables). Translate prose only; keep code/identifiers as-is.

## Layout & styling
- All pages inherit `_layouts/default.html` (header, bilingual nav, skip link, footer). The header brand uses a two-part structure: `.brand-mark` ("Ar") + `.brand-copy` (title + tagline).
- Update visual tweaks only in `assets/css/main.scss`. Design system: Inter font stack, neutral palette with CSS vars (`--accent`, `--surface`, `--text`), card-based layouts.
- **Navigation state**: Current section highlighting uses `.is-active` class driven by matching `page.nav_section` or `page.page_id` against hardcoded sections (home/articles/blog).

## Linking & navigation
- Use Liquid relative links so URLs stay language-neutral, e.g. `{{ '/articles/gdd/' | relative_url }}`, `{{ '/blog/' | relative_url }}`.
- When adding primary sections, also update the nav label variants (EN/FR) inside `_layouts/default.html` (lines 40-43) so the header stays in sync.
- Keep permalinks identical between languages, or bind pages with a shared `page_id`.

## Developer workflow
- **Scripts design**: Bash scripts in `scripts/` with strict mode (`set -euo pipefail`). They auto-install Bundler if missing and configure `bundle install --path vendor/bundle`.
- Preview locally: `./scripts/serve.sh` (foreground with live reload). Background: `./scripts/serve.sh --daemon` writes PID to `tmp/pids/jekyll.pid` and logs to `tmp/log/jekyll.log`.
- Stop background server: `./scripts/stop.sh` reads PID and sends TERM signal.
- Build static export: `./scripts/build.sh` → output in `_site/`.
- **Testing pattern**: `./scripts/check.sh` uses curl to verify HTTP 200 on a hardcoded list of EN/FR endpoints. When adding pages, extend the `URLS=()` array at line 7. Uses `BASE_URL=${BASE_URL:-"http://127.0.0.1:4000/archi"}` for flexibility.

## Production deployment
- GitHub Actions workflow `.github/workflows/pages.yml` builds and deploys to GitHub Pages.
- Live site: `https://ng-galien.github.io/archi` (url + baseurl in `_config.yml`).
- The `baseurl: "/archi"` must match repository name for proper asset loading.

## Scope guardrails
- This repo ships a static site; avoid adding app runtimes/frameworks. Keep content in Markdown with simple HTML when necessary.
- Code samples are welcome in posts/articles, but don't add build pipelines beyond Jekyll.

## Quality bar
- Complete when: local server starts cleanly, `scripts/check.sh` returns 0, FR/EN pages remain aligned, language-switch links work, and styles conform to the custom layout.
