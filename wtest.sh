#!/bin/bash
readcom=/usr/local/Scal/write
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
while getopts :r:w:d:hc: opt
do
  case "$opt" in
  r) numofread=$OPTARG    ;;
  w) numofwrite=$OPTARG   ;;
  d) numofrread=$OPTARG   ;;
  c) etc=$OPTARG          ;;
  h) usage   
     exit 0    ;;
  *) usage 
     exit 0    ;;
  esac
done


nodes=`awk '/Alias/ && /tcp/ {print $2}' $etc`

i=0

for iter in $nodes
do
   i=$[$i+1]
done


parall=$[$numofread / $i]

flag=0

for eachnode in $nodes
do

  if [[ 0 -ne $flag ]]; then
  command=$command""" & "
  fi

  flag=1
   i=$[$RANDOM %30]
  command=$command""" ssh $eachnode "
  
  command=$command""" \"  $readcom /mnt/pvfs2/test""$i /mnt/pvfs2/test""$i"

  for (( c = 1 ; c <= $[$parall-2] ; c++  ))
 
 
   do
   i=$[$RANDOM %30]
      command=$command""" & $readcom /mnt/pvfs2/test""$i  /mnt/pvfs2/test""$i "
   done
  i=$[$RANDOM %30]
  command=$command""" & $readcom /mnt/pvfs2/test""$i /mnt/pvfs2/test""$i \" "
 
done
d=`date "+%Y-%m-%d+%H:%M:%S" `
echo "#!/bin/bash" >./run/$d""_write""$numofread"".sh
echo $command >>./run/$d""_write""$numofread"".sh
chmod a+x  ./run/$d""_write""$numofread"".sh
./run/$d""_write""$numofread"".sh  >  ./result/$d""_write""$numofread
rm -rf ./run/$d""_write""$numofread"".sh

