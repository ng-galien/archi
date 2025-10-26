# Graph-Driven Design (GDD)

This repository is a bilingual (FR/EN) knowledge base about Graph-Driven Design — modeling with relations as first-class citizens and expressing business as pure transformations.

## Documentation

- English
  - Landing: ./en/
  - Main essay: ./en/gdd/index.md
  - Comparison: ./en/gdd/ddd-gdd.md

- Français
  - Accueil : ./fr/
  - Essai principal : ./fr/gdd/index.md
  - Comparatif : ./fr/gdd/ddd-gdd.md

## GitHub Pages (via Actions + Jekyll plugin)

This site uses GitHub Actions to build with Jekyll and the multi-language plugin.

Enable publishing:

1) In GitHub: Settings → Pages → Source: GitHub Actions
2) Push to `main` to trigger the workflow `.github/workflows/pages.yml`

The site uses the built-in Cayman theme configured in `_config.yml`. The root `index.html` redirects to `/fr/` or `/en/` based on browser language, and the language menus live at `fr/index.md` and `en/index.md`.

Contributions: keep French sources under `fr/` authoritative; add mirrored English pages under `en/` with the same paths (e.g., `fr/gdd/<slug>.md` ↔ `en/gdd/<slug>.md`). Use relative links throughout.
