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
  command=$command""" ssh $eachnode "

  command=$command""" \"  $readcom /mnt/pvfs2/test""$[$RANDOM % 30]"

  for (( c = 1 ; c <= $[$parall-2] ; c++  ))
   do
    command=$command""" & $readcom /mnt/pvfs2/test""$[$RANDOM% 30] "
   done
  command=$command""" & $readcom /mnt/pvfs2/test""$[$RANDOM% 30] \" "
 
done

echo "#!/bin/bash" >tmp.sh
echo $command >>tmp.sh
chmod a+x tmp.sh
./tmp.sh
rm -rf ./tmp.sh

