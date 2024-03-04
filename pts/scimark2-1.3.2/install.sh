#!/bin/sh

unzip -o scimark2_1c.zip -d scimark2_files
cd scimark2_files/
$CC $CFLAGS -o scimark2 *.c -lm
echo $? > ~/install-exit-status
cd ..

NUMACTL="numactl --membind=0 --cpunodebind=0 -- "
echo "#!/bin/sh
cd scimark2_files/
$NUMACTL ./scimark2 -large > \$LOG_FILE 2>&1" > scimark2
chmod +x scimark2
