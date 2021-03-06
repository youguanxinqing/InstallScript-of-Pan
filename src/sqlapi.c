/*
 * @Author: Guan
 * @Github: https://github.com/youguanxinqing
 * @Date: 2019-05-04 22:08:34
 * @LastEditTime: 2019-05-05 10:45:34
 */

#include "sqlapi.h"

/* 连接数据库 */
MYSQL* you_connect(char* username, \
                   char* password, char* dbname) {
    
    MYSQL *conn = NULL;
    conn = mysql_init(NULL);
    if ( conn == NULL ) {
        SQL_INFO("%s", "sql 连接失败");
        goto end;
    }
    mysql_real_connect(conn, "localhost", \
                       username, password, \
                       dbname, 0, NULL, 0);
end:
    return conn;
}

/******************
 *执行查询语句
 *成功 返回 非 0 数字
 *失败 返回 -1 
*******************/
int you_findall(MYSQL* conn, const char* sql, YOU_LINE_DATA* data) {
    
    int i = 0, count = 0;
    MYSQL_RES *result;
    MYSQL_ROW row;

    int res = mysql_query(conn, sql);  /* 执行sql */
    if (res != 0) {
        SQL_INFO("%s, sql: %s", "sql 可能存在问题", sql);
        return -1;
    }
    result = mysql_store_result(conn);  /* 存储 sql 结果 */
    int num_fields = mysql_num_fields(result);  /* 每一行有多少个域 */
    while ((row = mysql_fetch_row(result))) {  /* 取出每一行 */
        for(i = 0; i < num_fields; i++) {
            switch (i) {
            case 0: data[count].id = atoi(row[i]); break;
            case 1: strcpy(data[count].filename, row[i]); break;
            case 2: strcpy(data[count].fileid, row[i]); break;
            }
        }
       ++count;
    }
    mysql_free_result(result);
    SQL_INFO("%s", "findall 执行结束");
    return count;
}

/******************
 *执行 sql 语句
 *成功 返回 0
 *失败 返回 -1 
*******************/
int you_execute(MYSQL* conn,  const char* sql) {
    int res = mysql_query(conn, sql);
    if (res == 0) return 0;
    
    SQL_INFO("%s, sql: %s", "sql 可能存在问题", sql);
    return -1;
}

void you_disconnect(MYSQL* conn) {
    mysql_close(conn);
    SQL_INFO("%s", "释放 sql 连接");
}

void you_mysql_init(char* dbname, char* tablename) {
    
    SQL_INFO("%s", "数据库初始化");
    MYSQL* conn = you_connect("root", "123456", NULL);
    if (conn == NULL)
        SQL_INFO("%s", "数据库连接失败");

    SQL_INFO("%s", "创建数据库");
    int flag;
    char sql[1024*4] = {0};
    snprintf(sql, 1024, "create database %s charset=utf8", dbname);
    SQL_DEBUG("%s", sql);
    flag = you_execute(conn, sql);
    you_disconnect(conn);
    if (flag != 0)
        SQL_INFO("%s", "数据库创建失败, 也许这个数据库已经存在");

    SQL_INFO("%s", "创建数据表");
    conn = you_connect("root", "123456", dbname);
    memset(sql, 0, 1024);
    snprintf(sql, 1024*4, "create table %s(id int auto_increment primary key not null, "
                                          "filename varchar(1024) not null, "
                                          "fileid varchar(1024) not null)", tablename);
    flag = you_execute(conn, sql);
    if (flag != 0) {
        you_disconnect(conn);
        SQL_INFO("%s", "数据表创建失败, 也许这个数据表已经存在");
    }
}

/* usage1 */
// int main(int argc, char **argv)
// {
//     MYSQL *conn = you_connect("root", "123456", "guan");
//     if (conn == NULL) goto end;
  
//     YOU_LINE data[10] = {0};
//     int num = you_findall(conn, "select * from stu where age 9", data);
    
//     // you_insert(conn, "insert into stu values('he', 33)");

//     // int num = you_delete(conn, "delete from stu where name = 'he'");
//     // printf("%d\n", num);
    
//     you_disconnect(conn);  /* 释放连接 */

//     int  i = 0;
//     for (i = 0; i<num; i++) {
//         printf("%s %s\n", data[i].name, data[i].age);
//     }
//     return 0;

// end:
//     printf("%s\n", "error");
//     return -1;
// }

/* usage2 */
// int main(int argc, char** argv) {
//     init("youguan", "data");
//     SQL_DEBUG("%s", "完成数据库初始化");

//     MYSQL* conn = you_connect("root", "123456", "youguan");
//     YOU_LINE_DATA data[1024] = {0};
//     int num = you_findall(conn, "select * from data", data);
//     int i = 0;
//     for (i = 0; i < num; i++) {
//         printf("%d, %s, %s\n", data[i].id, data[i].filename, data[i].fileid);
//     }
// }