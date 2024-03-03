#!/bin/sh
tar -xf openssl-3.1.0.tar.gz
cd openssl-3.1.0
./config no-zlib
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
NUMACTL="numactl --membind=0 --cpunodebind=0 --preferred=0 -- "
echo "#!/bin/sh
cd openssl-3.1.0
LD_LIBRARY_PATH=.:\$LD_LIBRARY_PATH $NUMACTL ./apps/openssl speed -multi 1 -seconds 30 \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > openssl
chmod +x openssl
