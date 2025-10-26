#!/usr/bin/env bash
set -euo pipefail

# Start Jekyll in background (daemon) by default
# Usage:
#   ./scripts/serve.sh            # daemon mode (default)
#   ./scripts/serve.sh --foreground  # foreground (interactive)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
PID_DIR="$ROOT_DIR/tmp/pids"
LOG_DIR="$ROOT_DIR/tmp/log"
PID_FILE="$PID_DIR/jekyll.pid"
LOG_FILE="$LOG_DIR/jekyll.log"
HOST="127.0.0.1"
PORT="4000"

mkdir -p "$PID_DIR" "$LOG_DIR"

# Ensure bundler is present
if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler not found. Installing..."
  gem install bundler -v "~> 2.5"
fi

cd "$ROOT_DIR"

# Install gems to vendor/bundle (kept out of git via .gitignore)
bundle config set --local path vendor/bundle >/dev/null
bundle install --jobs 4 --retry 3

if [[ "${1:-}" == "--foreground" ]]; then
  echo "Starting Jekyll in foreground on http://$HOST:$PORT ..."
  JEKYLL_ENV=development bundle exec jekyll serve \
    --host "$HOST" \
    --port "$PORT" \
    --livereload \
    --drafts \
    --trace
  exit $?
fi

# If already running, don't start a duplicate
if [[ -f "$PID_FILE" ]]; then
  if ps -p "$(cat "$PID_FILE")" >/dev/null 2>&1; then
    echo "Jekyll already running (PID $(cat "$PID_FILE")) at http://$HOST:$PORT"
    exit 0
  else
    echo "Stale PID file found. Cleaning up."
    rm -f "$PID_FILE"
  fi
fi

echo "Starting Jekyll in background on http://$HOST:$PORT ..."
nohup env JEKYLL_ENV=development \
  bundle exec jekyll serve \
    --host "$HOST" \
    --port "$PORT" \
    --livereload \
    --drafts \
    --trace \
    >"$LOG_FILE" 2>&1 &

JEKYLL_PID=$!
echo "$JEKYLL_PID" > "$PID_FILE"
sleep 1

if ps -p "$JEKYLL_PID" >/dev/null 2>&1; then
  echo "Jekyll started (PID $JEKYLL_PID). Logs: $LOG_FILE"
else
  echo "Failed to start Jekyll. Check logs: $LOG_FILE" >&2
  exit 1
fi
