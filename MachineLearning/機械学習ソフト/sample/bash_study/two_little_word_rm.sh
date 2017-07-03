#!/bin/sh


set +x

rm -f $2 $2_many.txt $2_little.txt $1_many.txt

cat $1 | sort | uniq -c | sort -nr >> $2

while read x; do 
 y=`echo $x |cut -d' ' -f1 ` 
echo $y
 if [ 5 -gt 3 ]; then
# if [ $y -gt 3 ]; then
   echo $y >> $2_many.txt
 else 
   echo $y >> $2_little.txt
 fi 
done < $2


# 文字を比較して削除

while read x; do
  grep $x $2_little.txt 
  if [ ! $? = 0 ]; then
    echo $x >> $1_many.txt
  fi
done  < $1
