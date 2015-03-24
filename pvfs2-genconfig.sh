#!/bin/bash
#create pvfs2 config
pvfs2_config=/etc/pvfs2-fs.conf
gencfg=/etc/pvfs2-fs.conf.new
function  addnode() {
    local i=0
    local old_node=`awk '/Alias/ && /tcp/ {print $2}' $gencfg`
    for iter in $old_node
    do
      # echo $iter
       i=$[$i+1]
    done
    # echo $i
      
    sed -e "22a\        Alias $1 tcp://$1:3334"  \
        -e "$[$i+30]a\                Range $1 $[2*$i+1]000000000000000001-$[2*$i+2]000000000000000000 " \
        -e "$[32+$i*2]a\                Range $1 $[2*$i+2]000000000000000001-$[2*$i+3]000000000000000000" $gencfg   >$gencfg"".tmp
    mv $gencfg  $gencfg"".old
    mv $gencfg"".tmp $gencfg
    
      
   # sed -e '22a\ Alias $i tcp://3334'
}

if [ "$1"x = "-s"x ]; then
   if [ $2 ]; then
   addnode  $2
   exit 0
   fi
   echo "please input node added"
   exit 0
fi

cat baseconfig  >$gencfg
echo "<Aliases>" >> $gencfg

   for i in $@ 
   do
      echo 	"        Alias $i tcp://"$i""":3334" >> $gencfg
   done
echo "</Aliases>" >> $gencfg
echo >> $gencfg

echo $'<Filesystem> 
	Name pvfs2-fs 
	ID 854477929 
	RootHandle 1048576000000000000
	FileStuffing yes 
	<MetaHandleRanges>'  >>$gencfg

        i=0
	for iter  in $@
        do	
          i=$[$i+1] 
          echo "                Range """$iter ""$i""000000000000000001-""$[$i+1]""000000000000000000 >> $gencfg
        done
echo  $'        </MetaHandleRanges>  
	<DataHandleRanges>' >> $gencfg 
        for iter in $@
        do
         i=$[$i+1] 
          echo "                Range """$iter ""$i""000000000000000001-""$[$i+1]""000000000000000000 >> $gencfg
        done
echo   $'        </DataHandleRanges>        
	<StorageHints>              
		TroveSyncMeta yes  
		TroveSyncData no    
		TroveMethod alt-aio
	</StorageHints>             
</Filesystem>'                      >>$gencfg     
exit 0                  
