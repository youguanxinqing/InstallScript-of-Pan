/*
 * @Author: Guan
 * @Github: https://github.com/youguanxinqing
 * @Date: 2019-05-05 08:20:10
 * @LastEditTime: 2019-05-05 10:18:18
 */

#ifndef __SQLAPI_H__
#define __SQLAPI_H__

#include <stdio.h>
#include <string.h>
#include <mysql/mysql.h>
#include "log.h"


#define SQL_DEBUG(fmt, x...) DEBUG("fdfs", "sqlapi", fmt, ##x)
#define SQL_INFO(fmt, x...) INFO("fdfs", "sqlapi", fmt, ##x)
#define SQL_ERROR(fmt, x...) ERROR("fdfs", "sqlapi", fmt, ##x)

typedef struct {
    int id;
    char filename[1024];
    char  fileid[1024];
} YOU_LINE_DATA;

void you_mysql_init(char* dbname, char* tablename);
MYSQL* you_connect(char* usernmae, \
                   char* password, char*dbname);
int you_findall(MYSQL* conn, \
                const char* sql, YOU_LINE_DATA* data);
int you_execute(MYSQL* conn, const char* sql);
void you_disconnect(MYSQL* conn);

#endif