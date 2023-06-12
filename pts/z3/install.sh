#!/bin/sh

tar xfj z3-4.12.1.tar.gz
cd z3-4.12.1
./configure
cd build
make -j$NUM_CPU_CORES z3

echo "#!/bin/sh
cd z3-4.12.1/build/
(./z3 ../../1.smt2 && ./z3 ../../2.smt2) > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > z3
chmod +x z3
