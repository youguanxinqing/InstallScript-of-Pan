###
 # @Author: Guan
 # @Github: https://github.com/youguanxinqing
 # @Date: 2019-05-01 17:22:21
 # @LastEditTime: 2019-05-01 17:22:28
###

. $(dirname 0)/../tools.lib

function find_libfcgi()
{
    path_arry=("/usr/local/lib" "/usr/local/lib64" "/usr/lib" "/usr/lib64")
    for i in $path_arry; do
        local rlt=$(find $i -name libfcgi.so | wc -l)
        if [ $rlt -eq 1 ]; then
            is_in_libconfig $i
            if [ $? -eq 0 ]; then append_libconfig $i; fi
            ldconfig
            return 1
        fi
    done

    return 0
}

function append_libconfig()
{
    sed -i "1a $1" /etc/ld.so.conf
}

# 存在返回 1； 不存在返回 0
function is_in_libconfig()
{
    rlt=$(grep $1 /etc/ld.so.conf | wc -l)
    if [ $rlt -eq 0 ]; then
        return 0
    fi
    return 1
}

is_installed "nginx"
if [ $? -eq 0 ]; then
    echo_error "stop working, pls install nginx firstly."
    exit
fi

is_installed "spawn-fcgi"
if [ $? -eq 0 ]; then
    echo_error "sto working, pls install spawn-fcgi firstly."
    exit
fi

if [ ! -d "../package/fastcgi/fcgi-2.4.1-SNAP-0910052249" ]; then
    echo_error "no src code can be compiled."
    exit
fi

find_libfcgi
if [ $? -eq 0 ]; then
    echo_error "no libfcgi.so, pls install fastcgi."
    exit
fi

# testfcgi 的编译与安装
cd ../package/fastcgi/fcgi-2.4.1-SNAP-0910052249/examples
gcc -o testfcgi echo.c -lfcgi
bin_dir="/opt/YouGuan/bin"
if [ ! -d $bin_dir ]; then mkdir -p $bin_dir; fi
cp ./testfcgi $bin_dir -rf
ps -ef | grep testfcgi | grep -v grep | awk '{print "kill -9 " $2}' | sh
spawn-fcgi -a 127.0.0.1 -p 9001 -f $bin_dir/testfcgi
if [ $? -ne 0 ]; then
    echo_error "start program 'testfcgi' failed!"
    exit
fi
echo_note "start program 'testfcgi' successfully."
cd -

# nginx.conf 的设置
append_nginxconfig '\ \ \ \ \ \ \ \ location /test.html {\n            root html;\n            index test.html;\n        }\n'
append_nginxconfig '\ \ \ \ \ \ \ \ location /testfcgi {\n            fastcgi_pass 127.0.0.1:9001;\n            include fastcgi.conf;\n        }\n'
cp ../static/html/test.html /usr/local/nginx/html/ -rf
nginx -s reload
if [ $? == 0 ]; then
    print_format "config 'testfcgi' program successfully."
else
    print_format "sorry, any errors occurred."
fi


# zyFile2 的相关设置
append_nginxconfig '\ \ \ \ \ \ \ \ location /zyFile2/ {\n            root html;\n            index demo.html;\n        }\n'
cd ../static/html; tar xzvf zyFile2.tar.gz
rm /usr/local/nginx/html/zyFile2 -rf
cp zyFile2 /usr/local/nginx/html -rf
nginx -s reload
if [ $? -eq 0 ]; then
    print_format "config web successfully."
else
    print_format "sorry, any errors occurred to web"
fi
cd -

# you_upload 配置
append_nginxconfig '\ \ \ \ \ \ \ \ location /you_upload {\n            fastcgi_pass 127.0.0.1:9002;\n            include fastcgi.conf;\n        }\n'
cd ..; make clean; make
cp bin/you_upload /opt/YouGuan/bin -rf
nginx -s reload
cd /opt/YouGuan/bin
ps -ef | grep you_upload | grep -v grep | awk '{print "kill -9 " $2}' | sh
spawn-fcgi -a 127.0.0.1 -p 9002 -f ./you_upload
if [ $? -eq 0 ]; then
    print_format "start you_upload successfully."
else
    print_format "sorry, start you_upload failed."
fi
cd -