#!/bin/bash
#
. $(dirname $0)/tools.lib

ps -ef | grep redis | grep -v grep | awk '{print "kill -9 " $2}' | sh
rm /usr/local/bin/redis-* -rf
rm /opt/redis/ -rf
print_format "Uninstall Redis Successfully"
