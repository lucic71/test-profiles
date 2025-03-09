#!/bin/sh

unzip -o scimark2_1c.zip -d scimark2_files
cd scimark2_files/
$CC -c FFT.c
$CC -c LU.c
$CC -c MonteCarlo.c
$CC -c Random.c
$CC -c SOR.c
ORIG_UB_OPT_FLAG=$UB_OPT_FLAG
UB_OPT_FLAG="$UB_OPT_FLAG -fno-lto"
$CC -c SparseCompRow.c -fno-lto
UB_OPT_FLAG="$ORIG_UB_OPT_FLAG"
$CC -c Stopwatch.c
$CC -c array.c
$CC -c kernel.c
$CC -c scimark2.c
$CC -o scimark2 scimark2.o FFT.o kernel.o Stopwatch.o Random.o SOR.o SparseCompRow.o array.o MonteCarlo.o LU.o -lm
echo $? > ~/install-exit-status
cd ..

TASKSET="sudo nice -n -20 taskset -c 0"
echo "#!/bin/sh
cd scimark2_files/
$TASKSET ./scimark2 -large > \$LOG_FILE 2>&1" > scimark2
chmod +x scimark2
