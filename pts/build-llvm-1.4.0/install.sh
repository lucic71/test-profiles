#!/bin/sh

NUMACTL="numactl --membind=0 --cpunodebind=0 --preferred=0 -- "

echo "#!/bin/sh

cd build
$NUMACTL cmake --build . -- -j \$NUM_CPU_CORES 2>&1
echo \$? > ~/test-exit-status" > build-llvm

chmod +x build-llvm
