###
 # @Author: Guan
 # @Github: https://github.com/youguanxinqing
 # @Date: 2019-04-28 21:29:10
 # @LastEditTime: 2019-04-28 21:29:50
###

. $(dirname $0)/../tools.lib

function install_nginx()
{
    cd ../package/nginx; tar xzvf nginx.tar.gz; cd nginx
    ./configure; make; make install
    ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
    cd ../../../install
}

function open_port()
{
    zones_name=$(printf `firewall-cmd --get-active-zones`)
    answer=$(firewall-cmd --query-port=$1/tcp)
    if [ "$answer" == "no" ]; then
        firewall-cmd --zone=$zones_name --add-port=$1/tcp --permanent
        firewall-cmd --reload 
    fi
    
    # firewall-cmd --remove-port=80/tcp --permanent  关闭端口，测试语句
}

function install_bzip2()
{
    echo "start install bzip2 ... "
    cd ../package/nginx
    rpm -ivh bzip2-devel-1.0.6-13.el7.x86_64.rpm
    rpm -ivh bzip2-1.0.6-13.el7.x86_64.rpm
    cd -
}

function install_gcc_cpp()
{
    echo "start install gcc ... "
    cd ../package/nginx
    rpm -ivh gcc-c++-4.8.5-36.el7_6.1.x86_64.rpm
    cd -
}

function install_pcre()
{
    echo "start install pcre ... "
    cd ../package/nginx; tar xzvf pcre.tar.gz
    cd pcre; ./configure; make; make install
    cd ../../../install
}

function install_openssl()
{
    echo "start install openssl ... "
    cd ../package/nginx; tar xzvf openssl.tar.gz
    cd openssl; ./config; make
    cd ../../../install
}

function install_zlib()
{
    echo "start install zlib ... "
    cd ../package/nginx; tar xzvf zlib.tar.gz
    cd zlib; ./configure; make; make install
    cd ../../../install
}

# 主逻辑
is_installed "bzip2"
if [ $? -eq 0 ]; then install_bzip2; fi

is_installed "g++"
if [ $? -eq 0 ]; then install_gcc_cpp; fi

install_openssl; install_pcre; install_zlib

is_installed "nginx"
if [ $? -eq 0 ]; then
    install_nginx; open_port 80; /usr/local/nginx/sbin/nginx
fi

print_format "install nginx successfully !"
