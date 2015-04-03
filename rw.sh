#!/bin/bash
for (( i =1 ; i <900  ; i++ ))
do
 setsid   ./rrtest.sh  -r 60 -c /etc/pvfs2-fs.conf 
 setsid   ./rwtest.sh  -r 10  -c /etc/pvfs2-fs.conf 
 sleep 2
done


