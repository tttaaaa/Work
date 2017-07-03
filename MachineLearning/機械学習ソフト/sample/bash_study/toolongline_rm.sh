#!/bin/sh

rm -f $2

cat $1  | while read line; 
do
  if [ `echo $line | wc -m` -lt 40  ];then
    echo $line >> $2
  fi 
done
