#!/bin/bash

# 格式化输出
function print_format
{
	local symbol
	local blank
	strlen=$((`expr length "$1"` + 2))
	for((i=0;i<strlen;i++))
	do
		symbol="$symbol-"
		blank="$blank "
	done
	
	echo "$symbol--"
	echo "|$blank|"
	echo "| $1 |"
	echo "|$blank|"
	echo "$symbol--"
}

# 第一步：下载libfastcommon和fastcommon
function download_from_github
{
	git clone $1
	if [ $? -eq 0 ]
	then
		print_format "Download libfastcommon successfully."
	else
 		print_format "Download libfastcommon failed!!!"
	fi
}

# 第二步：编译并安装
function install
{
	echo "Start install $1..."
	cd $1
	./make.sh &> /dev/null
	if [ $? -ne 0 ]
	then
		print_format "Install $1 failed!!!"
		exit 0
	fi
	
	./make.sh install &> /dev/null
	if [ $? -eq 0 ]
	then
		print_format "Install $1 successfully."
	else
		print_format "Install $1 failed!!!"
		exit 0
	fi
	cd ..
}

# 主函数执行逻辑
download_from_github "https://github.com/happyfish100/libfastcommon.git"
download_from_github "https://github.com/happyfish100/fastdfs.git"

# 环境中需要有gcc
install "libfastcommon"
install "fastdfs"
