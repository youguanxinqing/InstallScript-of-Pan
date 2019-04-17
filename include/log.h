#ifndef __LOG_H__
#define __LOG_H__

#include <pthread.h>

#define ORDINARY_PERMISSION 0777

static int create_log_path(char *path, char *module_name, char *proc_name);
static int write_log(char* path, char* buf);
int usage(char* module_name, char* proc_name, const char* filename,
          int line, const char* funcname, char *fmt, ...);

#ifndef _LOG
#define LOG(module_name, proc_name, x...) \
            usage(module_name, proc_name, \
                  __FILE__, __LINE__, __FUNCTION__, ##x)
#else
#define LOG(module_name, proc_name, x...)
#endif

extern pthread_mutex_t lock;

#endif