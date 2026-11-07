#!/bin/bash
# ==============================================================================
# Script khởi động Hive Metastore Service & HiveServer2 trên toan-master
# ==============================================================================

# 1. Hive 4.2.1 yêu cầu Java 21 (class version 65.0)
if [ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
    export PATH=$JAVA_HOME/bin:$PATH
    
    # Tránh việc hadoop-env.sh ép ngược lại Java 8
    sed -i 's|^export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64|export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-8-openjdk-amd64}|' /opt/hadoop/etc/hadoop/hadoop-env.sh 2>/dev/null || true
    echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" > /opt/hive/conf/hive-env.sh 2>/dev/null || true
fi

echo "=========================================================="
echo ">> [1/4] Chuẩn bị thư mục HDFS cho Hive Warehouse..."
echo "=========================================================="
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod -R 777 /tmp
hdfs dfs -chmod -R 777 /user/hive/warehouse

echo "=========================================================="
echo ">> [2/4] Kiểm tra / Khởi tạo Schema PostgreSQL Metastore..."
echo "=========================================================="
schematool -dbType postgres -initSchema 2>/dev/null || echo ">> Schema đã tồn tại hoặc đã được khởi tạo."

echo "=========================================================="
echo ">> [3/4] Khởi động Hive Metastore Thrift Service (Port 9083)..."
echo "=========================================================="
nohup hive --service metastore > /home/hadoop/hive-metastore.log 2>&1 &
sleep 4

echo "=========================================================="
echo ">> [4/4] Khởi động HiveServer2 (Thrift 10000 / Web UI 10002)..."
echo "=========================================================="
nohup hive --service hiveserver2 > /home/hadoop/hiveserver2.log 2>&1 &
sleep 6

echo "=========================================================="
echo ">> Tiến trình Java hiện tại (JPS) trên toan-master:"
echo "=========================================================="
jps

echo ""
echo ">> Dịch vụ Apache Hive đã chạy nền:"
echo "   - Hive Metastore: Cổng 9083"
echo "   - HiveServer2:    Cổng 10000 (JDBC) / Web UI: http://localhost:10002"
echo "   - Log Metastore:  /home/hadoop/hive-metastore.log"
echo "   - Log Server2:    /home/hadoop/hiveserver2.log"
echo "=========================================================="
