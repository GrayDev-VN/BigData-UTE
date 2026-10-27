#!/bin/bash
# ==============================================================================
# Script thực thi tạo bảng Hive tự động từ file SQL qua Beeline
# ==============================================================================

echo ">> Đang kết nối Beeline HiveServer2 để tạo bảng..."
beeline -u "jdbc:hive2://toan-master:10000" -n hadoop -f /home/hadoop/scripts/create_table.sql
echo ">> Hoàn tất tạo bảng trong Hive!"
