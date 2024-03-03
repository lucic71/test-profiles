#!/bin/sh
tar -xvf zstd-1.5.4.tar.gz
cd zstd-1.5.4
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
cd ~
NUMACTL="numactl --membind=0 --cpunodebind=0 --preferred=0 -- "
cat > compress-zstd <<EOT
#!/bin/sh
$NUMACTL ./zstd-1.5.4/zstd -T1 \$@ silesia.tar > \$LOG_FILE 2>&1
sed -i -e "s/\r/\n/g" \$LOG_FILE 
EOT
chmod +x compress-zstd
