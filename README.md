# Graph-Driven Design (GDD)

[![Pages CI](https://github.com/ng-galien/archi/actions/workflows/pages.yml/badge.svg)](https://github.com/ng-galien/archi/actions/workflows/pages.yml)

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

## Actions history and logs

- Workflow runs: [Actions › pages.yml](https://github.com/ng-galien/archi/actions/workflows/pages.yml)
- Latest deploy URL will appear on the run’s summary page after completion.

Using GitHub CLI (optional):

```zsh
# List recent runs for the Pages workflow
gh run list --workflow pages.yml --limit 10

# Show logs for the latest run
gh run view --workflow pages.yml --log

# Open the Actions page in your browser
gh run list --workflow pages.yml --json url -q '.[0].url' | xargs open
```

Contributions: keep French sources under `fr/` authoritative; add mirrored English pages under `en/` with the same paths (e.g., `fr/gdd/<slug>.md` ↔ `en/gdd/<slug>.md`). Use relative links throughout.
