version=`cat ../../../board/shredos/fsoverlay/etc/shredos/version.txt`
sed -i "/banner/c\const char* banner = \"ShredOS v$version\";" ./src/version.c

