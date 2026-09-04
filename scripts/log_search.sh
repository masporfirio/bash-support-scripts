#!/usr/bin/env bash

set -u

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  printf 'Usage: %s LOG_FILE [KEYWORD]\n' "$0" >&2
  exit 2
fi

LOG_FILE="$1"
KEYWORD="${2:-error}"

if [ ! -r "$LOG_FILE" ]; then
  printf 'Error: file is not readable: %s\n' "$LOG_FILE" >&2
  exit 1
fi

printf 'Matches for "%s" in %s:\n' "$KEYWORD" "$LOG_FILE"

if grep -in -- "$KEYWORD" "$LOG_FILE"; then
  MATCH_COUNT="$(grep -ic -- "$KEYWORD" "$LOG_FILE")"
  printf '\nTotal matches: %s\n' "$MATCH_COUNT"
else
  GREP_STATUS=$?
  if [ "$GREP_STATUS" -eq 1 ]; then
    printf 'No matches found.\n'
  else
    printf 'Error: grep could not search the file.\n' >&2
    exit "$GREP_STATUS"
  fi
fi
