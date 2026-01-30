#!/bin/bash -e

if grep -Eq "^BR2_ARCH_IS_64=y$" "${BR2_CONFIG}"; then
    MKIMAGE_ARCH=x86_64
    MKIMAGE_EFI=bootx64.efi
    MKIMAGE_CFG=genimage.cfg
else
    MKIMAGE_ARCH=i586
    MKIMAGE_EFI=bootia32.efi
    MKIMAGE_CFG=genimage_i586.cfg
fi

version=$(cat board/shredos/fsoverlay/etc/shredos/version.txt)

cp "board/shredos/grub.cfg"                            "${BINARIES_DIR}/grub.cfg"         || exit 1
cp "output/target/lib/grub/i386-pc/boot.img"           "${BINARIES_DIR}/boot.img"         || exit 1
cp "${BINARIES_DIR}/efi-part/EFI/BOOT/${MKIMAGE_EFI}"  "${BINARIES_DIR}/${MKIMAGE_EFI}"   || exit 1
cp "${BINARIES_DIR}/efi-part/EFI/BOOT/bootx64.efi"     "${BINARIES_DIR}/bootx64.efi"      || exit 1

cp "board/shredos/autorun.inf"             "${BINARIES_DIR}/autorun.inf"                  || exit 1
cp "board/shredos/README.txt"              "${BINARIES_DIR}/README.txt"                   || exit 1
cp "board/shredos/shredos.ico"             "${BINARIES_DIR}/shredos.ico"                  || exit 1

# version.txt is used to help identify the (boot) USB disk
cp "board/shredos/fsoverlay/etc/shredos/version.txt" "${BINARIES_DIR}/version.txt"        || exit 1

# Determine size of FAT partition based on size of bzImage plus an arbitary 20MB to hold PDF's etc.
BZIMAGE="${BINARIES_DIR}/bzImage"
CFG="board/shredos/${MKIMAGE_CFG}"
OFFSET=20000000

# Get bzImage size in bytes
if [[ ! -f "$BZIMAGE" ]]; then
    echo "Error: $BZIMAGE not found"
    exit 1
fi

SIZE=$(stat -c %s "$BZIMAGE")
NEW_SIZE=$((SIZE + OFFSET))

# Update size line in genimage.cfg
if [[ ! -f "$CFG" ]]; then
    echo "Error: $CFG not found"
    exit 1
fi

sed -i -E "0,/^[[:space:]]*size[[:space:]]*=/{s/^[[:space:]]*size[[:space:]]*=.*/size = ${NEW_SIZE}/}" "$CFG"

echo "Updated size to $NEW_SIZE bytes in $CFG"

# Create the .img
rm -rf "${BUILD_DIR}/genimage.tmp"                                                        || exit 1
genimage --rootpath="${TARGET_DIR}" \
    --inputpath="${BINARIES_DIR}" \
    --outputpath="${BINARIES_DIR}" \
    --config="board/shredos/${MKIMAGE_CFG}" \
    --tmppath="${BUILD_DIR}/genimage.tmp"                                                 || exit 1

SUFFIXIMG="${version}_$(date +%Y%m%d)"
FINAL_IMAGE_PATH="${BINARIES_DIR}/shredos-${SUFFIXIMG}.img"
mv "${BINARIES_DIR}/shredos.img" "${FINAL_IMAGE_PATH}"                                    || exit 1

GREEN="\033[0;32m"
RESET="\033[0m"

printf "%b" "$GREEN"
echo
echo "==============================================="
echo "  USB image '${FINAL_IMAGE_PATH}'"
echo "  (for '${MKIMAGE_ARCH}' architecture)"
echo "  CREATED SUCCESSFULLY!"
echo "==============================================="
echo
printf "%b\n" "$RESET"

exit 0
