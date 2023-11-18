#!/bin/sh

rm -rf redis-7.0.4
tar -xzf redis-7.0.4.tar.gz

cd ~/redis-7.0.4/deps
make hiredis jemalloc linenoise lua

cd ~/redis-7.0.4
make MALLOC=libc -j $NUM_CPU_CORES
echo $? > ~/install-exit-status

if `lscpu | grep -i arm > /dev/null`
then
	NUMACTL="numactl --membind=0 --physcpubind=0-79"
fi

cd ~
echo "#!/bin/sh
cd ~/redis-7.0.4

echo \"io-threads \$NUM_CPU_CORES
io-threads-do-reads yes
tcp-keepalive 0\" > redis.conf

$NUMACTL ./src/redis-server redis.conf &
REDIS_SERVER_PID=\$!
sleep 6

$NUMACTL ./src/redis-benchmark \$@ > \$LOG_FILE
kill \$REDIS_SERVER_PID
sed \"s/\\\"/ /g\" -i \$LOG_FILE" > redis
chmod +x redis
