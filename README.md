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

## GitHub Pages

To publish these docs as a static site:

1) In GitHub: Settings → Pages → Build and deployment
2) Set Source to "Deploy from a branch"
3) Select Branch: `main`, Folder: `/ (root)`

The site will use the built-in Cayman theme configured in `_config.yml`. The root `index.html` redirects to `/fr/` or `/en/` based on browser language, and the language menus live at `fr/index.md` and `en/index.md`.

Contributions: keep French sources under `fr/` authoritative; add mirrored English pages under `en/` with the same paths (e.g., `fr/gdd/<slug>.md` ↔ `en/gdd/<slug>.md`). Use relative links throughout.
