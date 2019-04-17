#include <stdio.h>
#include "log.h"

int main()
{
    char str[1024] = {"test a log"};
    LOG("毕设", "管易鑫", "info: %s", str);
    return 0;
}

