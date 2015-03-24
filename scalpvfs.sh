#!/bin/bash
#this is for scaling the pvfs2 system 
#args : $1 node will be added 
function usage()
{ 
   local  time=`date`
   echo $time
   echo "Use: ./saclpvfs2.sh  node(added node) "
}

if [ ! $1 ]; then
   usage 
   exit 1 
fi  
pvfs2_config=/etc/pvfs2-fs.conf
create_config=/etc/pvfs2-fs.conf.new
old_pvfs2_config=/etc/pvfs2-fs.conf.old
#step one:read config and add new alias in config 
old_alias=`awk '/Alias/  && /tcp/ {print $2}' $create_config`

./pvfs2-genconfig.sh  -s $1
for i in $old_alias
do
 scp $create_config  $i:$create_config
 PID=`ssh $i ps aux |grep pvfs2-server |grep -v grep | awk ' {print $2}'`
 ssh $i "kill  $PID"
 ssh $i pvfs2-server $create_config -a $i
 #reload config
done

 scp $create_config $1:$create_config
 PID=`ssh $1 ps aux |grep pvfs2-server |grep -v grep |awk '{print $2}'`
 ssh $1 "kill $PID"
 ssh $1 "rm -rf /pvfs2-storage-space"
 ssh $1 pvfs2-server -f $create_config -a $1
 ssh $1 pvfs2-server    $create_config -a $1

file=`pvfs2-ls /mnt/pvfs2/`

for eachfile in $file
do
   pvfs2-cp /mnt/pvfs2/$eachfile  /tmp/$eachfile
   pvfs2-rm /mnt/pvfs2/$eachfile
   pvfs2-cp /tmp/$eachfile  /mnt/pvfs2/$eachfile
   rm -rf  /tmp/$eachfile
done

# ssh $pvfs2_config $1:$pvfs2_config
# ssh $i "pvfs2-server -f $pvfs2_config -a $1"
# ssh $i "pvfs2-server  $pvfs2_config -a $1"
 
exit 0

#step two:the new node start pvfs2
#step three:call function in old nodes reload config
#step four:re set file 

