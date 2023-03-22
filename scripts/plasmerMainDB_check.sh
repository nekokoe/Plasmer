#!/usr/bin/bash

while read line
do
    if [ ! -s "$(dirname $1)/$line" ];then
		echo "$(dirname $1)/$line is not found or empty!"
	fi
done < $1
