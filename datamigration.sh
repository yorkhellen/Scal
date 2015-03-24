#!/bin/bash
dir=`pwd`
recode=/tmp/dbasky/root
files=/mnt/pvfs2
config=/etc/pvfs2-fs.conf.new

result_recode=`ls $recode`
result_files=`pvfs2-ls $files`
old_alias=`awk '/Alias/ && /tcp/ {print $2}' $config`
echo $old_alias
host=`hostname`
for eachnode in $old_alias
do
   if (( $eachnode""x != $host""x)); then
      scp $eachnode "/usr/local/Scal/datamigration.sh"
   fi
done




