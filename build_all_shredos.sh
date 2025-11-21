#!/bin/bash
set -euo pipefail

################################################################################
# Usage: ./build_all_shredos.sh [x64|x32|all]
#
# Arguments:
#  x64   - Build only x86-64 configurations
#  x32   - Build only i586 (32-bit) configurations
#  all   - Build all configurations (64-bit first, then 32-bit)
#
# Environment Variables:
#  DRY_RUN=0|1      - Output all commands that would be executed (default: 0)
#  PRE_CLEAN=0|1    - Do an initial 'make clean' before starting (default: 1)
#  QUICK_BUILD=0|1  - Do not full rebuild for same architecture (default: 0)
#  FAST_FAIL=0|1    - Exit on first configuration build failure (default: 1)
#  NEW_VERSION=STR  - Set version string (default: prompts user)
#
# Examples:
#  ./build_all_shredos.sh x64
#  ./build_all_shredos.sh all
#  QUICK_BUILD=1 ./build_all_shredos.sh x32
#  NEW_VERSION="2024.11_27_x86-64_0.38" ./build_all_shredos.sh x64
################################################################################

# Location of the version file:
VERSION_FILE="board/shredos/fsoverlay/etc/shredos/version.txt"

# 64-bit configurations to build:
X64_CONFIGS=(
	"shredos_defconfig"
	"shredos_img_defconfig"
	"shredos_iso_defconfig"
	"shredos_iso_legacy_defconfig"
	"shredos_iso_extra_defconfig" # experimental
)

# 32-bit configurations to build:
X32_CONFIGS=(
	"shredos_i586_defconfig"
	"shredos_img_i586_defconfig"
	"shredos_iso_i586_defconfig"
	"shredos_iso_legacy_i586_defconfig"
	"shredos_iso_extra_i586_defconfig" # experimental
)

# Packages always needing rebuild between runs, even for the same architecture.
# This only applies when QUICK_BUILD is enabled, otherwise rebuilds everything.
ALWAYS_REBUILD_PKGS=(
	"grub2"
)

################################################################################

DRY_RUN="${DRY_RUN:-0}"
PRE_CLEAN="${PRE_CLEAN:-1}"
QUICK_BUILD="${QUICK_BUILD:-0}"
FAST_FAIL="${FAST_FAIL:-1}"
NEW_VERSION="${NEW_VERSION:-}"

X64_SUCCESS=0
X64_FAILED=0
X32_SUCCESS=0
X32_FAILED=0

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

FORCE_CLEAN=0

print_usage() {
	echo
	echo "Usage: $0 [x64|x32|all]"
	echo ""
	echo "Arguments:"
	echo "  x64   - Build only x86-64 configurations"
	echo "  x32   - Build only i586 (32-bit) configurations"
	echo "  all   - Build all configurations (64-bit first, then 32-bit)"
	echo ""
	echo "Environment Variables:"
	echo "  DRY_RUN=0|1      - Output all commands that would be executed (default: 0)"
	echo "  PRE_CLEAN=0|1    - Do an initial 'make clean' before starting (default: 1)"
	echo "  QUICK_BUILD=0|1  - Do not full rebuild for same architecture (default: 0)"
	echo "  FAST_FAIL=0|1    - Exit on first failure (default: 1)"
	echo "  NEW_VERSION=STR  - Set version string (default: prompts user)"
	echo ""
	echo "Examples:"
	echo "  $0 x64"
	echo "  $0 all"
	echo "  QUICK_BUILD=1 PRE_CLEAN=0 $0 x32"
	echo
}

parse_arguments() {
	if [ $# -eq 0 ]; then
		printf "%b" "$RED"
		echo "Error: Missing architecture argument"
		printf "%b" "$RESET"
		print_usage
		exit 1
	fi

	BUILD_TARGET="$1"
	case "$BUILD_TARGET" in
		x64)
			X32_CONFIGS=()
			;;
		x32)
			X64_CONFIGS=()
			;;
		all)
			;;
		*)
			printf "%b" "$RED"
			echo "Error: Invalid architecture '$BUILD_TARGET'"
			echo "Must be one of: x64, x32, all"
			printf "%b" "$RESET"
			print_usage
			exit 1
			;;
	esac
}

