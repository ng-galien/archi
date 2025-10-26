# Copilot instructions for this repository (archi)

This repo is a bilingual knowledge base about Graph-Driven Design (GDD). There is no application code. Your job is to evolve the Markdown docs under `en/gdd/` and `fr/gdd/` with clear, concrete, domain-grounded examples — and maintain English translations alongside the original French.

## What this repo contains
- `fr/gdd/index.md` — essai principal (tables obèses → relations fonctionnelles, graphe + fonctions pures).
- `fr/gdd/ddd-gdd.md` — tableau comparatif DDD vs modèle relationnel-fonctionnel (GDD).
- English translations live under `en/gdd/` as mirror files: `en/gdd/index.md`, `en/gdd/ddd-gdd.md`.

## Bilingual policy (do this first)
- Do not edit French sources under `fr/`. Maintain English counterparts under `en/`.
- Mirror structure 1:1: same paths and filenames under `en/` and `fr/` (e.g., `en/gdd/<slug>.md` ↔ `fr/gdd/<slug>.md`), same H1/H2 outline, same examples adapted to English.
- Keep relation vocabulary unchanged (nodes Capitalized, relations UPPER_SNAKE with attributes), translate only surrounding prose.
- Add a language switch at the top of each page, linking to its sibling in the other language (e.g., from `en/gdd/<slug>.md` to `fr/gdd/<slug>.md`).

### Language management
- Put a language switch at the top of every English page (after the H1), linking to its sibling French file in `GDD/`.
- For English pages, add front matter `lang: en` to improve accessibility/SEO in GitHub Pages.
- From English pages, link to English targets when available; only link to French if no English page exists yet.
- When adding a new English page, update the bilingual menus in `en/index.md` and `fr/index.md`.

## Authoring conventions
- Language: English for `*.en.md` (clear, pragmatic tone). French typography rules apply only to `*.fr.md`.
- Structure: one H1 per file; H2 sections; bullet lists; Markdown tables for comparisons. Emojis allowed sparingly (see ddd-gdd).
- GDD vocabulary (unchanged in both languages):
  - Nodes (stable, singular, Capitalized): `Product`, `Customer`, `Order`.
  - Relations (first-class, UPPER_SNAKE): `HAS_PRICE`, `PLACED_BY`, `HAS_STATUS`, `HAS_PROMO`, `DISCOUNTED_PRICE`, `CATEGORY`, `SUPPLIER`.
  - Relations carry attributes (e.g., `amount`, `currency`, `valid_from`, `valid_to`). Absence of a link ≈ “no value” (avoid NULL).
  - Versioning/temporality by context: e.g., `HAS_PRICE@v2`, validity period.
  - Business as pure transformation: `[relations₀] → f → [relations₁]` (e.g., price → `HAS_EFFECTIVE_PRICE`; claim → `HAS_CLAIM_STATUS`).
- File naming: kebab-case `.md` files under `en/gdd/` and `fr/gdd/` (no language suffix in filename; language is in the directory path). Add front matter `lang: en` for English pages.
- Linking: use relative links. From English pages, link to English targets when available; you may cross-link to the French source for reference.

## Scope and guardrails
- Don’t introduce runnable code, ORMs, or impl-specific details (conceptual repo).
- Position GDD as complementary to relational/DDD; document observable practices (no aspirational claims).
- If diagrams are proposed, stay in Markdown/tables; don’t add tooling (Mermaid/build) unless explicitly requested.

## Patterns to preserve
- Relation-centric graph: simple nodes; variability on links (attributes + temporal context). Missing link replaces nullability.
- Invariants by structure: phrase rules as coexistence/uniqueness of links (e.g., “per `(Order, scope)`, at most one active `HAS_STATUS`).
- Append-only historization: add facts (new links) instead of mutating entities. Reads = traversal/composition of links.

