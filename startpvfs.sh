#/bin/bash
cfg=/etc/pvfs2-fs.conf
storage=`awk '/StorageSpace/ {print  $2} ' $cfg`
for (( i = 0 ; i <= 30 ; i ++ )) 
do
  pvfs2-cp ../house.rmvb  /mnt/pvfs2/test""$i
  echo "$i done"
done


