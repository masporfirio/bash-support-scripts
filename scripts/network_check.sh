#!/usr/bin/env bash

set -u

IP_TARGET="${1:-127.0.0.1}"
NAME_TARGET="${2:-localhost}"
CHECK_FAILED=0

if ! command -v ping >/dev/null 2>&1; then
  printf 'Error: ping is required for this check.\n' >&2
  exit 1
fi

printf 'Routing information:\n'
if command -v ip >/dev/null 2>&1; then
  ip route
else
  printf 'The ip command is not available. Skipping route display.\n'
fi

printf '\nTesting IP connectivity to %s:\n' "$IP_TARGET"
if ! ping -c 2 "$IP_TARGET"; then
  CHECK_FAILED=1
fi

printf '\nTesting name resolution for %s:\n' "$NAME_TARGET"
if command -v getent >/dev/null 2>&1; then
  if ! getent hosts "$NAME_TARGET"; then
    CHECK_FAILED=1
  fi
else
  printf 'The getent command is not available. Skipping name lookup.\n'
fi

exit "$CHECK_FAILED"
