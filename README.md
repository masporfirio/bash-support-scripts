# Bash Support Scripts

Small Bash scripts created while practicing Linux administration and IT support tasks.

The scripts are intentionally simple. They help me practice arguments, exit codes, command checks, file tests and basic error handling without hiding the Linux commands underneath.

## Scripts

| Script | Purpose |
| --- | --- |
| [`disk_usage_report.sh`](scripts/disk_usage_report.sh) | Shows filesystem use and the largest entries in a directory. |
| [`service_status.sh`](scripts/service_status.sh) | Displays a systemd service status and its recent journal entries. |
| [`log_search.sh`](scripts/log_search.sh) | Searches a readable text log for a keyword. |
| [`network_check.sh`](scripts/network_check.sh) | Performs a small IP connectivity and name-resolution check. |
| [`backup_home_simple.sh`](scripts/backup_home_simple.sh) | Creates a timestamped archive of a chosen directory. |

## Disk usage report

**What it does:** runs `df` for a target directory and uses `du` to list its largest entries one level below it.

**What I practiced:** positional arguments, directory checks, pipelines and the difference between filesystem usage and directory usage.

```bash
./scripts/disk_usage_report.sh /var/log
```

If no directory is supplied, the script checks the current directory.

**Limitations:** this is a report only. It does not remove files or decide what is safe to delete. Permission errors from `du` are hidden, so the list may be incomplete.

## Service status

**What it does:** combines `systemctl status` with the last 30 journal entries for one service.

**What I practiced:** validating required commands, accepting a service name and preserving the status returned by `systemctl`.

```bash
./scripts/service_status.sh ssh
```

**Limitations:** it requires a systemd-based Linux system. Journal access depends on the current user's permissions, and the script does not attempt to restart or reconfigure the service.

## Log search

**What it does:** searches a readable text file with case-insensitive line numbers and reports the match count.

**What I practiced:** file tests, default arguments, `grep` exit codes and quoting user input.

```bash
./scripts/log_search.sh /var/log/syslog error
```

The default keyword is `error` when the second argument is omitted.

**Limitations:** it is intended for plain-text logs. It does not read compressed archives, binary logs or the systemd journal.

## Network check

**What it does:** shows the route table when `ip` is available, pings an IP target and checks a hostname with `getent`.

**What I practiced:** separating basic IP connectivity from name resolution and collecting a meaningful exit status.

```bash
./scripts/network_check.sh 1.1.1.1 example.com
```

For an offline test, the defaults use `127.0.0.1` and `localhost`.

**Limitations:** ICMP may be blocked even when another protocol works. This is a first check, not a complete network diagnosis.

## Simple directory backup

**What it does:** creates a timestamped `.tar.gz` archive and writes a small log next to the archive.

**What I practiced:** path validation, timestamps, command success checks and safer defaults. The script refuses to archive `/` and refuses to place the destination inside the source.

```bash
./scripts/backup_home_simple.sh "$HOME/Documents" "$HOME/backups"
```

When the destination is omitted, it uses `$HOME/backups`.

**Limitations:** it does not encrypt, upload, rotate or verify the archive after creation. A real backup plan also needs a separate copy and a restore test.

## Validation

All scripts can be checked without running them:

```bash
bash -n scripts/*.sh
```

I also run the non-destructive scripts with test inputs before committing changes. `shellcheck` is useful for an additional review when it is installed.
