#!/bin/sh

tar -xf LuaJIT-20190110.tar.xz
cd LuaJIT-Git
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status

if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0"
fi

cd ~
echo "#!/bin/sh
$NUMACTL ./LuaJIT-Git/src/luajit scimark.lua -large > \$LOG_FILE 2>&1" > luajit
chmod +x luajit
