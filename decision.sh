#!/bin/bash
#step collect data from old alias 
#step sort and find
function Uses ()
{
	echo  "Use:  ./decision.sh  configuration_file"
	echo  "Use:  eg: ./decision.sh /etc/pvfs2-fs.conf"
	exit 0
}
function main()
{
	if (( $1 )); then

    local alias=awk '/Alias/ && /tcp/ {print $2} ' $1
	local host=`hostname`
	local i=0
		for node in $alias
		do 
			
			if (( $node""x == $host""x )); then
			note[$i]  scp $node   datamigration.sh -n
			count[$i] scp $node   datamigration.sh -c
			$i=$[$i+1]
			fi
		done
	   local filesize=`pvfs2-ls -lh /mnt/pvfs2 | awk '{print $5}'`
	   local filename=`pvfs2-ls -lh /mnt/pvfs2 | awk '{print $8}'`
	   #  get count filename filesize and node args
	   local x=0
	   for eachfile in filename
	   do
		   filecount[$x]=0
		   x=$[$x+1]
	   done
        

	   for eachcount in $count
	   do  
	    for (( node=0 ; node <= $x ; node++ ))
		do
				filecount[$x]=$[$(filecount[$x])+$eachcount[$node]]
		done
       done
    exit 0
	fi 
	exit 0    

}
function migration () 
{
   
    for eachfile in $@
	do

		if (( $eachfile )); then
		pvfs2-cp /mnt/pvfs2""$eachfile  /tmp/""$eachfile
		pvfs2-rm /mnt/pvfs2""$eachfile
		pvfs2-cp /tmp/""$eachfile /mnt/pvfs2""$eachfile
	    rm -rf /tmp/""$eachfile
		fi
	done
  exit 0 
}
main $1
