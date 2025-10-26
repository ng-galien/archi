#!/usr/bin/env bash
set -euo pipefail

# Lint Markdown with markdownlint-cli (via npx, no local install required)
# Usage:
#   ./scripts/lint-md.sh                # lint all markdown files
#   ./scripts/lint-md.sh --fix          # attempt autofix where possible

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
cd "$ROOT_DIR"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required to run markdownlint. Please install Node.js (https://nodejs.org)." >&2
  exit 1
fi

ARGS=("**/*.md" "!_site/**" "!vendor/**" "!tmp/**" "!**/node_modules/**")

if [[ "${1:-}" == "--fix" ]]; then
  npx --yes markdownlint-cli@0.39.0 --config .markdownlint.yml --fix "${ARGS[@]}"
else
  npx --yes markdownlint-cli@0.39.0 --config .markdownlint.yml "${ARGS[@]}"
fi
