#!/bin/bash
#

. $(dirname $0)/tools.lib

function make_clean
{
    cd $1
    ./make.sh clean
    rm - &> /dev/null
}

echo "yes" | yum remove gcc
if [ $? -eq 0 ]; then 
	echo "Uninstalled gcc successfully."
else
	echo "Uninstalled gcc failed!!!"
fi
print_format "gcc 卸载成功"

# 停止 storaged, trackerd 服务
ps aux| grep storaged| grep -v grep| awk '{print "kill -9 " $2}'| sh
ps aux| grep trackerd| grep -v grep| awk '{print "kill -9 " $2}'| sh

make_clean "fastdfs"
make_clean "libfastcommon"

if [ -d "/etc/fdfs" ]; then
    # 移除数据目录
    for config in $(grep ^base_path /etc/fdfs/*.conf); do
        echo "${config#*=}  移除..."
        rm ${config_dir#*=}  -rf
    done
    # 移除配置目录
    rm "/etc/fdfs" -rf
fi

rm /usr/bin/fdfs_* -rf  # 移除可执行文件
rm /usr/include/fastdfs/ -rf  # 移除 fastdfs 的头文件
rm /usr/include/fastcommon/ -rf  # 移除 fastcommon 的头文件
rm /usr/lib64/libfdfs* -rf  # 移除 lib64下 libfdfsclient.so
rm /usr/lib/libfdfsclient.so /usr/lib/libfastcommon.so -rf  # 移除 lib 下库文件

print_format "fastDFS、libfastcommon 卸载成功"
