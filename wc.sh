#!/bin/bash
results=`ls /usr/local/Scal/tmp/ `
for file in $results
do
  count=`awk '{print $6}' /usr/local/Scal/tmp/""$file`

done
