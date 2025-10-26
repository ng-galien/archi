# Graph-Driven Design (GDD)

[![Pages CI](https://github.com/ng-galien/archi/actions/workflows/pages.yml/badge.svg)](https://github.com/ng-galien/archi/actions/workflows/pages.yml)

This repository is a bilingual (FR/EN) knowledge base about Graph-Driven Design — modeling with relations as first-class citizens and expressing business as pure transformations.

## Documentation

- English
  - Landing: ./index.en.md
  - Deep dives index: ./articles/index.en.md (sources in `_articles/*.en.md`)
  - Blog index: ./blog/index.en.md (posts in `_posts/en/`)

- Français
  - Accueil : ./index.fr.md
  - Articles de fond : ./articles/index.fr.md (sources dans `_articles/*.fr.md`)
  - Blog : ./blog/index.fr.md (billets dans `_posts/fr/`)

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

## Local preview

Prerequisites: Ruby 3.3.x, Bundler.

- Install Bundler (if needed):

```zsh
gem install bundler
```

- Serve locally with live reload:

```zsh
./scripts/serve.sh
```

- Output folder `_site/` and `vendor/bundle/` are ignored by git (see `.gitignore`).

### Local build (static export)

Produce a fresh static build into `_site/`:

```zsh
./scripts/build.sh
```

Then open `./_site/index.html` in your browser or serve the folder with any static server.

Contributions: keep French sources canonical, then mirror the same edits in English. Long-form essays live under `_articles/<slug>.fr.md` ↔ `_articles/<slug>.en.md`. Blog posts live in `_posts/fr/` and `_posts/en/` with matching slugs/dates. Use `relative_url` filters (e.g., `{{ '/articles/gdd/' | relative_url }}`) to stay language-neutral in Markdown links.
