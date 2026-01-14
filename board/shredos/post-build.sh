#!/bin/sh
set -eu

TARGET_DIR="$1"

# häufige Pfade
rm -rf \
  "$TARGET_DIR/usr/lib/kselftests" \
  "$TARGET_DIR/usr/libexec/kselftests" \
  "$TARGET_DIR/usr/share/kselftests" \
  "$TARGET_DIR/kselftests" \
  "$TARGET_DIR/opt/kselftests" || true
