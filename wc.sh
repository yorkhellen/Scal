#!/bin/bash
results=`ls /usr/local/Scal/result `
for file in $results
do
  echo "$file"
  count=`awk '{print $7}' /usr/local/Scal/result/""$file`
  total=0
  i=0
  for speed in $count
  do
    total=$(echo "$total+$speed" | bc)
    i=$[$i+1]
  done
  
  echo " $i   $total"
  echo 
done
:<<tip
 result =`ls /usr/local/Scal/result`
 for file in $result
 do 
   echo $file
   times=`awk '{print $5}' /usr/local/Scal/result/""$file`
   size=`echo $times |wc -l`
   max=`echo $times |sort -g -r`
   speed=$( echo $size*1126 /${max[0]}| bc)
   echo $i   $speed
 done
tip
