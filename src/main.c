#include "main.h"


int main(int argc, char** argv)
{
    int result;
    if (argc < 3) {
        my_usage();
        return 0;
    }

    if ((result=strcmp("upload", argv[1])) == 0) {
        // 上传
        if (argc != 3) goto notice;
        char file_id[1024] = {};
        upload(CLIENT_CONF, argv[2], file_id);
    } else if ((result=strcmp("download", argv[1])) == 0) {
        // 下载
        if (argc != 4) goto notice;
        download(CLIENT_CONF, argv[2], argv[3]);
    } else if ((result=strcmp("delete", argv[1])) == 0) {
        // 删除
        if (argc != 3) goto notice;
        delete_file(CLIENT_CONF, argv[2]);
    } else {
        goto notice;
    }
    return 0;

notice:
    puts("argument error");
    puts("");
    my_usage();
    return -1;
}

static void my_usage()
{
    puts("-------------------------------------");
    puts("app 用法测试 ");
    puts("-------------------------------------");
    puts("[upload]   [filename]");
    puts("");
    puts("[download] [fileID] [filename]");
    puts("");
    puts("[delete]   [fileID]");
    puts("-------------------------------------");
}
