#!/usr/bin/env bash
set -euo pipefail

# For local dev with baseurl, default to project path. Override BASE_URL to change.
BASE_URL=${BASE_URL:-"http://127.0.0.1:4000/archi"}
# Basic endpoints
URLS=(
  "/"
  "/fr/"
  "/gdd/"
  "/fr/gdd/"
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

# DDD-GDD page may be written as canonical or language-suffixed depending on build state
EN_PATHS=("/gdd/ddd-gdd.html" "/gdd/ddd-gdd.en.html")
FR_PATHS=("/fr/gdd/ddd-gdd.html" "/fr/gdd/ddd-gdd.fr.html")

for path in "${EN_PATHS[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL%/}${path}" || echo "000")
  if [[ "$code" == "200" ]]; then
    echo "[OK]   ${BASE_URL%/}${path}"
    break
  fi
done
if [[ "$code" != "200" ]]; then
  echo "[FAIL] English DDD-GDD not found at ${EN_PATHS[*]}"
  fail=1
fi

for path in "${FR_PATHS[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL%/}${path}" || echo "000")
  if [[ "$code" == "200" ]]; then
    echo "[OK]   ${BASE_URL%/}${path}"
    break
  fi
done
if [[ "$code" != "200" ]]; then
  echo "[FAIL] French DDD-GDD not found at ${FR_PATHS[*]}"
  fail=1
fi

exit $fail
