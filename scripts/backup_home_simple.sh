#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  printf 'Usage: %s SOURCE_DIRECTORY [DESTINATION_DIRECTORY]\n' "$0" >&2
  exit 2
fi

SOURCE_INPUT="$1"
DESTINATION_INPUT="${2:-$HOME/backups}"

if [ ! -d "$SOURCE_INPUT" ]; then
  printf 'Error: source directory not found: %s\n' "$SOURCE_INPUT" >&2
  exit 1
fi

SOURCE_DIRECTORY="$(cd "$SOURCE_INPUT" && pwd -P)"

if [ "$SOURCE_DIRECTORY" = "/" ]; then
  printf 'Error: refusing to archive the filesystem root.\n' >&2
  exit 1
fi

mkdir -p "$DESTINATION_INPUT"
DESTINATION_DIRECTORY="$(cd "$DESTINATION_INPUT" && pwd -P)"

case "$DESTINATION_DIRECTORY/" in
  "$SOURCE_DIRECTORY/"*)
    printf 'Error: destination cannot be inside the source directory.\n' >&2
    exit 1
    ;;
esac

SOURCE_PARENT="$(dirname "$SOURCE_DIRECTORY")"
SOURCE_NAME="$(basename "$SOURCE_DIRECTORY")"
TIMESTAMP="$(date +%F_%H-%M-%S)"
ARCHIVE_FILE="$DESTINATION_DIRECTORY/${SOURCE_NAME}_${TIMESTAMP}.tar.gz"
LOG_FILE="$DESTINATION_DIRECTORY/backup.log"

printf '%s Starting backup of %s\n' "$(date '+%F %T')" "$SOURCE_DIRECTORY" >> "$LOG_FILE"

if tar -C "$SOURCE_PARENT" -czf "$ARCHIVE_FILE" "$SOURCE_NAME" 2>> "$LOG_FILE"; then
  printf '%s Backup completed: %s\n' "$(date '+%F %T')" "$ARCHIVE_FILE" | tee -a "$LOG_FILE"
else
  printf '%s Backup failed. A partial archive may remain at %s\n' "$(date '+%F %T')" "$ARCHIVE_FILE" | tee -a "$LOG_FILE" >&2
  exit 1
fi
