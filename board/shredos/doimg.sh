#!/bin/bash -e

version=`cat board/shredos/fsoverlay/etc/shredos/version.txt`

cp "board/shredos/grub.cfg"                "${BINARIES_DIR}/grub.cfg"    || exit 1
cp "board/shredos/bootx64.efi"             "${BINARIES_DIR}/bootx64.efi" || exit 1
#cp "${HOST_DIR}/lib/grub/i386-pc/boot.img" "${BINARIES_DIR}/boot.img"    || exit 1
cp "output/target/lib/grub/i386-pc/boot.img" "${BINARIES_DIR}/boot.img"    || exit 1

# copy the ShredOS icon and Windows autorun.inf; if a USB stick is plugged into a Windows system
# it will be identified as 'ShredOS - Dangerous' as a warning to users unaware what ShredOS is.
cp "board/shredos/autorun.inf"             "${BINARIES_DIR}/autorun.inf" || exit 1
cp "board/shredos/README.txt"              "${BINARIES_DIR}/README.txt"  || exit 1
cp "board/shredos/shredos.ico"             "${BINARIES_DIR}/shredos.ico" || exit 1

# version.txt is used to help identify boot disc
cp "board/shredos/fsoverlay/etc/shredos/version.txt" "${BINARIES_DIR}/version.txt" || exit 1

rm -rf "${BUILD_DIR}/genimage.tmp"                                       || exit 1
genimage --rootpath="${TARGET_DIR}" --inputpath="${BINARIES_DIR}" --outputpath="${BINARIES_DIR}" --config="board/shredos/genimage.cfg" --tmppath="${BUILD_DIR}/genimage.tmp" || exit 1

# renaming
SUFFIXIMG="${version}_$(date +%Y%m%d)"
FINAL_IMAGE_PATH="${BINARIES_DIR}/shredos-${SUFFIXIMG}.img"
mv "${BINARIES_DIR}/shredos.img" "${FINAL_IMAGE_PATH}" || exit 1
#mv "${BINARIES_DIR}/bzImage" "${FINAL_IMAGE_PATH}" || exit 1

echo "File ${FINAL_IMAGE_PATH} created successfully"

exit 0
