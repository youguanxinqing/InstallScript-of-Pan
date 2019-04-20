#ifndef __LOG_H__
#define __LOG_H__

#include <pthread.h>

#define ORDINARY_PERMISSION 0777

extern pthread_mutex_t lock;

static int create_log_path(char *path, char *module_name, char *proc_name);
static int write_log(char* path, char* buf);
int usage(char* kind, char* module_name, char* proc_name, const char* filename,
          int line, const char* funcname, char *fmt, ...);

// #define FILE_LOG  // 日志输出 或是 标准输出 开关
#ifdef FILE_LOG
#define NEED_DEBUG 1
#define INFO(module_name, proc_name, x...) \
            usage("info", module_name, proc_name, \
                  __FILE__, __LINE__, __FUNCTION__, ##x)

#define DEBUG(module_name, proc_name, x...) \
            usage("debug", module_name, proc_name, \
                  __FILE__, __LINE__, __FUNCTION__, ##x)

#define ERROR(module_name, proc_name, x...) \
            usage("error", module_name, proc_name, \
                  __FILE__, __LINE__, __FUNCTION__, ##x)
#else
#pragma message "You don't enable file log."
#include <stdarg.h>
#define INFO(module_name, proc_name, fmt, ...) \
            printf("[info] %s %s-%s[%d]: " fmt "\n", \
                   __TIME__, __FILE__, __FUNCTION__, \
                   __LINE__, __VA_ARGS__)

#define DEBUG(module_name, proc_name, fmt, ...) \
            printf("[debug] %s %s-%s[%d]: " fmt "\n", \
                   __TIME__, __FILE__, __FUNCTION__, \
                   __LINE__, __VA_ARGS__)

#define ERROR(module_name, proc_name, fmt, ...) \
            printf("[error] %s %s-%s[%d]: " fmt "\n", \
                   __TIME__, __FILE__, __FUNCTION__, \
                   __LINE__, __VA_ARGS__)

#endif
#endif