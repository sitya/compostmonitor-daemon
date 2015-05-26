#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for point in `ls $PROCDIR`
do
  params=`echo $point | awk -F  "." '{print "{\"localid\";\""$1"\",\"timestamp\";\""$2 }'`
  json={${params:1}\",\"value\":\"`cat $PROCDIR/$point`\"}
  curl -X POST -d "${json//;/:}" $COMPOSTSERVER_HOSTNAME/api/v1/sensorvalues.json --header "Content-Type:application/json" --user $COMPOSTSERVER_USERNAME:$COMPOSTSERVER_PASSWORD
  rm $PROCDIR/$point
done