## Checklists
- Translate an existing page: create `en/gdd/<slug>.md` mirroring `fr/gdd/<slug>.md`; replicate headings, translate prose, preserve relation names/attributes, add language switch.
- Extend the DDD vs GDD comparison: keep the table format; add symmetric rows (axis, DDD column, GDD column) with consistent ✅/🚫.
- Illustrate a rule: context → nodes → relation → attributes → invariant (clear textual form).

## Workflow
- No build/tests. Verify Markdown rendering in the editor. Keep relative links functional and style consistent.

## GitHub Pages site (static docs)
- Preferred: GitHub Actions with Jekyll (folder-based i18n: `en/` and `fr/`). No i18n plugin required.
- Enable GitHub Pages in Settings → Pages → Source: GitHub Actions.
- Workflow lives at `.github/workflows/pages.yml` and builds with Bundler + Jekyll.
- `_config.yml` uses the Cayman theme. The landing `index.html` redirects to `/fr/` or `/en/` based on browser language. Menus are `en/index.md` and `fr/index.md` and link to `en/gdd/` and `fr/gdd/`.
- Adding content: add pages under `en/gdd/` and `fr/gdd/`, then update `en/index.md` and `fr/index.md`.
- Linking rules: use relative links (e.g., from `en/gdd/index.md` to `./ddd-gdd.md`). From English pages, link English targets; cross-link to French only if no English exists.

## Local preview (developer loop)
- Requirements: Ruby 3.3.0 (use rbenv) and Bundler 2.5+.
- First-time setup on macOS (zsh):
  - `brew install rbenv ruby-build`
  - `echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc && exec zsh`
  - `rbenv install 3.3.0 && rbenv local 3.3.0`
  - `gem install bundler -v "~> 2.5"`
- Run locally with live reload (daemon by default):
  - `./scripts/serve.sh` → starts background server, PID in `tmp/pids/jekyll.pid`, logs in `tmp/log/jekyll.log`.
  - Foreground mode (interactive): `./scripts/serve.sh --foreground`.
  - Server listens on http://127.0.0.1:4000/.
- Stop server: `./scripts/stop.sh`.
- Verify pages: `./scripts/check.sh` (returns non-zero on failures). Update this script when you add pages to keep coverage meaningful.
- Gems are installed to `vendor/bundle` and build output to `_site/` (both ignored by git).
- When adding pages under `en/gdd/` or `fr/gdd/`, also update `en/index.md` and `fr/index.md`.

### Local build (static export)
- Build production output into `_site/`:
  - `./scripts/build.sh`
- Open `./_site/index.html` locally or serve `_site/` with a static server.

### Alternative: deploy from a branch (no Actions)
- Not recommended here; keep Actions to build the site consistently.

## Automation & testing loop (for agents)
- Contract:
  - Inputs: Markdown files under `en/` and `fr/`.
  - Side effects: Start/stop local Jekyll; update `scripts/check.sh` when adding pages; keep links consistent.
  - Success: `./scripts/check.sh` returns 0; `serve.sh` launches without errors; no broken relative links.
- Steps to self-test changes:
  1) Ensure Ruby 3.3.0 active (rbenv) and Bundler 2.5+ installed.
  2) Start server: `./scripts/serve.sh` (daemon) or `./scripts/serve.sh --foreground`.
  3) Run checks: `./scripts/check.sh` and inspect non-200s; adjust links or add routes to the list.
  4) Stop server: `./scripts/stop.sh`.
- When adding a new page:
  - Create `fr/gdd/<slug>.md` (source of truth) and `en/gdd/<slug>.md` (mirrored translation).
  - Insert language switch links at the top of each file.
  - Add entry links in `en/index.md` and `fr/index.md` menus.
  - Update `scripts/check.sh` to include the new endpoints (both EN and FR variants) and re-run checks.

## Quality gates
- Build: PASS if `./scripts/serve.sh --foreground` runs without fatal errors.
- Tests: PASS if `./scripts/check.sh` exits 0 (all endpoints reachable).
- Lint: N/A (Markdown only); keep headings/links consistent and avoid broken relative links.
