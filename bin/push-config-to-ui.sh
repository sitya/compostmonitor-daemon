#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for i in `ls $CONFDDIR`;
do
  if [[ $i -eq "dht" ]]; then
  	touch $LOGDIR/ht_$i.txt
  fi
  while read line; do
    name=`echo ${line// /_} | awk -F  ":" '{print $2}'`

  	params=`echo $line | awk -F  "|" '{print "{\"type\";\""$1"\", \"localid\";\""$2"\"}" }' | awk -F  ":" '{print  "\""$1"\", \"name\":"}'`
    json=${params:1}\"${name:1}\"}
    curl -X POST -d "${json//;/:}" $COMPOSTSERVER_HOSTNAME/api/v1/sensors.json --header "Content-Type:application/json" --user $COMPOSTSERVER_USERNAME:$COMPOSTSERVER_PASSWORD
  done < ../conf.d/$i
  echo "Done."
done
