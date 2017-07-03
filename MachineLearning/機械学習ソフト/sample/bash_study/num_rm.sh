#/bin/sh 
set -x

# 全て半角数字の行の削除
# ただし、-anyオプションありの場合は一つもじでも半角英数字のある行を削除する。

# sed -e "/condtion/d" => remove the line

if [ $# -gt 3  ];then 
  echo error
  exit 1
fi

anyflag=off
if [ -z $1  ] ;then
  echo 1
  source=source.txt
  target=target.txt
elif [ -z $2 ] ;then
  source=$1
  target=$1_target.txt
elif [ "$3" = "-any"  ];then
  source=$1
  target=$1_target.txt
  anyflag=on
else 
  source=$1
  target=$2
fi 

echo $anyflag
if [ "$3" = "-any" ];then
# if [ ! "$anyflag"="on" ] ;then
  echo flagon
  sed -e "/[1-9]/d" $source > $target
else 
  sed -e "/^[1-9]*$/d" $source > $target
fi 


