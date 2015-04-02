#!/bin/bash
readcom=/usr/local/Scal/rwtest.sh
writecom=/usr/local/Scal/write
rreadcom=/usr/local/Scal/rread
command=
function usage ()
{
  echo $'name rw.sh  for test the pvfs read write performance
usage:       rw.sh [opts]  
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

  command=$command""" /usr/local/Scal/rwtest.sh -r $eachcount \""

echo "#!/bin/bash " >rwtmp.sh
echo $command  >>rwtmp.sh
chmod a+x rwtmp.sh
./rwtmp.sh
rm -rf ./rwtmp.sh
