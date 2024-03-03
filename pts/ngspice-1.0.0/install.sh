#!/bin/sh

tar -xf ngspice-34.tar.gz
tar -xf iscas85Circuits-1.tar.xz

cd ngspice-34
./configure
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
NUMACTL="numactl --membind=0 --cpunodebind=0 --preferred=0 -- "

echo "#!/bin/sh

cd ngspice-34
$NUMACTL ./src/ngspice \$@ > \$LOG_FILE" > ngspice
chmod +x ngspice
