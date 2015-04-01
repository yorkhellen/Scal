#!/bin/bash

function main ()
{
    if [[ $1 && $2 ]]; then

    if [[ "$1"x = "-s"x ]]; then
      addnode $2
      exit 0
    fi

    if [[ "$1"x = "-g"x ]]; then
      genconfig $2
      #pvfs_start $2
      exit 0 
    fi

    fi

    usage

    exit 0
}

function  addnode() {
   # create new config
    local i=0
    local old_node=`awk '/Alias/ && /tcp/ {print $2}' $1`
    local storage=`awk '/StorageSpace/ {print $2}' $1`
    read -p "please input the node you want add:" new_node
    for iter in $old_node
    do
      # echo $iter
       i=$[$i+1]
    done
    # echo $i
      
    sed -e "22a\        Alias $new_node tcp://$new_node:3334"  \
        -e "$[$i+30]a\                Range $new_node $[2*$i+1]000000000000000001-$[2*$i+2]000000000000000000 " \
        -e "$[32+$i*2]a\                Range $new_node $[2*$i+2]000000000000000001-$[2*$i+3]000000000000000000" $1   >$1"".tmp
    mv $1  $1"".old
    mv $1"".tmp $1
    rm -f $1"".old
  # restart pvfs2-server 

    for eachnode in $old_node
    do
        ssh $eachnode "killall pvfs2-server"
        ssh $eachnode "pvfs2-server $1 -a $eachnode" 
    done
    ssh $new_node "rm -rf $storage"
    ssh $new_node "killall pvfs2-server"
    ssh $new_node "pvfs2-server -f $1 -a $new_node"
    ssh $new_node "pvfs2-server $1 -a $new_node"
}


function usage()
{ 
   local  time=`date`
   echo $time
   echo "two args s or g"
   echo "Use: ./Saclpvfs2.sh  -s configuration_file "
   echo "Use: ./Scalpvfs2.sh  -g configuration_file"
}
function genconfig()
{
 echo --------------------------------------------------------------
 echo         Welcome to the PVFS2 Configuration Generator:
 echo         We all use default settings
 echo --------------------------------------------------------------
 read -p "please input the nodes:(such as node1 node2)" nodes
 
 if [[ $1 ]]; then
    baseconfig $1
    for i in $nodes
    do
       echo "       Alias $i tcp://"$i""":3334" >> $1     
    done   
    echo "</Aliases>" >> $1

    echo >> $1

    echo $'<Filesystem>
         Name pvfs2-fs
         ID 854477929
         RootHandle 1048576000000000000
         FileStuffing yes
         <MetaHandleRanges>' >> $1
            
            local i=0
            for eachnode in $nodes
            do
              i=$[$i+1]
              echo "                Range """$eachnode ""$i""000000000000000001-""$[$i+1]""000000000000000000 >> $1
            done
echo  $'         </MetaHandleRanges>
         <DataHandleRanges>' >> $1
             for eachnode in $nodes
             do
             i=$[$i+1]
               echo "               Range """$eachnode ""$i""000000000000000001-""$[$i+1]""000000000000000000 >> $1
             done
echo   $'         </DataHandleRanges>
         <StorageHints>
                  TroveSyncMeta yes
                  TroveSyncData no
                  TroveMethod  alt-aio
         </StorageHints>
</FileSystem>'                          >>$1                   

 fi 
}
function baseconfig ()
{
 echo $'<Defaults>
        UnexpectedRequests 50
        EventLogging none
        EnableTracing no
        LogStamp datetime
        BMIModules bmi_tcp
        FlowModules flowproto_multiqueue
        PerfUpdateInterval 1000
        ServerJobBMITimeoutSecs 30
        ServerJobFlowTimeoutSecs 30
        ClientJobBMITimeoutSecs 300
        ClientJobFlowTimeoutSecs 300
        ClientRetryLimit 5
        ClientRetryDelayMilliSecs 2000
        PrecreateBatchSize 512
        PrecreateLowThreshold 256
 
        StorageSpace /pvfs2-storage-space
        LogFile /tmp/pvfs2-server.log
</Defaults>
        
<Aliases>' > $1
}

function pvfs_start () 
{
 if (( $1 )); then
  local alias=`awk '/alias/ && /tcp/ {print $2}' $1`
  local pvfs2_storage=`awk '/StorageSpace/ {print $2}' $1`

  for i in $alias
  do
    scp $1 $i:$1
    ssh $i pvfs2-server $1 -a $i
  done
  fi
}

main $1 $2 
