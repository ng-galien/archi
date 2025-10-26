#!/usr/bin/env bash
set -euo pipefail

# For local dev with baseurl, default to project path. Override BASE_URL to change.
BASE_URL=${BASE_URL:-"http://127.0.0.1:4000/archi"}
# Basic endpoints
URLS=(
  "/"
  "/fr/"
  "/articles/"
  "/fr/articles/"
  "/articles/gdd/"
  "/fr/articles/gdd/"
  "/articles/ddd-vs-gdd/"
  "/fr/articles/ddd-vs-gdd/"
  "/blog/"
  "/fr/blog/"
  "/blog/why-split-blog-and-deep-dives/"
  "/fr/blog/pourquoi-scinder-blog-et-articles/"
)

fail=0
# Check basic URLs
for path in "${URLS[@]}"; do
  url="${BASE_URL%/}${path}"
  code=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
  if [[ "$code" != "200" ]]; then
    echo "[FAIL] $url -> HTTP $code"
    fail=1
  else
    echo "[OK]   $url"
  fi
done

exit $fail
