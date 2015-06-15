#!/bin/bash

# Ez a szkript arra való, hogy a Tőgyi Balázs-féle logokból feltölthető adatsort készítsen

source /var/compostmonitor-daemon/main.conf

if [ -f $PROCDIR/lastrun ];then
	lastrun=`cat $PROCDIR/lastrun`
else
	lastrun=`date +"%s"`
	echo $lastrun > $PROCDIR/lastrun
fi

for i in `ls $LOGDIR`;
do
  while read line; do
    IFS=';' read datetime timestamp value <<< "$line"
    timestamp=`echo $timestamp|cut -d\. -f1`
    if [[ $((lastrun)) -lt $((timestamp)) ]];then
    	echo $value > $PROCDIR/$i.$timestamp
	fi
  done < $LOGDIR/$i
done
