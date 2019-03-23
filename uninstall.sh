#!/bin/bash
#

echo "yes" | yum remove gcc &> /dev/null
if [ $? -eq 0 ]
then 
	echo "Uninstalled gcc successfully."
else
	echo "Uninstalled gcc failed!!!"
fi
