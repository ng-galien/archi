#!/usr/bin/env bash
set -euo pipefail

BASE_URL=${BASE_URL:-"http://127.0.0.1:4000"}
# Basic endpoints
URLS=(
  "/"
  "/en/"
  "/fr/"
  "/en/gdd/"
  "/fr/gdd/"
  "/en/gdd/ddd-gdd.html"
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

# French ddd-gdd may be served as .html or .md depending on front matter
FR_PATH_HTML="/fr/gdd/ddd-gdd.html"
FR_PATH_MD="/fr/gdd/ddd-gdd.md"
code_html=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL%/}${FR_PATH_HTML}" || echo "000")
if [[ "$code_html" == "200" ]]; then
  echo "[OK]   ${BASE_URL%/}${FR_PATH_HTML}"
else
  code_md=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL%/}${FR_PATH_MD}" || echo "000")
  if [[ "$code_md" == "200" ]]; then
    echo "[OK]   ${BASE_URL%/}${FR_PATH_MD}"
  else
    echo "[FAIL] ${BASE_URL%/}${FR_PATH_HTML} (and .md) -> HTML:$code_html MD:$code_md"
    fail=1
  fi
fi

exit $fail
