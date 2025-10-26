# Copilot instructions for this repository (archi)

This repo is a bilingual knowledge base about Graph-Driven Design (GDD). There is no executable code or build. Your job is to evolve the Markdown docs under `en/gdd/` and `fr/gdd/` with clear, concrete, domain-grounded examples — and maintain English translations alongside the original French.

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
- Preferred: GitHub Actions with Jekyll + multilingual plugin.
- Enable GitHub Pages in Settings → Pages → Source: GitHub Actions.
- Workflow lives at `.github/workflows/pages.yml` and builds with Bundler + Jekyll.
- `_config.yml` enables `jekyll-multiple-languages-plugin`, sets `languages: ["en","fr"]`, `default_lang: en`, and directory defaults.
- Landing: `index.html` redirects to `/fr/` or `/en/` based on browser language. Menus are `en/index.md` and `fr/index.md` and link to `en/gdd/` and `fr/gdd/`.
- Adding content: add pages under `en/gdd/` and `fr/gdd/`, then update `en/index.md` and `fr/index.md`.
- Linking rules: use relative links (e.g., from `en/gdd/index.md` to `./ddd-gdd.md`). From English pages, link English targets; cross-link to French only if no English exists.

### Alternative: deploy from a branch (no Actions)
- Works without plugins; not recommended here since we rely on `jekyll-multiple-languages-plugin`.
