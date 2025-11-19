#!/bin/bash

################################################################################
# Usage:
#  FAIL_ON_ERROR=0|1 QUICK_BUILD=0|1 NEW_VERSION="STRING" ./build_all.sh
#
# Examples:
#  ./build_all.sh
#  FAIL_ON_ERROR=0 QUICK_BUILD=0 ./build_all.sh
#  NEW_VERSION="2024.11_27_x86-64_0.38" ./build_all.sh
#
# Environment Variables:
#  FAIL_ON_ERROR - 0=continue on failure, 1=exit on first failure (default: 1)
#  QUICK_BUILD - 0=full clean between configs, 1=grub2-rebuild only (default: 1)
#  NEW_VERSION - Version string (default: prompts user & keeps current on ENTER)
################################################################################

################################################################################
# 0 = continue to the next configuration if one fails to build
# 1 = exit the entire script if one configuration fails to build
FAIL_ON_ERROR="${FAIL_ON_ERROR:-1}"
################################################################################

################################################################################
# 0 = "make clean" between same architecture configs (much slower)
# 1 = "make grub2-rebuild" between same architecture configs (much faster)
QUICK_BUILD="${QUICK_BUILD:-1}"
################################################################################

################################################################################
VERSION_FILE="board/shredos/fsoverlay/etc/shredos/version.txt"

x64_configs=(
	"shredos_defconfig"
	"shredos_img_defconfig"
	"shredos_iso_defconfig"
	"shredos_iso_aio_defconfig"
)

x32_configs=(
	"shredos_i586_defconfig"
	"shredos_img_i586_defconfig"
	"shredos_iso_i586_defconfig"
	"shredos_iso_aio_i586_defconfig"
)
################################################################################

set -e
trap 'exit 1' SIGINT
trap 'exit 1' SIGTERM

x64_success=0
x64_failed=0
x32_success=0
x32_failed=0

GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

prompt_version() {
	local CURRENT_VERSION=""

	if [ -f "$VERSION_FILE" ]; then
		CURRENT_VERSION=$(cat "$VERSION_FILE")
	else
		printf "%b" "$RED"
		echo
		echo "==============================================="
		echo "Version file not found: $VERSION_FILE"
		echo "==============================================="
		echo
		printf "%b" "$RESET"
		exit 1
	fi

	if [ -z "$NEW_VERSION" ]; then
		echo
		echo "x86-64 and i586 will be replaced/switched around during builds (depending on architecture)"
		read -rp "Enter new version or press ENTER to keep existing [${CURRENT_VERSION}]: " NEW_VERSION
		[ -z "$NEW_VERSION" ] && NEW_VERSION="$CURRENT_VERSION"
	fi

	echo "$NEW_VERSION" > "$VERSION_FILE"

	printf "%b" "$GREEN"
	echo
	echo "==============================================="
	echo "Version updated to: $NEW_VERSION"
	echo "==============================================="
	echo
	printf "%b" "$RESET"
}

display_build_plan() {
	local total_configs=$((${#x64_configs[@]} + ${#x32_configs[@]}))
	
	printf "%b" "$GREEN"
	echo
	echo "==============================================="
	echo "PLANNING TO BUILD:"
	echo "==============================================="
	echo "Version:        $NEW_VERSION"
	echo "Fail on Error:  $FAIL_ON_ERROR"
	echo "Quick Build:    $QUICK_BUILD"
	echo "Total Configs:  $total_configs"
	echo "==============================================="
	echo
	printf "%b" "$RESET"
	
	if [ ${#x64_configs[@]} -gt 0 ]; then
		echo "64-bit targets (${#x64_configs[@]}):"
		for config in "${x64_configs[@]}"; do
			echo "  - $config"
		done
		echo
	fi
	
	if [ ${#x32_configs[@]} -gt 0 ]; then
		echo "32-bit targets (${#x32_configs[@]}):"
		for config in "${x32_configs[@]}"; do
			echo "  - $config"
		done
		echo
	fi
	
	printf "%b" "$GREEN"
	echo "==============================================="
	echo "Configurations to build can be amended inside the script."
	echo "==============================================="
	echo
	printf "%b" "$RESET"
}

replace_version() {
	local from=$1
	local to=$2
	if [ -f "$VERSION_FILE" ]; then
		sed -i "s/$from/$to/g" "$VERSION_FILE"
	fi
}

build_config() {
	local config=$1
	local arch=$2
	local log_file="dist/${config}.log"

	echo
	echo "============================================"
	echo "Building $config ($arch)"
	echo "============================================"
	echo

	if [ "$QUICK_BUILD" -eq 1 ]; then
		make "$config"
		make grub2-rebuild
	else
		make clean
		make "$config"
	fi

	[ ! "$FAIL_ON_ERROR" -eq 1 ] && set +e
	make 2>&1 | tee "$log_file"
	local make_status=${PIPESTATUS[0]}
	[ ! "$FAIL_ON_ERROR" -eq 1 ] && set -e

	if [ "$make_status" -eq 0 ]; then
		mv "$log_file" "dist/${config}-SUCCESS.log"

		mkdir -p "dist/$config"
		mv output/images/shredos*.iso "dist/$config/" 2>/dev/null || true
		mv output/images/shredos*.img "dist/$config/" 2>/dev/null || true

		printf "%b" "$GREEN"
		echo
		echo "==============================================="
		echo "$config build ($arch) success"
		echo "==============================================="
		echo
		printf "%b\n" "$RESET"

		if [ "$arch" = "x64" ]; then
			((x64_success++))
		else
			((x32_success++))
		fi
		return 0
	else
		mv "$log_file" "dist/${config}-FAILED.log"

		printf "%b" "$RED"
		echo
		echo "==============================================="
		echo "$config build ($arch) failed"
		echo "==============================================="
		echo
		printf "%b\n" "$RESET"

		if [ "$arch" = "x64" ]; then
			((x64_failed++))
		else
			((x32_failed++))
		fi
		return 1
	fi
}

################################################################################

prompt_version
display_build_plan

echo "Starting these builds in 10 seconds... (press CTRL+C to cancel)"
sleep 10

echo "Running 'make clean' on the building environment..."
make clean

echo "Removing and recreating 'dist/' folder (if it exists)..."
rm -r dist || true
mkdir -p dist

echo "Starting to build..."

if [ ${#x64_configs[@]} -gt 0 ]; then
	echo
	echo "==============================================="
	echo "Starting 64-bit builds..."
	echo "==============================================="
	echo
	replace_version "i586" "x86-64"

	for config in "${x64_configs[@]}"; do
		build_config "$config" "x64" || true
	done
fi

make clean

if [ ${#x32_configs[@]} -gt 0 ]; then
	echo
	echo "==============================================="
	echo "Starting 32-bit builds..."
	echo "==============================================="
	echo
	replace_version "x86-64" "i586"

	for config in "${x32_configs[@]}"; do
		build_config "$config" "x32" || true
	done
fi

total_success=$((x64_success + x32_success))
total_failed=$((x64_failed + x32_failed))
total_builds=$((total_success + total_failed))

echo
echo "============================================"
echo "BUILD SUMMARY"
echo "============================================"
echo "64-bit builds:  $x64_success succeeded, $x64_failed failed"
echo "32-bit builds:  $x32_success succeeded, $x32_failed failed"
echo "--------------------------------------------"
echo "Total:  $total_success succeeded, $total_failed failed (out of $total_builds)"
echo "--------------------------------------------"
echo "You will find all output files of the builds in the 'dist/' folder."
echo "============================================"
echo

if [ $total_failed -gt 0 ]; then
	exit 1
else
	exit 0
fi
