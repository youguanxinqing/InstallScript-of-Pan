#!/bin/bash
#
. $(dirname $0)/tools.lib

# 卸载 redis
ps -ef | grep redis | grep -v grep | awk '{print "kill -9 " $2}' | sh
rm /usr/local/bin/redis-* -rf
rm /opt/redis/ -rf
print_format "Uninstall Redis Successfully"

# 移除 hiredis 环境
cd ./package/hiredis; make clean
rm /usr/local/include/hiredis -rf
rm /usr/local/lib/libhiredis* -rf
rm /usr/local/lib/pkgconfig -rf
cd -