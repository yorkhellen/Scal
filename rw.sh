#!/bin/bash
for (( i =1 ; i <900  ; i++ ))
do
 setsid   ./rrtest.sh  -r 500 -c /etc/pvfs2-fs.conf 
 setsid   ./rwtest.sh  -r 5  -c /etc/pvfs2-fs.conf 
 sleep 2
done


