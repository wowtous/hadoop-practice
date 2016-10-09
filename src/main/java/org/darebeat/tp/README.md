
# NCDC气象数据下载
```sh
cd ~
mkdir temperature
cd temperature
wget http://labfile.oss.aliyuncs.com/courses/237/temperature.zip
unzip temperature.zip
cd 1971/
zcat *.gz > ~/temperature.txt
```

# 解压气象数据并上传到HDFS中
```sh
hadoop fs -mkdir -p /data/input
hadoop fs -copyFromLocal temperature.txt /data/input
hadoop fs -ls /data/input
```

# 编译代码
```sh
javac -classpath xxx.jar *.java
```

# 打包编译文件
```sh
jar cvf ./MinTemperature.jar ./Min*.class
mv *.jar ..
rm Min*.class
```

# 运行程序
```sh
hadoop jar MinTemperature.jar MinTemperature /data/input/temperature.txt /data/output
```

# 查看结果
```sh
hadoop fs -ls /data/output
hadoop fs -cat /data/output/part-r-00000
```