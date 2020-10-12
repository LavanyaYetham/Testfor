#!/usr/bin/bash

echo "server_IP,server_status,Ram_Usage,Process_List" > ram_usage.csv

for line in `cat inputs.csv`
do
    n=`echo $line | awk -F"," '{print $1}'`
    echo $n
    m=`echo $line |awk -F"," '{print $2}'`
    echo $m
    if [ -z $m ]
    then
        m=3
    fi
    ping -c 1 $n >/dev/null
    PingResult=`echo $?`
    if [ $PingResult -eq 0 ]
    then
        serverstatus="Rechable"
    else
        serverstatus="Unrechable"
    fi
    Memory=`ssh root@$n "free -m "|grep "Mem:"`
    Memory_Usage=`echo $Memory |awk '{print $3 }'`
    let m=m+1
    ProcList=`ps aux --sort -rss|head -n $m |grep -v "USER"|awk '{print $11}'`
    echo $ProcList
    echo "$n,$serverstatus,$Memory_Usage,$ProcList">>ram_usage.csv
done
