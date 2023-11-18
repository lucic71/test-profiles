#!/bin/sh
tar -xvf z3-4.12.1.tar.gz
cd z3-z3-4.12.1
PYTHON=/usr/bin/python3 ./configure
cd build
make -j$NUM_CPU_CORES z3
if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0"
fi
echo "#!/bin/sh
$NUMACTL ./z3-z3-4.12.1/build/z3 \$1 > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > ~/z3
chmod +x ~/z3
