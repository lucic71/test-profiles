#!/bin/sh

if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0-79"
fi

echo "#!/bin/sh

cd build
$NUMACTL cmake --build . -- -j \$NUM_CPU_CORES 2>&1
echo \$? > ~/test-exit-status" > build-llvm

chmod +x build-llvm
