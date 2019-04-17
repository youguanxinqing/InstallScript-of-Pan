#!/bin/bash
#

. $(dirname $0)/tools.lib

function install_and_set_redis
{
    cd ./package; tar xzvf redis.tar.gz; chmod 777 -R redis; cd ./redis
    make clean; make MALLOC=libc; make; make install
    cd ../../
}

function config_redis
{
    conf_path="/opt/YouGuan/redis"
    mkdir -p $conf_path
    cp ./package/redis/redis.conf "$conf_path/redis.conf"
    cd $conf_path
    sed -i "/^daemonize/c daemonize yes" redis.conf  # 开机自启
    sed -i "/^pidfile/c pidfile ./redis_6379.pid" redis.conf
    sed -i "/^logfile/c logfile ./redis.log" redis.conf
    sed -i "/^dir/c dir $conf_path" redis.conf
    cd -
}

# redis 安装逻辑
is_installed "gcc"
if [ $? -eq 0 ]; then
    yum install gcc
fi

is_installed "redis-server"
if [ $? -eq 0  ]; then
    install_and_set_redis
fi
print_format "Redis was installed successfully."
echo ""
echo "config redis ... "
config_redis
echo "start redis ... "
redis-server /opt/YouGuan/redis/redis.conf