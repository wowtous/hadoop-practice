#! /bin/bash

jar="hemp.jar"
if [[ x$2 != x ]];then
    jar=$2
fi

if [[ x$3 != x ]];then
    hadoop jar $jar org.darebeat.mapreduce.emp.$1 $3 $4 $5
    if [[ x$5 != x ]];then
        hadoop fs -cat $5/part-r-00000
    else
        hadoop fs -cat $4/part-r-00000
    fi
else
    hadoop jar $jar org.darebeat.mapreduce.emp.$1 /data/input/dept /data/input/emp /data/$1
    hadoop fs -cat /data/$1/part-r-00000
fi
