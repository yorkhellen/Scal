#!/bin/bash
function nodeinfo ()
{
	dstat -rnl 20 45
}
function userinfo ()
{
local result_file=`pvfs2-ls /mnt/pvfs2`
local result_recode=`ls /tmp/dbasky/root `
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
	echo $(array[*])
exit 0
}

function main ()
{
	if (( $1""x == "-n"x )); then
         nodeinfo
	fi

	if (( $1""x == "-s"x )); then
		 userinfo
	fi
	exit 0
}
main $1
