#!/bin/bash
./pvfs2-genconfig.sh note02 note05 
scp /etc/pvfs2-fs.conf.new note02:/etc/pvfs2-fs.conf.new 
pid=`ps aux |grep pvfs2-server |grep -v  grep | awk '{print $2}'`
kill -s 9 $pid
pid=`ssh note02 "ps aux |grep pvfs2-server |grep -v grep |awk '{ print $2}' "`
ssh note02 "kill -s 9 $pid"

rm -rf /pvfs2-storage-space 
ssh note02 "rm -rf /pvfs2-storage-space"
pvfs2-server -f /etc/pvfs2-fs.conf.new -a note05
pvfs2-server  /etc/pvfs2-fs.conf.new -a note05


ssh note02 "pvfs2-server -f /etc/pvfs2-fs.conf.new -a note02"
ssh note02 "pvfs2-server    /etc/pvfs2-fs.conf.new -a note02"



