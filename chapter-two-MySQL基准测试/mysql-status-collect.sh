#!/bin/bash

SQLHOST=
SQLUSER=root
SQLPW=123321
INTERVAL=5
PREFIX=$INTERVAL-sec-status
RUNFILE=/home/benchmarks/running
mysql -p$SQLPW -e 'SHOW GLOBAL VARIABLES' >> mysql-variables
while test -e $RUNFILE; do
  #statements
  file=$(date +%F_%I)
  sleep=$(date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}")
  sleep $sleep
  ts="$(date +"TS %s.%N %F %T")"
  loadavg="$(uptime)"
  echo "$ts $loadavg" >> $PREFIX-${file}-status
  mysql -p$SQLPW -e 'SHOW GLOBAL STATUS' >> $PREFIX-${file}-status &
  echo "$ts $loadavg" >> $PREFIX-${file}-innodbstatus
  mysql -p$SQLPW -e 'SHOW ENGINE INNODB STATUS\G' >> $PREFIX-${file}-innodbstatus &
  echo "$ts $loadavg" >> $PREFIX-${file}-processlist
  mysql -p$SQLPW -e 'SHOW FULL PROCESSLIST\G' >> $PREFIX-${file}-processlist &
  echo $ts
done
echo Exiting because $RUNFILE does not exist.
