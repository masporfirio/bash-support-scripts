# System information script: validation record

Validation date: 2026-11-10.

## Tested revision

- Script: [`scripts/system_info.sh`](../scripts/system_info.sh).
- Source commit: [`a18d0084f964b741c67bf4342d09184802af80d3`](https://github.com/masporfirio/bash-support-scripts/commit/a18d0084f964b741c67bf4342d09184802af80d3).
- SHA-256: `099399da05421f7f9485c2221c9300d51b61ee8f111dc3dc9be705199517de55`.
- The same script contents were used on both platforms. No script changes were
  needed to pass the Debian validation.

## Results

| Check | Debian GNU/Linux 12 | macOS |
| --- | --- | --- |
| Bash syntax (`bash -n`) | Passed | Passed |
| Complete script execution | Exit status 0 | Exit status 0 |
| Disk-space report | Present | Present |
| Memory report | RAM and swap present | `PhysMem` present |
| Network interfaces | Present | Present |
| Default route/gateway | Present | Present |

Linux environment: Debian GNU/Linux 12 (bookworm), aarch64, Xfce desktop in UTM.
The VM's UTM display name still contains "Debian 11"; `/etc/os-release` inside
the running guest confirmed `VERSION_ID="12"` and `VERSION_CODENAME=bookworm`.

macOS environment: macOS 27.2, Apple silicon. The initial restricted execution
blocked `top` and `route`; an unrestricted local execution verified those queries.

## Debian procedure

The published script was downloaded from the source commit into a temporary
directory inside the existing VM. No package installation, system upgrade,
service restart or network-configuration change was needed.

```bash
sha256sum system_info.sh
bash -n system_info.sh
LC_ALL=C bash system_info.sh > report.txt 2> errors.txt
echo "$?"
test ! -s errors.txt
```

The SHA-256 matched the source file, the script returned zero, and `errors.txt`
was empty. The report was also checked for all three section headings, `Mem:`,
`Swap:`, loopback and a default-route entry. The complete output was reviewed.

Observed Debian result summary:

```text
OS: Debian GNU/Linux 12 (bookworm)
Architecture: aarch64
Bash syntax: PASS
Standard error: EMPTY
Disk report: PASS
Memory report: PASS
Swap report: PASS
Network interfaces: PASS
Default route: PASS
Full script execution: exit status 0
Result: PASSED on Debian GNU/Linux 12 (UTM)
```

Raw network output and VM screenshots are not published.

## Scope

These results demonstrate successful execution on the two environments above.
They do not prove internet access, application health, continuous monitoring,
or compatibility with every Linux distribution. The script's existing
error-handling limitations remain documented in the
[study guide](system-info-study-guide.md#limitations-and-errors).

The validation was performed during preparation of the study material. It does
not establish that the learner has personally completed the lab exercises.
