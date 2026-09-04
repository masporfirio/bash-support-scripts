#!/usr/bin/env bash

set -u

SERVICE_NAME="${1:-}"

if [ -z "$SERVICE_NAME" ]; then
  printf 'Usage: %s SERVICE_NAME\n' "$0" >&2
  exit 2
fi

for REQUIRED_COMMAND in systemctl journalctl; do
  if ! command -v "$REQUIRED_COMMAND" >/dev/null 2>&1; then
    printf 'Error: required command not found: %s\n' "$REQUIRED_COMMAND" >&2
    exit 1
  fi
done

printf 'Status for %s:\n' "$SERVICE_NAME"
STATUS_CODE=0
systemctl status "$SERVICE_NAME" --no-pager || STATUS_CODE=$?

printf '\nRecent journal entries for %s:\n' "$SERVICE_NAME"
journalctl -u "$SERVICE_NAME" -n 30 --no-pager || true

exit "$STATUS_CODE"
