#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
PID_FILE="$ROOT_DIR/tmp/pids/jekyll.pid"

if [[ ! -f "$PID_FILE" ]]; then
  echo "No PID file found ($PID_FILE). Server may not be running."
  exit 0
fi

PID=$(cat "$PID_FILE")
if ! ps -p "$PID" >/dev/null 2>&1; then
  echo "No process with PID $PID. Removing stale PID file."
  rm -f "$PID_FILE"
  exit 0
fi

echo "Stopping Jekyll (PID $PID)..."
kill "$PID" || true

# Wait up to ~5s
for i in {1..10}; do
  if ! ps -p "$PID" >/dev/null 2>&1; then
    break
  fi
  sleep 0.5
done

if ps -p "$PID" >/dev/null 2>&1; then
  echo "Process still running, forcing kill..."
  kill -9 "$PID" || true
fi

rm -f "$PID_FILE"
echo "Jekyll stopped."
