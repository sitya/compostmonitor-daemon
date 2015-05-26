#!/bin/bash

source /var/compostmonitor-daemon/main.conf

sensors=`cat /sys/bus/w1/devices/w1_bus_master1/w1_master_slaves;`

for line in $sensors
do
  value=`cat /sys/bus/w1/devices/w1_bus_master1/$line/w1_slave|tail -1|cut -d"=" -f2;`
  l=`expr length $value`
  up=`echo $value|cut -c1-$(($l-3));`
  down=`echo $value|cut -c $(($l-2))-;`
  echo $up.${down:1:1} > $PROCDIR/$line.`date +%s`
done
