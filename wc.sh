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
