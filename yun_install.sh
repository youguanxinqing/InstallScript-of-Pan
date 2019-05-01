#!/bin/bash

# 工具导入
. $(dirname $0)/tools.lib

# 下载 libfastcommon 和 fastcommon
function download_from_github
{
	git clone $1
	if [ $? -eq 0 ]; then
		print_format "Download libfastcommon successfully."
	else
 		print_format "Download libfastcommon failed!!!"
	fi
}

# 编译并安装
function install
{
	echo "Start install $1..."
	cd $1
	./make.sh
	if [ $? -ne 0 ]; then
		print_format "Install $1 failed!!!"
		exit 0
	fi
	
	./make.sh install
	if [ $? -eq 0 ]; then
		print_format "Install $1 successfully."
	else
		print_format "Install $1 failed!!!"
		exit 0
	fi
	cd ..
}

# 判断可执行程序是否已经安装
function is_installed
{
	if [ -x "$(command -v $1)" ]; then
		return 1
	else
		return 0
	fi
}

# fastDFS 的数据文件
function mkdir_for_tsc
{
    fastdfs_dir="/opt/YouGuan/fastDFS"
    tracker_dir="/opt/YouGuan/fastDFS/tracker"
    storage_dir="/opt/YouGuan/fastDFS/storage"
    client_dir="/opt/YouGuan/fastDFS/client"

    # 不存在以上目录时才创建
    if [ ! -d "$fastdfs_dir" ]; then mkdir $fastdfs_dir; fi
    if [ ! -d "$tracker_dir" ]; then mkdir $tracker_dir; fi
    if [ ! -d "$storage_dir" ]; then mkdir $storage_dir; fi
    if [ ! -d "$client_dir" ]; then mkdir $client_dir; fi
}

function get_host_ip
{
    ips[0]=""
    count=1
    for ip in $(ip addr | sed -n '/inet/p' | sed -r '/inet6/d;s/brd.*|[a-z]*|\s+//g'); do
        ips[$count]=${ip%/*}
        echo "$count. ${ips[$count]}"
        count=$(($count + 1))
    done
    
    array_len=${#ips[*]}
    
    while :
    do
        read -p "如果上面有你想要的, 请输出序号; 如果没有, 输入[0]退出: " choise
        
        # echo $choise
        # echo $array_len
        if [ $choise -lt  $array_len ]; then
            result_ip=${ips[$choise]}
            break
        else
            echo "错误输入, 再次尝试: "
            continue
        fi
    done
}

# fastDFS 的文件配置
function config_fastDFS
{
    cd /etc/fdfs/
    if [ ! -d "template" ]; then 
        mkdir template
        mv *.sample ./template &> /dev/null
    fi

    echo yes | cp template/tracker.conf.sample ./tracker.conf &> /dev/null
    echo yes | cp template/storage.conf.sample ./storage.conf &> /dev/null
    echo yes | cp template/client.conf.sample ./client.conf &> /dev/null

    # 如果没能自动获取到ip, 那么需要用户手动输入
    if [ -z "$result_ip" ]; then
        read -p "Pls enter your host ip: " ip  # 获取本机 ip
    else
        echo $result_ip
        ip=$result_ip
    fi
    
    # 配置tracer.conf
    sed -i "/^bind_addr/c bind_addr=$ip" tracker.conf  # 绑定 ip
    sed -i "/^base_path/c base_path=$tracker_dir" tracker.conf  # 设置日志等数据路径
    # 配置storage
    sed -i "/^bind_addr/c bind_addr=$ip" storage.conf
    sed -i "/^base_path/c base_path=$storage_dir" storage.conf
    sed -i "/^store_path0/c store_path0=$storage_dir" storage.conf  # 设置存储路径
    sed -i "/^tracker_server/c tracker_server=$ip:22122" storage.conf  # 连接tracker_server
    # 配置客户端
    sed -i "/^base_path/c base_path=$client_dir" client.conf
    sed -i "/^tracker_server/c tracker_server=$ip:22122" client.conf
    
    cd - &> /dev/null
}

# 启动tracker, storage
function start_fastDFS
{
    echo "启动 tracker storage 服务..."
    fdfs_trackerd /etc/fdfs/tracker.conf
    fdfs_storaged /etc/fdfs/storage.conf
    echo "启动成功！"
}

# 主函数执行逻辑
is_installed "gcc"  # FastDFS 的安装环境必须有gcc支持
if [ $? -eq 0 ]; then
	yum install gcc
fi

is_installed "fdfs_test"  # 安装 libfastcommon，fastdfs
if [ $? -eq 0 ]; then
	# download_from_github "https://github.com/happyfish100/libfastcommon.git"
	# download_from_github "https://github.com/happyfish100/fastdfs.git"

	# 环境中需要有gcc
    cd ./package
    tar xzvf "libfastcommon.tar.gz"
	install "libfastcommon"
    tar xzvf "fastdfs.tar.gz"
	install "fastdfs"
    cd -
else
	print_format "FastDFS was installed successfully."
fi

mkdir_for_tsc
echo ""; echo "进入配置阶段..."
get_host_ip
config_fastDFS
start_fastDFS
