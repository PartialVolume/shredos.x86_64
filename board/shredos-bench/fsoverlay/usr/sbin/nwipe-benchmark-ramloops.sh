#!/bin/bash
# Create one tmpfs-backed loop device per CPU core.
# Prints the list of /dev/loopX devices on stdout (space separated).

set -e

RESERVE_KB=1048576   # keep ~1 GiB free (in KiB)

mem_kb=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
cores=$(nproc 2>/dev/null || awk '/^processor[[:space:]]*:/ {c++} END {print c+0}' /proc/cpuinfo)

if [[ -z "$cores" || "$cores" -lt 1 ]]; then
    cores=1
fi

# Require at least ~2 GiB total (just to be safe)
if (( mem_kb <= RESERVE_KB * 2 )); then
    echo "create_ramloops: not enough RAM (${mem_kb} kB), aborting" >&2
    exit 1
fi

usable_kb=$((mem_kb - RESERVE_KB))
per_core_kb=$((usable_kb / cores))

echo "create_ramloops: total=${mem_kb}kB cores=${cores} usable=${usable_kb}kB per_core=${per_core_kb}kB" >&2

tmpdir=/run/ramloops
mkdir -p "$tmpdir"

# Single tmpfs backing store for all images
if ! mountpoint -q "$tmpdir"; then
    mount -t tmpfs -o size=${usable_kb}k ramloops "$tmpdir"
fi

loopdevs=()

for ((i=0; i<cores; i++)); do
    img="$tmpdir/bench-$i.img"
    echo "create_ramloops: creating $img (${per_core_kb}kB)" >&2

    # Sparse file – fast and cheap
    truncate -s "${per_core_kb}K" "$img"

    # Create loop device for this image
    ld=$(losetup -fP --show "$img")
    echo "create_ramloops: loop device $ld" >&2
    loopdevs+=("$ld")
done

if ((${#loopdevs[@]} == 0)); then
    echo "create_ramloops: no loop devices created" >&2
    exit 1
fi

# Output devices on stdout for the caller (launcher) to consume
printf '%s ' "${loopdevs[@]}"
echo
