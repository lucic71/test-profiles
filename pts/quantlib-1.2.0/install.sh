#!/bin/sh
tar -xf QuantLib-1.32.tar.gz
cd QuantLib-1.32/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native" -DCMAKE_C_FLAGS="-O3 -march=native" -DQL_ENABLE_PARALLEL_UNIT_TEST_RUNNER=ON 
if [ $OS_TYPE = "BSD" ]
then
	gmake -j $NUM_CPU_CORES
	echo $? > ~/install-exit-status
else
	make -j $NUM_CPU_CORES
	echo $? > ~/install-exit-status
fi
cd ~
if `lscpu | grep -i arm > /dev/null`
then
	NUMACTLMP="numactl --membind=0 --physcpubind=0-79"
	NUMACTL="numactl --membind=0 --physcpubind=0"
fi
echo "#!/bin/bash
cd QuantLib-1.32/build
if [ \$@ == "--mp" ]
then
	$NUMACTLMP ./test-suite/quantlib-benchmark --mp=\$NUM_CPU_CORES > \$LOG_FILE 2>&1
else
	$NUMACTL ./test-suite/quantlib-benchmark > \$LOG_FILE 2>&1
fi
echo \$? > ~/test-exit-status" > quantlib
chmod +x quantlib
