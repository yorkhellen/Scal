#!/bin/bash
for (( i = 0 ; i < 360 ; i++ ))
do
 setsid ./rwtest.sh  -r 30 -c /etc/pvfs2-fs.conf.new
 sleep 1
done
