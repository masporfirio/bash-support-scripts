# Study guide: system information with Bash

Use this guide with the [commented script](../scripts/system_info.sh) and the
[hands-on lab](../labs/system-info/README.md). Level: beginner.

## Goal

Learn to inspect disk space, memory usage, network interfaces and routes while
understanding each command. The script takes a snapshot; it is not a continuous
monitor and does not test connectivity with ping or check DNS resolution.

## Setup and execution

If you do not already have a copy of the repository:

```bash
git clone https://github.com/masporfirio/bash-support-scripts.git
cd bash-support-scripts
```

Otherwise, enter your up-to-date copy. Run the following commands from the
repository root:

```bash
bash -n scripts/system_info.sh
bash scripts/system_info.sh
```

- `git clone` downloads a copy of the repository; `cd` changes the current directory.
- `bash -n` checks syntax without running the commands. It does not prove that
  the required tools are installed or that the queries will succeed.
- `bash scripts/system_info.sh` starts a Bash process to run the file. The file
  needs read permission, but its execute permission bit is not required.
- The script is committed with execute permission, so you can also run
  `./scripts/system_info.sh`. Direct execution uses the interpreter in the shebang.
- If execute permission is lost when copying the file, `chmod +x scripts/system_info.sh`
  restores it. This command changes that permission on the file.

Normal queries do not require `sudo`. Linux requires Bash, `df`, `free`
(usually provided by `procps` or `procps-ng`) and `ip` (usually provided by
`iproute2` or `iproute`). Package names vary by distribution. On macOS, the script
uses the built-in `df`, `top`, `awk`, `ifconfig`, `route` and `uname` commands.

## Bash structure

| Code | Meaning |
| --- | --- |
| `#!/bin/bash` | Shebang: selects the interpreter for direct execution. |
| `# comment` | Documentation ignored by Bash; the first-line shebang has a special purpose. |
| `system=$(uname -s)` | Runs `uname -s` and stores its output in `system`. There are no spaces around `=`. |
| `"$system"` | Expands the variable in quotes, preserving its value as one argument. |
| `printf '\n=== TITLE ===\n'` | Prints text; `\n` represents a newline. |
| `case "$system" in` | Selects the matching operating system block. |
| `Linux)` / `Darwin)` | Patterns matching Linux and macOS, respectively. |
| `;;` | Ends the current `case` alternative. |
| `*)` | Matches the remaining systems. |
| `esac` | Closes the `case` statement. |
| `command1 \| command2` | A pipe sends the first command's standard output to the second command's standard input. |

There are two `case` statements: one selects the memory query and the other
selects the network queries. Both systems use `df -h`.

## Commands and interpretation

### Detect the system and inspect disk space

- `uname -s` prints the kernel name. On macOS, it returns `Darwin`.
- `df -h` displays usage for mounted filesystems in human-readable units.
  Look at `Size`, `Used`, `Avail`, `Use%` or `Capacity`, and `Mounted on`.
  Column names can vary by operating system and language.

`df` reports space at the filesystem level. It does not identify which directory
is taking up the most space. Use the existing
[`disk_usage_report.sh`](../scripts/disk_usage_report.sh) to study that distinction.
APFS volumes can share storage; do not add the rows to estimate physical disk capacity.

### Inspect memory on Linux

`free -h` displays RAM and swap in human-readable units:

- `total`: total memory reported by the tool.
- `used`: memory in use, according to the tool's calculation.
- `free`: completely unused memory.
- `buff/cache`: memory used for buffers and cache.
- `available`: an estimate of memory available to new applications without swapping.

Cache can be reclaimed. A low `free` value alone does not prove a RAM shortage.
Swap uses storage to support memory management; it is not physical RAM.

### Inspect memory on macOS

```bash
top -l 1 -n 0 | awk '/^PhysMem:/ { print }'
```

- `top` collects system statistics.
- `-l 1` takes one sample in the macOS tool's logging mode.
- `-n 0` omits the process list.
- `|` sends the output to `awk`.
- `awk '/^PhysMem:/ { print }'` prints lines beginning with `PhysMem:`.
  `^` matches the start of a line; `{ print }` prints the matching line.

The options accepted by `top` differ between platforms. This command belongs
to the macOS block. Fields such as `used`, `unused`, `wired` and `compressor`
have different relationships; do not simply add all of them. This summary alone
does not diagnose memory pressure.

### Inspect networking on Linux

- `ip -brief address` summarizes interfaces, their state and IPv4/IPv6 addresses.
  `lo` is the loopback interface used for communication with the machine itself.
- `ip route show` displays the main IPv4 routing table. A line containing
  `default via ... dev ...` identifies a default route, its gateway and its interface.

There may be more than one default route. This report does not cover all policy
routing tables or all IPv6 routes.

### Inspect networking on macOS

- `ifconfig` lists interfaces, flags, addresses and other properties.
  `inet` indicates IPv4, `inet6` indicates IPv6, and `lo0` is loopback.
- `route -n get default` queries the default IPv4 route. `-n` keeps addresses
  numeric. Look at `gateway` and `interface`.

An active interface and a default route do not prove internet access. A VPN can
also install more specific routes that this default-route query does not show.
An isolated machine may legitimately have no default route.

## Limitations and errors

- `command not found`: a required command is missing or is not in `PATH`.
- `Operation not permitted`: permissions or the execution environment blocked the query.
- No default route: the macOS route query may return an error.
- This beginner version does not combine errors from every query into one status.
  In particular, without `pipefail`, the memory pipeline returns the status of
  `awk`; a failure in `top` can be masked. A final zero status does not guarantee
  a complete report. Check all three sections and any error messages.
- The report may contain IP and hardware addresses. Keep practice notes local
  and review output before sharing it.

## Validation recorded on 2026-11-10

- Bash syntax: passed with `bash -n`.
- Native macOS execution: completed with exit status zero; disk output, a
  `PhysMem` line, network interfaces and a default gateway were present.
- The initial restricted execution blocked `top` and `route`. Running outside
  that restriction allowed the queries to be verified.
- Native Linux execution: passed on Debian GNU/Linux 12 (bookworm, aarch64),
  running Xfce in UTM. The published script passed SHA-256 verification and Bash
  syntax checking, returned exit status zero, produced no standard-error output,
  and displayed disk space, RAM, swap, interfaces and a default route.
- See the [validation record](system-info-validation.md) for the tested revision,
  checks and observed Debian results. These results cover the tested
  environments and do not establish compatibility with every Linux distribution.
- Student execution and learning assessment: pending. Publishing the material
  does not establish that the student has completed the lab.

## Local reference

Use `man df`, `man uname` and `man awk`, plus the platform-specific manuals:
`man free` and `man ip` on Linux; `man top`, `man ifconfig` and `man route` on macOS.
`man` opens the local documentation; press `q` to quit.
