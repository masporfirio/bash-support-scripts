#!/usr/bin/env bash

set -u

TARGET_DIRECTORY="${1:-.}"

if [ ! -d "$TARGET_DIRECTORY" ]; then
  printf 'Error: directory not found: %s\n' "$TARGET_DIRECTORY" >&2
  exit 1
fi

printf 'Filesystem usage for %s:\n' "$TARGET_DIRECTORY"
df -h "$TARGET_DIRECTORY"

printf '\nLargest entries one level below %s:\n' "$TARGET_DIRECTORY"
if du --help 2>&1 | grep -q -- '--max-depth'; then
  du -h --max-depth=1 "$TARGET_DIRECTORY" 2>/dev/null | sort -hr | head -n 10
else
  du -h -d 1 "$TARGET_DIRECTORY" 2>/dev/null | sort -hr | head -n 10
fi
