#!/bin/bash -e

if grep -Eq "^BR2_ARCH_IS_64=y$" "${BR2_CONFIG}"; then
    MKIMAGE_ARCH=x86_64
else
    MKIMAGE_ARCH=i386
fi

version=$(cat board/shredos/fsoverlay/etc/shredos/version.txt)

SUFFIXISO="${version}_$(date +%Y%m%d)"
FINAL_ISO_PATH="${BINARIES_DIR}/shredos-${SUFFIXISO}.iso"

mv "${BINARIES_DIR}/rootfs.iso9660" "${FINAL_ISO_PATH}"             || exit 1

GREEN="\033[0;32m"
RESET="\033[0m"

printf "%b" "$GREEN"
echo
echo "==============================================="
echo "  ISO image '${FINAL_ISO_PATH}'"
echo "  (for '${MKIMAGE_ARCH}' architecture)"
echo "  CREATED SUCCESSFULLY!"
echo "==============================================="
echo
printf "%b" "$RESET"

exit 0
