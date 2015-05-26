#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for sensor in `ls $CONFDDIR`
do
  scriptname=read-$sensor-sensors.sh
  $BINDIR/$scriptname
done