prompt_version() {
	local current_version=""

	if [ -f "$VERSION_FILE" ]; then
		current_version=$(cat "$VERSION_FILE")
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
		read -rp "Enter new version or press ENTER to keep existing [${current_version}]: " NEW_VERSION
		[ -z "$NEW_VERSION" ] && NEW_VERSION="$current_version"
	fi

	run_cmd_change_version "$NEW_VERSION"

	printf "%b" "$GREEN"
	echo
	echo "==============================================="
	echo "Version updated to: $NEW_VERSION"
	echo "==============================================="
	echo
	printf "%b" "$RESET"
}

display_build_plan() {
	local total_configs=$((${#X64_CONFIGS[@]} + ${#X32_CONFIGS[@]}))

	printf "%b" "$GREEN"
	echo
	echo "==============================================="
	echo "PLANNING TO BUILD:"
	echo "==============================================="
	echo "Version:                  $NEW_VERSION"
	echo "Dry-Run:                  $DRY_RUN"
	echo "Pre-Clean:                $PRE_CLEAN"
	echo "Quick Build:              $QUICK_BUILD"
	echo "Fast Failure:             $FAST_FAIL"
	echo "Total Configurations:     $total_configs"
	echo "Building Architectures:   $BUILD_TARGET"
	echo "==============================================="
	echo
	printf "%b" "$RESET"

	if [ ${#X64_CONFIGS[@]} -gt 0 ]; then
		echo "64-bit configurations (${#X64_CONFIGS[@]}):"
		for config in "${X64_CONFIGS[@]}"; do
			echo "  - $config"
		done
		echo
	fi

	if [ ${#X32_CONFIGS[@]} -gt 0 ]; then
		echo "32-bit configurations (${#X32_CONFIGS[@]}):"
		for config in "${X32_CONFIGS[@]}"; do
			echo "  - $config"
		done
		echo
	fi

	if [ ${#ALWAYS_REBUILD_PKGS[@]} -gt 0 ]; then
		echo "Packages that will be re-built between same-architecture runs (${#ALWAYS_REBUILD_PKGS[@]}):"
		for package in "${ALWAYS_REBUILD_PKGS[@]}"; do
			echo "  - $package"
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
		run_cmd sed -i "s@$from@$to@g" "$VERSION_FILE"
	fi
}

run_cmd() {
	local timestamp
	timestamp=$(date '+%d.%m.%Y %H:%M:%S')

	if [ "$DRY_RUN" -eq 1 ]; then
		if [[ $* == make* ]]; then
			printf "%b" "$YELLOW"
			echo "[DRY_RUN] $*"
			printf "%b" "$RESET"
		else
			echo "[DRY_RUN] $*"
		fi
	else
		echo "[$timestamp] $*" >> "build_all_shredos.log"
		"$@"
	fi
}

run_cmd_tee() {
	local timestamp
	timestamp=$(date '+%d.%m.%Y %H:%M:%S')
	local log_file="$1"
	
	if [ "$DRY_RUN" -eq 1 ]; then
		echo "[DRY_RUN] tee $log_file"
		cat
	else
		echo "[$timestamp] tee $log_file" >> "build_all_shredos.log"
		tee "$log_file"
	fi
}

run_cmd_change_version() {
	local timestamp
	timestamp=$(date '+%d.%m.%Y %H:%M:%S')
	local new_version="$1"
	
	if [ "$DRY_RUN" -eq 1 ]; then
		echo "[DRY_RUN] echo \"$new_version\" > \"$VERSION_FILE\""
	else
		echo "[$timestamp] echo \"$new_version\" > \"$VERSION_FILE\"" >> "build_all_shredos.log"
		echo "$new_version" > "$VERSION_FILE"
	fi
}

build_config() {
	local index="$1"
	local config="$2"
	local arch="$3"
	local log_file="dist/${config}.log"

	printf "%b" "$YELLOW"
	echo
	echo "============================================"
	echo "Started: '$config' ($arch)"
	echo "============================================"
	echo
	printf "%b" "$RESET"

	# Build  | QuickBuild=1, PreClean=1  | QuickBuild=0, PreClean=1  | QuickBuild=1, PreClean=0  | QuickBuild=0, PreClean=0
	# -------|---------------------------|---------------------------|---------------------------|---------------------------
	# x64 #0 | config -> make            | config -> make            | config -> rebuild -> make | config -> rebuild -> make
	# x64 #1 | config -> rebuild -> make | clean -> config -> make   | config -> rebuild -> make | clean -> config -> make
	# x64 #2+| config -> rebuild -> make | clean -> config -> make   | config -> rebuild -> make | clean -> config -> make
	# x32 #0 | clean -> config -> make   | clean -> config -> make   | clean -> config -> make   | clean -> config -> make
	# x32 #1+| config -> rebuild -> make | clean -> config -> make   | config -> rebuild -> make | clean -> config -> make

	if [ "$index" -ne 0 ] && [ "$QUICK_BUILD" -eq 1 ] && [ "$FORCE_CLEAN" -ne 1 ]; then
		# If it's not the first configuration, and quick-build is enabled,
		# and a clean is not otherwise forced, just rebuild necessary packages.
		echo
		echo "============================================"
		echo "Loading configuration '$config' ($arch)..."
		echo "============================================"
		echo
		if ! run_cmd make "$config"; then
			build_config_failed "$config" "$arch" "$log_file"
			return 1
		fi
		echo
		echo "============================================"
		echo "Rebuilding packages for '$config' ($arch)..."
		echo "============================================"
		echo
		for pkg in "${ALWAYS_REBUILD_PKGS[@]}"; do
			# Reconfigure starts one stage before rebuild, just to be safe.
			# It is the earliest step after the source download and patching.
			if ! run_cmd make "${pkg}-reconfigure"; then
				build_config_failed "$config" "$arch" "$log_file"
				return 1
			fi
		done
	else
		if [ "$index" -ne 0 ] || [ "$FORCE_CLEAN" -eq 1 ]; then
			# If it's not the first configuration, or the clean was forced
			# (due to architecture change), clean the building environment.
			echo
			echo "============================================"
			echo "Running 'make clean' for '$config' ($arch)..."
			echo "============================================"
			echo
			if ! run_cmd make clean; then
				build_config_failed "$config" "$arch" "$log_file"
				return 1
			fi
		fi
		echo
		echo "============================================"
		echo "Loading configuration '$config' ($arch)..."
		echo "============================================"
		echo
		if ! run_cmd make "$config"; then
			build_config_failed "$config" "$arch" "$log_file"
			return 1
		fi
		if [ "$index" -eq 0 ] && [ "$PRE_CLEAN" -eq 0 ] && [ "$FORCE_CLEAN" -ne 1 ]; then
			# If it's the first configuration in a deliberately unclean environment,
			# and clean was not otherwise forced, at least rebuild the necessary packages.
			echo
			echo "============================================"
			echo "Rebuilding packages for '$config' ($arch)..."
			echo "============================================"
			echo
			for pkg in "${ALWAYS_REBUILD_PKGS[@]}"; do
				# Reconfigure starts one stage before rebuild, just to be safe.
				# It is the earliest step after the source download and patching.
				if ! run_cmd make "${pkg}-reconfigure"; then
					build_config_failed "$config" "$arch" "$log_file"
					return 1
				fi
			done
		fi
	fi

	FORCE_CLEAN=0 # Reset previous dirty state

	echo
	echo "============================================"
	echo "Building '$config' ($arch)..."
	echo "============================================"
	echo
	if run_cmd make 2>&1 | run_cmd_tee "$log_file"; then
		echo
		echo "============================================"
		echo "Finishing '$config' ($arch)..."
		echo "============================================"
		echo
		build_config_success "$config" "$arch" "$log_file"
		return 0
	else
		echo
		echo "============================================"
		echo "Finishing '$config' ($arch)..."
		echo "============================================"
		echo
		build_config_failed "$config" "$arch" "$log_file"
		return 1
	fi
}

print_summary_and_exit() {
	local return_code="$1"
	local total_success=$((X64_SUCCESS + X32_SUCCESS))
	local total_failed=$((X64_FAILED + X32_FAILED))
	local total_builds=$((total_success + total_failed))

	echo
	echo "============================================"
	echo "BUILD SUMMARY"
	echo "============================================"
	echo "64-bit builds:  $X64_SUCCESS succeeded, $X64_FAILED failed"
	echo "32-bit builds:  $X32_SUCCESS succeeded, $X32_FAILED failed"
	echo "--------------------------------------------"
	echo "Total:  $total_success succeeded, $total_failed failed (out of $total_builds)"
	echo "--------------------------------------------"
	echo "You will find all output files of the builds in the 'dist/' folder."
	echo "Check 'build_all_shredos.log' for all the commands that were executed."
	echo "============================================"
	echo

	if [ "$return_code" -ne 0 ]; then
		exit "$return_code"
	elif [ "$total_failed" -gt 0 ]; then
		exit 1
	else
		exit 0
	fi
}

build_config_success() {
	local config="$1"
	local arch="$2"
	local log_file="$3"

	if [ -f "$log_file" ]; then
		run_cmd mv "$log_file" "dist/${config}-SUCCESS.log"
	fi

	run_cmd mkdir -p "dist/$config"
	run_cmd mv output/images/shredos*.iso "dist/$config/" 2>/dev/null || true
	run_cmd mv output/images/shredos*.img "dist/$config/" 2>/dev/null || true

	printf "%b" "$GREEN"
	echo
	echo "==============================================="
	echo "SUCCESS: '$config' ($arch)"
	echo "==============================================="
	echo
	printf "%b" "$RESET"

	if [ "$arch" = "x64" ]; then
		((X64_SUCCESS++))
	else
		((X32_SUCCESS++))
	fi
}

build_config_failed() {
	local config="$1"
	local arch="$2"
	local log_file="$3"

	if [ -f "$log_file" ]; then
		run_cmd mv "$log_file" "dist/${config}-FAILED.log"
	fi

	printf "%b" "$RED"
	echo
	echo "==============================================="
	echo "FAILURE: '$config' ($arch)"
	echo "==============================================="
	echo
	printf "%b" "$RESET"

	if [ "$arch" = "x64" ]; then
		((X64_FAILED++))
	else
		((X32_FAILED++))
	fi

	if [ "$FAST_FAIL" -eq 1 ]; then
		printf "%b" "$RED"
		echo
		echo "==============================================="
		echo "Fast Failure Mode is enabled - not proceeding..."
		echo "==============================================="
		echo
		printf "%b" "$RESET"
		exit 1
	fi
}

################################################################################

if [ -f "build_all_shredos.log" ]; then
	rm build_all_shredos.log
fi

parse_arguments "$@"
prompt_version
display_build_plan

if [ "$DRY_RUN" -eq 1 ]; then
	printf "%b" "$YELLOW"
	echo
	echo "==============================================="
	echo "DRY RUN - NO ACTUAL CHANGES WILL BE MADE"
	echo "DISREGARD WARNINGS ABOUT 'MAKE CLEAN' ETC..."
	echo "==============================================="
	echo
	printf "%b" "$RESET"
fi

if [ "$PRE_CLEAN" -eq 1 ]; then
	printf "%b" "$RED"
	echo
	echo "==============================================="
	echo "Beware - WILL run a MAKE CLEAN before starting building!"
	echo "Press ENTER in the next 10 seconds to skip this step..."
	echo "or otherwise (if you want to MAKE CLEAN) - just wait..."
	echo "==============================================="
	echo
	printf "%b" "$RESET"
	
	if read -rt 10; then
		PRE_CLEAN=0
		echo "Skipped cleaning the building stage (no 'make clean')..."
	fi
fi

printf "%b" "$YELLOW"
echo
echo "==============================================="
echo "Starting build in 10 seconds... (press CTRL+C to cancel)"
if [ "$PRE_CLEAN" -eq 1 ]; then
	printf "%b" "$RESET"
	printf "%b" "$RED"
	echo "Beware - WILL run a MAKE CLEAN before starting building!"
	printf "%b" "$RESET"
	printf "%b" "$YELLOW"
fi
echo "==============================================="
echo
printf "%b" "$RESET"

sleep 10

if [ "$PRE_CLEAN" -eq 1 ]; then
	echo "Running 'make clean' on the building environment..."
	run_cmd make clean
fi

echo "Removing and recreating 'dist/' folder (if it exists)..."
run_cmd rm -r dist || true
run_cmd mkdir -p dist

echo "Starting to build..."
trap 'print_summary_and_exit $?' EXIT INT TERM

if [ ${#X64_CONFIGS[@]} -gt 0 ]; then
	echo
	echo "==============================================="
	echo "Starting 64-bit builds..."
	echo "==============================================="
	echo
	replace_version "i586" "x86-64"

	CFG_INDEX=0
	for config in "${X64_CONFIGS[@]}"; do
		build_config "$CFG_INDEX" "$config" "x64" || true
		((++CFG_INDEX))
	done
fi

if [ ${#X32_CONFIGS[@]} -gt 0 ]; then
	if [ ${#X64_CONFIGS[@]} -gt 0 ]; then
		run_cmd make clean
		FORCE_CLEAN=1 # Need this for architecture change
	fi

	echo
	echo "==============================================="
	echo "Starting 32-bit builds..."
	echo "==============================================="
	echo
	replace_version "x86-64" "i586"

	CFG_INDEX=0
	for config in "${X32_CONFIGS[@]}"; do
		build_config "$CFG_INDEX" "$config" "x32" || true
		((++CFG_INDEX))
	done
fi
