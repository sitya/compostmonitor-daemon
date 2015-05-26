#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for i in `ls $CONFDDIR`;
do
  while read line; do
    if [[ "$i" = "dht" ]]; then
	id=`echo $line | cut -f1 -d: |cut -f2 -d\|`
	touch /tmp/ht_$id.txt
    fi
    name=`echo ${line// /_} | awk -F  ":" '{print $2}'`

    params=`echo $line | awk -F  "|" '{print "{\"type\";\""$1"\", \"localid\";\""$2"\"}" }' | awk -F  ":" '{print  "\""$1"\", \"name\":"}'`
    json=${params:1}\"${name:1}\"}
    echo curl -X POST -d "${json//;/:}" $COMPOSTSERVER_HOSTNAME/api/v1/sensors.json --header "Content-Type:application/json" --user $COMPOSTSERVER_USERNAME:$COMPOSTSERVER_PASSWORD
  done < $CONFDDIR/$i
done
echo "Done."
