#!/bin/bash
# Display local information without changing the computer's configuration.

# $(...) captures command output; uname -s identifies the operating system.
system=$(uname -s)

# printf prints text; \n starts a new line.
printf '\n=== DISK SPACE ===\n'
# -h uses human-readable sizes, such as Gi and Mi.
df -h

printf '\n=== MEMORY USAGE ===\n'
# case selects the commands for the detected operating system.
case "$system" in
    Linux)
        # Display RAM and swap; -h uses human-readable units.
        free -h
        ;;
    Darwin)
        # On macOS, collect one sample and omit the process list.
        # The pipe | sends output to awk, which selects the PhysMem line.
        top -l 1 -n 0 | awk '/^PhysMem:/ { print }'
        ;;
    *)
        printf 'Memory reporting is not implemented for: %s\n' "$system"
        ;;
esac

printf '\n=== NETWORK INFORMATION ===\n'
case "$system" in
    Linux)
        printf '\nInterfaces and IP addresses:\n'
        # -brief summarizes output; address displays interface addresses.
        ip -brief address
        printf '\nRouting table:\n'
        ip route show
        ;;
    Darwin)
        printf '\nInterfaces and IP addresses:\n'
        ifconfig
        printf '\nDefault route (gateway):\n'
        # Query the default route; -n keeps addresses numeric.
        route -n get default
        ;;
    *)
        printf 'Network reporting is not implemented for: %s\n' "$system"
        ;;
esac
