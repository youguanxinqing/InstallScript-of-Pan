###
 # @Author: Guan
 # @Github: https://github.com/youguanxinqing
 # @Date: 2019-05-01 08:50:27
 # @LastEditTime: 2019-05-01 08:50:41
###

. $(dirname 0)/../tools.lib

function uninstall_fastcgi()
{
    local dirname="fcgi-2.4.1-SNAP-0910052249"
    cd ../package/fastcgi/$dirname
    make uninstall; make clean
    cd ..; rm $dirname -rf
    cd ../../uninstall
}

function uninstall_spawn_fcgi()
{
    pwd
    local dirname="spawn-fcgi"
    cd ../package/fastcgi/$dirname
    make uninstall; make clean
    cd ..; rm $dirname -rf
    cd ../../uninstall
}

function stop_subprocess()
{
    local some_pro=$1
    for i in ${some_pro[*]}; do
        echo $i
        ps -ef | grep $i | grep -v grep | awk '{print "kill -9 " $2}' | sh
    done
}


# 停止所有 fastcgi 进程
processes=("fastcgi" "you_upload")
stop_subprocess "${processes[*]}"  # 传入数组的方式

flag1=0; flag2=0
uninstall_fastcgi
if [ $? -eq 0 ]; then
    flag1=1
    echo_note "uninstall fastcgi successfully."
else
    echo_error "uninstall fastcgi fail."
fi

uninstall_spawn_fcgi
if [ $? -eq 0 ]; then
    flag2=1
    echo_note "uninstall spwan-fcgi successfully."
else
    echo_error "uninstall spwan-fcgi fail."
fi

if [ $flag1 -eq 1 ] && [ $flag2 -eq 1 ]; then
    print_format "uninstall fcgi successfully."
fi