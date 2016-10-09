# hadoop practice


## HDFS 实验

1. 读取local2hdfs第101-120字节的内容写入HDFS成为一个新文件

+ 编译打包源码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/hdfs/LocalFile2Hdfs.java

cd build && jar cvf ../hcp.jar org && rm -rf ./* && cd ..
```

+ 新增数据文件
```sh
echo "Manifest-Version: 1.0
Created-By: Darebeat
Name: org.darebeat.hdfs
Main-Class: org.darebeat.hdfs.*
Class-Path: xxx.jar" > test1.txt
```

+ 运行jar包进行测试
```sh
hadoop fs -mkdir -p /data/test
hadoop jar hcp.jar org.darebeat.hdfs.LocalFile2Hdfs ./test1.txt /data/test/test1.txt
hadoop fs -cat /data/test/test1.txt
```

2. 使用编译代码查看文件内容

+ 编译打包源码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/hdfs/FileSystemCat.java

cd build && jar cvf ../hcat.jar org && rm -rf ./* && cd ..
```

+ 上传文件到hdfs
```sh
hadoop fs -put test1.txt /data/test/test2.txt
```

+ 运行jar包进行测试
```sh
hadoop jar hcat.jar org.darebeat.hdfs.FileSystemCat /data/test/test2.txt
```

3. 在HDFS中生成一个大约100字节的文本文件，写一段程序读入这个文件，并将其第101-120字节的内容写入本地文件系统成为一个新文件。

+ 编译打包源码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/hdfs/Hdfs2LocalFile.java

cd build && jar cvf ../hget.jar org && rm -rf ./* && cd ..
```

+ 运行jar包进行测试
```sh
hadoop jar hget.jar org.darebeat.hdfs.Hdfs2LocalFile /data/test/test2.txt test2.txt
cat test2.txt
```

## MapReduce 实验

