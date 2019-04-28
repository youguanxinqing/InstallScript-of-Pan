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
        if [[ ! $i =~ "lib" ]]; then
            rpm -e $i
        fi
    done
}


# 停止 nginx 服务，删除相关配置
# nginx -s stop; rm_nginx_related
# if [ $? -eq 0 ];then
#     print_format "uninstall nginx successfully."
# fi

# rm_openssl_related
# if [ $? -eq 0 ]; then
#     echo "removed openssl !"
# fi

uninstall_bzip2