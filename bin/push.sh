#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for point in `ls $PROCDIR`
do
  params=`echo $point | awk -F  "." '{print "{\"localid\";\""$1"\",\"timestamp\";\""$2 }'`
  json={${params:1}\",\"value\":\"`cat $PROCDIR/$point`\"}
  trying=0
  until $(curl -X POST -d "${json//;/:}" --output /dev/null --silent $COMPOSTSERVER_HOSTNAME/api/v1/sensorvalues.json --header "Content-Type:application/json" --user $COMPOSTSERVER_USERNAME:$COMPOSTSERVER_PASSWORD); do
       if [ $trying -lt 5 ]; then
          $trying=$trying+1
          sleep 3
       else
          exit 1
       fi
  done
  rm $PROCDIR/$point
done
