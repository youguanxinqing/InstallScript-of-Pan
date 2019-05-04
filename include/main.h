#ifndef __MAIN_H__
#define __MAIN_H__

#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include "fcgi_config.h"
#include "fcgi_stdio.h"
#include "upload.h"
#include "log.h"

#define CLIENT_CONF "/etc/fdfs/client.conf"

#define MA_DEBUG(fmt, x...) DEBUG("fdfs", "main", fmt, ##x)
#define MA_INFO(fmt, x...) INFO("fdfs", "main", fmt, ##x)
#define MA_ERROR(fmt, x...) ERROR("fdfs", "main", fmt, ##x)

// static void my_usage();

static int extract_data_and_save(char* begin, \
                                 char* end, \
                                 int len, \
                                 char* filename);

static char* get_pointer_of_border(char* content, \
                                   int len, \
                                   char* boundary);


#endif