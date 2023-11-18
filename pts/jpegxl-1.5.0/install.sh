#!/bin/sh
tar -xf libjxl-0.7.0.tar.gz
tar -xf png-samples-1.tar.xz
unzip -o sample-photo-6000x4000-1.zip
cd libjxl-0.7.0
./deps.sh
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
cmake --build . -- -j $NUM_CPU_CORES
echo $? > ~/install-exit-status

if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0-79"
	ARMFLAGS="--num_threads=80"
fi

cd ~
echo "#!/bin/sh
$NUMACTL ./libjxl-0.7.0/build/tools/cjxl $ARMFLAGS \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > jpegxl
chmod +x jpegxl
