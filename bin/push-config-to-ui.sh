#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for i in `ls $CONFDDIR`;
do
  while read line; do
    name=`echo ${line// /_} | awk -F  ":" '{print $2}'`
    params=`echo $line | awk -F  "|" '{print "{\"type\";\""$1"\", \"localid\";\""$2"\"}" }' | awk -F  ":" '{print  "\""$1"\", \"name\":"}'`
    json=${params:1}\"${name:1}\",\"user\"\:\"$COMPOSTSERVER_USERNAME\"}
    curl -X POST -d "${json//;/:}" $COMPOSTSERVER_HOSTNAME/api/v1/sensors.json --header "Content-Type:application/json" --user $COMPOSTSERVER_USERNAME:$COMPOSTSERVER_PASSWORD
    echo $name "...OK"
  done < $CONFDDIR/$i
done
