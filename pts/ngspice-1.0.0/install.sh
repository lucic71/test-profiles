#!/bin/sh

tar -xf ngspice-34.tar.gz
tar -xf iscas85Circuits-1.tar.xz

cd ngspice-34
./configure
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0"
fi

echo "#!/bin/sh

cd ngspice-34
$NUMACTL ./src/ngspice \$@ > \$LOG_FILE" > ngspice
chmod +x ngspice
