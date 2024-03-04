#!/bin/sh

version=8.0
tar xvf primesieve-$version.tar.gz
cd primesieve-$version

cmake . -DBUILD_SHARED_LIBS=OFF
if [ "$OS_TYPE" = "BSD" ]
then
	gmake -j $NUM_CPU_CORES
	echo $? > ~/install-exit-status
else
	make -j $NUM_CPU_CORES
	echo $? > ~/install-exit-status
fi
cd ~

NUMACTL="numactl --membind=0 --cpunodebind=0 -- "
echo "#!/bin/sh
$NUMACTL primesieve-$version/./primesieve -t 1 \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > primesieve-test
chmod +x primesieve-test
