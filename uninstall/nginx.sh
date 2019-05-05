###
 # @Author: Guan
 # @Github: https://github.com/youguanxinqing
 # @Date: 2019-04-28 21:16:11
 # @LastEditTime: 2019-04-28 21:21:56
###

. $(dirname 0)/../tools.lib

function rm_nginx_related()
{
    rm -rf /etc/sysconfig/nginx; rm -rf /etc/logrotate.d/nginx
    rm -rf /etc/nginx; rm -rf /var/log/nginx; rm -rf /var/cache/nginx
    rm -rf /usr/sbin/nginx*; rm -rf /usr/lib64/nginx; rm -rf /usr/bin/nginx
    rm -rf /usr/share/nginx; rm -rf /usr/local/nginx
    rm -rf /usr/libexec/initscripts/legacy-actions/ngin
}

function rm_openssl_related()
{
    rm -rf /usr/bin/openssl; rm -rf /usr/lib64/openssl
    rm -rf /usr/share/ruby/openssl
    rm -rf /etc/pki/ca-trust/extracted/openssl
}

function uninstall_bzip2()
{
    echo "start uninstall bzip2 ..."
    for i in $(rpm -qa |grep bzip2); do
        # 如果 'lib' 不在字符串 i 中
        if [[ ! "$i" =~ "lib" ]]; then
            rpm -e "$i"
        fi
    done
}

function uninstall_gcc_cpp()
{
    for i in $(rpm -qa|grep c++); do
        if [[ "$i" =~ "gcc" ]]; then 
            rpm -e $i
        fi
    done
}

function uninstall_others()
{
    cd ../package/nginx
    if [ -d "pcre" ]; then cd pcre; make uninstall; cd ..; fi
    if [ -d "zlib" ]; then cd zlib; make uninstall; cd ..; fi
    # 清除解压后的目录
    echo_note "current location: $(pwd)"
    rm fastdfs-nginx-module -rf
    rm pcre -rf
    rm nginx -rf 
    rm openssl -rf
    rm zlib -rf
    cd ../../uninstall
}


# 停止 nginx 服务，删除相关配置
if [ -x "$(command -v nginx)" ]; then systemctl stop nginx; fi
rm_nginx_related
if [ $? -eq 0 ];then echo_note "removed nginx !"; fi

rm_openssl_related
if [ $? -eq 0 ]; then echo_note "removed openssl !"; fi

uninstall_gcc_cpp
if [ $? -eq 0 ]; then echo_note "removed c++ !"; fi

uninstall_bzip2
if [ $? -eq 0 ]; then echo_note "remove bzip2 !"; fi

uninstall_others
if [ $? -eq 0 ]; then echo_note "removed zlib、pcre !"; fi

cd ../package/nginx
echo yes| rm -r nginx openssl zlib pcre
print_format "uninstall nginx successfully."