###
 # @Author: Guan
 # @Github: https://github.com/youguanxinqing
 # @Date: 2019-05-01 08:18:04
 # @LastEditTime: 2019-05-01 08:18:22
###

. $(dirname 0)/../tools.lib


function install_fastcgi()
{
    local dirname="fcgi-2.4.1-SNAP-0910052249"
    cd ../package/fastcgi
    tar xzvf $dirname.tar.gz; cd $dirname
    # 确保编译时不报 EOF 错误
    sed -i "26a #include <stdio.h>" libfcgi/fcgio.cpp
    ./configure; make; make install
    cd ../../../install
}

function install_spawn_fcgi()
{
    local dirname="spawn-fcgi"
    cd ../package/fastcgi
    tar xzvf $dirname.tar.gz; cd $dirname
    ./configure; make; make install
    cd ../../../install
}


# 主逻辑
flag1=0; flag2=0
install_fastcgi
if [ $? -eq 0 ]; then
    echo_note "install fastcgi successfully."
    flag1=1
else
    echo_note "install fastcgi error."
fi

install_spawn_fcgi
if [ $? -eq 0 ]; then
    echo_note "install spawn-fcgi successfully."
    flag2=1
else
    echo_note "install spawn-fcg error."
fi

if [ $flag1 -eq 1 ] && [ $flag2 -eq 1 ]; then
    print_format "install fcgi successfully."
fi
