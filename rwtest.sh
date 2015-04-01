#!/bin/bash
readcom=/usr/local/Scal/read
writecom=/usr/local/Scal/write
rreadcom=/usr/local/Scal/rread
command=
function usage ()
{
  echo $'name rwtest.sh  for test the pvfs read write performance
usage:       rwtest.sh [opts]  
opts: 
	-r    read client num
        -w    write client num
        -d    random read client num
	-h    show this menu '
 exit 0
}
while getopts :r:w:d:h opt
do
  case "$opt" in
  r) numofread=$OPTARG    ;;
  w) numofwrite=$OPTARG   ;;
  d) numofrread=$OPTARG   ;;
  h) usage   
     exit 0    ;;
  *) usage 
     exit 0    ;;
  esac
done


nodes=`awk '/Alias/ && /tcp/ {print $2}' /etc/pvfs2-fs.conf.new`
echo $nodes

i=0
for iter in $nodes
do
   i=$[$i+1]
done

parall=$[$[$numofread/$i]]
for eachnode in $nodes
do
  command=$command""" & ssh $eachnode "
  command=$command""" \"  $readcom /mnt/pvfs2/test""$[$RANDOM % 30]"
  for (( c = 1 ; c <= $parall ; c++  ))
   do
    command=$command""" & $readcom /mnt/pvfs2/test""$[$RANDOM% 30] "
   done
  command=$command""" & $readcom /mnt/pvfs2/test""$[$RANDOM% 30] \" " 
done

echo $command
#parall=$[$totalnum/$i+1]
#for eachnode in $nodes
#do
#  command=$command""" & ssh $eachnode "
##  for (( c=1; c<=$parall ; c++ ))
#   do
#    command=$command""" & $readcom /mnt/pvfs2/test""rand"
#   done 
#done
#parall=$[$totalnum/$i+1]
##for eachnode in $nodes
#do
#  command=$command""" & ssh $eachnode "
#  for (( c=1; c<=$parall ; c++ ))
#   do
#    command=$command""" & $readcom /mnt/pvfs2/test""rand"
#   done 
#done


