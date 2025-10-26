# Agent instructions for this repository (archi)

## Repository focus
- `archi` is a bilingual GitHub Pages blog covering multiple technical themes such as software architecture, relational modeling, AI tools, and engineering practices. Work only on Markdown docs; keep examples grounded in Product/Order-style nodes, relations, and attributes.
- Treat French pages as the canonical source, but evolve their English mirrors at the same time so both languages stay aligned after every change.

## Bilingual workflow
- Each page lives as `*.fr.md` and `*.en.md` siblings in the same folder sharing the same slug/permalink. Front matter always declares `lang`, `page_id`, and `permalink`.
- At the top of every page, render a `<div class="language-switch">` that links to the sibling file using relative, language-neutral URLs so Polyglot can rewrite them.
- Mirror structure 1:1 (headings, sections, tables). Keep relation vocabulary untouched (nodes Capitalized, relations UPPER_SNAKE). Only translate prose and surrounding narrative.

## Layout & styling
- All pages inherit `_layouts/default.html`, which provides the header, bilingual nav, skip link, and footer. Do not reintroduce Cayman or inline styling.
- Extend or tweak visuals exclusively through `assets/css/main.scss`, using the existing Inter-based typography, neutral palette, and responsive card layout.
- Maintain the minimalist developer-blog aesthetic: subtle gradients, soft cards, high readability, and accessible contrasts.

## Linking & navigation
- Use relative, language-neutral links (e.g., `{{ '/articles/gdd/' | relative_url }}`, `{{ '/blog/' | relative_url }}`). Polyglot rewrites them according to the active locale.
- When adding new primary sections, update the nav labels (both EN and FR variants) inside the layout so the header links stay in sync.
- Keep permalinks consistent between languages or use shared `page_id` values when necessary.

## Workflow & validation
- Toolchain: Ruby 3.3.0 with Bundler 2.7.2 (matches `Gemfile.lock`). Install/activate these before running any scripts.
- Preview locally via `./scripts/serve.sh` (daemon) or `./scripts/serve.sh --foreground`; stop with `./scripts/stop.sh`.
- Verify endpoints using `./scripts/check.sh`. Append any new EN/FR paths you introduce so curl checks remain comprehensive.
- Build artifacts live in `_site/` and dependencies in `vendor/bundle`; both are ignored by git.

## Scope guardrails
- Topics may cover a variety of technology and design subjects beyond Graph-Driven Design, including software architecture, modeling, AI tools, and engineering best practices.
- No application code, ORMs, or diagram tooling—stick to Markdown, tables, and plain text. Diagrams are expressed via Markdown constructs only.
- Present content with a pragmatic and concrete tone grounded in domain scenarios (pricing, orders, fulfillment, etc.).

## Quality bar
- A change is complete when the Jekyll server starts cleanly, bilingual pages remain aligned, language-switch links work, and the rendering respects the overall style and design system of the blog.
