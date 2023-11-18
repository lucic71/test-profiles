#!/bin/sh

tar -xf png-samples-1.tar.xz
tar -xf basis_universal-1.13.tar.gz
cd basis_universal-1.13/
cmake CMakeLists.txt -DCMAKE_BUILD_TYPE=Release
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status

if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0"
fi

cd ~
echo "#!/bin/sh
cd basis_universal-1.13/bin
$NUMACTL ./basisu -no_multithreading \$@ ~/sample-*.png > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > basis
chmod +x basis
