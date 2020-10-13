#!/usr/bin/bash

echo "Server_IP, Server_Status, Ram_Usage"> ram_usage.csv  #  Process_List" > ram_usage.csv
for line in `cat inputs.csv`
do
    n=`echo $line |awk -F"," '{print $1}'`
    echo $n
    m=`echo $line |awk -F"," '{print $2}'`
    if [ -z "$m" ]
    then
        m=3
    fi
    echo $m
    ping -c 1 $n >/dev/null
    pingresult=`echo $?`
    if [ $pingresult -eq 0 ]
    then
        serverstatus="Rechable"
    else
        serverstatus="Unrechable"
    fi
    echo $serverstatus
    Memory=`ssh root@$n "free -m"|grep "Mem:"`
    Memory_Usage=`echo $Memory |awk '{print $3}'`
    echo $Memory_Usage
    ProcList=`ps aux --sort -rss | head -n $m | grep -v "USER" | awk '{print $11}'`
   # ProcList=`ps aux --sort -rss | head -n $m | grep -v "USER" | awk '{print $11}'`
    echo $ProcList
    echo ""$n","$serverstatus","$Memory_Usage"" >>ram_usage.csv
done
