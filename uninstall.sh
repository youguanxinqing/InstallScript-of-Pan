#!/bin/bash
#

. $(dirname $0)/tools.lib

echo "yes" | yum remove gcc &> /dev/null
if [ $? -eq 0 ]
then 
	echo "Uninstalled gcc successfully."
else
	echo "Uninstalled gcc failed!!!"
fi

print_format "gcc 卸载成功"
