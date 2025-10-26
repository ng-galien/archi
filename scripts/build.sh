#!/usr/bin/env bash
set -euo pipefail

# Local Jekyll build with Bundler
# Usage: ./scripts/build.sh

# Ensure bundler is present
if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler not found. Installing..."
  gem install bundler
fi

# Install gems to vendor/bundle (kept out of git via .gitignore)
bundle config set --local path vendor/bundle
bundle install --jobs 4 --retry 3

# Build the site into ./_site (clean build)
rm -rf _site
JEKYLL_ENV=production bundle exec jekyll build --destination ./_site --trace

echo
echo "Build complete. Open ./_site/index.html or serve the folder with a static server."
