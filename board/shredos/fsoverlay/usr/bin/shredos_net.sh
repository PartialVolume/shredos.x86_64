#!/bin/bash
#
# ShredOS network setup & simple hotplug (Realtek-friendly)
#
# - Brings loopback and at most ONE Ethernet interface up via DHCP
# - Gentle hotplug: reacts only on link state changes
# - Workaround for OOM issues with Realtek drivers:
#   * slower polling interval
#   * limit ifup retries per interface
#   * avoid endless ifup/ifdown loops
#
version=1.2-workaround-rlk-oom

set -u

# ------------------------------------------------------------
# Helper: read from sysfs without spawning "more" or "cat"
# ------------------------------------------------------------
read_sysfs() {
    local path="$1"
    if [[ -r "$path" ]]; then
        local v
        v=$(< "$path" 2>/dev/null)
        printf '%s\n' "$v"
    else
        printf '%s\n' ""
    fi
}

# ------------------------------------------------------------
# Option: completely disable networking
# Kernel cmdline flags: "nonet" or "shredos_nonet"
# ------------------------------------------------------------
if grep -Eq '(^| )nonet(=| |$)|(^| )shredos_nonet(=| |$)' /proc/cmdline 2>/dev/null; then
    ifdown -f -a >/dev/null 2>&1 || true
    ifup lo >/dev/null 2>&1 || true
    echo "[INFO] Network disabled via kernel cmdline (nonet/shredos_nonet)."
    exit 0
fi

# ------------------------------------------------------------
# Bring everything down, then loopback up
# ------------------------------------------------------------
ifdown -f -a >/dev/null 2>&1 || true
ifup lo >/dev/null 2>&1 || true

# ------------------------------------------------------------
# Rebuild /etc/network/interfaces
# ------------------------------------------------------------
rm -f /etc/network/interfaces

{
    echo "auto lo"
    echo "iface lo inet loopback"
    echo
} > /etc/network/interfaces

net_devices=$(ls -1 /sys/class/net 2>/dev/null || echo "")
active_device="none"

for device in $net_devices; do
    # Only Ethernet devices: en* or eth*
    if [[ "$device" == en* || "$device" == eth* ]]; then
        {
            echo "auto $device"
            echo "iface $device inet dhcp"
            echo
        } >> /etc/network/interfaces
    fi
done

# ------------------------------------------------------------
# Per-device state (bash associative arrays)
# ------------------------------------------------------------
declare -A last_operstate
declare -A last_carrier
declare -A last_status       # "up" / "down"
declare -A ifup_failures     # number of ifup failures
declare -A disabled          # 0 = active, 1 = do not touch anymore

# Initial state and one-shot bring-up for first device with carrier
for device in $net_devices; do
    [[ "$device" != en* && "$device" != eth* ]] && continue

    operstate=$(read_sysfs "/sys/class/net/$device/operstate")
    [[ -z "$operstate" ]] && operstate="down"

    carrier=$(read_sysfs "/sys/class/net/$device/carrier")
    # Only "0" or "1" make sense here; treat everything else as "0"
    [[ "$carrier" != "1" ]] && carrier="0"

    last_operstate["$device"]="$operstate"
    last_carrier["$device"]="$carrier"
    last_status["$device"]="down"
    ifup_failures["$device"]=0
    disabled["$device"]=0

    # First device with carrier=1 gets a one-shot ifup
    if [[ "$active_device" == "none" && "$carrier" == "1" ]]; then
        if ifup "$device" >/dev/null 2>&1; then
            last_status["$device"]="up"
            active_device="$device"
            echo "[OK] $device is up (initial DHCP)."
        else
            ifup_failures["$device"]=1
            echo "[WARN] $device initial ifup failed."
        fi
    fi
done

if [[ "$net_devices" == "" ]]; then
    echo "[INFO] No network devices found."
fi

# ------------------------------------------------------------
# Hotplug monitor
# - Poll every 5 seconds
# - Only act on state changes
# - Max 3 ifup attempts per device
# ------------------------------------------------------------
while :; do
    for device in $net_devices; do
        [[ "$device" != en* && "$device" != eth* ]] && continue
        [[ "${disabled[$device]}" -eq 1 ]] && continue

        # Only manage one active device at a time
        if [[ "$active_device" != "$device" && "$active_device" != "none" ]]; then
            continue
        fi

        operstate=$(read_sysfs "/sys/class/net/$device/operstate")
        [[ -z "$operstate" ]] && operstate="down"

        carrier=$(read_sysfs "/sys/class/net/$device/carrier")
        [[ "$carrier" != "1" ]] && carrier="0"

        prev_oper="${last_operstate[$device]}"
        prev_carrier="${last_carrier[$device]}"
        status="${last_status[$device]}"
        fails="${ifup_failures[$device]}"

        # Only do something if anything changed
        if [[ "$operstate" != "$prev_oper" || "$carrier" != "$prev_carrier" ]]; then
            last_operstate["$device"]="$operstate"
            last_carrier["$device"]="$carrier"

            # Carrier went 0 -> 1 and interface is down: try ifup
            if [[ "$carrier" == "1" && "$status" == "down" && "$fails" -lt 3 ]]; then
                if ifup "$device" >/dev/null 2>&1; then
                    last_status["$device"]="up"
                    active_device="$device"
                    echo "[OK] $device is up (carrier on)."
                    ifup_failures["$device"]=0
                else
                    fails=$((fails + 1))
                    ifup_failures["$device"]="$fails"
                    echo "[WARN] $device ifup failed ($fails/3)."
                    if [[ "$fails" -ge 3 ]]; then
                        disabled["$device"]=1
                        echo "[WARN] $device disabled after repeated ifup failures."
                        [[ "$active_device" == "$device" ]] && active_device="none"
                    fi
                fi
            fi

            # operstate went to "down" and interface was up: bring it down
            if [[ "$operstate" == "down" && "$status" == "up" ]]; then
                if ifdown -f "$device" >/dev/null 2>&1; then
                    last_status["$device"]="down"
                    echo "[OK] $device is down (operstate down)."
                    if [[ "$active_device" == "$device" ]]; then
                        active_device="none"
                    fi
                else
                    echo "[WARN] $device ifdown failed."
                fi
            fi
        fi
    done

    # Less aggressive polling to avoid stressing drivers
    sleep 5
done
