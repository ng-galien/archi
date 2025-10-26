# Copilot instructions for this repository (archi)

This repo is a bilingual knowledge base about Graph-Driven Design (GDD). There is no application code. We use jekyll-polyglot to build a multilingual static site. Your job is to evolve the Markdown docs with clear, concrete, domain-grounded examples — and maintain English translations alongside the original French.

## What this repo contains
- `gdd/index.fr.md` — essai principal (tables obèses → relations fonctionnelles, graphe + fonctions pures).
- `gdd/ddd-gdd.fr.md` — tableau comparatif DDD vs modèle relationnel-fonctionnel (GDD).
- English translations live as sibling files with `*.en.md`: `gdd/index.en.md`, `gdd/ddd-gdd.en.md`.

## Bilingual policy (do this first)
- Do not edit French sources (`*.fr.md`) without need. Maintain English counterparts as sibling `*.en.md` files in the same folder.
- Mirror structure 1:1: same paths and filenames (minus language suffix), same H1/H2 outline, same examples adapted to English.
- Keep relation vocabulary unchanged (nodes Capitalized, relations UPPER_SNAKE with attributes), translate only surrounding prose.
- Add a language switch at the top of each page, linking to its sibling in the other language. Prefer language-neutral links (Polyglot will relativize URLs per active language).

### Language management (jekyll-polyglot)
- Each page must include front matter `lang: en` or `lang: fr`.
- Use consistent permalinks across translations (either identical filenames and paths, or explicit `permalink:` in front matter) so Polyglot pairs them.
- Optional: Use `page_id:` if you want different permalinks per language.
- Language switchers: build neutral links (e.g., `../gdd/ddd-gdd.html`). Polyglot will keep users within their active language.
- For English (default language), pages are served at the root (`/`); for French, under `/fr/`.

## Authoring conventions
- Language: English for `*.en.md` (clear, pragmatic tone). French typography rules apply only to `*.fr.md`.
- Structure: one H1 per file; H2 sections; bullet lists; Markdown tables for comparisons. Emojis allowed sparingly (see ddd-gdd).
- GDD vocabulary (unchanged in both languages):
  - Nodes (stable, singular, Capitalized): `Product`, `Customer`, `Order`.
  - Relations (first-class, UPPER_SNAKE): `HAS_PRICE`, `PLACED_BY`, `HAS_STATUS`, `HAS_PROMO`, `DISCOUNTED_PRICE`, `CATEGORY`, `SUPPLIER`.
  - Relations carry attributes (e.g., `amount`, `currency`, `valid_from`, `valid_to`). Absence of a link ≈ “no value” (avoid NULL).
  - Versioning/temporality by context: e.g., `HAS_PRICE@v2`, validity period.
  - Business as pure transformation: `[relations₀] → f → [relations₁]` (e.g., price → `HAS_EFFECTIVE_PRICE`; claim → `HAS_CLAIM_STATUS`).
- File naming: kebab-case `.md` files side-by-side, suffixed with `.en.md` and `.fr.md` under the same path (e.g., `gdd/ddd-gdd.en.md` and `gdd/ddd-gdd.fr.md`).
- Linking: use relative, language-neutral links (e.g., `./ddd-gdd.html`). Polyglot rewrites links to the active language.

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
- Built with GitHub Actions and Jekyll + jekyll-polyglot.
- Enable GitHub Pages in Settings → Pages → Source: GitHub Actions.
- Workflow lives at `.github/workflows/pages.yml` (Ruby 3.3, Bundler 2.5, Jekyll build).
- `_config.yml` uses the Cayman theme and Polyglot. Default language (EN) at root; FR under `/fr/`.
- Landing page: English served at root (`/`), French under `/fr/`. No separate redirect file to avoid conflicts with Polyglot output.

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
- When adding pages, create both `*.fr.md` and `*.en.md` siblings and keep permalinks consistent. Update landing menus if needed.

### Local build (static export)
- Build production output into `_site/`:
  - `./scripts/build.sh`
- Open `./_site/index.html` locally or serve `_site/` with a static server.

### Alternative: deploy from a branch (no Actions)
- Not recommended here; keep Actions to build the site consistently.

## Automation & testing loop (for agents)
- Contract:
  - Inputs: Markdown files `*.en.md` and `*.fr.md` under the same paths.
  - Side effects: Start/stop local Jekyll; update `scripts/check.sh` when adding pages; keep links consistent.
  - Success: `./scripts/check.sh` returns 0; `serve.sh` launches without errors; no broken relative links.
- Steps to self-test changes:
  1) Ensure Ruby 3.3.0 active (rbenv) and Bundler 2.5+ installed.
  2) Start server: `./scripts/serve.sh` (daemon) or `./scripts/serve.sh --foreground`.
  3) Run checks: `./scripts/check.sh` and inspect non-200s; adjust links or add routes to the list.
  4) Stop server: `./scripts/stop.sh`.
- When adding a new page:
  - Create `gdd/<slug>.fr.md` (source of truth) and `gdd/<slug>.en.md` (mirrored translation) with the same permalink.
  - Insert a language switch at the top of each file.
  - Update landing menus if applicable.
  - Update `scripts/check.sh` to include the new endpoints (both EN and FR variants) and re-run checks.

## Quality gates
- Build: PASS if `./scripts/serve.sh --foreground` runs without fatal errors.
- Tests: PASS if `./scripts/check.sh` exits 0 (all endpoints reachable).
- Lint: N/A (Markdown only); keep headings/links consistent and avoid broken relative links.
