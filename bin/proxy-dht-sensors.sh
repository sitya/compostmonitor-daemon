#!/bin/bash

source /var/compostmonitor-daemon/main.conf

ADAFRUIT_DHT_DRIVER=$SOURCEDIR/Adafruit_DHT_Driver/Adafruit_DHT
#DHT_TYPE: {11,22,2302}
DHT_TYPE=2302

for i in `ls $LOGDIR`;
do
if [ "${i:0:2}" == "ht" ]; then
  age=$(($(date +%s) - $(stat -c '%Y' "$LOGDIR/$i")))
  output=`cat $LOGDIR/$i`
  j="$((${#output}-1))"

  echo $i

  if [ "${output:$j:1}" != "%" ] || [ $age -gt 240 ]; then
      sudo $ADAFRUIT_DHT_DRIVER $DHT_TYPE ${i:3:-4} > $LOGDIR/$i
      echo sudo $ADAFRUIT_DHT_DRIVER $DHT_TYPE ${i:3:-4}
      sleep 1
  fi
fi

done
