#!/bin/bash

source /var/compostmonitor-daemon/main.conf

for i in `ls $LOGDIR`;
  do
    if [ "${i:0:2}" == "ht" ]; then
      output=`cat $LOGDIR/$i`
      j="$((${#output}-1))"

      if [ "${output:$j:1}" == "%" ]; then
        k=$((${#output}-21))
        value=${output:$k:4}
        echo $value > $PROCDIR/${i:3:-4}.`date +%s`
      fi
    fi
done;
