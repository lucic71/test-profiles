#!/bin/sh

unzip -o crafty-25.2.zip


if [ "X$CFLAGS_OVERRIDE" = "X" ]
then
          CFLAGS="$CFLAGS -O3 -march=native"
else
          CFLAGS="$CFLAGS_OVERRIDE"
fi

export CFLAGS="-Wall -pipe -fomit-frame-pointer $CFLAGS -j $NUM_CPU_CORES"
export CXFLAGS="-Wall -pipe -O3 -fomit-frame-pointer $CXXFLAGS -j $NUM_CPU_CORES"
export LDFLAGS="$LDFLAGS -pthread -lstdc++"
# sed -i ".orig" -e 's/-j /-j4 /g' Makefile
sed -i 's/-j / /g' Makefile
make unix-clang

echo $? > ~/install-exit-status

cd ~

NUMACTL="numactl --membind=0 --cpunodebind=0 --preferred=0 -- "
echo "#!/bin/sh
$NUMACTL ./crafty \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > crafty-benchmark
chmod +x crafty-benchmark
