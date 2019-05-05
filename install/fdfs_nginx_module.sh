###
 # @Author: Guan
 # @Github: https://github.com/youguanxinqing
 # @Date: 2019-05-05 18:50:37
 # @LastEditTime: 2019-05-05 18:52:23
###

. $(dirname 0)/../tools.lib

echo_note "配置并编译 fastdfs-nginx-module"
filename="fastdfs-nginx-module"
cd ../package/nginx
tar xzvf $filename.tar.gz
abs_path=$(pwd)/$filename/src
cd nginx  # package/nginx/nginx
./configure --add-module=$abs_path; 
sed -i "/^ALL_INCS/a \ \ \ \ -I /usr/include/fastdfs youguan_end\n    -I /usr/include/fastcommon youguan_end" objs/Makefile
sed -ir "s/youguan_end/\\\/g" objs/Makefile
make; make install

echo_note "拷贝 mime.types http.conf mod_fastdfs.conf 到 /etc/fdfs"
cp ./conf/mime.types /etc/fdfs/ -rf  # nginx/conf/mime.types
cp ../../fastdfs/conf/http.conf /etc/fdfs/ -rf  # fastdfs/conf/http.conf
cp ../fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/ -rf  # fastdfs-nginx-module/src/mod_fastdfs.conf

# mod_fastdfs.conf 需要修改的地方
echo_note "配置 mod_fastdfs.conf"
cd /etc/fdfs
file="mod_fastdfs.conf"
storage_conf_path="/opt/YouGuan/fastDFS/storage"
tracker_server=$(grep -e "^tracker_server" /etc/fdfs/storage.conf)
sed -i "/^base_path/c base_path=$storage_conf_path" $file
sed -i "/^tracker_server/c $tracker_server" $file
sed -i "/^url_have_group_name/c url_have_group_name = true" $file
sed -i "/^store_path0/c store_path0=$storage_conf_path" $file
sed -i "/^group_count/c group_count = 1" $file
groupinfo="\\\n[group1]\ngroup_name=group1\nstorage_server_port=23000\nstore_path_count=1\nstore_path0=$storage_conf_path"
sed -i "/^group_count/a $groupinfo" $file
cd -; cd ../../../install

echo_note "配置 nginx.conf 并重启 nginx"
need_cp_config="no need"
res=$(grep "group1/M00" /usr/local/nginx/conf/nginx.conf | wc -l)
if [ $res -eq 0 ]; then
    append_nginxconfig "\ \ \ \ \ \ \ \ location /group1/M00 {\n            root $storage_conf_path/data;\n            ngx_fastdfs_module;\n        }\n"
fi
systemctl restart nginx
if [ $? -eq 0 ]; then
    print_format "fdfs_nginx_module successfully."
else
    echo_error "there some errors, pls read error.log of nginx"
fi
