#!/bin/bash
function nodeinfo ()
{
	dstat -rnl 20 45 > /tmp/minotor
        cat /tmp/minotor
}
function userinfo ()
{
local result_file=`pvfs2-ls /mnt/pvfs2`
#echo $result_file
local result_recode=`ls /tmp/dbasky/root`
#echo $result_recode
local i=0
	for eachfile in $result_files
	do
		sum=0;
		for eachrecode in $result_recode
		do
			 sum=$[$sum+`awk -v RS='/mnt/pvfs2/$eachfile' 'END {print --NR}' /tmp/dbasky/root/""$eachrecode`]
		done
		array[$i]=$sum
		i=$[$i+1]
	done
	echo ${array[@]}
exit 0
}

function main ()
{
echo $1
	if [[ "$1"x = "-n"x ]]; then
           nodeinfo
	fi

	if [[ "$1"x = "-s"x ]]; then
           echo "in userinfo"
           userinfo
	fi
	exit 0
}
function Use ()
{
 echo "Use datamigration.sh -s or -n"
 echo "Use -s for user info"
 echo "Use -n for node info"
 exit 0
}
if ((  $# < 1 )); then
  Use
fi 
main $1
